
# bouncycastle. 
export JAVA_OPTS="$JAVA_OPTS -Djava.security.properties=/opt/java/openjdk/conf/security/java_bc.security"
export JAVA_OPTS="$JAVA_OPTS --module-path $(ls /usr/local/lib/bcprov-jdk18on-*.jar | head -1)"
export JAVA_OPTS="$JAVA_OPTS --add-modules org.bouncycastle.provider"

# eidas config
export EIDAS_CONNECTOR_CONFIG_REPOSITORY="/etc/config/eidas-connector/"
export CLASSPATH=$CLASSPATH:$EIDAS_CONNECTOR_CONFIG_REPOSITORY
# Auditlogs config: -DLOG_HOME="<myDirectoryName>"
export LOG_HOME="/usr/local/tomcat/eidas/logs"
