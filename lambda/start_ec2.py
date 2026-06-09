import boto3
import os
import logging

#Set up logging so we can see output
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """
    Starts the EC2 instance defined in the INSTANCE_ID environment variable.
    Triggered automatically by EventBridge on a schedule.
    """
    ec2 = boto3.client('ec2', region_name=os.environ['EC2_REGION'])
    
    instance_id = os.environ['INSTANCE_ID']
    
    logger.info(f"Starting EC2 instance: {instance_id}")
    
    response = ec2.start_instances(InstanceIds=[instance_id])
    
    current_state = response['StartingInstances'][0]['CurrentState']['Name']
    logger.info(f"Instance {instance_id} is now: {current_state}")
    
    return {
        'statusCode': 200,
        'body': f'Instance {instance_id} is now {current_state}'
    }