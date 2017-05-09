# LVM—逻辑卷管理器

## 一、Logical Volume Manager（LVM）
### 1、简介

### 2、名词
1. PhysicalStorageMedia:物理存储介质，如/dev/sda等，是存储系统最底层的存储单元。
2. PhysicalVolume（PV）：物理卷，磁盘上的物理分区打上PV的标识。LVM基本的存储逻辑块。
3. Volume Group（VG）：卷组，由一个或多个PV整合而成，是LVM组合起来的大磁盘（可以做到跨盘）。
4. Logical Volume（LV）：逻辑卷，类似磁盘分区的存在，由VG切割而来，在LV上可以创建文件系统。
5. Physical Extend（PE）：物理扩展块，是整个LVM中最小的存储单位，意味着我们的数据都是写入PE来处理的（类似文件系统中的block），LVM使用默认４M的PE块，而一个VG最多能有65534个PE。具有唯一编号的PE是可以被LVM寻址的最小单元。
6. Logical Extent（LE）：逻辑块，逻辑卷LV也被划分为可被寻址的基本单位，称为LE。在同一个卷组中，LE的大小和PE是相同的，并且一一对应。
6. 数据的写入机制：
+ 线性模式（linear）：用完一个PV在使用另一个PV
+ 交错模式（triped）：有点想RAID 0，将一个数据分开写到多个PV。
7. LV的名称构建为/dev/VG1/lv1（可以不是这个名字）是为了让用户直观的使用，实际LVM的设备放在/dev/mapper目录下。
8. 8e：LVM文件系统标识符（system ID）

## 二、常用命令
1. PV——在物理分区打上PV属性，名称还是分区的设备文件名
+ pvcreate：将物理分区创建成PV（物理卷）
+ pvscan：查看目前 系统中具有PV的磁盘
+ pvdisplay：显示目前系统中的PV详细状态
+ pvremove：移除PV属性，让该分区不具有PV属性
+ pvmove：迁移数据
2. VG——可以自定义名字
+ vgcreate：创建VG
+ vgscan：查看目前 系统中的VG
+ vgdisplay：显示目前系统中的VG详细状态
+ vgextend：在该VG中扩展额外的PV
+ vgreduce：在该VG中删除PV
+ vgchange：设置VG是否启动（active）
+ vgremove：删除VG
3. LV——可以自定义名字
+ lvcreate：在VG/PV中创建LV
+ lvscran：查看目前 系统中的LV
+ lvdisplay：显示目前系统中LV信息/状态
+ lvextend：扩展LV的容量
+ lvreduce：减少LV的容量
+ lvresize：调整LV的容量（常用）
+ lvremove：删除一个LV
+ lvdata：显示LV卷组上的LVDA信息
+ lvchange：改变LV卷组属性

resize2fs 设备名 重新读取分区大小

## 三、LVM实践操作
+ 所需软件：lvm2

### 1、创建LVM
+ 流程：partition--->pv--->vg--->lv--->file system

1. 创建partition阶段
+ 思路：创建分区并调整文件系统标识符（system id）为8e（LVM的标识符）
+ 操作
    [root@oracle_1 ~]# fdisk /dev/sdc
\
    ......(创建分区略)
\
    Command (m for help): t
    Selected partition 1
    Hex code (type L to list codes): 8e
    Changed system type of partition 1 to 8e (Linux LVM)
\
    Command (m for help): p
\
    ......
\
    Device Boot      Start         End      Blocks   Id  System
    /dev/sdc1               1        1044     8385898+  8e  Linux LVM
\
    Command (m for help): w
    The partition table has been altered!

2. 创建pv阶段
[root@oracle_1 ~]# pvscan
  No matching physical volumes found
\
  [root@oracle_1 ~]# pvcreate /dev/sd[bcd]1　//  /dve/sd[bcd]等同于/dev/sd{b,c,d}，作用是一次性创建3个PV
  Physical volume "/dev/sdb1" successfully created
  Physical volume "/dev/sdc1" successfully created
  Physical volume "/dev/sdd1" successfully created
\
  [root@oracle_1 ~]# pvscan
    PV /dev/sdb1                      lvm2 [8.00 GiB]
    PV /dev/sdc1                      lvm2 [8.00 GiB]
    PV /dev/sdd1                      lvm2 [8.00 GiB]
    Total: 3 [23.99 GiB] / in use: 0 [0   ] / in no VG: 3 [23.99 GiB]

3. 创建vg阶段
+ 语法：vgcreate [-s number[M/G/T]] VG_name PV_name
参数：
 -s：PE的大小，单位可为M、G、T（大小写均可），默认４M。
 VG_name：卷组的名称
 PV_name：逻辑卷ＰＶ
