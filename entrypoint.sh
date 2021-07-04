#!/bin/bash
set -e

echo "Building some OpenAPI specs for you..."
vertag=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 30)

aws_endpoint=$AWS_ENDPOINT
if [ $aws_endpoint != http* ]
then
  aws_endpoint=https://$aws_endpoint
fi

files=$1
echo $files
for i in $files
do
  outfname=${GITHUB_WORKSPACE}/${i}_${vertag}.html
  fname=$(basename $outfname)
  npx redoc-cli bundle $GITHUB_WORKSPACE/$i -o $outfname --disableGoogleFont --options.expandDefaultServerVariables "true" 
  aws --endpoint-url $aws_endpoint s3 cp $outfname s3://$BUCKET_NAME/
  aws --endpoint-url $aws_endpoint s3api put-object-acl --bucket $BUCKET_NAME --acl public-read --key $fname
  out="== Uploaded spec successfully to https://${BUCKET_NAME}.${AWS_ENDPOINT}/$fname =="
  ln=${#out}
  while [ $ln -gt 0 ]; do printf '=%.0s'; ((ln--));done;
  echo ""
  echo $out
  ln=${#out}
  while [ $ln -gt 0 ]; do printf '=%.0s'; ((ln--));done;
  echo ""
done
