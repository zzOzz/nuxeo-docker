# Nuxeo IO Base image is a ubuntu precise image with all the dependencies needed by Nuxeo Platform
#
# VERSION               0.0.1

FROM       quay.io/nuxeoio/nuxeo-base
MAINTAINER Vincent Lombard <vincent.lombard@universite-lyon.fr>

# Copy scripts
ADD nuxeo-install.sh /root/nuxeo-install.sh
ADD nuxeo-update.sh /root/nuxeo-update.sh
ADD start.sh /root/start.sh

# Download & Install Nuxeo
RUN /bin/bash /root/nuxeo-install.sh

# Update Nuxeo
ADD instance.clid /var/lib/nuxeo/data/instance.clid
RUN /bin/bash /root/nuxeo-update.sh

# export NUXEO_CONF=/platform/etc/data/conf/nuxeo.conf
ENV NUXEO_CONF /platform/etc/data/conf/nuxeo.conf
RUN mv -f /var/lib/nuxeo/server/lib/log4j.xml /var/lib/nuxeo/server/lib/log4j.xml.orig
#RUN touch /var/lib/nuxeo/server/lib/log4j.xml


#Ajout CA cert ActiveDirectory
ADD ./CERT-CA.cer /etc/ssl/certs/java/CERT-CA.cer
RUN (keytool -import -trustcacerts -alias ca-cert -file /etc/ssl/certs/java/CERT-CA.cer -keystore /etc/ssl/certs/java/cacerts -storepass changeit -noprompt)

EXPOSE 8080
CMD ["/bin/bash","/root/start.sh"]
VOLUME ["/platform/etc/data/","/var/lib/nuxeo/server/lib/log4j.xml"]

# Update/Upgrad all packages on each build
ONBUILD RUN apt-get update && apt-get upgrade -y
#docker run -i -t -v /data-pp/:/platform/etc/data nuxeoudlcontainer_nuxeo /bin/bash