+ 例子：将/dev/sdb,/dev/sdc,/dev/sdf(sdf不存在)创建成名为VG1的VG。
Volume group "VG1" successfully created
[root@oracle_1 ~]# vgscan　
Reading all physical volumes.  This may take a while...
No volume groups found
[root@oracle_1 ~]# vgcreate -s 16M VG1 /dev/sd[bcf]1    
[root@oracle_1 ~]# vgscan
Reading all physical volumes.  This may take a while...
 Found volume group "VG1" using metadata type lvm2
[root@oracle_1 ~]# pvscan
 PV /dev/sdb1   VG VG1             lvm2 [7.98 GiB / 7.98 GiB free]
 PV /dev/sdc1   VG VG1             lvm2 [7.98 GiB / 7.98 GiB free]
 PV /dev/sdd1                      lvm2 [8.00 GiB]
 Total: 3 [23.97 GiB] / in use: 2 [15.97 GiB] / in no VG: 1 [8.00 GiB]

4. 创建lv阶段
+ 语法：lvcreate [-L number[M/G/T]] [-n LV_name] VG_name    或   lvcreate [-l number] [-n LV_name] VG_name
+ 参数：
-L：容量，最小为一个PE大小，故而该数为PE的倍数（可以输入的不是倍数，系统可以自行调整为最相近的容量。
-l：PE的个数，容量自行计算，不跟单位。
-n后接LV名称
+ 例子：
[root@oracle_1 ~]# lvscan
[root@oracle_1 ~]# lvcreate -L 2G -n lv1 VG1
 Logical volume "lv1" created

5. 创建file system阶段
fkfs.ext4 /dev/VG1/lv1

### 2、维护LVM
1. 向VG中添加PV（VG的扩容）
+ 创建PV略
+ 添加
    + 语法：vgextend VG_name PV_name
    + 例子：[root@oracle_1 ~]# vgextend VG1 /dev/sdd1
        Volume group "VG1" successfully extended
2. LV容量的调整
+ 扩展LV容量
lvsize -L/-l +number[M/G/T] LV_name
例如：lvsize -l +30 lv1
+ 减小LV容量
lvsize -L/-l -number[M/G/T] LV_name
例如：lvsize -L -30M lv1
+ 调整LV容量——重新设定容量
lvsize -L/-l  number[M/G/T] LV_name
例如：lvsize -L 300M lv1
+ 操作后LV的容量改变了，但文件系统的容量没变，无需umount，使用resize2fs处理下即可
语法：resize2fs  [-f] [device] [size]
参数：-f：强制进行resize操作；device：设备文件名；size：加上时必须写单位，不加则默认整个分区的容量。

xfs_growfs /dev/mapper/rhel-home

5. 迁移PV中的数据
[root@oracle_1 ~]# lsblk
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdb                  8:16   0    8G  0 disk
└─sdb1               8:17   0    8G  0 part
sdd                  8:48   0    8G  0 disk
└─sdd1               8:49   0    8G  0 part
sdc                  8:32   0    8G  0 disk
└─sdc1               8:33   0    8G  0 part
  └─VG1-lv1 (dm-0) 253:0    0    3G  0 lvm  
[root@oracle_1 ~]# pvmove /dev/sdc1 /dev/sdb1
  /dev/sdc1: Moved: 2.1%
  /dev/sdc1: Moved: 100.0%
[root@oracle_1 ~]# lsblk
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdb                        8:16   0    8G  0 disk
└─sdb1              8:17   0    8G  0 part
  └─VG1-lv1 (dm-0) 253:0    0    3G  0 lvm  
sdd                       8:48   0    8G  0 disk
└─sdd1             8:49   0    8G  0 part
sdc                       8:32   0    8G  0 disk
└─sdc1             8:33   0    8G  0 part

### 3、LVM的移除
1. 从VG中移除PV
[root@oracle_1 ~]# pvmove /dev/sdd1 /dev/sdc1　//移除前必须迁移数据
 /dev/sdd1: Moved: 2.1%
 /dev/sdd1: Moved: 100.0%
[root@oracle_1 ~]# vgreduce VG1 /dev/sdc1   //正在使用的ＰＶ不能移除
 Physical volume "/dev/sdc1" still in use
[root@oracle_1 ~]# vgreduce VG1 /dev/sdd1   //从VG1卷组中移除/dev/sdd1这个ＰＶ
 Removed "/dev/sdd1" from volume group "VG1"
2. 移除PV

3. 移除VG
