#!/bin/bash
set -e
platform="unknown"
appdata=""
function resolvePlatform() {
    case "$OSTYPE" in
      darwin*)  platform="mac" ;;
      linux*)   platform="linux" ;;
      msys*)    platform="windows" ;;
      *)        echo "The platform type: $OSTYPE couldn't be resolved as a valid platform!" && exit 1 ;;
    esac
}
function resolveAppDataFolder() {
    if [ $platform == "windows" ]; then
        appdata="$APPDATA/appzard"
    elif [ $platform = "MAC" ]; then
        appdata="$HOME/Library/Application/Appzard"
    elif [ $platform == "linux" ]; then
        appdata="$HOME/.appzard"
    fi
}
function createDirIfDoesntExist() {
    if [ ! -d "$1" ]; then
      mkdir "$1"
    fi
}
function downloadAppzardExecutable() {
  curl --location \
    --progress-bar \
    --url "https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/bin/${platform}/appzard" \
    --output "${appdata}/bin/appzard.exe"
}
function downloadAppengine() {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/appengine.zip"
}
function downloadAppengineLibraries() {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/appengine-lib.zip"
}
function unpackAppengineFiles() {
    # Unzip the downloaded files
    unzip -o -q "${appdata}/deps/appengine.zip" -d "${appdata}/deps"
    unzip -o -q "${appdata}/deps/appengine-lib.zip" -d "${appdata}/deps/appengine"
    # So we don't take a large space
    rm "${appdata}/deps/appengine.zip"
    rm "${appdata}/deps/appengine-lib.zip"
}
green="\033[32m"
yellow="\033[33m"
reset="\033[0m"

echo "Starting Appzard installation.."
resolvePlatform
resolveAppDataFolder
appengineDownloadUrl=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/appengine.json" | sed "s/\"//g")
appengineLibDownloadUrl=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/appengine-lib.json" | sed "s/\"//g")
createDirIfDoesntExist "${appdata}/bin"
createDirIfDoesntExist "${appdata}/deps"
echo "Downloading Appzard executable.."
downloadAppzardExecutable
echo -e "${green}Done!${reset}"
echo "Downloading Appengine java SDK.."
downloadAppengine "${appengineDownloadUrl}"
echo -e "${green}Done!${reset}"
# We host this separately instead of right using one compressed zip ( which is how it's served by google), to make the archives smaller.
echo "Downloading appengine java SDK libraries.."
downloadAppengineLibraries "${appengineLibDownloadUrl}"
echo -e "${green}Done!${reset}"
echo "Unpacking files.."
unpackAppengineFiles
echo -e "${green}Done!${reset}"
echo -e "${yellow}Appzard has been successfully installed on your device! Please add this path: ${appdata}/bin to your PATH environment variable, then run appzard -v to verify the installation.${reset}"