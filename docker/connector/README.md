# eIDAS-connector Configuration

Folder `config` contains the configuration files for the eIDAS-connector.

## URLs
Placeholders to change:
* `NO-EIDAS-CONNECTOR-URL` - URL of this application (eidas-connector) used in eidas.xml
* `IDPORTEN-CONNECTOR-URL` - URL to eidas-idporten-connector (SpecificConnectorService) used in eidas.xml
* `DEMOLAND-CA-URL` - URL of the CA of the DEMOLAND country whitelisted in metadata/ folder. Also add foreign countries EidasNodeConnector to this list.
* `NO-EU-EIDAS-CONNECTOR-URL` - URL of Norway NO country whitelisted in metadata/ folder. Also add foreign countries EidasNodeConnector to this list.

NB: might be changed to reflect correct context-paths and api.

These must be altered in dockerfile or in config outside of K8 container.

## Keystores
TODO: replace with our versions, should use HMS in test/production.

