# Nuxeo docker image for : Université de Lyon
===========================================

This repository holds the Dockerfile for nuxeo

## Configuration
All nuxeo Configuration is stored in the data folder

data Folder structure:
├── binarystore
├── conf
│   ├── CERT-CA.cer
│   ├── log4j.xml
│   ├── nuxeo.conf
│   ├── nuxeo.conf.backup
│   └── templates
│       └── shibboleth
│           ├── nuxeo.defaults
│           └── nxserver
│               └── config
│                   ├── authentication-chain-config.xml
│                   └── shibboleth-config.xml
└── marketplace
    └── marketplace-CustomLoginUDL-1.0.9-SNAPSHOT.zip

binarystore -> Data Storage (H2, elasticsearch)
conf/CERT-CA.cer -> Certification Authority for ldaps authentication
conf/log4j.xml -> Logging parameter
conf/nuxeo.conf -> Nuxeo configuration file
conf/templates -> Nuxeo templates folder (contains shibboleth nuxeo configuration for example)
marketplace/ -> Nuxeo marketplace packages folder (for custom package installation, packages not published on nuxeo marketplace)

You can create your own configuration folder and change theese lines with the correct location

 - /Users/vincent/Documents/dev/java/nuxeo-udl/etc_data:/platform/etc/data
 - /Users/vincent/Documents/dev/java/nuxeo-udl/etc_data/CERT-CA.cer:/tmp/CERT-CA.cer:ro


## build
docker-compose build

## run
docker-compose up

## Custom Certificates

You can use you own Certificates by uncommenting
For SAML encrypyting Certificates.

  volumes:
    - /Location_of_your_cert/sp-cert.pem:/etc/shibboleth/sp-cert.pem:ro
    - /Location_of_your_cert/sp-key.pem:/etc/shibboleth/sp-key.pem:ro

For HTTPS Certificates see (https://github.com/jwilder/nginx-proxy)

  nginx:
    environment:
      DEFAULT_HOST: local.dev
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock
      - /Location_of_your_cert/:/etc/nginx/certs
    image: jwilder/nginx-proxy
