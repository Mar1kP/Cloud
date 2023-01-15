#!/bin/bash

aws iam create-role --role-name lambda-ex --assume-role-policy-document file://trust-policy.json
aws iam attach-role-policy --role-name lambda-ex --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
zip function.zip index.py
aws lambda create-function --function-name my-function \
    --zip-file fileb://function.zip --handler index.handler --runtime python3.9 \
    --role arn:aws:iam::141848694151:role/lambda-ex
aws lambda invoke --function-name my-function out --log-type Tail \
    --query 'LogResult' --output text |  base64 -d
aws lambda list-functions --max-items 10
aws lambda get-function --function-name my-function





