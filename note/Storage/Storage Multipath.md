# Storage Multipath   
> **简介:**   
> 在多路径功能出现之前，主机上的硬盘是直接挂接到一个总线（PCI）上，路径是一对一的关系，也就是一条路径指向一个硬盘或是存储设备，这样的一对一关系对于操作系统而言，处理相对简单，但是缺少了可靠性。当出现了光纤通道网络（Fibre Channle）也就是通常所说的SAN网络时，或者由iSCSI组成的IPSAN环境时，由于主机和存储之间通过光纤通道交换机或者多块网卡及IP来连接时，构成了多对多关系的IO通道，也就是说一台主机到一台存储设备之间存在多条路径。当这些路径同时生效时，I/O流量如何分配和调度，如何做IO流量的负载均衡，如何做主备。这种背景下多路径软件就产生了。   
> **功能:**  
> 1.故障的切换和恢复  
> 2.IO流量的负载均衡  
> 3.磁盘的虚拟化   

## `No.1:` Linux Multipath   
> OS: CentOS 7.3
> Software: device-mapper-multipath-0.4.9-99
### 1. DM-Multipath简介  
1. DM-Multipath组件  
dm-multipath: 内核模块,为路径和路径组群重新指定 I/O 并支持出错冗余。  
mpathconf: 程序,配置并启用设备映射器多路径  
multipath: 命令,列出并配置 multipath 设备。 
multipathd: 守护进程,监视器路径，如果路径故障并返回，它可能会启动路径组群切换。可为多路径设备提供互动修改。对 /etc/multipath.conf 文件的任何修改都必须启动它。  
kpartx: 命令,为设备中的分区生成设备映射器设备。这个命令对带 DM-MP 的 DOS 分区是很必要的。kpartx 在其自身软件包中就存在，但 device-mapper-multipath 软件包要依赖它。  

2. `mpathconf`介绍:  
	+ 用于配置device-mapper-multipath的工具,可以创建或修改/etc/multipath.conf   
	+ 也可以加载dm_multipath模块，启动和停止multipathd守护程序，并将multipathd服务配置为自动启动或取消开机自启。   
	+ `mpathconf`帮助
		```
		[root@localhost ~]# mpathconf -h
		usage: /usr/sbin/mpathconf <command>

		Commands:
		Enable: --enable 
		Disable: --disable
		Only allow certain wwids (instead of enable): --allow <WWID>
		Set user_friendly_names (Default y): --user_friendly_names <y|n>
		Set find_multipaths (Default y): --find_multipaths <y|n>
		Load the dm-multipath modules on enable (Default y): --with_module <y|n>
		start/stop/reload multipathd (Default n): --with_multipathd <y|n>
		select output file (Default /etc/multipath.conf): --outfile <FILE>
		```
	> 使用 `mpathconf` 程序设置多路径，它可创建多路径配置文件 `/etc/multipath.conf`。  
	>	1. 如果 /etc/multipath.conf 文件已存在，mpathconf 程序将会编辑该文件。  
	>	2. 如果 /etc/multipath.conf 文件不存在，mpathconf 程序将使用 /usr/share/doc/device-mapper-multipath-0.4.9/multipath.conf 文件作为起始文件。  
	>	3. 如果 /usr/share/doc/device-mapper-multipath-0.4.9/multipath.conf 文件不存在，则 mpathconf 程序将从头开始创建 /etc/multipath.conf 文件。    
3. Linux中多路径设备标识符  
当在 DM-Multipath中添加新设备时，这些新设备会位于 /dev 目录的两个不同位置：`/dev/mapper/mpath<n>` 和 `/dev/dm-<n>`。  
	+ /dev/mapper 中的设备是在引导过程中生成的。可使用这些设备访问多路径设备，例如在生成逻辑卷时。  
	+ 所有 /dev/dm-n 格式的设备都只能是作为内部使用，请不要使用它们。  
5. **注意事项**  
	+ 在集群中保持多路径设备名称一致;  
### 2. DM-Multipath安装及配置  
1. 查看是否安装: `rpm -qa |grep device-mappere` 若没有请安装  
	+ 安装软件包: `yum  install device-mapper device-mapper-multipath`  
2. 编辑配置文件并启动multipathd守护进程  
+ 如果您不需要手动编辑 /etc/multipath.conf 文件，您可以运行以下命令为基本故障切换配置设定 DM-Multipath。   
	+ `[root@localhost ~]# mpathconf --enable --with_multipathd y`  这个命令可启用Multipath配置文件并启动multipathd守护进程。   
+ 如果您需要在启动 multipathd 守护进程前编辑 /etc/multipath.conf 文件,请安下面步骤操作  
	+ `[root@localhost ~]# mpathconf --enable` 生成`/etc/multipath.conf`,并加载dm_multipath模块,但不启动multipathd守护进程,可以用`lsmod |grep dm_multipath`检查模块是否加载成功.   
	+ 编辑`/etc/multipath.conf`文件  
	+ `systemctl start multipathd` 启动multipathd守护进程  
