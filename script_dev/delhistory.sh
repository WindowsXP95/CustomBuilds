#!/bin/bash

# �¹Ԥ���������ץȤ����򤫤���ꤷ���Ԥ�������
# $1 ���򤫤������륹����ץȵ�ư���ޥ�ɥ饤��
delhistory(){
  history=${script_local}/history.sh
  args="$@"
  echo "args=${args}"
  if [ -e ${history} ]; then
    # ����Ʊ���Ԥ�¸�ߤ��뤫��ǧ����
    line=`grep "${args}" ${history}`
    if [ -n "${line}" ]; then
      delline=`echo ${line} | sed -e 's@/@\\\\/@g'`
      sed -e "/${delline}/d" -i ${history}
      if [ 0 -ne $? ]; then
        echo Failed to delete shell command from history. abort.
	exit 1
      fi
      echo delete shell command from history.
    else
      echo specified shell command not found history.
    fi
  else
    echo ${history} not found.
  fi

}

