#!/bin/bash

job=$1
kernel_config=$2
kernel_commit=$3

#job="jobs/xfstests-generic.yaml"
job="jobs/ebizzy.yaml"
kernel_config="x86_64-rhel"
kernel_commit="c13dcf9f2d6f5f06ef1bf79ec456df614c5e058b"

jobs_dir="/tmp/jobs"
[[ -d $jobs_dir ]] || mkdir -p $jobs_dir

#vm_lkp="vm-lkp-wsx03-4G"
vm_lkp="vm-lkp-wsx03-android-x86-4G"

web_path="/var/www/html/~lkp"

RESULT_ROOT="/tmp/result_root"
SSH_PORT="2222"

VDISK_PATH="/tmp/vdisk"
[[ -d $VDISK_PATH ]] || mkdir -p $VDISK_PATH 
#[[ -d $VDISK_ROOT ]] || mkdir -p $VDISK_ROOT

export LKP_SRC=$PWD
export PATH=$PATH:$LKP_SRC/bin

parse_yaml() {
	local s='[[:space:]]*'
	local w='[a-zA-Z0-9_-]*'
	local tmp_filter="$(mktemp)"
	ls -LR $LKP_SRC/setup $LKP_SRC/monitors $LKP_SRC/tests $LKP_SRC/daemon > $tmp_filter
	scripts=$(cat $1 | sed -ne "s|^\($s\):|\1|" \
	         -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\2|p" \
	         -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\2|p" | grep -x -F -f $tmp_filter | grep -v -e ':$' -e '^$')
}

#xxx 
#lkp install $LKP_SRC/$job

CACHE_DIR=/tmp/lkp-qemu-downloads
#[ -d $BM_DIR ] || mkdir -p $BM_DIR

scripts=
parse_yaml $job

echo "scripts: {$scripts}"
for script in $scripts
do
[ -x "$LKP_SRC/pack/$script" ] || continue
$LKP_SRC/sbin/pack -d android-x86 -c $script

bm_cgz="$script-$(uname -m).cgz"
bm_path="/lkp/benchmarks/$bm_cgz"

cp $bm_path $web_path/$bm_path

done


#lkp split -o $jobs_dir -c $kernel_config -k $kernel_commit -t vm-lkp-wsx03-4G \
split_job=$( lkp split -o $jobs_dir -c $kernel_config -k $kernel_commit -t $vm_lkp --any \
-s 'LKP_SERVER: 192.168.0.119' \
-s 'LKP_CGI_PORT: 80 ' \
-s 'LKP_CIFS_PORT: 139 ' \
-s "CACHE_DIR: $CACHE_DIR " \
-s "testbox: $vm_lkp " \
-s 'user: lkp' \
-s 'compiler: gcc-4.9' \
-s 'kernel: /pkg/linux/x86_64-rhel/gcc-4.9/c13dcf9f2d6f5f06ef1bf79ec456df614c5e058b/vmlinuz-4.2.0-rc8 ' \
-s "result_root: $RESULT_ROOT " \
-s 'initrd: /osimage/debian/debian-x86_64-2015-02-07.cgz' \
-s 'lkp_initrd: /lkp/lkp/lkp-x86_64.cgz ' \
-s 'modules_initrd: /pkg/linux/x86_64-rhel/gcc-4.9/c13dcf9f2d6f5f06ef1bf79ec456df614c5e058b/modules.cgz ' \
-s "bm_initrd: /osimage/deps/debian-x86_64-2015-02-07.cgz/lkp.cgz,/osimage/deps/debian-x86_64-2015-02-07.cgz/run-ipconfig.cgz,/osimage/deps/debian-x86_64-2015-02-07.cgz/turbostat.cgz,/lkp/benchmarks/turbostat.cgz,$bm_path " \
$LKP_SRC/$job | awk '/\.yaml/ {print $3}' )

# [[ $model =~ 'netdev' ]] && echo "contain"
# [[ $model =~ 'netdev' ]] || echo "NOT contain"
 [[ $split_job =~ '.yaml' ]] || {
	echo -e "\033[31m lkp split ERROR ! \033[0m"
	exit
}

echo -e "\033[32m $split_job \033[0m"

lkp compile -o ${split_job}.sh $split_job
if [ $? -ne 0 ];then
echo -e "\033[31m lkp compile ERROR ! \033[0m"
exit
fi

lkp qemu -o $RESULT_ROOT -s $SSH_PORT -p $VDISK_PATH -S  ${split_job}.sh 

