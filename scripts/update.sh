#!/bin/bash

if [ "$EUID" -ne 0 ]
    echo "This script requires root privileges. Please enter your sudo password when prompted."
    sudo $0 $@
    exit
fi

echo "Grabbing the latest updater script..."
TMP_FILE=$(mktemp)
wget "https://github.com/UnchartedBull/OctoDash/raw/main/scripts/updater.sh" -q -O "${TMP_FILE}"
if [ $? -ne 0 ]
then
    echo "Failed to grab updater script. Aborting..."
    exit 1
fi

CHANGED=$(md5sum "${TMP_FILE}" "/opt/OctoDash/update.sh" | awk ' { print $1 } ' | uniq | wc -l)
if [ $CHANGED -gt 1 ]
then
    echo "Update script has changed. Re-executing..."
    mv "${TMP_FILE}" "/opt/OctoDash/update.sh"
    sudo $0 $@
    exit
fi


arch=$(uname -m)
if [[ $arch == x86_64 ]]; then
    releaseURL=$(curl -s "https://api.github.com/repos/UnchartedBull/OctoDash/releases/latest" | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4)
elif [[ $arch == aarch64 ]]; then
    releaseURL=$(curl -s "https://api.github.com/repos/UnchartedBull/OctoDash/releases/latest" | grep "browser_download_url.*arm64.deb" | cut -d '"' -f 4)
elif  [[ $arch == arm* ]]; then
    releaseURL=$(curl -s "https://api.github.com/repos/UnchartedBull/OctoDash/releases/latest" | grep "browser_download_url.*armv7l.deb" | cut -d '"' -f 4)
fi

IFS='/' read -ra version <<< "$releaseURL"


echo "Updating OctoDash"

echo "Downloading package..."
DEB_FILE=$(mktemp)
wget "${releaseURL}" -O "${DEB_FILE}" -q --show-progress


echo "Installing Dependencies ..."
dependencies=$(dpkg -I "${DEB_FILE}" | grep '^ Depends: ' | awk -F'Depends: ' ' { print $2 } ' | sed 's/,//g')
apt -qq update
apt -qq install $dependencies -y

echo "Installing OctoDash "${version[7]}, $arch" ..."
dpkg -i "${DEB_FILE}"

rm "${DEB_FILE}"

echo "Upgrade complete..."
