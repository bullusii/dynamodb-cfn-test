#!/bin/sh

BASE_DIR='seed'
SEED_EXECUTER="${BASE_DIR}/build_seed_json.rb"

TABLE_NAME_1='cfnTestPrices'

DB_EXIST=$(aws dynamodb list-tables | grep $TABLE_NAME_1)

./$SEED_EXECUTER
SEED_COUNT=$(ls ${BASE_DIR}/ | grep prices_seed)
for i in $SEED_COUNT; do
    if [[ $DB_EXIST  == *"$TABLE_NAME_1"* ]]; then
      echo "SEEDING DYNAMODB TABLE ${TABLE_NAME_1} - Count ${i}"
      aws dynamodb batch-write-item --request-items file://${BASE_DIR}/${i} --return-consumed-capacity TOTAL --output text
      rm -rf $BASE_DIR/$i
    fi
done
