touch /config/aria2.session
envsubst < config.template > aria2.conf
cp -n aria2.conf /config/aria2.conf
aria2c --conf-path=/config/aria2.conf