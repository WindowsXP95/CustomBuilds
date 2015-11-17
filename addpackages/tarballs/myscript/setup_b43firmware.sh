#!/bin/bash

cd `dirname $0`
source script_root.sh
source addhistory.sh

#addhistory $0 "$@"

# remount root rw
mount -o remount,rw /

BACKUPDIR=/mnt/stateful_partition/dev_image/myscript/b43
FIRMWARE_ARCHIVE=broadcom-wl-6.30.163.46.tar.bz2
FIRMWARE_FILE=broadcom-wl-6.30.163.46.wl_apsta.o

# /mnt/stateful_partition/dev_image/myscript/firmware/b43 �����뤫�����å�����
if [ -d ${BACKUPDIR} ]; then
  # ���Ĥ��ä��ʤ饤�󥹥ȡ��뤷�ƽ�λ
  echo The backup of B43 firmware found. installing...
  cp -r ${BACKUPDIR} /lib/firmware
  if [ $? -eq 0 ]; then
    echo Firmware installed.
    exit 0
  else
    echo Failed to install firmware. Abort.
    exit 1
  fi
  
fi

# nohistory�����ꤵ��Ƥ�����ϥХå����åפ��ʤ���Хե����०�����򥤥󥹥ȡ��뤹��褦�˥�å�������Ф��ƽ�λ
nohis=`echo $@ | grep nohistory`

if [ -n "${nohis}" ]; then
  echo 
  echo =======================================================
  echo Broadcom Wireless Chip requires the firmware.
  echo The firmware is not included because of license issues.
  echo Please install it manually.
  echo See http://chromiumosde.gozaru.jp/b43firmware.html
  echo =======================================================
  echo 
  exit 0
fi 

# nohistory�����ꤵ��Ƥ��ʤ����ϥ�ࡼ�Х֥��ǥ����򸡺����ƥե����०�������������֤����뤫Ĵ�٤롣
# �ͥåȥ�����ʤ����֤Ǥϥ����󤬤Ǥ�������ࡼ�Х֥��ǥ����μ�ư�ޥ���Ȥ�ư���ʤ��ΤǼ�ʬ��õ�������ʤ���
# �ޤ���ࡼ�Х֥��ǥ����ΰ�������
echo Search for firmware archive on removable media...
mkdir /tmp/_mnt
dbus-send --system --dest=org.chromium.CrosDisks --type=method_call --print-reply /org/chromium/CrosDisks org.chromium.CrosDisks.EnumerateAutoMountableDevices | grep -e '^ *string' | grep -v '/ata' | grep -o -e '/[^/]*"$' | sed -e 's/"//'  | while read mountable; do
  mount /dev/${mountable} /tmp/_mnt 2>/dev/null
  if [ $? -eq 0 ]; then
    # �ޥ���ȤǤ����ʤ�ե����뤬���뤫õ��
    if [ -e /tmp/_mnt/${FIRMWARE_ARCHIVE} ]; then
      # ���Ĥ��ä���script_local�β��˥��ԡ�����
      echo The firmware archive found. Copy to internal disk.
      cp /tmp/_mnt/${FIRMWARE_ARCHIVE} ${script_local}/
      umount /tmp/_mnt
      break;
    fi
    umount /tmp/_mnt
  fi
done
# script_local�˥ե����०�������������֤����뤫Ĵ�٤�
cd ${script_local}
if [ ! -e ./${FIRMWARE_ARCHIVE} ]; then
  # �ʤ����ϥ�������ɤ��ߤ�
  echo Firmware archive not found.
  echo Trying to download firmware...
  wget http://www.lwfinger.com/b43-firmware/${FIRMWARE_ARCHIVE}
  if [ $? -ne 0 ]; then
    echo Failed to download firmware. Abort.
    exit 1
  fi
  echo Done.
  
fi

# ���٥�������ɥǥ��쥯�ȥ�˥ե����०�������������֤����뤫Ĵ�٤�
if [ ! -e ./${FIRMWARE_ARCHIVE} ]; then
  echo Firmware archive does not found. Abort.
  exit 1
fi

# �ե����०�������������֤�Ÿ��
echo Get firmware object file from archive..
tar jxf ./${FIRMWARE_ARCHIVE}
if [ $? -ne 0 ]; then
  echo Failed to get firmware object file. Abort.
  exit 1
fi
echo Done.

# b43-fwcutter�ǥե����०�������ڤ�Ф�
echo Extract firmware from object file...
b43-fwcutter -w ${script_local} ${FIRMWARE_FILE}
if [ $? -ne 0 ]; then
  echo b43-fwcutter failed. Abort.
  exit 1
fi
echo Done.

# �ڤ�Ф����ե����०�����򥤥󥹥ȡ��뤹��
echo Install firmware...
cp -r ${BACKUPDIR} /lib/firmware
if [ $? -ne 0 ]; then
  echo Failed to install. Abort.
  exit 1
fi

echo Done. Please reboot.

exit 0

