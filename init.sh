#!/bin/bash

BUCKET_CATS_DOGS="syd-ecs-dogs/dogs"
BUCKET_UNICORN="syd-ecs-dogs/unicorns"
REGION="us-east-1"
PARAMETER_STORE_NAME="unicorn"

SECRET_PATH=$(aws ssm get-parameters --region $REGION --name $PARAMETER_STORE_NAME --with-decryption --output text | awk '{print $4}')

if [ "$SECRET_PATH" != "" ]; then echo "secret='"$SECRET_PATH"';" >> /usr/local/apache2/htdocs/app.js; fi

/usr/local/bin/aws --region $REGION s3 cp s3://$BUCKET_CATS_DOGS /usr/local/apache2/htdocs/ --recursive
# copy unicorn images
if [ "$SECRET_PATH" != "" ]; then
mkdir /usr/share/nginx/html/$SECRET_PATH
/usr/local/bin/aws --region $REGION s3 cp s3://$BUCKET_UNICORN /usr/local/apache2/htdocs/$SECRET_PATH --recursive
fi
