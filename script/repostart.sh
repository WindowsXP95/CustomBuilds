#!/bin/bash

# �����ȥǥ��쥯�ȥ꤬repo start����Ƥ��뤫Ĵ�١�
# �ޤ�start����ʤ����start����

branch=`git branch --list | grep $1`
if [ -z "${branch}" ]; then
  repo start $1 .
else
  echo Already repo started. skip.
fi
