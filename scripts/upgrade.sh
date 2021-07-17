#!/bin/bash
set -e
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
reset="\033[0m"
currentVersion="0"
latestVersion="1"
function createDirIfDoesntExist {
    if [ ! -d "$1" ]; then
      mkdir "$1"
    fi
}

function downloadAppengine {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/appengine.zip"
}
function downloadAppengineLibraries {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/appengine-lib.zip"
}
function downloadBuildFiles {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/build.zip"
}
if ! command -v COMMAND &> /dev/null
then
  currentVersion=$(appzard -v)
  latestVersion=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/version.json" | sed "s/\"//g")
  appengineDownloadUrl=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/appengine.json" | sed "s/\"//g")
  buildDownloadUrl=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/build.json" | sed "s/\"//g")
  appengineLibDownloadUrl=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/appengine-lib.json" | sed "s/\"//g")
  echo "Your current appzard version is ${currentVersion}"
  echo "The latest appzard version is ${latestVersion}"
  if [ "$latestVersion" == "$currentVersion" ]; then
    echo -e "${green}You are up to date!${reset}"
  else
    echo -e "${yellow}An appzard update is available!${reset}"
    read -p "Do you want to update appzard to the latest version? (Y / n): " response
    if [ "$response" == "Y" ]; then
      echo "Starting Appzard update.."
      bindir="$HOME/.appzard/bin"
      platform="unknown"
      appdata=""
      case "$OSTYPE" in
        darwin*)  platform="mac" ;;
        linux*)   platform="linux" ;;
        msys*)    platform="windows" ;;
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
      curl --location \
        --progress-bar \
        --url "https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/bin/${platform}/appzard" \
        --output "${bindir}/appzard"
        echo -e "${green}Done!${reset}"
      forcedUpdate=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/forcedUpdate.json" | sed "s/\"//g")
      if [ "$forcedUpdate" == "true" ]; then
        # a forced update requires downloading the appengine files again
        echo "Downloading Appengine java SDK.."
        downloadAppengine "${appengineDownloadUrl}"
        echo -e "${green}Done!${reset}"
        # We host this separately instead of right using one compressed zip ( which is how it's served by google), to make the archives smaller.
        echo "Downloading appengine java SDK libraries.."
        downloadAppengineLibraries "${appengineLibDownloadUrl}"
        echo -e "${green}Done!${reset}"
        echo "Unpacking files.."
        unzip -o -q "${appdata}/deps/appengine.zip" -d "${appdata}/deps"
        unzip -o -q "${appdata}/deps/appengine-lib.zip" -d "${appdata}/deps/appengine"
        rm "${appdata}/deps/appengine.zip"
        rm "${appdata}/deps/appengine-lib.zip"
        echo -e "${green}Done!${reset}"
      fi
      buildFilesUpdated=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/buildFilesUpdated.json" | sed "s/\"//g")
      if [ "$buildFilesUpdated" == "true" ]; then
        # Appzard's build files has been updated, mostly there's an appzard update
        echo "Downloading Build files.."
        downloadBuildFiles "${buildDownloadUrl}"
        echo -e "${green}Done!${reset}"
        echo "Unpacking files.."
        unzip -o -q "${appdata}/deps/build.zip" -d "${appdata}/deps"
        rm "${appdata}/deps/build.zip"
        echo -e "${green}Done!${reset}"
      fi
      echo -e "${yellow}Appzard update has been completed successfully!${reset}"
    fi
  fi
else
  echo -e "${red}You don't have appzard installed on this device!${reset}"
  exit
fi
