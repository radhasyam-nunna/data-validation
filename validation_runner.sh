env="dev"
dbName="schema"
collectionName="schema"
nohup python3 fetchData.py $env $dbName $collectionName &> "./logs/validation_${collectionName}.log" 2>&1 