+ 注意  
	+ 如果您在启动 multipath 守护进程后发现需要编辑 multipath 配置文件，则必须执行 service multipathd reload 命令方可使更改生效。  
	+ 如果您不想使用默认的设备名称(`mpath<n>`)名称,可以执行`mpathconf --enable --user_friendly_names n`或修改配置文件  

3. 路径操作
	+ `multipath -F`: 刷新所有多路径设备映射  
	+ `multipath -v2`: 格式化路径   
	+ `multipath -ll`: 显示多路径信息  

4. 创建分区和文件系统   
这个嘛,还是不说了......
### 3. 实践操作  
这里只做一个基本的配置
1. 创建Multipath
	```
	[root@localhost ~]# mpathconf --enable
	[root@localhost ~]# lsmod |grep dm_multipath
	dm_multipath           23065  0 
	dm_mod                114430  9 dm_multipath,dm_log,dm_mirror
	[root@localhost ~]# 
	[root@localhost ~]# lsblk
	NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
	sda               8:0    0 278.5G  0 disk 
	├─sda1            8:1    0   100M  0 part /boot/efi
	.......
	sdc               8:32   0    20G  0 disk 
	sdd               8:48   0    20G  0 disk 
	sde               8:64   0    20G  0 disk 
	sdf               8:80   0    20G  0 disk 
	[root@localhost ~]# 
	[root@localhost ~]# vim /etc/multipath.conf 
	[root@localhost ~]# systemctl restart multipathd  
	[root@localhost ~]# multipath -F
	May 12 12:08:58 | /etc/multipath.conf line 31, duplicate keyword: defaults
	May 12 12:08:58 | /etc/multipath.conf line 94, duplicate keyword: blacklist
	[root@localhost ~]# 
	[root@localhost ~]# multipath -v2
	May 12 12:09:04 | /etc/multipath.conf line 31, duplicate keyword: defaults
	May 12 12:09:04 | /etc/multipath.conf line 94, duplicate keyword: blacklist
	May 12 12:09:08 | sdb: alua not supported
	May 12 12:09:08 | sda: alua not supported
	create: mpatha (3600a0b8000486c4a0000d35b59135194) undef IBM     ,1814      FAStT 
	size=20G features='1 queue_if_no_path' hwhandler='1 rdac' wp=undef
	|-+- policy='round-robin 0' prio=6 status=undef
	| `- 2:0:1:0 sde 8:64 undef ready  running
	`-+- policy='round-robin 0' prio=1 status=undef
	  `- 2:0:0:0 sdc 8:32 undef ghost  running
	create: mpathb (3600a0b8000322f0c0000a34c591356d4) undef IBM     ,1814      FAStT 
	size=20G features='1 queue_if_no_path' hwhandler='1 rdac' wp=undef
	|-+- policy='round-robin 0' prio=4 status=undef
	| `- 2:0:0:1 sdd 8:48 undef ghost  running
	`-+- policy='round-robin 0' prio=3 status=undef
	  `- 2:0:1:1 sdf 8:80 undef ready  running
	[root@localhost ~]# 
	[root@localhost ~]# 
	[root@localhost ~]# lsblk
	NAME            MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
	......
	sdc               8:32   0    20G  0 disk  
	└─mpatha        253:2    0    20G  0 mpath 
	sdd               8:48   0    20G  0 disk  
	└─mpathb        253:3    0    20G  0 mpath 
	sde               8:64   0    20G  0 disk  
	└─mpatha        253:2    0    20G  0 mpath 
	sdf               8:80   0    20G  0 disk  
	└─mpathb        253:3    0    20G  0 mpath 
	sr0              11:0    1  1024M  0 rom   
	[root@localhost ~]# 
	[root@localhost ~]# ls /dev/mapper/
	control  mpatha  mpathb  vg1-lv_root  vg1-lv_swap
	[root@localhost ~]# 
	[root@localhost ~]# mkfs.ext4 /dev/mapper/mpatha 
	mke2fs 1.42.9 (28-Dec-2013)
	......
	Writing superblocks and filesystem accounting information: 完成   
	[root@localhost ~]# 
	[root@localhost ~]# mount /dev/mapper/mpatha /mnt/
	[root@localhost ~]# df -h
	文件系统                 容量  已用  可用 已用% 挂载点
	/dev/mapper/vg1-lv_root  175G  1.1G  174G    1% /
	devtmpfs                 3.9G     0  3.9G    0% /dev
	tmpfs                    3.9G     0  3.9G    0% /dev/shm
	tmpfs                    3.9G  8.7M  3.9G    1% /run
	tmpfs                    3.9G     0  3.9G    0% /sys/fs/cgroup
	/dev/sda2                497M  109M  389M   22% /boot
	/dev/sda1                100M  9.5M   91M   10% /boot/efi
	tmpfs                    798M     0  798M    0% /run/user/0
	/dev/mapper/mpatha        20G   45M   19G    1% /mnt
	```