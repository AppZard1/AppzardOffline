#!/bin/bash
set -e
platform="unknown"
appdata=""
bindir=""
function resolvePlatform {
    case "$OSTYPE" in
      linux*)   platform="linux" ;;
      msys*)    platform="windows" ;;
      *)        echo "The platform type: $OSTYPE couldn't be resolved as a valid platform!" && exit 1 ;;
    esac
}
function resolveAppDataFolder {
    if [ $platform == "windows" ]; then
        appdata="$APPDATA/appzard"
    elif [ $platform = "MAC" ]; then
        appdata="$HOME/Library/Application/Appzard"
    elif [ $platform == "linux" ]; then
        appdata="$HOME/.appzard"
    fi
}
function createDirIfDoesntExist {
    if [ ! -d "$1" ]; then
      mkdir "$1"
    fi
}
function downloadAppzardExecutable {
  curl --location \
    --progress-bar \
    --url "https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/bin/${platform}/appzard" \
    --output "${bindir}/appzard"
}
function downloadAppengine {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/appengine.zip"
}
function downloadBuildFiles {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/build.zip"
}
function downloadBuildserverFiles {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/buildserver.zip"
}
function downloadUpgradeScript() {
    curl --location \
    --progress-bar \
    --url "https://raw.githubusercontent.com/AppZard1/AppzardOffline/main/scripts/upgrade.sh" \
    --output "${appdata}/scripts/upgrade.sh"
}
function unpackFiles {
    # Unzip the downloaded files
    unzip -o -q "${appdata}/deps/appengine.zip" -d "${appdata}/deps"
    unzip -o -q "${appdata}/deps/build.zip" -d "${appdata}/deps"
    unzip -o -q "${appdata}/deps/buildserver.zip" -d "${appdata}/deps/buildserver"
    # So we don't take a large space
    rm "${appdata}/deps/appengine.zip"
    rm "${appdata}/deps/build.zip"
    rm "${appdata}/deps/buildserver.zip"
}
green="\033[32m"
yellow="\033[33m"
reset="\033[0m"

echo "Starting Appzard installation.."
resolvePlatform
resolveAppDataFolder
appengineDownloadUrl=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/appengine.json" | sed "s/\"//g")
buildDownloadUrl=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/build.json" | sed "s/\"//g")
buildserverDownloadUrl=$(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/buildserver.json" | sed "s/\"//g")
bindir="$HOME/.appzard/bin"
createDirIfDoesntExist "$HOME/.appzard"
createDirIfDoesntExist "${bindir}"
createDirIfDoesntExist "${appdata}"
createDirIfDoesntExist "${appdata}/deps"
createDirIfDoesntExist "${appdata}/buildserver"
createDirIfDoesntExist "${appdata}/scripts"
echo "Downloading Appzard executable.."
downloadAppzardExecutable
echo -e "${green}Done!${reset}"
echo "Downloading Appengine java SDK.."
downloadAppengine "${appengineDownloadUrl}"
echo -e "${green}Done!${reset}"
echo "Downloading Build files.."
downloadBuildFiles "${buildDownloadUrl}"
echo -e "${green}Done!${reset}"
echo "Downloading Buildserver files.."
downloadBuildserverFiles "${buildserverDownloadUrl}"
echo -e "${green}Done!${reset}"
echo "Downloading Upgrade Script.."
downloadUpgradeScript
echo -e "${green}Done!${reset}"
echo "Unpacking files.."
unpackFiles
echo -e "${green}Done!${reset}"
echo -e "${yellow}Appzard has been successfully installed on your device! Please add this path: ${bindir} to your PATH environment variable, then run appzard -v to verify the installation.${reset}"
