#!/bin/bash
# �ʲ��Τ褦�ˤ��ơ��������հʹߤΥ��ߥåȤ����뤫���縡������
# find . -mexdepth 1 -exec ~/myenv/script/git_log_since.sh {} "yyyy-mm-dd HH:MM:SS" \; | less
cd $1
git log  --since="$2"
