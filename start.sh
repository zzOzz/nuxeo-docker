#!/bin/sh -x

# Update Nuxeo HF
#su $NUXEO_USER -m -c "$NUXEOCTL mp-hotfix --relax=false --accept=true"
#Ajout CA cert ActiveDirectory
(keytool -import -trustcacerts -alias ca-cert -file /platform/etc/data/conf/CERT-CA.cer -keystore /etc/ssl/certs/java/cacerts -storepass changeit -noprompt)

#create log4j.xml if not exists
cp -f /platform/etc/data/conf/log4j.xml /var/lib/nuxeo/server/lib/log4j.xml

# Install packages if exist
if [ ! -z "$PACKAGES" ]; then
  su $NUXEO_USER -m -c "$NUXEOCTL mp-install $PACKAGES -s --relax=false --accept=true"
fi

# Install complementary packages if exist
if [ ! -z "$PACKAGES2" ]; then
  su $NUXEO_USER -m -c "$NUXEOCTL mp-install $PACKAGES2 -s --relax=false --accept=true"
fi

# Set Templates if exist
if [ ! -z "$TEMPLATES" ]; then
  su $NUXEO_USER -m -c "sed -i'.backup' 's|\(^nuxeo.templates=\).*|\1$TEMPLATES|g' $NUXEO_CONF"
fi

# Start nuxeo
su $NUXEO_USER -m -c "$NUXEOCTL --quiet start"
#su $NUXEO_USER -m -c "$NUXEOCTL console"
#Where Am I
#curl -s http://172.17.42.1:2375/v1.17/info |tr "," "\n"|grep \"Name|head -1|cut -d ":" -f2
echo var dockerhost=$(curl -s http://172.17.42.1:2375/v1.17/info)";" >>/var/lib/nuxeo/server/nxserver/nuxeo.war/scripts/nxtimezone.js

su $NUXEO_USER -m -c "tail -f /var/log/nuxeo/server.log"
