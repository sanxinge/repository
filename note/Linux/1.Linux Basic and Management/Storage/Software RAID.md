
## 一、创建software RAID
---
> 术语：
> SW：software RAID的缩写，即软件阵列
> HW：hardware RAID的缩写，即硬件阵列
> + 35块8TB的磁盘做RAID10用了一周时间
### 1、安装mdadm  
mdadm 是multiple devices admin 的简称，它是Linux下的一款标准的软件RAID 管理工具。   
### 2、创建RAID
1. 磁盘分区并修改分区类型
	```
	[root@localhost ~]# fdisk /dev/sda
	......
	命令(输入 m 获取帮助)：n
	分区号 (1-128，默认 1)：
	第一个扇区 (34-15628053134，默认 2048)：
	Last sector, +sectors or +size{K,M,G,T,P} (2048-15628053134，默认 15628053134)：
	已创建分区 1

	命令(输入 m 获取帮助)：t
	已选择分区 1
	分区类型(输入 L 列出所有类型)：L
	  1 EFI System                     C12A7328-F81F-11D2-BA4B-00A0C93EC93B
	  2 MBR partition scheme           024DEE41-33E7-11D3-9D69-0008C781F39F
	  3 BIOS boot partition            21686148-6449-6E6F-744E-656564454649
	  4 Microsoft reserved             E3C9E316-0B5C-4DB8-817D-F92DF00215AE
	  5 Microsoft basic data           EBD0A0A2-B9E5-4433-87C0-68B6B72699C7
	  6 Microsoft LDM metadata         5808C8AA-7E8F-42E0-85D2-E1E90434CFB3
	  7 Microsoft LDM data             AF9B60A0-1431-4F62-BC68-3311714A69AD
	  8 Windows recovery evironmnet    DE94BBA4-06D1-4D40-A16A-BFD50179D6AC
	  9 IBM General Parallel Fs        37AFFC90-EF7D-4E96-91C3-2D7AE055B174
	 10 HP-UX data partition           75894C1E-3AEB-11D3-B7C1-7B03A0000000
	 11 HP-UX service partition        E2A1E728-32E3-11D6-A682-7B03A0000000
	 12 Linux filesystem               0FC63DAF-8483-4772-8E79-3D69D8477DE4
	 13 Linux RAID                     A19D880F-05FC-4D3B-A006-743F0F84911E
	 14 Linux swap                     0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
	  ......

	分区类型(输入 L 列出所有类型)：13
	已将分区“Linux filesystem”的类型更改为“Linux RAID”
	命令(输入 m 获取帮助)：p
	......
	#         Start          End    Size  Type            Name
	 1         2048  15628053134    7.3T  Linux RAID      
	命令(输入 m 获取帮助)：w
	......
	```  
2. 同步分区信息
使用`partprobe` 命令同步分区信息。
3. 创建RAID10
	```
	[root@localhost ~]#  mdadm --create /dev/md0 --level=10 --spare-devices=1 --raid-devices=33 /dev/sd[a-z]1 /dev/sda[a-i]
	mdadm: Defaulting to version 1.2 metadata
	mdadm: array /dev/md0 started.
	```
+ 说明
	+ -C/--create　  创建阵列；
	+ -a/--auto　　  同意创建设备，如不加此参数时必须先使用mknod 命令来创建一个RAID设备，不过推荐使用-a yes参数一次性创建；
	+ -l/--level　　　阵列模式，支持的阵列模式有 linear, raid0, raid1, raid4, raid5, raid6, raid10, multipath, faulty, container；
	+ -n/ --raid-devices    阵列中活动磁盘的数目，该数目加上备用磁盘的数目应该等于阵列中总的磁盘数目；
	+ /dev/md0　　　　 阵列的设备名称；
	+ /dev/sd[b,c]1　　参与创建阵列的磁盘名称  

