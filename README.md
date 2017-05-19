# CSGO Demo Uploader
This is a simple bash script that moves csgo demos (*.dem) out of the current folder to an external webserver to be downloaded via a browser. Package requirements:
```bash
apt-get install openssh-client zip
```

It also requires the following environmental variables to be set (since I use this script inside Docker containers):
```bash
$SRCDS_IP
$SRCDS_PORT
$SRCDS_PW
$SRCDS_RCONPW
```
**The user running this script requires a valid ssh key setup to access the remote server and move the files over.**

Note: This script is made to run while the gameserver is running and will automatically detect if the demo is finished and ready to upload.
