#!/bin/bash

DIR="/opt/letsencrypt"
CONFIG_PATH="/etc/letsencrypt/cli.ini"
EMAIL=""
DOMAINS=""

if [ -d ${DIR} ]; then
    git checkout .

    echo "UPDATING REPO"
    cd ${DIR}
    git pull origin master
else
    echo "CLONING GIT REPO"
    git clone https://github.com/letsencrypt/letsencrypt ${DIR}
fi

cat > ${CONFIG_PATH} <<EOF
rsa-key-size = 4096
email = ${EMAIL}
webroot-path = /usr/share/nginx/html
EOF

cd ${DIR}

IFS=', ' read -r -a array <<< ${DOMAINS}

service nginx stop

for x in "${array[@]}"
do
    echo "$x";
    ./letsencrypt-auto certonly --standalone --agree-tos --keep-until-expiring -d ${x} --config ${CONFIG_PATH}
done

service nginx start





