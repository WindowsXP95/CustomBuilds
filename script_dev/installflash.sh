#!/bin/bash

cleanup() {
  cd /home/chronos/user/Downloads
  rm -rf chrome_work
# remount / read-only
mount -r -o remount / 
}

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
export PATH=${PATH}:/usr/local/bin
# download chrome stable version(x86)
echo Download Chrome package...
echo 
cd /home/chronos/user/Downloads
mkdir chrome_work
cd chrome_work

if [ -e google-chrome-stable_current_i386.deb ]; then
  rm google-chrome-stable_current_i386.deb
fi
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
echo
echo Download Completed.
echo
echo Extract package...
ar x google-chrome-stable_current_i386.deb
tar xf data.tar.lzma --lzma
echo 
echo Extracted.
echo
echo get flash version...
cd opt/google/chrome/PepperFlash
flash_version=`grep version manifest.json | grep -o -E '[0-9\.]*'`
if [ -n version ]; then
  echo flash version is ${flash_version}
else
  echo failed to get flash version. Abort.
  cleanup
  exit 1
fi

echo install flash plugin

# remount / writable
mount -o remount,rw /

echo copy plugins
mkdir /opt/google/chrome/PepperFlash
cp libpepflashplayer.so /opt/google/chrome/PepperFlash -f
cp manifest.json /opt/google/chrome/PepperFlash -f

echo add option to /etc/chrome_dev.conf

sed -e '/^--ppapi-flash-path=\/opt\/google\/chrome\/PepperFlash\/libpepflashplayer.so/d' -i /etc/chrome_dev.conf 
sed -e '/^--ppapi-flash-version.*/d' -i /etc/chrome_dev.conf

echo '--ppapi-flash-path=/opt/google/chrome/PepperFlash/libpepflashplayer.so' >> /etc/chrome_dev.conf
echo "--ppapi-flash-version=${flash_version}" >> /etc/chrome_dev.conf

cleanup
echo install Completed.

echo 
echo Please Restert your machine.
