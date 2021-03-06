#!/bin/bash
myname=$0
cd ${myname%/*}

source ./revisionup_ebuild.sh

if [ -z ${BOARD} ]; then
	echo "[ERROR] Please set BOARD".
	exit 1
fi

# スクリプトをtarにまとめる。このとき、ディレクトリmyscript配下にスクリプトが置かれるようにする
pushd . > /dev/null
#copydir=~/myenv/addpackages/tarballs/myscript-1
copydir=~/myenv/addpackages/tarballs/myscript
if [ -e ${copydir} ]; then
	rm -rf ${copydir}
fi
mkdir ${copydir}
cp -R ../script_dev/* ${copydir}

cd ${copydir}/..
#tar zcvf myscript.tar.gz ./myscript-1
tar zcvf myscript.tar.gz ./myscript
if [ 0 -ne $? ]; then
	echo "[ERROR]Create tar failed. Abort."
	exit 1
fi


# 作成したtar.gzをキャッシュディレクトリに置く
cp myscript.tar.gz /var/cache/chromeos-cache/distfiles/target/
if [ 0 -ne $? ]; then
	echo "[ERROR]copy tar to cache dir failed. Abort."
	exit 1
fi


# ebuildを所定の場所に置く
cd ../ebuilds/app-misc
tar cvf - myscript | (cd ~/trunk/src/third_party/portage-stable/app-misc; tar xf -)
if [ 0 -ne $? ]; then
	echo "[ERROR]copy ebuild to portage-stable failed. Abort."
	exit 1
fi

# portageのパッケージ展開先をクリアしておく
portage_workdir=/build/${BOARD}/tmp/portage/app-misc/myscript-1
if [ -e ${portage_workdir} ]; then
	sudo rm -rf ${portage_workdir}
fi

# ebuildのテストを実行する
cd ~/trunk/src/third_party/portage-stable/app-misc/myscript
rm -f Manifest
ebuild-${BOARD} myscript-1.ebuild manifest
ebuild-${BOARD} myscript-1.ebuild test
emerge-${BOARD} app-misc/myscript --pretend --verbose


# 依存関係を追加
cd ${OVERLAY_DIR:=~/trunk/src/third_party/chromiumos-overlay}/virtual/target-chromium-os
search=`grep 'myscript' target-chromium-os-1.ebuild`
if [ -z "${search}" ]; then
        echo myscript is not included in base overlay. append to base overlay now.
        sed -e '/^RDEPEND="${CROS_COMMON_RDEPEND}/a \\tmybuild? ( app-misc\/myscript )' -i target-chromium-os-1.ebuild || exit 1
        echo done
        revisionup_ebuild
else
        echo myscript is already included in base overlay. skip.
fi
popd > /dev/null
