#!/bin/bash

source ./path.sh
source ./getKernelSourcePath.sh

# ���ꤷ�������ͥ�ѥ�᡼�������ꤵ��Ƥ���config�ե������õ��
# $1 : �ѥ�᡼��̾
# return : 0������ 1�����顼
getTargetConfigName(){
	kernel_path=`getKernelSourcePath`

	if [ -z "${kernel_path}" ]; then
		return 1
	fi
#echo root=${SDK_ROOT}
	local kernel_fullpath=${SDK_ROOT}/${kernel_path}
#echo ${kernel_fullpath}

	pushd . > /dev/null

	cd ${kernel_fullpath}/chromeos/config

	local target_line=`find . -name '*.config' -print | grep -e 'base\|i386/' | xargs grep $1`
	local target_configname=${kernel_fullpath}/`echo ${target_line}|cut -d ":" -f 1 `
	echo ${target_configname}

	popd > /dev/null
	return 0
}

# �����ͥ�ѥ�᡼���θ��ߤ��������ꤷ�����Ƥ��֤�������
# $1 ���ꤹ�����ơ�param=value�η���
# $2 �Խ���������ե�����̾
modifyKernelParam(){
	echo $1
	echo $2
	local target_param=`echo $1 | cut -d '=' -f 1`
	echo ${target_param}
	local sedscript="s/^.*${target_param}.*$/$1/" 
	echo ${sedscript}
}

modifyKernelParam CONFIG_PATA_ACPI=y ~/myenv/test/common.config
