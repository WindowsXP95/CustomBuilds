#!/bin/bash

# /etc/chrome_dev.conf�˻��ꤷ���Ԥ��ɲä��롣
# Ʊ����/usr/local/myscript/chrome_dev_history��Ʊ�����Ƥ��ɲä��롣
# �ɤ���˽��Ϥ���ݤ��ʣ�����å�����Ʊ���Ԥ��ޤޤ�ʤ��褦�ˤ���
# $1 chrome_dev.conf�˽��Ϥ���ʸ���󡣶����ޤ���ϥ��֥륯�����ȤǰϤ�
add_chrome_dev() {
  chrome_dev=/etc/chrome_dev.conf
  if [ ! -e ${chrome_dev} ]; then
    echo chrome_dev.conf not found. Abort.
    exit 1
  fi
  line=`grep -- "$1" ${chrome_dev}`
  if [ -z "${line}" ]; then
    mount -o remount,rw /
    if [ 0 -ne $? ]; then
      echo Remount failed. Abort.
      exit 1
    fi
    echo "$1" >> ${chrome_dev}
    echo add line to chrome_dev.conf
  else
    echo same line already exists in chrome_dev.conf 
  fi
  history=${script_local}/chrome_dev_history.sh
  if [ -e ${history} ]; then
    # ����Ʊ���Ԥ�¸�ߤ��뤫��ǧ����
    line=`grep -- "$1" ${history}`
    if [ -z "${line}" ]; then
      echo "$1" >> ${history}
      echo add line comand to chrome_dev_history.
    else
      echo same line already exists in chrome_dev_history.
    fi
  else
    echo $1 > ${history}
  fi

}

#script_local=/tmp
#add_chrome_dev "test test"
