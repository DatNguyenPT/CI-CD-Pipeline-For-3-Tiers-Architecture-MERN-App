#!/bin/bash

MASTER_IP="<MASTER_IP>"
WORKER_IP="<WORKER_IP>"

USER="ubuntu"

SSH_KEY="~/.ssh/id_rsa"

echo "Connecting to Master Node at $MASTER_IP..."
ssh -i $SSH_KEY $USER@$MASTER_IP

if [ $? -eq 0 ]; then
    echo "Successfully connected to Master Node!"
else
    echo "Failed to connect to Master Node!"
    exit 1
fi

echo "Connecting to Worker Node at $WORKER_IP..."
ssh -i $SSH_KEY $USER@$WORKER_IP

if [ $? -eq 0 ]; then
    echo "Successfully connected to Worker Node!"
else
    echo "Failed to connect to Worker Node!"
    exit 1
fi

echo "Script completed successfully!"
