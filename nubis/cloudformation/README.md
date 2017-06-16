

# Working with Cloudformation

## Set Up

Before you deploy with Cloudformation you need to set up your parameters.json
file. There is an example copy called parameters.json-dist that you can copy and
edit. It should look something like this:

```json

[
  {
    "ParameterKey": "ServiceName",
    "ParameterValue": "base"
  },
  {
    "ParameterKey": "Environment",
    "ParameterValue": "sandbox"
  },
  {
    "ParameterKey": "SSHKeyName",
    "ParameterValue": "my_key"
  },
  {
    "ParameterKey": "TechnicalOwner",
    "ParameterValue": "my-email@domain.dom"
  },
  {
    "ParameterKey": "AmiId",
    "ParameterValue": "ami-abcdef123"
  }
]

```

### ServiceName

The ServiceName is the name of this service. For Mozilla deployments this should
be the name of a real service as noted in [inventory](https://inventory.mozilla.org/en-US/core/service/)

### Environment

The environment is one of *sandbox*, *stage* or *prod*. For this (and all manual
deployments) you will set this to *sandbox*.

### SSHKeyName

This is the name of an existing ssh key that you have either created or uploaded
to AWS.

### TechnicalOwner

The technical owner should be a valid email or distribution list which is
monitored by the team responsible for maintaining this service.

### AmiId

You will collect this as output from nubis-builder. Once the build is complete
nubis-builder will display the ami id which you will need to manually copy into
the parameters.json file. You will need to do this after every successful build.

## Commands to work with CloudFormation

NOTE: All examples run from the top level project directory.

In these examples the stack is called *nubis-base*. You will need to choose a
unique name for your stack as their can only be one *nubis-base* stack at a time.

### Set up

Start by setting the profile and region, NOTE: If you have not set up any
profiles set this to '*default*'. These commands assume that you have set up
your profile names the same as the account names.

```bash

PROFILE='nubis-lab'; REGION='us-east-1'; ENVIRONMENT='stage'; STACK_NAME='nubis-base'

```

### Create

To create a new stack:

```bash

aws cloudformation create-stack \
--profile $PROFILE \
--region $REGION \
--template-body file://nubis/cloudformation/main.json \
--parameters file://nubis/cloudformation/parameters.$REGION.json \
--stack-name $STACK_NAME

```

### Update

To update and existing stack:

```bash

aws cloudformation update-stack \
--profile $PROFILE \
--region $REGION \
--template-body file://nubis/cloudformation/main.json \
--parameters file://nubis/cloudformation/parameters.$REGION.json \
--stack-name $STACK_NAME

```

### Monitor

To monitor the progress of the stack during create or update:

```bash

watch -n 1 "echo 'Container Stack'; \
aws cloudformation describe-stacks \
--region $REGION \
--profile $PROFILE \
--query 'Stacks[*].[StackName, StackStatus]' \
--output text \
--stack-name $STACK_NAME; \
echo \"\nStack Resources\"; \
aws cloudformation describe-stack-resources \
--region $REGION \
--profile $PROFILE \
--stack-name $STACK_NAME \
--query 'StackResources[*].[LogicalResourceId, ResourceStatus]' \
--output text"

```

### Login

If you have only one EC2 instance and your ssh keys are on the jumphost, you can
login by:

```bash

ssh -A -t ec2-user@jumphost.$ENVIRONMENT.$REGION.$PROFILE.nubis.allizom.org \
"ssh -A -t ubuntu@$(nubis-consul \
--region $REGION \
--profile $PROFILE \
--stack-name $STACK_NAME \
--settings nubis/cloudformation/parameters.$REGION.json get-ec2-instance-ip)"

```

### Delete

To delete the stack:

```bash

aws cloudformation delete-stack \
--profile $PROFILE \
--region $REGION \
--stack-name $STACK_NAME

```

## Nested Stacks

We are using Cloudformation nested stacks to deploy the necessary resources. Yo
can find the nested stack templates in the [nubis-stacks](https://github.com/Nubisproject/nubis-stacks)
repository.
