#!/bin/bash

# �¹Ԥ���������ץȤ��������¸����
# $1 �������¸���륹����ץȵ�ư���ޥ�ɥ饤��
addhistory(){
  history=${script_local}/history.sh
  args="$@"
  echo "args=${args}"
  nohis=`echo ${args} | grep nohistory`
  if [ -z "${nohis}" ]; then
    if [ -e ${history} ]; then
      # ����Ʊ���Ԥ�¸�ߤ��뤫��ǧ����
      line=`grep "${args}" ${history}`
      if [ -z "${line}" ]; then
        echo ${args} >> ${history}
        echo add shell comand to history.
      else
        echo shell command already exists in history.
      fi
    else
      echo '#!/bin/bash' > ${history}
      echo ${args} >> ${history}
      echo add shell comand to history.
    fi
  fi

}


