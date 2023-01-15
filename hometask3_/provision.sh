#!/bin/bash

VPC_ID=`aws ec2 describe-vpcs --query Vpcs[0].VpcId --output text`
SUBNET_ID=`aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text`
GROUP_ID=`aws ec2 create-security-group --group-name SecurityGroup --description "Security group" --vpc-id $VPC_ID --query GroupId --output text`

aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --port 443 --cidr 0.0.0.0/0 

aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > ./MyKeyPair.pem
chmod 400 MyKeyPair.pem

echo '#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd' > user_script.sh

aws ec2 modify-vpc-attribute --enable-dns-hostnames --vpc-id $VPC_ID 

INSTANCE_ID=`aws ec2 run-instances \
    --image-id ami-0533f2ba8a1995cf9 \
    --count 1 \
    --instance-type t2.micro \
    --key-name MyKeyPair \
    --security-group-ids $GROUP_ID \
    --subnet-id $SUBNET_ID \
    --user-data file://user_script.sh \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Role,Value=WebServer}]' \
    --query Instances[0].InstanceId --output text`

IP_ADDRESS=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --query Reservations[0].Instances[0].PublicDnsName --output text`
echo $IP_ADDRESS
