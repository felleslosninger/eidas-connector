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
How to replace:
1. Look for ENCRYPT_KEYSTORE_BASE64 in the cd-repo.
2. Update keystore file with new certificate. Keep same aliases, subject and issuer etc for your mental health
3. The subject of the new certificate must match encrypt-certificate-issuer in vault exactly
4. Encode to base64.
5. Replace value in Vault.

If docker the same as systest:
1. Update EncryptModule_Connector.xml with new serial number in docker\EncryptModule_connector.xml
2. responseDecryptionIssuer in EncryptModule_Connector.xml must match the subject of the new certificate exactly 
3. Update docker compose with new base64 string in environment ENCRYPT_KEYSTORE_BASE64

### Truststore of other countries metadata signing certificates
Truststore stored in Vault for all environments.
Configured in MetadataModule_Connector.xml/SignModule_Connector_HSM_P12.xml.

### Signing and metadata signing
Signing + metadata signing certificate and key stored in HSM for test and production environments. For local-docker and systest these are stored in Vault.
Configured in MetadataModule_Connector.xml/SignModule_Connector_HSM_P12.xml.
Oppdater sign cert:
1. oppdater SIGN_KEYSTORE_BASE64 i hhv vault (og docker compose om systest)
2. oppdater serialnr i vault (og om systest docker/SignModule_Connector.xml)