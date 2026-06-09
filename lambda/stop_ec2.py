import boto3
import os
import logging

# Set up logging so we can see output in AWS CloudWatch
logger = logging.getlogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """
    Stops the EC2 instance defined in the INSTANCE_ID enviornment variable.
    Triggered automatically by EventBridge on a schedule.
    """
    # boto is AWS's Python SDK - it lets us talk to AWS
    ec2 = boto3.client('ec2', region_name=os.enviorn["EC2_REGION"])

    instance_id = os.enviorn['INSTANCE_ID']

    logger.info(f"Stopping EC2 instance: {instance_id}")

    response = ec2.stop_instances(InstanceIds=[instance_id])

    current_state = response['StoppingInstances'][0]['CurrentState']['Name']
    logger.info(f"Instance {instance_id} is now: {current_state}")

    return {
        'statusCode': 200,
        'body': f'Instance {instance_id} is now {current_state}'
    }