4. 使用mdadm -D /dev/md0 查看RAID的状态： 
	```
	[root@localhost ~]# cat /proc/mdstat 
	Personalities : [raid10] 
	md0 : active raid10 sdaa1[26] sdv1[21] sdy1[24] sdad1[29] sdab1[27] sdl1[11] sdaf1[31] sdo1[14] sdt1[19] sdi1[8] sdw1[22] sdm1[12] sdae1[30] sdn1[13] sdag1[32] sdj1[9] sdai1[34](S) sds1[18] sdh1[7] sdf1[5] sdu1[20] sdg1[6] sdx1[23] sdk1[10] sdah1[33] sdr1[17] sdp1[15] sdac1[28] sdz1[25] sdq1[16] sde1[4] sda1[0] sdb1[1] sdd1[3] sdc1[2]
		  132836200448 blocks super 1.2 512K chunks 2 near-copies [34/34] [UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
		  bitmap: 0/495 pages [0KB], 131072KB chunk

	unused devices: <none>

	[root@localhost ~]# mdadm -D /dev/md0 
	/dev/md0:
			Version : 1.2
	  Creation Time : Wed Apr 12 10:52:38 2017
		 Raid Level : raid10
		 Array Size : 128929253376 (122956.52 GiB 132023.56 GB)
	  Used Dev Size : 7813894144 (7451.91 GiB 8001.43 GB)
	   Raid Devices : 33
	  Total Devices : 34
		Persistence : Superblock is persistent

	  Intent Bitmap : Internal

		Update Time : Wed Apr 12 11:44:19 2017
			  State : active, resyncing 
	 Active Devices : 33
	Working Devices : 34
	 Failed Devices : 0
	  Spare Devices : 1

			 Layout : near=2
		 Chunk Size : 512K

	  Resync Status : 100% complete

			   Name : localhost.localdomain:0  (local to host localhost.localdomain)
			   UUID : e7ab0569:4894600e:a6e6d5bc:4682c33f
			 Events : 547

		Number   Major   Minor   RaidDevice State
	   0       8        1        0      active sync set-A   /dev/sda1
       1       8       17        1      active sync set-B   /dev/sdb1
       2       8       23        2      active sync set-B   /dev/sdai1
       3       8       49        3      active sync set-B   /dev/sdd1
       4       8       65        4      active sync set-A   /dev/sde1
       5       8       81        5      active sync set-B   /dev/sdf1
       6       8       97        6      active sync set-A   /dev/sdg1
	   ......
	   32      66        1       32      active sync set-A   /dev/sdag1
       33      66       17       33      active sync set-B   /dev/sdah1

	   34      66       33        -      spare   /dev/sdai1

	```
+ 说明：
	+ Raid Level : 阵列级别； 
	+ Array Size : 阵列容量大小；
	+ Raid Devices : RAID成员的个数；
	+ Total Devices : RAID中下属成员的总计个数，因为还有冗余硬盘或分区，也就是spare，为了RAID的正常运珩，随时可以推上去加入RAID的；
	+ State : clean, degraded, recovering 状态，包括三个状态，clean 表示正常，degraded 表示有问题，recovering 表示正在恢复或构建；
	+ Active Devices : 被激活的RAID成员个数；
	+ Working Devices : 正常的工作的RAID成员个数；
	+ Failed Devices : 出问题的RAID成员；
	+ Spare Devices : 备用RAID成员个数，当一个RAID的成员出问题时，用其它硬盘或分区来顶替时，RAID要进行构建，在没构建完成时，这个成员也会被认为是spare设备；
	+ UUID : RAID的UUID值，在系统中是唯一的；

5. 创建RAID 配置文件/etc/mdadm.conf
RAID 的配置文件为/etc/mdadm.conf，默认是不存在的，需要手工创建。该配置文件的主要作用是系统启动的时候能够自动加载软RAID，同时也方便日后管理。但不是必须的，推荐对该文件进行配置（测试发现没有这个文件，重启后md0 会自动变成md127）。
	+ /etc/mdadm.conf 文件内容包括：
