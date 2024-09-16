# eIDAS-connector Configuration

Folder `connector/config` contains common configuration files for the eIDAS-connector.
Folder `connector/profiles/<environment>` contains environment specific configuration.

docker/connector/profiles/<environment>/eidas.xml contains configuration of connected countries.

## Keystores
Are read from Vault as base64 encoded strings and decoded as keystores via scripts. 
The keystore passwords and keystore-key passwords is stored in Vault as well.

### Encryption
Keystore stored in Vault for all environments.
Configured in EncryptModule_Connector.xml.

### Truststore of other countries metadata signing certificates
Truststore stored in Vault for all environments.
Configured in MetadataModule_Connector.xml/SignModule_Connector_HSM_P12.xml.

### Signing and metadata signing
Signing + metadata signing certificate and key stored in HSM for test and production environments. For local-docker and systest these are stored in Vault.
Configured in MetadataModule_Connector.xml/SignModule_Connector_HSM_P12.xml.
