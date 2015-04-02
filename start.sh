#!/bin/sh -x

# Update Nuxeo HF
#su $NUXEO_USER -m -c "$NUXEOCTL mp-hotfix --relax=false --accept=true"

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
su $NUXEO_USER -m -c "tail -f /var/log/nuxeo/server.log"
