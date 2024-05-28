FROM maven:3-eclipse-temurin-22 as builder

WORKDIR /data

ARG GIT_PACKAGE_TOKEN

# Download our redis-lib
ARG REDIS_LIB_VERSION=0.0.9
RUN curl -H "Authorization: token ${GIT_PACKAGE_TOKEN}" -L -O \
  https://maven.pkg.github.com/felleslosninger/eidas-redis-lib/no/idporten/eidas/eidas-redis/${REDIS_LIB_VERSION}/eidas-redis-${REDIS_LIB_VERSION}.jar
RUN curl -H "Authorization: token ${GIT_PACKAGE_TOKEN}" -L -O \
  https://maven.pkg.github.com/felleslosninger/eidas-redis-lib/no/idporten/eidas/eidas-redis-node/${REDIS_LIB_VERSION}/eidas-redis-node-${REDIS_LIB_VERSION}.jar
RUN curl -H "Authorization: token ${GIT_PACKAGE_TOKEN}" -L -O \
  https://maven.pkg.github.com/felleslosninger/eidas-redis-lib/no/idporten/eidas/eidas-redis-specific-communication/${REDIS_LIB_VERSION}/eidas-redis-specific-communication-${REDIS_LIB_VERSION}.jar

# Logstash-logback-endcoder to enable JSON logging (needs jackson). Versions must match logback in proxy pom.xml
ARG LOG_LIB_VERSION=7.2
RUN curl -L -O https://repo1.maven.org/maven2/net/logstash/logback/logstash-logback-encoder/${LOG_LIB_VERSION}/logstash-logback-encoder-${LOG_LIB_VERSION}.jar
ARG JACKSON_LIB_VERSION=2.13.3
RUN curl -L -O https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/${JACKSON_LIB_VERSION}/jackson-core-${JACKSON_LIB_VERSION}.jar
RUN curl -L -O https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/${JACKSON_LIB_VERSION}/jackson-databind-${JACKSON_LIB_VERSION}.jar
RUN curl -L -O https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/${JACKSON_LIB_VERSION}/jackson-annotations-${JACKSON_LIB_VERSION}.jar

# Download & build EU-eidas software
ARG EIDAS_NODE_VERSION=2.7.1
RUN git clone --depth 1 --branch eidasnode-${EIDAS_NODE_VERSION} https://ec.europa.eu/digital-building-blocks/code/scm/eid/eidasnode-pub.git

# Add our custom libs and config to EU-eidas software before build
RUN mkdir -p eidasnode-pub/EIDAS-Node-Connector/src/main/webapp/WEB-INF/lib && cp /data/eidas-redis-*${REDIS_LIB_VERSION}.jar eidasnode-pub/EIDAS-Node-Connector/src/main/webapp/WEB-INF/lib/
RUN cp /data/logstash-logback-encoder-*.jar /data/jackson-*.jar eidasnode-pub/EIDAS-Node-Connector/src/main/webapp/WEB-INF/lib/
COPY docker/connector/config/connectorSpecificCommunicationCaches.xml eidasnode-pub/EIDAS-SpecificCommunicationDefinition/src/main/resources/
COPY docker/connector/logback.xml eidasnode-pub/EIDAS-Node-Connector/src/main/resources/logback.xml

# Build eidas connector service
RUN cd eidasnode-pub && mvn clean install --file EIDAS-Parent/pom.xml -P NodeOnly -P-specificCommunicationJcacheIgnite -DskipTests

RUN mkdir -p eidas-connector-config/
COPY docker/connector/config/ eidas-connector-config

# Replace base URLs in eidas.xml and metadata (whitelist). TODO: move to environment specific k8 config
RUN sed -i 's/EIDAS-PROXY-URL/https:\/\/proxy.eidasnode.dev/g' eidas-connector-config/eidas.xml
RUN sed -i 's/EIDAS-IDPORTEN-CONNECTOR-URL/https:\/\/idporten-proxy.eidasnode.dev/g' eidas-connector-config/eidas.xml
RUN sed -i 's/NO-EIDAS-CONNECTOR-URL/http:\/\/connector.eidasnode.dev/g' eidas-connector-config/eidas.xml
RUN sed -i 's/DEMOLAND-CA-URL/http:\/\/eidas-demo-ca.eidasnode.dev/g' eidas-connector-config/eidas.xml

RUN sed -i 's/DEMOLAND-CA-URL/https:\/\/eidas-demo-ca.eidasnode.dev/g' eidas-connector-config/metadata/MetadataFetcher_Connector.properties
RUN sed -i 's/EIDAS-PROXY-URL/https:\/\/proxy.eidasnode.dev/g' eidas-connector-config/metadata/MetadataFetcher_Connector.properties


FROM tomcat:9.0-jre11-temurin-jammy

#Fjerner passord fra logger ved oppstart
RUN sed -i -e 's/FINE/WARNING/g' /usr/local/tomcat/conf/logging.properties
# Fjerner default applikasjoner fra tomcat
RUN rm -rf /usr/local/tomcat/webapps.dist

COPY docker/bouncycastle/java_bc.security /opt/java/openjdk/conf/security/java_bc.security
COPY docker/bouncycastle/bcprov-jdk18on-1.78.jar /usr/local/lib/bcprov-jdk18on-1.78.jar

COPY docker/connector/tomcat-setenv.sh ${CATALINA_HOME}/bin/setenv.sh
COPY docker/connector/server.xml ${CATALINA_HOME}/conf/server.xml

RUN mkdir -p /etc/config/ && chmod 770 /etc/config/
COPY --from=builder /data/eidas-connector-config/ /etc/config

# Add war files to webapps: /usr/local/tomcat/webapps
COPY --from=builder /data/eidasnode-pub/EIDAS-Node-Connector/target/EidasNodeConnector.war ${CATALINA_HOME}/webapps/ROOT.war
RUN chmod -R 770 ${CATALINA_HOME}/webapps

RUN mkdir -p ${CATALINA_HOME}/conf/Catalina/localhost  && chmod 770 ${CATALINA_HOME}/conf/Catalina/localhost

# eIDAS audit log folder
RUN mkdir -p ${CATALINA_HOME}/eidas/logs && chmod 774 ${CATALINA_HOME}/eidas/logs

EXPOSE 8080

CMD ["/bin/bash", "-c", "catalina.sh run"]
