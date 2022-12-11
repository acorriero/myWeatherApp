
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=us-east-1

aws ec2 create-key-pair --key-name main-key --region us-east-1 | jq -r ".KeyMaterial" > /home/anthony/Downloads/my-key.pem
