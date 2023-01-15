#!/bin/bash
IMAGE_ID=`aws ec2 describe-images --owners 141848694151 --query Images[0].ImageId --output text`
GROUP_ID=`aws ec2 describe-security-groups --query SecurityGroups[1].GroupId --output text`

INSTANCE_ID=`aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name MyKeyPair \
    --security-group-ids $GROUP_ID \
    --user-data file://user_script.sh \
    --query Instances[0].InstanceId --output text`

IP_ADDRESS=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --query Reservations[0].Instances[0].PublicDnsName --output text`
echo $IP_ADDRESS
