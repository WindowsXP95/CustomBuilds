#!/bin/bash

# �¹Ԥ���������ץȤ��������¸����
# $1 �������¸���륹����ץȵ�ư���ޥ�ɥ饤��
addhistory(){
  history=${script_local}/history.sh
  if [ -e ${history} ]; then
    # ����Ʊ���Ԥ�¸�ߤ��뤫��ǧ����
    line=`grep $1 ${history}`
    if [ -z "${line}" ]; then
      echo $1 >> ${history}
      echo add shell comand to history.
    else
      echo shell command already exists in history.
    fi
  else
    echo '#!/bin/bash' > ${history}
    echo $1 >> ${history}
  fi

}


