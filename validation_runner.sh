env="dev"
dbName="schema"
# dbName="refurb-service"
collectionName="schema"
# collectionName="inspection"
nohup python3 app.py $env $dbName $collectionName &> "./logs/validation_${collectionName}.log" 2>&1 