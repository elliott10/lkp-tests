#!/bin/bash

job=$1
kernel_config=$2
kernel_commit=$3

job="jobs/xfstests-generic.yaml"
kernel_config="x86_64-rhel"
kernel_commit="c13dcf9f2d6f5f06ef1bf79ec456df614c5e058b"

jobs_dir="/tmp/jobs"
[[ -d $jobs_dir ]] || mkdir -p $jobs_dir

#vm_lkp="vm-lkp-wsx03-4G"
vm_lkp="vm-lkp-wsx03-android-x86-4G"

RESULT_ROOT="/tmp/result_root"
SSH_PORT="2222"

VDISK_PATH="/tmp/vdisk"
[[ -d $VDISK_PATH ]] || mkdir -p $VDISK_PATH 
#[[ -d $VDISK_ROOT ]] || mkdir -p $VDISK_ROOT

export LKP_SRC=$PWD
export PATH=$PATH:$LKP_SRC/bin

#xxx 
#lkp install $LKP_SRC/$job

#lkp split -o $jobs_dir -c $kernel_config -k $kernel_commit -t vm-lkp-wsx03-4G \
split_job=$( lkp split -o $jobs_dir -c $kernel_config -k $kernel_commit -t $vm_lkp --any \
-s 'LKP_SERVER: 192.168.0.119' \
-s 'LKP_CGI_PORT: 80 ' \
-s 'LKP_CIFS_PORT: 139 ' \
-s "testbox: $vm_lkp " \
-s 'user: lkp' \
-s 'compiler: gcc-4.9' \
-s 'kernel: /pkg/linux/x86_64-rhel/gcc-4.9/c13dcf9f2d6f5f06ef1bf79ec456df614c5e058b/vmlinuz-4.2.0-rc8 ' \
-s "result_root: $RESULT_ROOT " \
-s 'initrd: /osimage/debian/debian-x86_64-2015-02-07.cgz' \
-s 'lkp_initrd: /lkp/lkp/lkp-x86_64.cgz ' \
-s 'modules_initrd: /pkg/linux/x86_64-rhel/gcc-4.9/c13dcf9f2d6f5f06ef1bf79ec456df614c5e058b/modules.cgz ' \
-s 'bm_initrd: /osimage/deps/debian-x86_64-2015-02-07.cgz/lkp.cgz,/osimage/deps/debian-x86_64-2015-02-07.cgz/run-ipconfig.cgz,/osimage/deps/debian-x86_64-2015-02-07.cgz/turbostat.cgz ' \
$LKP_SRC/$job | awk '/\.yaml/ {print $3}' )

##,/lkp/benchmarks/turbostat.cgz,/lkp/benchmarks/ebizzy-x86_64.cgz 

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

