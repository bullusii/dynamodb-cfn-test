## WHAT IS THIS

We are testing the following scenario

1. Run the command to create a (non-global) dynamoDB
``aws cloudformation deploy --template-file cloudformation.yaml --stack-name cfn-demo-dynamodb --capabilities CAPABILITY_NAMED_IAM``

2. Seed Data
``./seed/seed_table.sh``

3. Get Initial Count of Table:
``
aws dynamodb scan --table-name cfnTestPrices --select "COUNT"
``

4. Run Command to covert to global table
``
#This step will take around 5-10 minutes - you will see the table in Status Updating
#Then if you open GlobalTables Tab you will se us-east-2 creating
#Shows creating in replicas / but shows active un us-east-2
#5:38 Start -- 5:55 End (17Mins)
aws dynamodb update-table --table-name cfnTestPrices --cli-input-json file://./seed/global_update.json
``

5. Update CFN plan deploy to use global table
``aws cloudformation create-change-set --template-file cloudformation-global-tables.yaml --stack-name cfn-demo-dynamodb``

6. Deploy updated CFN
``aws cloudformation deploy --template-file cloudformation-global-tables.yaml --stack-name cfn-demo-dynamodb``

7. Ensure table is not modified
``
#Ensure that a replica table exists in us-east-2
aws dynamodb scan --table-name cfnTestPrices --select "COUNT"
``

8. Modify WCU in new CFN and deploy
``aws cloudformation deploy --template-file cloudformation-global-tables-wcu.yaml --stack-name cfn-demo-dynamodb``

9. Ensure that table is not deleted
``
#Check in console wcu is 10 now
aws dynamodb scan --table-name cfnTestPrices --select "COUNT"
``
