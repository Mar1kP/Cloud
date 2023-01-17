#!/bin/bash
aws s3api create-bucket --bucket mark-lab8-test --region us-east-1   
sleep 10
aws s3api put-object --bucket mark-lab8-test --key TestImage.jpg --body tmp/TestImage.jpg
sleep 10
aws iam create-policy --policy-name AWSLambdaS3Policy --policy-document file://s3_policy.json
aws iam create-role --role-name lambda-s3-role --assume-role-policy-document file://trust-policy.json

FUNC_NAME=$(aws lambda list-functions --query 'Functions[0].FunctionName' --output text)
aws lambda update-function-configuration --function-name $FUNC_NAME --timeout 30
aws lambda invoke --function-name $FUNC_NAME --cli-binary-format raw-in-base64-out --invocation-type Event --payload file://functionTest.json outputfile.json
aws lambda add-permission --function-name $FUNC_NAME --principal s3.amazonaws.com --statement-id s3invoke --action lambda:InvokeFunction \
    --source-arn arn:aws:s3:::mark-lab8-test --source-account 141848694151
aws lambda get-policy --function-name $FUNC_NAME

sleep 30
FUNC_ARN=$(aws lambda list-functions --query 'Functions[0].FunctionArn' --output text)
echo '{
    "LambdaFunctionConfigurations": [
        {
            "Id": "lambda-trigger",
            "LambdaFunctionArn": "'"$FUNC_ARN"'" ,
            "Events": [
                "s3:ObjectCreated:*"
            ]
        }
    ]
}' > notification.json
aws s3api put-bucket-notification-configuration --bucket mark-lab8-test --notification-configuration file://notification.json