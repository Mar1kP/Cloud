#!/bin/bash 

INSTANCE_ID=`aws ec2 describe-instances --filters Name=instance-state-name,Values=stopped \
    --query Reservations[0].Instances[0].InstanceId --output text`

aws ec2 create-image --instance-id $INSTANCE_ID --name "Test Image" \
    --description "An Image of my instance"
