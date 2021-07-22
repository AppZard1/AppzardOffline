# AppzardOffline
The offline version for Appzard workspace, this CLI helps appzard users to establish and appzard server locally on their device, with absolutely no need for internet connection.
## Requirments
To get Appzard offline to run correctly, you will need to have some software, which isn't served with appzard offline, installed on your computer.
#### Java
Java 8 is a requirement for appzard offline to start local servers, to check if java is installed on your computer, please run:
```
java -version
```
If it reports that the java command, wasn't found you will need to install it first.
#### System Requirments
To be able to use appzard, your system needs to:
- Have at least 800MB
- Have at least 2 GB RAM
- Have your OS Linux or Windows, macOS isn't officially supported as of now.  
## Installation
Note: A more detailed documentation can be found [here](https://community.appzard.com/t/how-to-install-appzard-offline/376?u=mohamedtamer).
You can install appzard on your device by:
- Opening a new terminal and running:
 
```
curl -s https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/scripts/install.sh | bash
```
And wait for the installation to finish.
After the installation is complete you should get a similar message:
`Appzard has been successfully installed on your device! Please add this path: {PATH} to your PATH environment variable, then run appzard -v to verify the installation.`
Copy the path in the message, and add it to the PATH environment variable, to be able to run the `Appzard` command.
After you add the installation path to the PATH variable, open a new terminal ( or restart your terminal ), then run `appzard -v` to verify the installation has succeeded.
## Available Commands
  ### - `start`
  Syntax: `appzard start`
  Starts a new appzard instance, you must not have a previous session running or have a program using 8888 port or `localhost`.
  ### - `doctor`
  Syntax: `appzard doctor`
  Checks that appzard is correctly configured and up-to-date on your device, please use this command first before reporting an issue to the support team.
## Available Arguments:
  - `--version` (abbr: `-v`): Displays Appzard's version
  - `--help` (abbr: `-h`): Displays the help message
## Upgrading
  Upgrades are periodically released for this service, to upgrade appzard to the latest version, please run:
  ```
  #Windows:
  bash $APPDATA/appzard/scripts/upgrade.sh
  #Linux/Mac:
  bash $HOME/.appzard/scripts/upgrade.sh
  ```
  #### Forced upgrades 
   Sometimes, it's useful to force an update to download all the required files by appzard offline, even though you are up to date, or the update didn't require all files to be downloaded, possibly because some files haven't been downloaded successfully ( you can check this by running `appzard doctor`.).
   To force an upgrade, you just need to add the `-f` flag, for example:
   ```
  #Windows:
  bash $APPDATA/appzard/scripts/upgrade.sh -f
  #Linux/Mac:
  bash $HOME/.appzard/scripts/upgrade.sh -f
  ```
## Uninstalling
  If you want to uninstall appzard from your computer, please delete the following directories:
  
  Windows:
  
  `C:/Users/Username/AppData/Roaming/appzard`
  
  `C:/Users/Useranme/.appzard/`
  
  Mac:
  
  `/home/username/.appzard`
  
  `/home/username/Library/Application Support`
  
  Linux:
  
  `/home/username/.appzard`
  
## FAQ
  ### Appzard offline URL shows a blank screen
  If you were redirected to the local instance URL, yet it has shown a blank screen, please clear your cache and hard reload the page.
  ### Does Appzard offline requires an internet connection anytime?
  The advantage of appzard offline is to be able to run appzard workspace locally without an internet connection. However, some other functions require an internet connection to work properly:
  - Installation: installing Appzard requires an internet connection to download installation files from the cloud.
  - Upgrade: upgrading appzard requires an internet connection, to check the latest version, and download the updated files.
  - `appzard doctor`: appzard doctor requires an internet connection, to check the latest version of appzard.
  ### How to stop appzard offline instance
  When starting a new instance you might have got a similar error: `An appzard instance is already running!`
  
  This error typically results in two situations:

  1- Another program is using the `8888` port, and subsequently failing to establish a connection from appzard offline.

  2- You have started, but didn't kill a previous appzard instance.
  
  #### If there is another program using the `8888` port on your local network
   To check the processes using the `8888` port, please run:
   ```
   netstat -ano | findstr :8888
   ```
   In your prefered terminal, you will get a similar output:
   ```
    TCP    0.0.0.0:8888           0.0.0.0:0              LISTENING       17692
    TCP    YOUR_LOCAL_IP:60121        127.0.0.1:8888         TIME_WAIT       0
    TCP    YOUR_LOCAL_IP:63783        127.0.0.1:88Windows88         TIME_WAIT       0
    ...
   ```
   The last item in each line is the process PID, for example, `17692`, we will use this to kill the process.
   Now, run:
   ```
   # On Windows CMD
   taskkill /PID 17692 /F
   # On gitbash terminal
   tskill 17692
   ```
   To kill the process, now you should be able to start an appzard instance.
   #### If another appzard instance is running
   In case you had another appzard instance running, you have to options to do:

   1- If you have the instance of appzard which is serving the previous appzard instance running on a terminal, use CTRL + C to kill this terminal and its attached processes.

   2- If you don't have it running on a terminal, either follow the example above to kill the process, or, if you are on windows, use CRTL + R then, write taskmgr, and kill the java processes, that should be sufficient for the instance to stop using the localhost port.
## Found a bug?
In case you found a bug, please check first it's not resulted in by a misconfiguration of the appzard offline tool on your computer by running `appzard doctor`, if it reports everything is correct, even though the bug persists, please report it to our staff, by opening either a new issue in GitHub or a new topic on our community ( https://community.appzard.com )
