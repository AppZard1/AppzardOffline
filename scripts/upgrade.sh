#!/bin/bash
set -e
red="\033[31m"
reset="\033[0m"
echo "Starting Appzard update.."
if ! command -v COMMAND &> /dev/null
then
  echo "Your current appzard version is $(appzard -v)"
  echo "The latest appzard version is $(curl -s "https://appzardoffline-default-rtdb.firebaseio.com/version.json" | sed "s/\"//g")"
else
  echo -e "${red}You don't have appzard installed on this device!${reset}"
  exit
fi