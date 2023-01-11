#!/bin/bash

VPS_ID=`aws ec2 create-vpc --cidr-block 10.10.0.0/16 --query Vpc.VpcId --output text`
SUBNET_PUBLIC_ID=`aws ec2 create-subnet --vpc-id $VPS_ID --cidr-block 10.10.1.0/24 --query Subnet.SubnetId --output text`
SUBNET_PRIVATE_ID=`aws ec2 create-subnet --vpc-id $VPS_ID --cidr-block 10.10.2.0/24 --query Subnet.SubnetId --output text`
GATEWAY_ID=`aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text`

aws ec2 attach-internet-gateway --vpc-id $VPS_ID --internet-gateway-id $GATEWAY_ID

ROUTE_ID=`aws ec2 create-route-table --vpc-id $VPS_ID --query RouteTable.RouteTableId --output text`
aws ec2 create-route --route-table-id $ROUTE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $GATEWAY_ID
aws ec2 associate-route-table  --subnet-id $SUBNET_PUBLIC_ID --route-table-id $ROUTE_ID
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUBLIC_ID --map-public-ip-on-launch

aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > ./MyKeyPair.pem
chmod 400 MyKeyPair.pem

GROUP_ID=`aws ec2 create-security-group --group-name SSHAccess --description "Security group for SSH access" --vpc-id $VPS_ID --query GroupId --output text`
aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

INSTANCE_ID=`aws ec2 run-instances --image-id ami-0533f2ba8a1995cf9 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $GROUP_ID --subnet-id $SUBNET_PUBLIC_ID --query Instances[0].InstanceId --output text`
aws ec2 modify-vpc-attribute --enable-dns-hostnames --vpc-id $VPS_ID 
IP_ADDRESS=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --query Reservations[].Instances[].PublicDnsName --output text`

ssh -i "MyKeyPair.pem" ec2-user@$IP_ADDRESS
aws ec2 describe-instance-status --instance-id $INSTANCE_ID
