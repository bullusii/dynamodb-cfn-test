## WHAT IS THIS

This is a demo test of upgrading a dynamodb table to a global table and retaining control in cfn
It assumes you have the permissions to run these commands


1. Run the command to create a (non-global) dynamoDB
``aws cloudformation deploy --template-file cloudformation-1-initial.yaml --stack-name cfn-demo-dynamodb --capabilities CAPABILITY_NAMED_IAM``

2. Seed Data - This script will create a random number of items for the cfnTestPrices Table
```
## will require ruby todo
./seed/seed_table.sh
```

3. Get Initial Count of Table:
```
aws dynamodb scan --table-name cfnTestPrices --select "COUNT"
```

4. Modify and deploy new CFN (cloudformation-2-deletionPolicy.yaml)
This step we are adding a DeletionPolicy Retain to all resources - We are also adding a tag to the dynamodb table.
DeletionPolicy changes are not recognized as changes unless there is some other change - this is why we are adding a tag.
We create a change set - view it - then execute if it looks good

```
aws cloudformation create-change-set --template-body file://./cloudformation-2-deletionPolicy.yaml --stack-name cfn-demo-dynamodb --capabilities CAPABILITY_NAMED_IAM --change-set-name create-retain
```

This may take a 5-10 mins to complete

5. In console - look at change set and execute (can create commands for this later)

In the console under the cloudformation stack change sets tab for create-retain- you will see a change set - select that - inspect that to ensure that nothing is being deleted and execute the change set. It should be set to modify based on the commands we added.

Execute Change Set < rollback all

Confirm we still have all of our data by running:
```
aws dynamodb scan --table-name cfnTestPrices --select "COUNT"
```

6.  Remove table and scaling policies from cfn (cloudformation-3-removingTable.yaml)

This step - we are going to remove the table / targets / scaling policies - leaving behind the scaling role / scaling role policy
This is the scary step - but if we've verified retain - we should be good to go. We are going to import the table back into cfn into the same template in the next step.
```
aws cloudformation deploy --template-file cloudformation-3-removingTable.yaml --stack-name cfn-demo-dynamodb --capabilities CAPABILITY_NAMED_IAM
```

Ensure we still have all the records
```
aws dynamodb scan --table-name cfnTestPrices --select "COUNT"
```

7. This step we are going to import the dynmodb:table as a dynamodb:GlobalTable
We are limiting this step just to the import of the table
We have left all the scaling policy / target just incase at this point

No Replicas:
- If the table has BillingMode = Provisioned, ensure it has an AutoScaling policy for the tables Write Capacity for its GSIs.To do so for this procedure, we recommend configuring AutoScaling via the AWS Management Console, API or CLI, and not via CloudFormation.
- If you have AutoScaling policies for the table’s Write Capacity or for the Write Capacity of any of its GSIs, delete any Scheduled Action present. CloudFormation does not currently support Scheduled Actions on Global Tables.
- Ensure that your table has Streams enabled, and set to “New and Old Images” ( we did this when we added retain)

If Replicas exist:
- If the table has BillingMode = Provisioned, ensure that all Autoscaling Write Capacity settings for the table and all its GSIs are the same across all replicas.
- If you have AutoScaling policies for the table’s Write Capacity or for the Write Capacity of any of its GSIs, delete any Scheduled Action present. CloudFormation does not currently support Scheduled Actions on Global Tables.


There are certain attributes that are not supported by global tables such as provisionedThroughput and Tags the cfn (cloudformation-4-import-table) has this. This step defines your current table as a global table. Ensure your replica region is the current region your table is in.

Also you need to remove tags / provisionedThroughput - not supported keys for global tables -> https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-dynamodb-globaltable.html
```
aws cloudformation create-change-set \
    --stack-name cfn-demo-dynamodb --change-set-name ImportChangeSet \
    --change-set-type IMPORT \
    --resources-to-import "[ \
      {\"ResourceType\":\"AWS::DynamoDB::GlobalTable\",\"LogicalResourceId\":\"cfnTestPrices\", \"ResourceIdentifier\":{\"TableName\":\"cfnTestPrices\"}}
    ]" \
    --template-body file://./cloudformation-4-import-table.yaml --capabilities CAPABILITY_NAMED_IAM
```

  - Ensure you execute the change set after reviewing it

8. Deregister previous scaling policy / target and create a new one
**This may need review - probably a better way

De-register target:
```
aws application-autoscaling deregister-scalable-target --service-namespace dynamodb --resource-id table/cfnTestPrices --scalable-dimension dynamodb:table:WriteCapacityUnits
```

Execute CFN to create new scaling target / policies
This is important that these scaling policies will be the same for both tables.
Modifying this AFTER you create the replica will only effect the original table - not the replica
You will have to update the replica with CLI commands for scaling (Currently)

```
aws cloudformation deploy --template-file cloudformation-5-recreate-scaling.yaml --stack-name cfn-demo-dynamodb --capabilities CAPABILITY_NAMED_IAM
```

You can verify this in the console in the additional settings tab
You may have to do this for autoscaled reads as well in the real world

9. Add a replica in the region of your choice
```
aws cloudformation create-change-set --template-body file://./cloudformation-6-create-replica.yaml --stack-name cfn-demo-dynamodb --capabilities CAPABILITY_NAMED_IAM --change-set-name add-replica
```

Review and execute change set

look in console to see if a replica exists
switch to other region (us-east-2) - verify there is a replica

verify item count:
```
aws dynamodb scan --table-name cfnTestPrices --select "COUNT" --region us-east-1
aws dynamodb scan --table-name cfnTestPrices --select "COUNT" --region us-east-2
```

10. Clean Up
This step removes the deletion policy to allow you to delete the resources:
```
aws cloudformation deploy --template-file cloudformation-7-clean-up.yaml --stack-name cfn-demo-dynamodb --capabilities CAPABILITY_NAMED_IAM
```

- Delete the stack **ADD COMMAND
- Manually delete the dynamodb in us-east-2 **ADD CLI COMMAND

## CONCLUSION

You should now have a replicated global table that is in two regions with no data loss and a new scaling policy

## TODO
- BUG FIX - cost mode doesn't change when updated - shows still as provisioned - but allows to execute throughout
- test with GSIs / LSIs
- Commands for Console parts
- Ensure the seed step doesn't require ruby
- Instructions on how to modify scaling policy in secondary region
- Post testing changes to dynamo
