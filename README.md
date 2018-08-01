# pre-configured-templates

The goal of these scripts is to skip user input for turnkey linux apps. The script will run on boot, changing the MySQL root password, and the app admin password and email (so far, this has only been tested with the turnkey Wordpress app). It will then remove itself from the list of processes that run on boot, and delete itself entirely. 

The no-user-input-required template is created by deploying the untouched Wordpress turnkey app, and completing the setup wizard. Then, place the script in /etc/init.d/

Make it executable and give it root priveleges:

```
chmod a+x simple_bash.sh   
chmod 777 simple_bash.sh 
```

Add script as last thing to run before login

```
sudo update-rc.d script.sh defaults
```

The container can now be templated and the script will run on first boot. The user can then find their credentials at /usr/creds.txt

