#!/bin/bash


get_version(){
        grep -s 'nuxeo_conf_git_version' /tmp/coreos.js|cut -d '(' -f4|cut -d')' -f1
}
write_version(){
                local CONFIG_VERSION=`cd /platform/etc/data/conf;git show --pretty=format:"%H" --no-patch|| echo "version0" |cut -c1-8`
		if [[ $CONFIG_VERSION != $(get_version) ]] ; then
                local HTML_CONFIG_VERSION="<div style='color:#000;opacity:0.2;float:left'><small class='nuxeo_conf_git_version'>`echo "$DOCKER_HOST - ($CONFIG_VERSION) - "` </small></div></f:subview>"

cat >> /tmp/coreos.js << EOF
(function($) {
        \$(this).ready(function(){
        console.log('ok');
        \$('.copyrights').prepend("$HTML_CONFIG_VERSION");
        }       );
})(jQuery);
EOF
echo "update"
fi
}
write_version
get_version
