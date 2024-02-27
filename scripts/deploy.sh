#!/bin/bash

set -e

echo "Collecting data..."
ECS_GROUP_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=prod-ecs-backend --query "SecurityGroups[0].GroupId" --output text)
PRIVATE_SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=prod-private-1" --query "Subnets[*].SubnetId" --output text)

echo "Running migration task..."
NETWORK_CONFIGURATION="{\"awsvpcConfiguration\": {\"subnets\": [\"${PRIVATE_SUBNET_ID}\"], \"securityGroups\": [\"${ECS_GROUP_ID}\"], \"assignPublicIp\": \"DISABLED\"}}"
# Start migration task
MIGRATION_TASK_ARN=$(aws ecs run-task --cluster prod --task-definition backend-migration --count 1 --launch-type FARGATE --network-configuration "${NETWORK_CONFIGURATION}" --query "tasks[*].taskArn" --output text)
echo "Task ${MIGRATION_TASK_ARN} is running..."
aws ecs wait tasks-stopped --cluster prod --tasks "${MIGRATION_TASK_ARN}"

echo "Updating web..."
aws ecs update-service --cluster prod --service prod-backend-web --force-new-deployment --query "service.serviceName"  --output json
echo "Updating worker..."
aws ecs update-service --cluster prod --service prod-backend-worker --force-new-deployment --query "service.serviceName"  --output json
echo "Updating beat..."
aws ecs update-service --cluster prod --service prod-backend-beat --force-new-deployment --query "service.serviceName"  --output json

echo "Done!"
