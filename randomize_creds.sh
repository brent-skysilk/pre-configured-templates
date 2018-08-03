#! /bin/bash

### BEGIN INIT INFO
# Provides:          example
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Example initscript
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.  This example start a
#                    single forking daemon capable of writing a pid
#                    file.  To get other behavoirs, implemend
#                    do_start(), do_stop() or other functions to
#                    override the defaults in /lib/init/init-d-script.
### END INIT INFO

#generate new mysql password
NEW_MYSQL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#generate new wordpress admin password
NEW_WP=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#add SkySilk Wordpress graphic to beginning of file
GRAPHIC=`cat /var/wp_skysilk_graphic.txt`
echo "$GRAPHIC" > /root/creds.txt

#add line break
echo "" >> /root/creds.txt
#add line break
echo "" >> /root/creds.txt

#create creds file
echo "Welcome to Wordpress hosted with SkySilk. " >> /root/creds.txt

#add line break
echo "" >> /root/creds.txt

#get vps ip and concatenate with Wordpress login path
IP=$(hostname -i)
IP+='/wp-admin'

#create ip string and make sure user knows username is admin
echo "To login to your Wordpress site, enter $IP into a browser and use these credentials:" >> /root/creds.txt

#add line break
echo "" >> /root/creds.txt

echo "username: admin" >> /root/creds.txt

WP_PW_STRING="password: "
WP_PW_STRING+="$NEW_WP"

#add new wordpress admin password to credentials file
echo "$WP_PW_STRING" >> /root/creds.txt

#add line break to separate passwords from each other
echo "" >> /root/creds.txt


#add new mysql password to credentials file
echo "MYSQL Password" >> /root/creds.txt
echo "$NEW_MYSQL" >> /root/creds.txt

#add line break
echo "" >> /root/creds.txt
#add line break
echo "" >> /root/creds.txt

#closing message to user
echo "You can also find these credentials at /root/creds.txt. We recommend you change your passwords and delete this file as soon as possible." >> /root/creds.txt

#add line break
echo "" >> /root/creds.txt
#add line break
echo "" >> /root/creds.txt


#wait for mysql to start
UP=$(pgrep mysql | wc -l)
while [ "$UP" -eq 0 ]; do
    sleep 1
UP=$(pgrep mysql | wc -l)
done

#give mysql time to initialize
sleep 10

#change mysql password, and wordpress admin password and email
mysql -u root -p"P@ssword5!" <<QUERIES
USE wordpress;
UPDATE wp_users SET user_pass = MD5("$NEW_WP"), user_email = 'admin@exampledomain.com' WHERE ID=1 LIMIT 1;
use mysql;
update user set password=PASSWORD("$NEW_MYSQL") where User='root';
flush privileges;
quit
QUERIES


#add welcome message to login process
chmod +x /var/welcome_message.sh
echo '/var/welcome_message.sh' >>/root/.bashrc

#remove script from init.d
rm /etc/init.d/randomize_creds.sh

#remove script from update-rc.d
update-rc.d randomize_creds.sh remove





