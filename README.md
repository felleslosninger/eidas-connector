# eidas-connector
eIDAS generic connector for Norway

See these documents in https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eIDAS-Node+version+2.8:

* eIDAS-Node National IdP and SP Integration Guide
* eIDAS-Node Installation Quick Start Guide
* eIDAS-Node Installation and Configuration Guide

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
    
```
./importMetadataCertificates.sh <dir> <keystore-file> <keystore-password>
```
E.g. 
```
    ./importMetadataCertificates.sh prod-certs truststore.p12 password
```
Get truststore from Vault in https://vault.apps.mgmt.digdir.cosng.net/ui/vault/secrets/prod-digdir/show/team-idporten/eidas/eidas-connector
and then
1. base64 decode the truststore
2. download certificates from eIDAS-dashboard to folder(Jørgen has running EU scritps from https://github.com/grnet/eidas_node_trust_config)
    * Like this: `for COUNTRY in SE DK FI IT AT BE BG HR CY CZ EE EU FR EL IT LV LI LT LU MT NL PL PT RO ES SK SL; do echo $COUNTRY; ./bin/eidas_node_trust_config --node-country-code NO --environment productionNode --api-countries $COUNTRY --eidas-node-mds-certs-dir prod_certs --eidas-node-mds-certs-component CONNECTOR; done `
4. run importMetadataCertificates script on folder in 2.
4. base64 encode the truststore and add String to Vault