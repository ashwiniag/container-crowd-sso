# Image tag for version to be consistent 
FROM atlassian/crowd:4.1 as Crowd

# Install Certbot 
RUN apt-get update  -y \
 && apt-get install certbot -y  \
 && apt install python3-certbot-dns-route53 -y \
 && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
RUN rm /opt/atlassian/crowd/apache-tomcat/conf/Catalina/localhost/openidserver.xml

COPY --chown=crowd:crowd ./server.xml.j2  /opt/atlassian/etc/server.xml.j2
COPY --chown=crowd:crowd ./keytool.sh /
RUN chmod +x /keytool.sh

EXPOSE 8095 8443
ENTRYPOINT ["/certificate.sh"]
