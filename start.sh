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

# Clustering ID generated for nuxeo.conf
j='';for i in {1..64}; do j="$j[[:xdigit:]]" ; done;/bin/cat /proc/self/cgroup |/usr/bin/head -n 1|/bin/sed 's/.*\('$j'\).*/\1/' >/tmp/container.id
echo "repository.clustering.id="$(cat /tmp/container.id |head -c 16) >>  $NUXEO_CONF
# Start nuxeo
su $NUXEO_USER -m -c "$NUXEOCTL --quiet start"
#Where Am I
echo var dockerhost=$(curl -s http://172.17.42.1:2375/v1.17/info)";" >>/tmp/coreos.js
echo "console.log(dockerhost);" >> /tmp/coreos.js
bash /root/version.sh
su $NUXEO_USER -m -c "tail -f /var/log/nuxeo/server.log"
