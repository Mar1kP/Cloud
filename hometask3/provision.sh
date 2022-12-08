#!/bin/bash
aws ec2 create-key-pair --key-name MyKeyPairl2 --query 'KeyMaterial2' --output text > MyKeyPairl2.pem \
&& chmod 400 MyKeyPairl2.pem \
&& VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) \
&& aws ec2 create-security-group --group-name SecurityGroup2 --description "My security group" \
&& SG=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text) \
&& aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 22 --cidr 0.0.0.0/0 \
&& aws ec2 authorize-security-group-ingress --group-id $SG  --protocol tcp --port 80 --cidr 0.0.0.0/0 \
&& aws ec2 authorize-security-group-ingress --group-id $SG  --protocol tcp --port 443 --cidr 0.0.0.0/0 \
&& NET_ID=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) \
&& INST_ID=$(aws ec2 run-instances --image-id ami-0b0dcb5067f052a63 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $SG --user-data file://user_data.sh --query 'Instances[*].[InstanceId]' --output text) \
&& aws ec2 create-tags --resources $INST_ID --tags Key=Name,Value=OldInstance \
&& echo $INST_ID 