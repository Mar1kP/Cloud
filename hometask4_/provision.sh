#!/bin/bash
VPC_ID=`aws ec2 describe-vpcs --query Vpcs[0].VpcId --output text`

SUBNET_1_ID=`aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text`
SUBNET_2_ID=`aws ec2 describe-subnets --query 'Subnets[1].SubnetId' --output text`
GROUP_LB_ID=`aws ec2 create-security-group --group-name SecurityGroupLB --description "Security group for LB" \
    --vpc-id $VPC_ID --query GroupId --output text`

aws ec2 authorize-security-group-ingress --group-id $GROUP_LB_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 

LB_ARN=`aws elbv2 create-load-balancer --name my-load-balancer --subnets $SUBNET_1_ID $SUBNET_2_ID \
    --security-groups $GROUP_LB_ID --query LoadBalancers[*].LoadBalancerArn --output text`
VPC_NET=`aws ec2 describe-vpcs --query Vpcs[0].CidrBlock --output text`
GROUP_INC_ID=`aws ec2 create-security-group --group-name SecurityGroupINC --description "Security group for Instances" \
    --vpc-id $VPC_ID --query GroupId --output text`

aws ec2 authorize-security-group-ingress --group-id $GROUP_INC_ID --protocol tcp --port 80 --cidr $VPC_NET
aws ec2 authorize-security-group-ingress --group-id $GROUP_INC_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 create-key-pair --key-name MyKeyPairLB --query 'KeyMaterial' --output text > ./MyKeyPairLB.pem

chmod 400 MyKeyPairLB.pem

IMAGE_ID=`aws ec2 describe-images --owners 141848694151 --query Images[0].ImageId --output text`

INSTANCE_1_ID=`aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --subnet-id $SUBNET_1_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name MyKeyPairLB \
    --security-group-ids $GROUP_INC_ID \
    --user-data file://user_script.sh \
    --query Instances[0].InstanceId --output text`
    
sleep 30

INSTANCE_2_ID=`aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --subnet-id $SUBNET_2_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name MyKeyPairLB \
    --security-group-ids $GROUP_INC_ID \
    --user-data file://user_script.sh \
    --query Instances[0].InstanceId --output text`
    
sleep 30

TG_ARN=`aws elbv2 create-target-group --name TargetGroup --protocol HTTP --port 80 --vpc-id $VPC_ID --query 'TargetGroups[*].TargetGroupArn' --output text`

sleep 30

aws elbv2 register-targets --target-group-arn $TG_ARN --targets Id=$INSTANCE_1_ID Id=$INSTANCE_2_ID

aws elbv2 create-listener --load-balancer-arn $LB_ARN --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$TG_ARN 

aws autoscaling create-auto-scaling-group --auto-scaling-group-name AutoScalingGroup --instance-id $INSTANCE_1_ID --min-size 2 --max-size 2 --target-group-arns $TG_ARN 

aws autoscaling update-auto-scaling-group --auto-scaling-group-name AutoScalingGroup --health-check-type ELB --health-check-grace-period 15 

LB_DNS=`aws elbv2 describe-load-balancers --query 'LoadBalancers[0].DNSName' --output text`

aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name AutoScalingGroup
echo $LB_DNS
