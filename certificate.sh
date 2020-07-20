#!/usr/bin/env bash

echo " ---- Requesting certbot for certificate ---- "
certbot certonly --dns-route53 --non-interactive --agree-tos --register-unsafely-without-email --domain=$ATL_PROXY_NAME --cert-name=$ATL_PROXY_NAME --config-dir /var/atlassian/application-data/crowd/certs --work-dir /var/atlassian/application-data/crowd/certs/lib/  --logs-dir /var/atlassian/application-data/crowd/certs/logs/
openssl pkcs12 -export -inkey /var/atlassian/application-data/crowd/certs/live/$ATL_PROXY_NAME/privkey.pem -in /var/atlassian/application-data/crowd/certs/live/$ATL_PROXY_NAME/cert.pem -certfile /var/atlassian/application-data/crowd/certs/live/$ATL_PROXY_NAME/fullchain.pem -out /var/atlassian/application-data/crowd/certs/live/crowd.pkcs12 -name $ATL_PROXY_NAME -password pass:$KEYSTORE_PASSWORD

echo " ---- Creating a keystore and adding certificates ---- "
/opt/java/openjdk/bin/keytool -importkeystore -srckeystore /var/atlassian/application-data/crowd/certs/live/crowd.pkcs12 -srcstoretype pkcs12 -srcalias $ATL_PROXY_NAME -srcstorepass $KEYSTORE_PASSWORD -destkeystore /var/atlassian/application-data/crowd/crowd.pkcs12  -deststoretype pkcs12 -deststorepass $KEYSTORE_PASSWORD -destalias tomcat -noprompt

/entrypoint.py
