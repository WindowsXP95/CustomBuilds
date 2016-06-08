#!/bin/bash

if [ -z ${BOARD} ]; then
  echo "[ERROR] Please set BOARD".
  exit 1
fi

#��Ⱦ���latest����
cd ~/trunk/src/build/images/x86-pentiumm/latest

if [ ! -f ./chromiumos_base_image.bin ]; then
  echo chromiumos_base_image.bin not found. Abort.
  exit 1
fi

# base���᡼����Ȥ��Τ�dev���᡼���ϥ�͡��ह��
if [ -f ./chromiumos_image.bin ]; then
  mv ./chromiumos_image.bin ./chromiumos_image.bin-
  if [ $? -ne 0 ]; then
    echo failed to rename dev image. Abort.
    exit 1
  fi
fi

# base���᡼����image_to_vm.sh�����Ȥ���ե�����̾�˥���ܥ�å����
ln -s ./chromiumos_base_image.bin ./chromiumos_image.bin
if [ $? -ne 0 ]; then
  echo failed to create symbolic link. Abort.
  exit 1
fi

# VM�ѥ��᡼������
cd ~/trunk/src/scripts
echo start creating vm image...
./image_to_vm.sh --board=${BOARD}
if [ $? -ne 0 ]; then
  echo failed to create vm image. Abort.
  exit 1
fi

# ����ܥ�å���󥯤�ä�
cd ~/trunk/src/build/images/x86-pentiumm/latest
unlink ./chromiumos_image.bin
if [ $? -ne 0 ]; then
  echo failed to remove symbolic link. Abort.
  exit 1
fi


# ���򤷤����᡼���򸵤��᤹
if [ -f ./chromiumos_image.bin- ]; then
  mv ./chromiumos_image.bin- ./chromiumos_image.bin
  if [ $? -ne 0 ]; then
    echo failed to recovery dev image. Abort.
    exit 1
  fi
fi


