# Backend
module "pre-backend" {
  source = "./backend/pre-setup"
}

module "backend" {
  source = "./backend"
}

#####################################################################################################
# VPCs
module "dev-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]  
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"] 
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"] 

  enable_nat_gateway = true
  single_nat_gateway = true  # Set to true for cost savings

  tags = {
    Terraform   = "true"
    Environment = "development"
  }
}

module "prod-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "prod-vpc"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]  
  private_subnets = ["10.1.2.0/24", "10.1.3.0/24"] 
  public_subnets  = ["10.1.102.0/24", "10.1.103.0/24"] 

  enable_nat_gateway = true
  single_nat_gateway = true  # Set to true for cost savings

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}
#####################################################################################################
#SG
module "jenkins-sg" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "jenkins-sg"
  vpc_id = module.dev-vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["https-443-tcp", "http-80-tcp", "postgresql-tcp", "ssh-tcp"]
  egress_rules  = ["all-all"]

  # Custom rules
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins port"
      cidr_blocks = "0.0.0.0/0"  
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "SonarQube port"
      cidr_blocks = "0.0.0.0/0"  
    },
    {
      from_port   = 9090
      to_port     = 9090  
      protocol    = "tcp"
      description = "Prometheus port"
      cidr_blocks = "0.0.0.0/0"  
    }
  ]
}

module "sonarqube-sg" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "sonarqube-sg"
  vpc_id = module.dev-vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins port"
      cidr_blocks = "0.0.0.0/0"  
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "SonarQube port"
      cidr_blocks = "0.0.0.0/0"  
    }
  ]
}

module "k8s-sg" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "k8s-sg"
  vpc_id = module.prod-vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}


#####################################################################################################
# EC2
module "jenkins_master" {
  source              = "./modules/ec2"
  vpc_id              = module.dev-vpc.vpc_id
  ami_id              = "ami-05778ef68e10b91d7"
  instance_type       = "t2.medium"
  key_name            = "instance-keypair"
  subnet_id           = module.dev-vpc.public_subnets[0]
  security_group_id   = module.jenkins-sg.security_group_id
  instance_name       = "jenkins-master"
  volume_size         = 80
  user_data_script    = "${path.root}/scriptfiles/jenkins_setup.sh"

  tags = {
    Environment = "dev"
    Role        = "CI"
  }
}

module "jenkins_worker" {
  source              = "./modules/ec2"
  vpc_id              = module.dev-vpc.vpc_id
  ami_id              = "ami-05778ef68e10b91d7"
  instance_type       = "t2.medium"
  key_name            = "instance-keypair"
  subnet_id           = module.dev-vpc.public_subnets[0]
  security_group_id   = module.jenkins-sg.security_group_id
  instance_name       = "jenkins-worker"
  volume_size         = 80
  user_data_script    = "${path.root}/scriptfiles/jenkins_setup.sh"

  tags = {
    Environment = "dev"
    Role        = "CI"
  }
}

module "sonarqube_server" {
  source              = "./modules/ec2"
  vpc_id              = module.dev-vpc.vpc_id
  ami_id              = "ami-05778ef68e10b91d7"
  instance_type       = "t2.medium"
  key_name            = "instance-keypair"
  subnet_id           = module.dev-vpc.public_subnets[0]
  security_group_id   = module.sonarqube-sg.security_group_id
  instance_name       = "sonarqube"
  volume_size         = 30
  user_data_script    = "${path.root}/scriptfiles/sonarqube_setup.sh"

  tags = {
    Environment = "dev"
    Role        = "QA"
  }
}


module "monitoring_server" {
  source              = "./modules/ec2"
  vpc_id              = module.dev-vpc.vpc_id
  ami_id              = "ami-05778ef68e10b91d7"
  instance_type       = "t2.medium"
  key_name            = "instance-keypair"
  subnet_id           = module.dev-vpc.public_subnets[0]
  instance_name       = "monitoring"
  volume_size         = 80
  user_data_script    = "${path.root}/scriptfiles/prometheus_grafana.sh"
  security_group_id   = module.jenkins-sg.security_group_id  

  tags = {
    Environment = "dev"
    Role        = "Monitoring"
  }
}

#######################################################################################################
# Prod EC2 Instances
module "kubespray" {
  source              = "./modules/ec2"
  vpc_id              = module.prod-vpc.vpc_id
  ami_id              = "ami-05778ef68e10b91d7"
  instance_type       = "t2.medium"
  key_name            = "instance-keypair"
  subnet_id           = module.prod-vpc.public_subnets[0]
  instance_name       = "kubespray"
  volume_size         = 80
  user_data_script    = null
  security_group_id   = module.k8s-sg.security_group_id

  tags = {
    Environment = "prod"
    Role        = "K8s Master"
  }
}


module "k8s_master" {
  source              = "./modules/ec2"
  vpc_id              = module.prod-vpc.vpc_id
  ami_id              = "ami-05778ef68e10b91d7"
  instance_type       = "t2.medium"
  key_name            = "instance-keypair"
  subnet_id           = module.prod-vpc.public_subnets[0]
  instance_name       = "k8s-master"
  volume_size         = 80
  user_data_script    = null
  security_group_id   = module.k8s-sg.security_group_id

  tags = {
    Environment = "prod"
    Role        = "K8s Master"
  }
}

module "k8s-worker" {
  source              = "./modules/ec2"
  vpc_id              = module.prod-vpc.vpc_id
  ami_id              = "ami-05778ef68e10b91d7"
  instance_type       = "t2.medium"
  key_name            = "instance-keypair"
  subnet_id           = module.prod-vpc.public_subnets[0]
  instance_name       = "k8s-worker"
  volume_size         = 80
  user_data_script    = null
  security_group_id   = module.k8s-sg.security_group_id

  tags = {
    Environment = "prod"
    Role        = "K8s Worker"
  }
}

module "load-balancer" {
  source              = "./modules/ec2"
  vpc_id              = module.prod-vpc.vpc_id
  ami_id              = "ami-05778ef68e10b91d7"
  instance_type       = "t2.medium"
  key_name            = "instance-keypair"
  subnet_id           = module.prod-vpc.public_subnets[0]
  instance_name       = "load-balancer"
  volume_size         = 20
  user_data_script    = null
  security_group_id   = module.k8s-sg.security_group_id

  tags = {
    Environment = "prod"
    Role        = "K8s Worker"
  }
}

#######################################################################################################
# ECR
module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "private-repo"

  repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}









