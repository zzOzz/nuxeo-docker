#!/bin/sh -x

# Update Nuxeo HF
su $NUXEO_USER -m -c "$NUXEOCTL mp-hotfix --relax=false --accept=true"
