#!/bin/bash
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
        appdata="$APPDATA\appzard"
    elif [ $platform = "MAC" ]; then
        appdata="$HOME/Library/Application/"
                + "Appzard"
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
    --output "${appdata}\bin\appzard.exe"
}
green="\033[32m"
reset="\033[0m"

echo "Starting Appzard installation.."
resolvePlatform
resolveAppDataFolder
createDirIfDoesntExist "${appdata}\bin"
echo "Downloading Appzard executable.."
downloadAppzardExecutable
echo -e "${green}Done!${reset}"