DEVICE 选项指定用于软RAID的所有设备，
ARRAY 选项所指定阵列的设备名、RAID级别、阵列中活动设备的数目以及设备的UUID号。
	+ 创建/etc/mdadm.conf
`# echo DEVICE /dev/sd[a-z]1 /dev/sda[a-i]1 >> /etc/mdadm.conf`
`# mdadm -Ds >> /etc/mdadm.conf`
6. 创建文件系统
`mkfs.ext4 /dev/md0`
7. 挂载
`mount /dev/md0 /mnt/`
## 二、维护操作
---
### 1、故障硬盘更换
1. 当软RAID 检测到某个磁盘有故障时，会自动标记该磁盘为故障磁盘，并停止对故障磁盘的读写操作。（这里测试手动标记为故障盘）
`[root@localhost ~]# mdadm /dev/md0 -f /dev/sdc1`
`mdadm: set /dev/sdc1 faulty in /dev/md0`
2. 查看raid状态
	```
	[root@localhost ~]# cat /proc/mdstat 
	Personalities : [raid10] 
	md0 : active raid10 sdaa1[26] sdv1[21] sdy1[24] sdad1[29] sdab1[27] sdl1[11] sdaf1[31] sdo1[14] sdt1[19] sdi1[8] sdw1[22] sdm1[12] sdae1[30] sdn1[13] sdag1[32] sdj1[9] sdai1[34] sds1[18] sdh1[7] sdf1[5] sdu1[20] sdg1[6] sdx1[23] sdk1[10] sdah1[33] sdr1[17] sdp1[15] sdac1[28] sdz1[25] sdq1[16] sde1[4] sda1[0] sdb1[1] sdd1[3] sdc1[2](F)
		  132836200448 blocks super 1.2 512K chunks 2 near-copies [34/33] [UU_UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
		  [>....................]  recovery =  0.1% (11471104/7813894144) finish=799.9min speed=162550K/sec
		  bitmap: 2/495 pages [8KB], 131072KB chunk

	unused devices: <none>
	```
