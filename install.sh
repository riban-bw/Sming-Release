#!/bin/bash
#
# This script installs Sming V3.5.1 on Posix systems including GNU/Linux, OS X, Cygwin
#
# Run this script from the parent directory for the Sming installation, e.g. to installs in a directory called Sming in your home directory:
# cd ~
# install.sh
# 

# Check wget supports --show-progress
wget -q --show-progress asdf &>/dev/null
if [ $? -eq 2 ]
then
  WGET="wget "
else
  WGET="wget -q --show-progress"
fi

# Check if Sming folder exists
# TODO: Avoid deleting whole Sming folder in case user keeps other data there
if [ -d Sming ]
then
  echo "Sming folder already exists. Delete and continue or Exit? [d/E]:"
  read RESPONSE
  if [ "$RESPONSE" = "d" ]
  then
    echo "Deleting `pwd`/Sming..."
    rm -r Sming 2> /dev/null
  else
    exit 1
  fi
fi
if [ -d Sming ]
then
  echo "Failed to delete Sming folder. Please manually remove before installing."
  exit 1
fi

# Download the platform specific cross compiler
PLATFORM=`uname -sm`
echo "Downloading Sming packages for $PLATFORM..."
if [ "$PLATFORM" = "Linux arm6l" ]
then
  $WGET -O $TEMP/xtensa-lx106-elf.zip https://www.dropbox.com/s/ofhbz9xpu01xtnp/xtensa-lx106-elf-armv6l.zip
elif [[ "$PLATFORM" == "Linux"* ]]
then
  $WGET -O $TEMP/xtensa-lx106-elf.zip https://www.dropbox.com/s/rjcvejm4wu1er8a/xtensa-lx-elf-linux32.zip
elif [[ "$PLATFORM" == "CYGWIN_NT"*"WOW i686" ]]
then
  $WGET -O $TEMP/xtensa-lx106-elf.zip https://www.dropbox.com/s/9jecy6j0rai1ou1/xtensa-lx106-elf-cygwin32.zip
else
  echo "Unsupported platform $PLATFORM"
  exit 1
fi

# Download the platform agnostic packages
$WGET -O $TEMP/Sming.zip https://www.dropbox.com/s/k8zwqo114bj213d/Sming-3.5.1.zip
$WGET -O $TEMP/SDK.zip https://www.dropbox.com/s/b8yjilq9a6xagdm/ESP8266_NONOS_SDK_V2.0.0_16_08_10.zip
#$WGET -O $TEMP/SDK.zip https://www.dropbox.com/s/3h9f3x236qb8ds5/ESP8266_NONOS_SDK-2.1.0.zip
$WGET -O $TEMP/esptool.zip https://www.dropbox.com/s/21ceaa8u9254k1f/esptool.zip

# Install the packages
echo "Installing Sming to `pwd`/Sming..."
unzip -q $TEMP/Sming.zip
unzip -qd Sming/esp-toolkit $TEMP/SDK.zip
unzip -qd Sming/esp-toolkit $TEMP/esptool.zip
unzip -qd Sming/esp-toolkit $TEMP/xtensa-lx106-elf.zip

# TODO: Remove downloaded packages

# Set environmental variables
export ESP_HOME=`pwd`/Sming/esp-toolkit
export SMING_HOME=`pwd`/Sming/Sming

