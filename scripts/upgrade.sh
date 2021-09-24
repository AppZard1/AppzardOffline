#!/bin/bash
set -e
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
reset="\033[0m"
currentVersion="0"
latestVersion="1"
linuxarch="x64"
function createDirIfDoesntExist {
    if [ ! -d "$1" ]; then
      mkdir "$1"
    fi
}

function downloadAppengine {
  curl -k --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/appengine.zip"
}
function downloadBuildFiles {
  curl -k --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/build.zip"
}
function downloadBuildserverFiles {
  curl -k --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/buildserver.zip"
}
function resolveLinuxArch {
    arch=$(uname -m)
    if [ "$arch" == "x86_64" ]; then
      linuxarch="x64"
    elif [ "$arch" == "aarch64" ]; then
      linuxarch="aarch64"
    fi
}
if ! command -v COMMAND &> /dev/null
then
  forceUpgrade=""
  while [ "$#" -gt 0 ]; do
  case "$1" in
    -f) forceUpgrade="$1"; break;;
  esac
done
  echo "Initializing upgrade.."
  currentVersion=$(appzard -v)
  latestVersion=$(curl -k -s "https://appzardoffline-default-rtdb.firebaseio.com/version.json" | sed "s/\"//g")
  appengineDownloadUrl=$(curl -k -s "https://appzardoffline-default-rtdb.firebaseio.com/appengine.json" | sed "s/\"//g")
  buildDownloadUrl=$(curl -k -s "https://appzardoffline-default-rtdb.firebaseio.com/build.json" | sed "s/\"//g")
  buildserverDownloadUrl=$(curl -k -s "https://appzardoffline-default-rtdb.firebaseio.com/buildserver.json" | sed "s/\"//g")
  echo "Your current appzard version is ${currentVersion}"
  echo "The latest appzard version is ${latestVersion}"
  if [ "$latestVersion" == "$currentVersion" ] && [ ! "$forceUpgrade" == "-f" ]; then
    echo -e "${green}You are up to date!${reset}"
  else
    if [ "$forceUpgrade" == "-f" ] && [ "$currentVersion" == "$latestVersion" ]; then
      echo -e "${yellow}No Appzard update is available, starting a forced update..${reset}"
      read -p "Do you want to force update appzard? (Y / n): " response
    else
      echo -e "${yellow}An Appzard update is available!${reset}"
      read -p "Do you want to update appzard to the latest version? (Y / n): " response
    fi
    if [ "$response" == "Y" ]; then
      echo "Starting Appzard update.."
      bindir="$HOME/.appzard/bin"
      platform="unknown"
      appdata=""
      case "$OSTYPE" in
        darwin*)  platform="mac" ;;
        linux*)   platform="linux" ;;
        msys*)    platform="windows" ;;
        cygwin*)    platform="windows" ;;
        *)        echo "The platform type: $OSTYPE couldn't be resolved to a valid operating system!" && exit 1 ;;
      esac
      if [ $platform == "windows" ]; then
        appdata="$APPDATA/appzard"
      elif [ $platform = "MAC" ]; then
          appdata="$HOME/Library/Application/Appzard"
      elif [ $platform == "linux" ]; then
          appdata="$HOME/.appzard"
      fi
      echo "Downloading Appzard executable.."
      executableURL="https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/bin/${platform}"
      if [ "$platform" == "windows" ]; then
        curl -k --location \
        --progress-bar \
        --url "$executableURL/appzard.exe" \
        --output "${bindir}/appzard.exe"
      elif [ "$platform" == "linux" ]; then
        curl -k --location \
        --progress-bar \
        --url "$executableURL/$linuxarch/appzard" \
        --output "${bindir}/appzard"
      else
        curl -k -location \
        --progress-bar \
        --url "$executableURL/appzard" \
        --output "${bindir}/appzard"
      fi
      if [ "$platform" == "windows" ]; then
        chmod +x "$bindir/appzard.exe"
      else
        chmod +x "$bindir/appzard"
      fi
      echo -e "${green}Done!${reset}"
      forcedUpdate=$(curl -k -s "https://appzardoffline-default-rtdb.firebaseio.com/forcedUpdate.json" | sed "s/\"//g")
      if [ "$forcedUpdate" == "true" ] || [ "$forceUpgrade" == "-f" ]; then
        # a forced update requires downloading the appengine files again
        echo "Downloading Appengine java SDK.."
        downloadAppengine "${appengineDownloadUrl}"
        echo -e "${green}Done!${reset}"
        echo "Unpacking files.."
        unzip -o -q "${appdata}/deps/appengine.zip" -d "${appdata}/deps/appengine"
        rm "${appdata}/deps/appengine.zip"
        echo -e "${green}Done!${reset}"
      fi
      buildFilesUpdated=$(curl -k -s "https://appzardoffline-default-rtdb.firebaseio.com/buildFilesUpdated.json" | sed "s/\"//g")
      if [ "$buildFilesUpdated" == "true" ] || [ "$forceUpgrade" == "-f" ]; then
        # Appzard's build files has been updated, mostly there's an appzard update
        echo "Downloading Build files.."
        downloadBuildFiles "${buildDownloadUrl}"
        echo -e "${green}Done!${reset}"
        echo "Unpacking files.."
        unzip -o -q "${appdata}/deps/build.zip" -d "${appdata}/deps"
        rm "${appdata}/deps/build.zip"
        echo -e "${green}Done!${reset}"
      fi
      buildserverFilesUpdated=$(curl -k -s "https://appzardoffline-default-rtdb.firebaseio.com/buildserverFilesUpdated.json" | sed "s/\"//g")
      if [ "$buildserverFilesUpdated" == "true" ] || [ "$forceUpgrade" == "-f" ]; then
        # Appzard's build files has been updated, mostly there's an appzard update
        echo "Downloading Buildserver files.."
        downloadBuildserverFiles "${buildserverDownloadUrl}"
        echo -e "${green}Done!${reset}"
        echo "Unpacking files.."
        unzip -o -q "${appdata}/deps/buildserver.zip" -d "${appdata}/deps"
        rm "${appdata}/deps/buildserver.zip"
        echo -e "${green}Done!${reset}"
      fi
      echo -e "${yellow}Appzard update has been completed successfully!${reset}"
    fi
  fi
else
  echo -e "${red}You don't have appzard installed on this device!${reset}"
  exit
fi
