# eidas-connector
eIDAS generic connector for Norway

See these documents in https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eIDAS-Node+version+2.8:

* eIDAS-Node National IdP and SP Integration Guide
* eIDAS-Node Installation Quick Start Guide
* eIDAS-Node Installation and Configuration Guide

## Upgrade
Upgrade of dependencies must be done manually since they have to match with version used in EU eIDAS-node, and thus must be upgraded carefully.
Upgrade eidas-proxy and eidas-redis-lib first and then eidas-connector, as eidas-proxy is more "sensitve" to changes in eidas-redis-lib than eidas-connector.

### Run eidas-connector as docker-compose on your machine for local testing

Add the following to your /etc/hosts file:
```
# eIDAS local dev
127.0.0.1 eidas-connector
```

Start docker containers:
```
docker-compose up --build 
```

## Run script for importing metadata pem files to truststore in Vault
This script is located in the /tools folder.
```
./importMetadataCertificates.sh <dir> <keystore-file> <keystore-password>
```
E.g. 
```
    ./importMetadataCertificates.sh prod-certs truststore.p12 password
```
Disclaimer: Only tested on Mac.
### Procedure
1. Get truststore from Vault in .../team-idporten/eidas/eidas-connector#truststore-p12-base64
2. base64 decode the truststore `base64 -d -i string-from-vault.base64 -o <truststore.p12>`
3. download certificates from eIDAS-dashboard to folder(the PO has running EU scripts from https://github.com/grnet/eidas_node_trust_config)
    * Like this: `for COUNTRY in SE DK FI IT AT BE BG HR CY CZ EE EU FR EL IT LV LI LT LU MT NL PL PT RO ES SK SL; do echo $COUNTRY; ./bin/eidas_node_trust_config --node-country-code NO --environment productionNode --api-countries $COUNTRY --eidas-node-mds-certs-dir prod_certs --eidas-node-mds-certs-component CONNECTOR; done `
4. run importMetadataCertificates script on folder in 3.
5. base64 encode the truststore `base64 -i <truststore.p12> -o <string-to-vault.base64>` and replace String value in Vault
