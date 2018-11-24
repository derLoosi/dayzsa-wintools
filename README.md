# dayzsa-wintools

Simple script i use to run my DayZ-Standalone Servers.
Just edit the settings.bat for your likings.
If you dont want to use the backup / compression feature just set the variables to be empty.

# What is it doing
First start:
 - check if steamcmd.exe is ok
 - check if the serverfolder already exists, if not:
   - download the serverfiles
   - create profile folder, battleye folder and sample configs
 - start the server
 
 Next starts / restart:
 - move the logs to profile\logs folder to keep everything clean
 - create a backup if configured
 - compress the backup if configured
 - update / validate the serverfiles
 - start the apocalypse
 - automatic restart if the server.exe is "killed" (script starts over)
 
 # Installation
 - make sure all runtimes for the DayZ Standalone Server are installed
 - download steamcmd from https://developer.valvesoftware.com/wiki/SteamCMD and unpack it somewhere on the server
 - store dayzsa-wintools.bat and settings.bat in the same folder on the server
 - adjust settings.bat for your likings
  
 # Why no BEC / Discord-Webhook integration
 I´am using a BEC and Discord integration on my servers, the reasons why you dont get it with this script:
 Both need additional setup that is not that easy. If you are able to set them up, you are also able to integrate it in the script yourself.
 
I cant support you setting them up, so i removed the relevant parts from this script.

If you need further assistance and want me to setup your vanilla server on your Windows Server contact me (i don´t do this for free!!!)
