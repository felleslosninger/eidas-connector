#!/bin/bash

# NB: Passwords must be configured in idporten-cd in container.env

#ENCRYPTION: Add passwords to config file for encryption
ENCRYPTMODULE_CONNECTOR_FILE=/etc/config/eidas-connector/EncryptModule_Connector.xml
if [ -f "$ENCRYPTMODULE_CONNECTOR_FILE" ]; then
    echo "Update keystore-config in $ENCRYPTMODULE_CONNECTOR_FILE" && printenv | grep ENCRYPT
    sed -i "s/ENCRYPT_KEYSTORE_PASSWORD/$ENCRYPT_KEYSTORE_PASSWORD/g" $ENCRYPTMODULE_CONNECTOR_FILE
    sed -i "s/ENCRYPT_KEYSTORE_KEY_PASSWORD/$ENCRYPT_KEYSTORE_KEY_PASSWORD/g" $ENCRYPTMODULE_CONNECTOR_FILE
fi

# SIGNING: Add passwords to config file for signing

# For keystore usage in local-docker and systest
SIGNMODULE_CONNECTOR_FILE=/etc/config/eidas-connector/SignModule_Connector.xml
if [ -f "$SIGNMODULE_CONNECTOR_FILE" ]; then
    echo "Update keystore-config in $SIGNMODULE_CONNECTOR_FILE" && printenv | grep PASSWORD
    sed -i "s/TRUSTSTORE_PASSWORD/$TRUSTSTORE_PASSWORD/g" $SIGNMODULE_CONNECTOR_FILE
    sed -i "s/SIGN_KEYSTORE_PASSWORD/$SIGN_KEYSTORE_PASSWORD/g" $SIGNMODULE_CONNECTOR_FILE
    sed -i "s/SIGN_KEYSTORE_KEY_PASSWORD/$SIGN_KEYSTORE_KEY_PASSWORD/g" $SIGNMODULE_CONNECTOR_FILE
    sed -i "s/SIGN_METADATA_KEYSTORE_PASSWORD/$SIGN_METADATA_KEYSTORE_PASSWORD/g" $SIGNMODULE_CONNECTOR_FILE
    sed -i "s/SIGN_METADATA_KEYSTORE_KEY_PASSWORD/$SIGN_METADATA_KEYSTORE_KEY_PASSWORD/g" $SIGNMODULE_CONNECTOR_FILE
    cat /opt/java/openjdk/conf/security/plain.java_bc.security > /opt/java/openjdk/conf/security/java_bc.security
    echo "Removed HSM security provider from java" && grep SunPKCS11 /opt/java/openjdk/conf/security/java_bc.security
fi

# -------- HSM -----------
# HSM_PASSWORD==HSM Password/pin
# HSM_SIGN_ALIAS==alias/label in HSM for signing reponse messages
# HSM_SIGN_CERTIFICATE_SERIAL_NUMBER_HEX==Serial number of certificate in HSM in hex format for signing reponse messages
# HSM_METADATA_SIGN_ALIAS==alias/label in HSM for signing metadata
# HSM_METADATA_SIGN_CERTIFICATE_SERIAL_NUMBER_HEX==Serial number of certificate in HSM in hex format for signing metadata
SIGNMODULE_CONNECTOR_FILE_HSM=/etc/config/eidas-connector/SignModule_Connector_HSM_P12.xml
if [ -f "$SIGNMODULE_CONNECTOR_FILE_HSM" ]; then
    echo "Update keystore-config in $SIGNMODULE_CONNECTOR_FILE_HSM" && printenv | grep -E 'HSM_SIGN_|HSM_METADATA_SIGN_'
    sed -i "s/TRUSTSTORE_PASSWORD/$TRUSTSTORE_PASSWORD/g" $SIGNMODULE_CONNECTOR_FILE_HSM
    sed -i "s/HSM_PASSWORD/$HSM_PASSWORD/g" $SIGNMODULE_CONNECTOR_FILE_HSM
    sed -i "s/HSM_SIGN_ALIAS/$HSM_SIGN_ALIAS/g" $SIGNMODULE_CONNECTOR_FILE_HSM
    sed -i "s/HSM_SIGN_CERTIFICATE_SERIAL_NUMBER_HEX/$HSM_SIGN_CERTIFICATE_SERIAL_NUMBER_HEX/g" $SIGNMODULE_CONNECTOR_FILE_HSM
    sed -i "s/HSM_SIGN_CERTIFICATE_ISSUER/$HSM_SIGN_CERTIFICATE_ISSUER/g" $SIGNMODULE_CONNECTOR_FILE_HSM
    sed -i "s/HSM_METADATA_SIGN_ALIAS/$HSM_METADATA_SIGN_ALIAS/g" $SIGNMODULE_CONNECTOR_FILE_HSM
    sed -i "s/HSM_METADATA_SIGN_CERTIFICATE_SERIAL_NUMBER_HEX/$HSM_METADATA_SIGN_CERTIFICATE_SERIAL_NUMBER_HEX/g" $SIGNMODULE_CONNECTOR_FILE_HSM
    sed -i "s/HSM_METADATA_SIGN_CERTIFICATE_ISSUER/$HSM_METADATA_SIGN_CERTIFICATE_ISSUER/g" $SIGNMODULE_CONNECTOR_FILE_HSM
fi
