#!/bin/bash

echo '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::markstep/*",
            "Condition" : {
                "NotIpAddress": {
                    "aws:SourceIp": "50.31.252.0/24"
                }
            }
        }
    ]
}' > tmp/bucket_policy.json

aws s3 mb s3://markstep
aws s3api put-bucket-policy --bucket markstep --policy file://tmp/bucket_policy.json
aws s3 sync ./ s3://markstep/
aws s3 website s3://markstep/ --index-document index.html --error-document error.html
aws s3 presign s3://markstep/index.html
aws s3 presign s3://markstep/error.html