+ PS：
a、发现sdc1后面多了个(F)，表示这块硬盘已损坏。
b、"[_U]" 表示当前阵列可以正常使用的设备是/dev/sdc1，如果是设备 “/dev/sdc1” 出现故障时，则将变成[U_]。
c、有热备盘自动顶上，所以状态已经变成recovery了。
3. 移除故障盘
`[root@localhost ~]# mdadm /dev/md0 -r /dev/sdc1`
`mdadm: hot removed /dev/sdc1 from /dev/md0`
4. 查看md0状态
`[root@localhost ~]# mdadm -D /dev/md0`
5. 添加新硬盘
如果是实际生产中添加新的硬盘，需要对新硬盘进行创建分区的操作，这里我们为了方便，将刚才模拟损坏的硬盘再次新加到raid10中
`mdadm /dev/md0 -a /dev/sdc1`
再次查看raid，发现raid10正在恢复，等待完成即可
	```
	[root@localhost ~]# mdadm -D /dev/md0
	/dev/md0:
	.....
	Rebuild Status : 1% complete
	.....
		Number   Major   Minor   RaidDevice State
		   0       8        1        0      active sync set-A   /dev/sda1
		   1       8       17        1      active sync set-B   /dev/sdb1
		  34      66       33        2      spare rebuilding   /dev/sdai1
		   3       8       49        3      active sync set-B   /dev/sdd1
		   4       8       65        4      active sync set-A   /dev/sde1
		   5       8       81        5      active sync set-B   /dev/sdf1
		   6       8       97        6      active sync set-A   /dev/sdg1
		   7       8      113        7      active sync set-B   /dev/sdh1
		   8       8      129        8      active sync set-A   /dev/sdi1
		   9       8      145        9      active sync set-B   /dev/sdj1
		  10       8      161       10      active sync set-A   /dev/sdk1
		  11       8      177       11      active sync set-B   /dev/sdl1
		  12       8      193       12      active sync set-A   /dev/sdm1
		  13       8      209       13      active sync set-B   /dev/sdn1
		  14       8       33       14      spare rebuilding   /dev/sdc1
		  15       8      241       15      active sync set-B   /dev/sdp1
		  16      65        1       16      active sync set-A   /dev/sdq1
		  17      65       17       17      active sync set-B   /dev/sdr1
		  18      65       33       18      active sync set-A   /dev/sds1
		  19      65       49       19      active sync set-B   /dev/sdt1
		  20      65       65       20      active sync set-A   /dev/sdu1
		  21      65       81       21      active sync set-B   /dev/sdv1
		  22      65       97       22      active sync set-A   /dev/sdw1
		  23      65      113       23      active sync set-B   /dev/sdx1
		  24      65      129       24      active sync set-A   /dev/sdy1
		  25      65      145       25      active sync set-B   /dev/sdz1
		  26      65      161       26      active sync set-A   /dev/sdaa1
		  27      65      177       27      active sync set-B   /dev/sdab1
		  28      65      193       28      active sync set-A   /dev/sdac1
		  29      65      209       29      active sync set-B   /dev/sdad1
		  30      65      225       30      active sync set-A   /dev/sdae1
		  31      65      241       31      active sync set-B   /dev/sdaf1
		  32      66        1       32      active sync set-A   /dev/sdag1
		  33      66       17       33      active sync set-B   /dev/sdah1

		   2       8      225        -      spare   /dev/sdo1
		   
	 [root@localhost ~]# cat /proc/mdstat 
		Personalities : [raid10] 
		[10] sdah1[33] sdr1[17] sdp1[15] sdac1[28] sdz1[25] sdq1[16] sde1[4] sda1[0] sdb1[1] sdd1[3]
		132836200448 blocks super 1.2 512K chunks 2 near-copies [34/32] [UU_UUUUUUUUUUU_UUUUUUUUUUUUUUUUUUU]
 		[>....................]  recovery =  1.4% (114415936/7813894144) finish=7812.0min speed=16426K/sec
      	bitmap: 3/495 pages [12KB], 131072KB chunk

		unused devices: <none>
	 ```
+ 注意
	+ 我做测试是同时拔两块盘的，一块是按上述步骤来的，一块直接拔盘，完全没影响（自动标记为removed状态），但不建议这样做
	+ 添加盘的时候需要确认/dev下的设备文件名还是否是原来的。我拔了sdc和sdo两块，在原来sdo的槽位插入盘被识别成sdc
## 三、mdadm彻底删除software RAID
----
### 1、准备
1. 使用`mdadm -D /dev/md0` 查看RAID的状态： 
	
2. 确保该RAID没有挂载到某一目录下，否则请先卸载，卸载格式：
`umount 路径`。

### 2、 删除流程

1. 停止运行RAID 
	[root@localhost ~]# mdadm -S /dev/md0   
	mdadm: stopped /dev/md0   
	+ `mdadm: stopped /dev/md0`表明该md0阵列已经停止运行。    
2. 删除自动配置文件   
将/etc/mdadm/mdadm.conf文件中关于该md0的配置信息删除即可，这个方式有很多种。由于我的配置信息中只有一个RAID，所以我选择将文件清空。   
`[root@localhost ~]# cat /dev/null > /etc/mdadm/mdadm.conf`   
3. 删除元数据   
以前我一直以为删除来配置文件就算彻底结束了，可是再重启的话还是可以在/dev下找到md设备，后来发现是没有将RAID分区中的元数据删除。  
`[root@localhost ~]# mdadm --zero-superblock /dev/sd[a-z]1`
`[root@localhost ~]# mdadm --zero-superblock /dev/sda[a-i]1`
**至此，该software RAID已经彻底删除，重启后也不会自动安装了。**

