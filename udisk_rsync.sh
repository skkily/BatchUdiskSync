#/bin/bash
#TianXu.Feng 231201a

get_udisk(){
	result=`find /dev/ -name sd*1`
	file_name=$1
	echo "" > $file_name
	for line in $result;do
		if [ "`lsblk $line | sed -n '2p' | awk '{print $4}'`" == $udisk_size ];then
		       echo "$line" >> $file_name
		fi
	done
}


rsync_process(){
	device=$1
	dev_name="./status/""`date +%H%M%S_`""`echo $1 | cut -d \/ -f 3`"
	dev_status_name=$dev_name".status"
	dev_log_name=$dev_name".log"

	echo "processing" > $dev_status_name

	umount $device 2>/dev/null
	
	mount_point=./udisk/`date +%y%m%d%H%M%S`
	[ -d $mount_point ] || mkdir -p $mount_point
	
	mount $1 $mount_point 2>&1 1>$dev_log_name
	[ $? -eq 0 ] || { echo "mount err!" > $dev_status_name ; return; }
	
	rsync -av --delete ./rootfs/ $mount_point 2>&1 1>$dev_log_name
	result=$?
	if [ $result -eq 0 ];then
		echo "rsync ok" > $dev_status_name
	else
		echo "rsync fail" > $dev_status_name
	fi

	umount $1
}

dialog_status(){
	rm -f ./status/*
	while true
	do
		clear
		echo "Insert udisk to rsync data"
		echo "Udisk capacity must be equal $udisk_size"
		echo "----------------------------------------"
		status_file_list=`find ./status -mindepth 1 -maxdepth 1 -type f -name "*.status" | sort`
		for file in $status_file_list; do
			echo $file"      "`cat $file`
		done
		sleep 1
	done
}


scan_udisk(){
	get_udisk "$diff_1"

	while true
	do
		sleep 1
		get_udisk "$diff_2"
		make_udisk=`diff $diff_1 $diff_2 | grep ">" |awk '{print $2}'`
		cp $diff_2 $diff_1
		[ "$make_udisk" == "" ] && continue
		for line in $make_udisk
		do
			rsync_process "$line" &
		done
	done
}

[ -d "./data" ] || { echo "data dir needed!";exit; }
[ -d "./status" ] || mkdir status
[ -d "./udisk" ] || mkdir udisk
[ -d "./dev_list" ] || mkdir dev_list
diff_1="./dev_list/dev_list_1"
diff_2="./dev_list/dev_list_2"
udisk_size="7.5G"

dialog_status &
scan_udisk
