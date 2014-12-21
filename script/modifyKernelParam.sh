#!/bin/bash

source ./path.sh
source ./getKernelSourcePath.sh

# ���ꤷ�������ͥ�ѥ�᡼�������ꤵ��Ƥ���config�ե������õ��
# $1 : �ѥ�᡼��̾
# return : 0������ 1�����顼
getTargetConfigName(){
	local kernel_fullpath=`getKernelSourcePath`

	if [ -z "${kernel_fullpath}" ]; then
		return 1
	fi
	pushd . > /dev/null

	cd ${kernel_fullpath}/chromeos/config

	local target_line=`find . -name '*.config' -print | grep -e 'base\|i386/' | xargs grep $1`
	local target_configname=${kernel_fullpath}/chromeos/config/`echo ${target_line}|cut -d ":" -f 1 `
	echo ${target_configname}

	popd > /dev/null
	return 0
}

# �����ͥ�ѥ�᡼���θ��ߤ��������ꤷ�����Ƥ��֤�������
# $1 ���ꤹ�����ơ�param=value�η���
# $2 �Խ���������ե�����̾
modifyKernelParam(){
	#echo $1
	#echo $2
	local target_param=`echo $1 | cut -d '=' -f 1`
	#echo ${target_param}
	local sedscript="s/^.*${target_param}.*\$/$1/" 
	echo ${sedscript}
	sed -e "${sedscript}" $2 > $2.new
	if [ 0 -ne $? ]; then
		rm $2.new
		return $?
	fi
	mv -f $2 $2.old
	mv $2.new $2
}

param_name=`echo $1 | cut -d "=" -f 1`
config_path=`getTargetConfigName ${param_name}`
if [ 0 -ne $? ]; then
	exit
fi
modifyKernelParam $1 ${config_path}
