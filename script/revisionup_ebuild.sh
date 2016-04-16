#!/bin/bash

# �����ȥǥ��쥯�ȥ�ˤ���ebuild�ե�����Υ���ܥ�å���󥯤Υ�ӥ�����夲��
# �����оݤΥѥå������ǥ��쥯�ȥ��cd���Ƥ��餳�Υ�����ץȤ�Ƥ�
# ����ܥ�å���󥯤�ʣ��������ϥƥ��Ȥ��Ƥ��ʤ��Τ�����ա�

revisionup_ebuild() {
	echo "Revision up ebuild file..."
	local overlay_symlink=`ls -1 | grep -e '.*-r[0-9]*\.ebuild'`
	local symlink_prefix=`echo ${overlay_symlink} | grep -E -o '.*-r'`
	local rev=`echo ${overlay_symlink} | grep -E -o '[0-9]*.ebuild' | cut -d '.' -f 1`

	local newrev=$(( rev + 1 ))
	local new_symlink=${symlink_prefix}${newrev}.ebuild
	
	mv ${overlay_symlink} ${new_symlink}
	if [ 0 -ne $? ]; then
	echo "[ERROR] Failed to rename ebuild file"
	return 1
	fi
	
	echo "Revision changed r${rev} -> r${newrev}"
	
}

