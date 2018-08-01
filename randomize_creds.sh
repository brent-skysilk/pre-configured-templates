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

#create credentials file for user to reference at /usr/creds.txt
echo "Wordpress Admin Password" > /usr/creds.txt

#add new wordpress admin password to credentials file
echo "$NEW_WP" >> /usr/creds.txt

#add line break to separate passwords from each other
echo "" >> /usr/creds.txt

#add new mysql password to credentials file
echo "MYSQL Password" >> /usr/creds.txt
echo "$NEW_MYSQL" >> /usr/creds.txt


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



#remove script from init.d
rm /etc/init.d/randomize_creds.sh

#remove script from update-rc.d
update-rc.d randomize_creds.sh remove

#delete self
rm -- "$0"




