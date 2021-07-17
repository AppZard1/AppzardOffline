# AppzardOffline
The offline version for Appzard workspace
## Installation
You can install appzard on your device by:
- Opening a new terminal and running:
 
```
curl https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/scripts/install.sh | bash
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
## Found a bug?
Incase you found a bug, please report it to our staff, either by opening a new issue in github, or a new topic on our commnity ( https://community.appzard.com )
