#!/bin/sh -x

# Nuxeo setup

# wget -q "http://cdn.nuxeo.com/nuxeo-7.4/nuxeo-cap-7.4-tomcat.zip" -O /tmp/nuxeo-distribution-tomcat.zip
#
# mkdir -p /tmp/nuxeo-distribution
# unzip -q -d /tmp/nuxeo-distribution /tmp/nuxeo-distribution-tomcat.zip
# distdir=$(/bin/ls /tmp/nuxeo-distribution | head -n 1)
# mkdir -p $NUXEO_HOME
# mv /tmp/nuxeo-distribution/$distdir/* $NUXEO_HOME
# rm -rf /tmp/nuxeo-distribution*
# chmod +x $NUXEO_HOME/bin/nuxeoctl
#
# mkdir -p /var/lib/nuxeo/data
# mkdir -p /var/log/nuxeo
# mkdir -p /var/run/nuxeo
#
# chown -R $NUXEO_USER:$NUXEO_USER /var/lib/nuxeo
# chown -R $NUXEO_USER:$NUXEO_USER /var/log/nuxeo
# chown -R $NUXEO_USER:$NUXEO_USER /var/run/nuxeo
#
# cat << EOF >> $NUXEO_HOME/bin/nuxeo.conf
# nuxeo.log.dir=/var/log/nuxeo
# nuxeo.pid.dir=/var/run/nuxeo
# nuxeo.data.dir=/var/lib/nuxeo/data
# nuxeo.wizard.done=true
# server.status.key=dd935711
# EOF


# Install java

if [ ! "$NUXEO_VERSION" == "nuxeo-6.0" ]; then
  echo "remove java 7 and install java 8"
  apt-get remove -y --purge openjdk-7-jdk
  add-apt-repository -y ppa:webupd8team/java && apt-get update
  echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
  echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
  apt-get install -y oracle-java8-installer
fi

# Nuxeo setup
#wget -q "http://cdn.nuxeo.com/nuxeo-7.4/nuxeo-cap-7.4-tomcat.zip" -O /tmp/nuxeo-distribution-tomcat.zip
echo "version: "$NUXEO_VERSION
wget -q -r -nd --no-parent -A "nuxeo*cap*tomcat.zip" "http://cdn.nuxeo.com/"$NUXEO_VERSION"/" -O /tmp/nuxeo-distribution-tomcat.zip


mkdir -p /tmp/nuxeo-distribution
unzip -q -d /tmp/nuxeo-distribution /tmp/nuxeo-distribution-tomcat.zip
DISTDIR=$(/bin/ls /tmp/nuxeo-distribution | head -n 1)
mkdir -p $NUXEO_HOME
mv /tmp/nuxeo-distribution/$DISTDIR/* $NUXEO_HOME
rm -rf /tmp/nuxeo-distribution*
chmod +x $NUXEO_HOME/bin/nuxeoctl

mkdir -p /var/lib/nuxeo/data
mkdir -p /var/log/nuxeo
mkdir -p /var/run/nuxeo

chown -R $NUXEO_USER:$NUXEO_USER /var/lib/nuxeo
chown -R $NUXEO_USER:$NUXEO_USER /var/log/nuxeo
chown -R $NUXEO_USER:$NUXEO_USER /var/run/nuxeo
cat << EOF >> $NUXEO_HOME/bin/nuxeo.conf
nuxeo.log.dir=/var/log/nuxeo
nuxeo.pid.dir=/var/run/nuxeo
nuxeo.data.dir=/var/lib/nuxeo/data
nuxeo.wizard.done=true
server.status.key=dd935711
EOF
