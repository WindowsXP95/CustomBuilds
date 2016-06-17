#!/bin/bash

cd `dirname $0`
. ./script_root.sh
source addhistory.sh

# x86�Ǥϥ��顼�ˤ���
is_x86=`uname -a | grep i686`
if [ -n "{is_x86}" ]; then
  echo Flash suport ended on x86 build. Abort. 
  exit 1
fi

# ��֡��Ȥ��������ٵ�ư�������ϲ��⤷�ʤ�

if [ -f ${script_local}/pre-shutdown.sh ]; then
  echo "installflash has been already executed. Skip."
  echo "Please reboot to start the installation. "
  exit 0
fi

# downloadflash�ϥҥ��ȥ�˵�Ͽ���ʤ���ɬ����ư�ǵ�ư���ƥ��󥹥ȡ��뤹���
#addhistory $0

if [ -e /opt/google/chrome/PepperFlash/manifest.json ]; then

  old_version=`grep version /opt/google/chrome/PepperFlash/manifest.json | grep -o -E '[0-9\.]*'`
  echo The current version of Flash Player is : ${old_version}
  echo Start the update...
else
  echo "Flash Player isn't installed."
  echo Start a new installation...
fi

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
export PATH=${PATH}:/usr/local/bin
# download chrome stable version(x86)
echo Download the Chrome package...
echo 
if [ ! -d ${script_local} ]; then
  rm ${script_local} > /dev/null 2>&1
  mkdir ${script_local}
fi

cd ${script_local}
mkdir chrome_work
cd chrome_work

if [ -e google-chrome-stable_current_amd64.deb ]; then
  rm google-chrome-stable_current_amd64.deb
fi
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
if [ 0 -ne $? ]; then
  echo Download failed. Abort..
  cd ..
  rm -rf chrome_work
  exit 1
fi
echo
echo Download is completed.
echo

echo Extract the package...
ar x google-chrome-stable_current_amd64.deb
if [ 0 -ne $? ]; then
  echo "Failed to extract package(ar). Abort.."
  cd ..
  rm -rf chrome_work
  exit 1
fi
#tar xf data.tar.lzma --lzma
xz -dv data.tar.xz
if [ 0 -ne $? ]; then
  echo "Failed to extract package(xz). Abort.."
  cd ..
  rm -rf chrome_work
  exit 1
fi

tar xf data.tar
if [ 0 -ne $? ]; then
  echo Failed to unpack package. Abort..
  cd ..
  rm -rf chrome_work
  exit 1
fi
echo 
echo Extracted.
echo

echo Create symlink. 

# remount / writable
mount -o remount,rw /
if [ 0 -ne $? ]; then
  echo Failed to remount root partition. Abort..
  cd ..
  rm -rf chrome_work
  exit 1
fi

ln -s ${script_root}/installflash.sh ${script_local}/pre-shutdown.sh
if [ 0 -ne $? ]; then
  echo Failed to create symlink. Abort..
  cd ..
  rm -rf chrome_work
  exit 1
fi

mount -r -o remount /

echo 
echo Ready to Install. Please reboot to start the installation.

