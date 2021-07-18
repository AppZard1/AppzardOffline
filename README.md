# AppzardOffline
The offline version for Appzard workspace
## Installation
You can install appzard on your device by:
- Opening a new terminal and running:
 
```
curl -s https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/scripts/install.sh | bash
```
And wait for the installation to finish.
After the installation is complete you should get a simmilar message:
`Appzard has been successfully installed on your device! Please add this path: {PATH} to your PATH environment variable, then run appzard -v to verify the installation.`
Copy the path in the message, and add it in the PATH environment variable, in order to be able to run the `appzard` command.
After you add the installation path to the PATH variable, open a new terminal ( or restart your terminal ), then run `appzard -v` to verify the installation has succeeded.
## Available Commands
  ### - `start`
  Syntax: `appzard start`
  Starts a new appzard instance, you must not have a previous session running or have a program using 8888 port or `localhost`.
  ### - `doctor`
  Syntax: `appzard doctor`
  Checks that appzard is correctly configured and up-to-date on your device, please use this command first before reposrting an issue to the support team.
## Available Arguments:
  - `--version` (abbr: `-v`): Displays appzard's version
  - `--help` (abbr: `-h`): Displays the help message
## Upgrading
  Upgrades are periocially released for this service, to upgrade appzard to the latest version, please run:
  ```
  #Windows:
  bash $APPDATA/appzard/scripts/upgrade.sh
  #Linux/Mac:
  bash $HOME/.appzard/scripts/upgrade.sh
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
  ### Appzard offline url shows a blank screen
  If you were redirected to the local instance url, yet it has shown a blank screen, please clear your cache and hard reload the page.
  ### How to stop appzard offline instance
  When starting a new instance you might have got a similar error: `An appzard instance is already running!`
  
  This error is typically resulted in from two situations:
  1- Another program is using the `8888` port, and subsequently failling to establish a connection from appzard offline.
  2- You have started, but didn't kill a previous appzard instance.
  
  #### If there is another program using the `8888` port on your local network
   To check the processes using the `8888` port, please run:
   ```
   netstat -ano | findstr :8888
   ```
   In your prefered terminal, you will get a simmilar output:
   ```
    TCP    0.0.0.0:8888           0.0.0.0:0              LISTENING       17692
    TCP    YOUR_LOCAL_IP:60121        127.0.0.1:8888         TIME_WAIT       0
    TCP    YOUR_LOCAL_IP:63783        127.0.0.1:8888         TIME_WAIT       0
    ...
   ```
   The last item in each line is the process PID, for example `17692`, we will use this to kill the process.
   Now, run:
   ```
   # On windows CMD
   taskkill /PID 17692 /F
   # On gitbash terminal
   tskill 17692
   ```
   To kill the process, now you should be able to start an appzard instance.
   #### If another appzard instance is running
   In case you had another appzard instance running, you have to options to do:
   1- If you have the instance of appzard which is serving the previous appzard instance running on a terminal, use CTRL + C to kill this terminal and it's attached processes.
   2- If you don't have it running on a terminal, either follow the example above to kill the process, or, if you are on windows, use CRTL + R then, write taskmgr, and kill the java processes, that should be sufficient for the instance to stop using the localhost port.
## Found a bug?
Incase you found a bug, please check first it's not resulted in by a mis-confoiguration of the appzard offline tool on your computer by running `appzard doctor`, if it reports eveything is correct, even though the bug persists, please report it to our staff, either by opening a new issue in github, or a new topic on our commnity ( https://community.appzard.com )
