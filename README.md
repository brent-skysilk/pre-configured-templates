# pre-configured-templates

The goal of these scripts is to skip user input for turnkey linux apps. The script will run on boot, changing the MySQL root password, and the app admin password and email and inserting them into a text file for the user to referene (so far, this has only been tested with the turnkey Wordpress app). It will then remove itself from the list of processes that run on boot, and delete itself entirely. 

In order to display the welcome message and graphic properly, make sure ```welcome_message.sh``` and the graphic .txt file are placed in /var/. The boot script will make the welcome message script executable.

The no-user-input-required template is created by deploying the untouched Wordpress turnkey app, and completing the setup wizard. Then, place the script in /etc/init.d/

Make it executable and give it root priveleges:

```
chmod +x /etc/init.d/randomize_creds.sh 
chmod 777 /etc/init.d/randomize_creds.sh
```

Add script as last thing to run before login

```
sudo update-rc.d randomize_creds.sh defaults
```

The container can now be templated and the script will run on first boot. The user can then find their credentials at /root/creds.txt

