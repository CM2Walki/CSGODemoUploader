# CSGO Demo Uploader
This is a simple bash script that moves csgo demos (*.dem) out of the current folder to an external webserver to be downloaded via a browser. The most important thing is that it's executed by an user that has the right ssh key to access the remote server and move the file over.

Currently the script 'encrypts' the demos with a password (server password + first letter of rcon), make sure those variables get declared before hand! In my case they are Docker environmental variables which are valid inside the container context and thus don't need to be defined again.

Note: This script is made to run while the gameserver is running and will automatically detect if the demo is finished and ready to upload.
