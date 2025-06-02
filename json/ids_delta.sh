collectionName="work_order_audit_log"
dbName="refurb-service"

dir="/mnt/disk-1/mdb/$collectionName"
filter=$(<./data_validation/ids.txt)
#mongoUri="mongodb+srv://refurb-schema:dna8k1AgkicWDh8R@refurb-prod.rils4.mongodb.net/"

mongoUri="mongodb+srv://refurb-service:xKoyEcn7NFzRjTaA@refurb-prod.rils4.mongodb.net/"
echo "Using collection: $collectionName | database: $dbName | URI: $mongoUri" 
#echo "filter: $filter"

sudo docker run -v /mnt/disk-1:/mnt/disk-1/ arangodb/arangodb:3.10.10 \
  arangoexport \
  --server.endpoint ssl://172.16.2.12:8529 \
  --server.database "$dbName"-in \
  --server.username radhasyam-nunna \
  --server.password 'bSj753gSSYaVde+f' \
  --custom-query "FOR doc IN $collectionName FILTER doc._key in $filter LET docKey = doc._key RETURN MERGE(UNSET(doc, '_id','_rev','_class','_key'), { _id: docKey })" \
  --type json \
  --output-directory "$dir" \
  --overwrite true \
  --documents-per-batch 300 \
  --progress true


# dir="/mnt/disk-1/mdb/$collectionName"
mongoimport --uri "$mongoUri" \
  --db "$dbName" \
  --collection "$collectionName" \
  --file "$dir/query.json" \
  --jsonArray \
  --upsert \
  --numInsertionWorkers=8

echo "started date conversion script"
curl --location "http://localhost:7091/test/migrate/$dbName/$collectionName?applyDateFilter=true"
