variable "config" {
   default = {
    "jenkins" = {
       ports  = [
        {
          from = 8080
          to = 8080
          source="0.0.0.0/0"
        },
        {
          from = 9000
          to = 9000
          source="::/0"
        },
         {
          from = 22
          to = 22
          source="0.0.0.0/0"
        },
        {
          from = 9090
          to = 9090
          source ="0.0.0.0/0"
        }
      ]
    },
     "sonarqube" = {
      ports = [       
         {
          from = 8080
          to = 8080
          source="0.0.0.0/0"
        },
        {
          from = 9090
          to = 9090
          source="::/0"
        },
        {
          from = 22
          to = 22
          source="0.0.0.0/0"
        }
      ]
    },
     "database" = {
        ports = [       
         {
          from = 8080
          to = 8080
          source="0.0.0.0/0"
        },
        {
          from = 22
          to = 22
          source="0.0.0.0/0"
        },
        {
          from = 9090
          to = 9090
          source="0.0.0.0/0"
        }
      ]
     },
     "monitoring" = {
      ports = [       
         {
          from = 8080
          to = 8080
          source="0.0.0.0/0"
        },
        {
          from = 22
          to = 22
          source="0.0.0.0/0"
        },
        {
          from = 9090
          to = 9090
          source="0.0.0.0/0"
        }
      ]
     }
   } 
 }

 variable "vpc_id" {
  description = "VPC ID"
  type        = string
 }

