# BatchUdiskSync
Use rsync to realize automated batch data synchronization of multiple USB disks

* You need to create a data folder in the script's running directory to store the data that needs to be synchronized.
* Only synchronize the first partition of the U disk. And judge whether it is the target synchronized U disk based on the capacity.
* By default, the script will synchronize the data of the first partition of this device only after it detects that the capacity of the first partition of the USB flash drive is `7.5G`.
* You can modify the variable `udisk_size` in the script to change the default capacity.
* Get the capacity of the first partition of the USB flash drive by executing lsblk.

利用rsync自动化同步多个u盘

* 需要在脚本的运行目录下创建一个data文件夹, 里面存放需要同步的数据.
* 仅同步U盘的第一个分区. 且根据容量大小判断是否是目标同步U盘
* 默认情况下, 脚本检测到u盘第一分区的容量`7.5G`, 才会去同步此设备的第一分区的数据.
* 可以修改脚本中的变量`udisk_size`来改变默认容量.
* 通过执行lsblk来获得u盘第一分区的容量大小.
