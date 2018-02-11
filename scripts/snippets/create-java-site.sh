# variables: $domain

# tomcat config
echo 'Configuring tomcat...'
sudo perl -i -pe "s!^.*--## Virtual Hosts ##--.*\$!$&\n\
<Host name=\"${domain}\" appBase=\"${domain}\" unpackWARs=\"true\" autoDeploy=\"true\" />!" \
	/opt/tomcat/conf/server.xml
sudo mkdir -p /opt/tomcat/${domain}
sudo chown -R tomcat:tomcat /opt/tomcat/${domain}
sudo chmod -R g+w /opt/tomcat/${domain}

sudo mkdir -p /var/www/${domain}/uploads
sudo chmod g+rw /var/www/${domain}/uploads
sudo chown -R tomcat:tomcat /var/www/${domain}/uploads

# nginx config
echo 'Configuring nginx...'
sudo cp /srv/.templates/site.nginx.conf /etc/nginx/sites-available/${domain}
sudo sed -i -e s/{{domain}}/${domain}/g /etc/nginx/sites-available/${domain}
sudo ln -s /etc/nginx/sites-available/${domain} /etc/nginx/sites-enabled/${domain}

echo 'Restarting tomcat...'
sudo systemctl restart tomcat
echo 'Restarting nginx...'
sudo systemctl restart nginx
