#!/bin/bash

# Disclaimer: Only tested on Mac locally.
# Usage: ./importMetadataCertificates.sh <path-to-pem-files> <path-to-keystore> <password>
# Prerequisites: Decode base64 string from vault: base64 -d -i from-vault.base64 -o <output.p12>


if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] ; then
  echo "All input parameters required: dir=$1, keystore-file=$2, password=$3" && exit 1;
fi

PEM_FILE_DIR=$1
KEYSTORE=$2
PASSWORD=$3

if [ ! -d "$PEM_FILE_DIR" ]; then
  echo "Directory '$PEM_FILE_DIR' does not exist" && exit 1;
fi
if [ ! -f "$KEYSTORE" ]; then
  echo "Truststore file '$KEYSTORE' does not exist" && exit 1;
fi

echo "Input parameters dir=$1, keystore-file=$2, password=$3"

# Run through all files in directory and import to keystore
for filename in $PEM_FILE_DIR/*; do
  echo "Filnamn: ${filename}"
  COUNTRY=$(openssl x509 -noout -subject -in ${filename} | grep -Eo -m 1 "/C=[A-Za-z]+/" | cut -c4- |tr / -)
  ALIAS=$(openssl x509 -noout -subject -in ${filename} | sed -n '/^subject/s/^.*CN=//p')
  echo "New alias found from pem certificate file: C=$COUNTRY and CN=$ALIAS"
  
  keytool -noprompt -v -import -file ${filename} -alias "${COUNTRY}${ALIAS}" -keystore $KEYSTORE -storepass ${PASSWORD}

done

# afterwards convert to base64: base64 -i tmp.p12 -o truststore-connector-prod-2024-10-21.base64
