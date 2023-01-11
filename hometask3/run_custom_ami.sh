#!/bin/bash
IMAGE_ID=$(aws ec2 describe-images --owners 141848694151 --query 'Images[*].ImageId' --output text)
echo $IMAGE_ID
aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type t2.micro --key-name MyKeyPair1 --security-group-ids sg-010f765f16f442e61 --user-data file://user_data.sh
