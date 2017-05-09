# HP安装Linux系统无法识别raid   
-------------
> 在公司机房的DL380 G4服务器安装CentOS 7时不能读到盘，通过万能又可恶的互联网找到了解决方法，之后又用了RedHat 7也一模一样，这里做个笔记，也共享一下哈。
	>  + 注：此方法也可以用在新的HP服务器上，反正读不到盘时都可以试试。
## 一、G5代及其之前的HP PC安装红帽系7版本时   
### 1、原因：   
+ 从2001年到〜2009年的HP RAID控制器驱动程序是CCISS驱动程序。后来转换成HPSA驱动程序（hpsa  是HP Smart Array RAID控制器的SCSI驱动程序），将Smart Array控制器支持移回到常规SCSI子系统中，而不是专用块驱动程序。故而，从G1到G5时代的HP ProLiant使用CCISS驱动程序。而在HP ProLiant G6和更高版本的系统使用HPSA驱动程序（这点不能100%确认）。  
+ 而在红帽系7版本时删除了CCISS驱动程序，采用的是HPSA驱动程序，故而在G1-G5安装系统时无法识别RAID做的逻辑盘。
### 2、解决方法：  
1. 方法：
加入驱动模块参数：`hpsa.hpsa_simple_mode=1 hpsa.hpsa_allow_any=1`  
	+ hpsa_allow_any = 1：此参数允许驱动程序尝试在任何HP Smart Array控制器上操作，即使驱动程序没有明确知道。这样的话就允许hpsa驱动程序驱动原来由cciss驱动程序处理的旧控制器。
2. 何处加参数
+ 安装系统时：
	+ 进去系统启动盘，选择`Install Centos7`
	![enter description here][1]
	+  选择`Install Centos7`后按`Tab`键，在底部原来的字符串后面跟上模块参数，注意要有空格。
	![enter description here][2]
	+ 按回车键继续安装，这样就可以识别到硬盘。
+ 系统安装完成后启动系统时
	+ 启动系统时也要加入参数，不然无法启动。方法时在系统启动到grub Boot loader菜单时选择第一项并按`e`键进入grub的编辑模式。
	![enter description here][3]
	+ 找到linux16这一行，在后面加入参数，如图：
	![enter description here][4]
	+ 按`Ctrl`+`x`继续启动
+ 为了以后每次启动系统不加参数，将参数写入grub的配置文件。
	+ `vi /boot/grub2/grub.cfg` 找到linux16这一行，在后面加入参数，下面时我的grub的配置文件
	```shell
	......
	### BEGIN /etc/grub.d/10_linux ###
        load_video
        set gfxpayload=keep
        insmod gzio
        insmod part_msdos
        insmod xfs
        set root='hd0,msdos6'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos6 --hint-efi=hd0,msdos6 --hint-baremetal=ahci0,msdos6 --hint='hd0,msdos6'  9b6afe7b-0618-4e04-80b8-79bf7e3fa8f9
        else
          search --no-floppy --fs-uuid --set=root 9b6afe7b-0618-4e04-80b8-79bf7e3fa8f9
        fi
        linux16 /vmlinuz-3.10.0-514.el7.x86_64 root=/dev/mapper/vg1-root ro crashkernel=auto rd.lvm.lv=vg1/root rd.lvm.lv=cl/swap rhgb quiet LANG=en_US.UTF-8  hpsa.hpsa_simple_mode=1 hpsa.hpsa_allow_any=1
        initrd16 /initramfs-3.10.0-514.el7.x86_64.img
	......
	```

**注：此方法理论上适合任何一款HP PC服务器，遇到同样的问题可以一试。**


  [1]: ./images/HP%E5%AE%89%E8%A3%85centos7%E6%97%A0%E6%B3%95%E8%AF%86%E5%88%ABraid_1.PNG "HP安装centos7无法识别raid_1.PNG"
  [2]: ./images/HP%E5%AE%89%E8%A3%85centos7%E6%97%A0%E6%B3%95%E8%AF%86%E5%88%ABraid_2.PNG "HP安装centos7无法识别raid_2.PNG"
  [3]: ./images/HP%E5%AE%89%E8%A3%85centos7%E6%97%A0%E6%B3%95%E8%AF%86%E5%88%ABraid_3.PNG "HP安装centos7无法识别raid_3.PNG"
  [4]: ./images/HP%E5%AE%89%E8%A3%85centos7%E6%97%A0%E6%B3%95%E8%AF%86%E5%88%ABraid_4.PNG "HP安装centos7无法识别raid_4.PNG"