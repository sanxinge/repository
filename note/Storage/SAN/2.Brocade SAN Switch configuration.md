# Borcade SAN Switch
---
## 一、概述
---
### 1、简介
配置 Zoning 需要涉及到三个对象的配置 Alias，Zone，Configuration。
1. Alias：
别名，可以把设备的 WWN或 ”Domain,Port“ 声明为 Alias，两个作用：
     + 使更好更直观的标示设备。使用 Alias 的主要目的是方便用户的使用（类似身份证号和名字）；
     + 声明Alias 的另外一个益处是便于 Zone 中成员的更换。当 Zone 中的某个成员更换时，如果定义了 Alias，只要修改 Alias 的定义而不用修改 Zone 的配置。 
2. Zone
Zone 区域：Zone内的设备可以相互访问，但不能访问其他 Zone 的设备。  
Zone 的成员可以有三种：“Domain,Port“；”WWN”；”Alias"。 Zone 对成员的数量没有限制，可以同时有多个类型的多个设备同时存在于一个 Zone 中。
3. Configuration 
在交换机上的一套关于 Zone 的配置，或者说一系列 Zone 的集合。它可以包含一个或多个 Zone 作为它的成员。在一个SAN 网络中可以有多个配置文件，但只能有一个处于Effective状态的配置文件，故而所有要使用的zone都要加到Effective状态的配置文件。Zoning 的配置可以动态的进行，当使用 cfgEnable 指定某个配置成为生效的配置后，Zoning 的配置会立即在 SAN 网络中生效，隔离 Zone 间的相互访问。
### 2、光纤通道端口
光纤通道也定义了其他一系列不同类别可以用于接收和传输光纤通道数据的端口, 如下
1. 设备 (节点)端口
N_Port = Fabric直接连接设备
NL_Port = Loop连接设备
2. 交换机端口
E_Port = 扩展端口 (交换机到交换机)
F_Port = Fabric端口
FL_Port = Fabric Loop端口  
G_Port = 通用(Generic)端口 梷 可以转化为E或F

## 二、Brocade SAN Switch日常维护
---
### 1、信息查询(巡检)
1. IP信息查询:`ipaddrshow`
    ```
    moonpac:admin> ipaddrshow
    
    SWITCH
    Ethernet IP Address: 10.172.28.6
    Ethernet Subnetmask: 255.255.255.0
    Fibre Channel IP Address: 0.0.0.0
    Fibre Channel Subnetmask: 0.0.0.0
    Gateway Address: 10.172.28.1
    ```  
2. 查看交换机信息及所有端口状态:`switchshow`  
    ```
    moonpac:admin> switchshow
    switchName:	moonpac
    switchType:	34.0
    switchState:	Online   
    switchMode:	Native
    switchRole:	Principal
    switchDomain:	1
    switchId:	fffc01
    switchWwn:	10:00:00:05:1e:02:22:f1
    zoning:	        ON (cfg0)
    switchBeacon:	OFF
    
    Area Port Media Speed State 
    ==============================
      0   0   id    N2   Online    F-Port  20:24:00:a0:b8:26:11:a6
      1   1   id    N2   Online    F-Port  20:25:00:a0:b8:26:11:a6
      2   2   id    N2   Online    F-Port  10:00:00:90:fa:ca:87:02
      3   3   id    N2   Online    F-Port  10:00:00:90:fa:ca:87:03
      4   4   id    N2   No_Light  
      5   5   id    N2   No_Light  
      6   6   id    N2   No_Light  
      7   7   id    N2   No_Light  
      8   8   --    N4   No_Module (No POD License) Disabled
      9   9   --    N4   No_Module (No POD License) Disabled
     10  10   --    N4   No_Module (No POD License) Disabled
     11  11   --    N4   No_Module (No POD License) Disabled
     12  12   --    N4   No_Module (No POD License) Disabled
     13  13   --    N4   No_Module (No POD License) Disabled
     14  14   --    N4   No_Module (No POD License) Disabled
     15  15   --    N4   No_Module (No POD License) Disabled
     ```
3. 查看交换机运行状态: `switchstatusshow`  
交换机状态为healthy，则表示交换机当前运行正常，如果有不是healthy的状态出现，则需要根据具体问题使用相关命令继续检查.
    ```  
    moonpac:admin> switchstatusshow
    Switch Health Report                        Report time: 01/01/2000 08:35:11 PM
    Switch Name: 	moonpac
    IP address:	10.172.28.6
    SwitchState:	HEALTHY
    Duration:	20:33
    
    Power supplies monitor	HEALTHY
    Temperatures monitor  	HEALTHY
    Fans monitor          	HEALTHY
    Flash monitor         	HEALTHY
    Marginal ports monitor	HEALTHY
    Faulty ports monitor  	HEALTHY
    Missing SFPs monitor  	HEALTHY
    Fabric Watch is not licensed
    Detailed port information is not included
    ```  
    
4. 风扇运行状态: `fanshow`
    ```
    moonpac:admin> fanshow
    Fan 1 is Ok
    Fan 2 is Ok
    Fan 3 is Ok
    ```
5. 当前温度查询: `tempshow`
显示交换机当前温度信息,并检查当前交换机的温度传感器是否为OK状态
    ```
    moonpac:admin> tempshow
    Sensor	State	Centigrade     Fahrenheit
      ID
    ==============================================
      1	Ok	    29		   84
      2	Ok	    29		   84
    ```  
6. 电源运行状态: `psshow`
电源状态都是OK则表明电源运行正常，absent表示没有插电源。
    ```
    moonpac:admin> psshow
    
    Power Supply #1 is OK
    ```
7. 错误日志: `errdump`
8. Firmware版本信息: `firmwareshow`
    ```
    moonpac:admin> firmwareshow
    Primary partition:	v5.0.1b
    Secondary Partition:	v5.0.1b
    ```
9. 显示交换机的工作时间: `uptime`
检查该交换机当前时钟，目前有几个用户登录到这台交换机，以及它已经正常工作了多长时间等信息。
    ```
    moonpac:admin> uptime
      5:42am  up  3:25,  1 user,  load average: 0.00, 0.00, 0.00
    ```
10. License信息查询: `licenseshow`
    ```
    moonpac:admin> licenseshow
    cbSRRSzcddcTSSp:
        Web license
    RdybRccSdySezcSU:
        Zoning license
    ```
11. zone的配置信息查询: `cfgshow`
    ```  
    moonpac:admin> cfgshow
    Defined configuration:
     cfg:	cfg0	dsa_fc1; dsa_fc2; dsb_fc1; dsb_fc2
     zone:	dsa_fc1	dsa; fc1
     zone:	dsa_fc2	dsa; fc2
     zone:	dsb_fc1	dsb; fc1
     zone:	dsb_fc2	dsb; fc2
     alias:	dsa	1,0
     alias:	dsb	1,1
     alias:	fc1	1,2
     alias:	fc2	1,3
    
    Effective configuration:
     cfg:	cfg0	
     zone:	dsa_fc1	1,0
    		1,2
     zone:	dsa_fc2	1,0
    		1,3
     zone:	dsb_fc1	1,1
    		1,2
     zone:	dsb_fc2	1,1
    		1,3
    ```
### 2、维护操作
1. IP设置: `ipaddrset`  
    ```    
    switch:admin> ipaddrset
    Ethernet IP Address [10.172.28.6]: 10.172.28.8
    Ethernet Subnetmask [255.255.255.0]: 
    Fibre Channel IP Address [0.0.0.0]: 
    Fibre Channel Subnetmask [0.0.0.0]: 
    Gateway IP Address [10.172.28.1]: 
    Issuing gratuitous ARP...Done.
    IP address is being changed...Done.
    Committing configuration...Done.
    ```  
2. 自定义交换机名称：`switchname newname`  
	```
	switch:admin> switchname moonpac
	Committing configuration...
	Done.
	moonpac:admin> 
	```  
3. 导入许可信息: `licenseadd "license-key"` 

4. 配置备份: `configupload`  
    + 配置文件备份的作用：  灾难恢复  故障诊断及恢复   恢复一台无效配置的交换机  修改或者扩展SAN  恢复意外删除的许可  恢复或者重配分区配置  
    + 需求: 有一台FTP Server.  
    ```
    moonpac:admin> configupload
    Protocol (scp or ftp) [ftp]: ftp
    Server Name or IP Address [host]: 10.172.28.103
    User Name [user]: dream
    File Name [config.txt]: ds4700_cfg.txt
    Password: 
    Upload complete
    ```
5. 配置恢复: `configdownload`
先要关闭交换机: `switchdisable`
    ```
    moonpac:admin> configdownload 
    configDownload: This command may not be executed on an operational switch.
    You must first disable the switch using the "switchDisable" command.
    moonpac:admin> switchdisable
    moonpac:admin> configdownload
    Protocol (scp or ftp) [ftp]: ftp
    Server Name or IP Address [host]: 10.172.28.103
    User Name [user]: dream
    File Name [config.txt]: ds4700_cfg.txt
    Password: 
    
                             *** CAUTION ***
    
      This command is used to download a backed-up configuration
      for a specific switch.  If using a file  from a  different
      switch, this file's configuration  settings will  override
      any current switch settings.   Downloading a configuration
      file, which was uploaded  from a different type of switch,
      may cause this switch to fail.  A switch reboot might be
      required for some parameter changes to take effect.
    
      Do you want to continue [y/n]: y
    download completed.
    ```

6. 修改用户密码: `passwd [username]`
不加username时修改当前用户的密码
    ```
    moonpac:admin> passwd
    Changing password for admin
    Enter old password: 
    Enter new password: 
    Password must be between 8 and 40 characters long.
    Enter new password: 
    Re-type new password: 
    passwd: all authentication tokens updated successfully
    Saving password to stable storage.
    Password saved to stable storage successfully.
    ```
### 3、忘记密码时恢复默认密码
> 恢复密码的大概过程是：
１. 重启San Switch。
２. 重启的时候可以注意到有一个提示，4秒内按esc可以中断启动， 进入启动接口模式。
３. 按3 进入到command shell 模式,手动启动系统到单用户模式。
４. 恢复密码并重启san switch。

1. 串口链接SAN Switch并重启 
    `moonpac:admin> reboot` 
2. 在交换机启动到`Press escape within 4 seconds to enter boot interface`时在4秒内按`Esc`进入Boot PROM菜单,一共有3 个选项：
    ```
    Press escape within 4 seconds to enter boot interface.
    
    1) Start system.            ／／启动系统
    2) Recover password.        ／／生成支持提供商的字符串，以恢复Boot PROM密码;需要有"Recovery"密码,仅原厂限内部使用;
    3) Enter command shell.     ／／打开一个可以输入命令的shell
    
    Option? 3
    ```

3. 输入3进入到command shell模式,通过配置以单用户模式启动设备(其实就是一个嵌入式Linux)
    ```
    ......
    Option? 3
    Password:   //输入Boot PROM密码,如果没有设置,则会提示"Boot PROM password has not been set",这个密码可以在"command shell"中设置
    > help      //帮助
    Valid commands are:
          auto  Boot per boot environment variable settings
          boot  Boot specified image
          date  Display or set the system date and time
         debug  Hardware debug - General debug utilities
          diag  Hardware tests - Hardware test diagnostics
          help  Display this list of commands
       helpenv  Display help for boot environment variables
          hinv  Display hardware inventory
        passwd  Set the boot modification password
          ping  Ping test
      printenv  Display all boot environment variables
         reset  Reset the system
       resetpw  Remove the boot modification password
        setenv  Set a boot environment variable
       saveenv  Save the current boot environment variables
      unsetenv  Unset a boot environment variable
       version  Display boot version info
    > passwd        //修改Boot PROM密码,这个与恢复系统密码无关.
    Old password: 
    New password: 
    Re-enter new password:
    > saveenv       //保存当前的引导环境变量,不保存重启失效.
    > resetpw       //删除Boot PROM密码,这个与恢复系统密码无关.
    > saveenv
    > printenv      //显示所有引导环境变量,目的是查看switch的系统OSLoader值为多少
    AutoLoad=yes
    ENET_MAC=00051E0222F1
    InitTest=MEM()
    LoadIdentifiers=Fabric Operating System;Fabric Operating System
    OSLoadOptions=quiet;quiet
    OSLoader=ATA()0x10b10;ATA()0x55000  //OS的加载程序(可启动DEVICE),可以看出有两个系统
    OSRootPartition=hda1;hda2           //OS的"/"分区,也有两个
    SkipWatchdog=yes
    > boot ATA()0x10b10 -s      //格式为:"boot DEVICE [COMMAND_LINE]":DEVICE一般为OSLoader的第一个值;COMMAND_LINE可以把"-s"更换为"single",与Linux(grub 1.x)何其相似啊
    Booting "Manually selected OS" image.
    Entry point at 0x01000000 ...
    开机自检过程省略......
    INIT: version 2.78 booting
    sh-2.04#            //已进入单用户模式
    sh-2.04#
    ```
    + 启动单用户还有一种设置,原理是一样的,可我做实验失败了,但我同事却在一家客户那边做过,可能版本不同采用的方法不同(猜测哈),就当做个记录,上面的方法不成功是可以试试这个.
    ```
    ......
    Option? 3
    Boot PROM password has not been set.
    > setenv OSLoadOptions=single
    > printenv
    Unrecognized command "printenv".
    "help" will give a list of commands.
    > printenv
    AutoLoad=yes
    ENET_MAC=00051E0222F1
    InitTest=MEM()
    LoadIdentifiers=Fabric Operating System;Fabric Operating System
    OSLoadOptions=single        //表示交换机将引导到单用户模式
    OSLoader=ATA()0x10b10;ATA()0x55000
    OSRootPartition=hda1;hda2
    SkipWatchdog=yes
    > saveenv                   //保存,否则不生效
    > boot
    ......
    > bootenv OSLoadOptions "quiet;quiet"   //将OSLoadOptions重置为“quiet; quiet”
    > reboot -f
    ```
    
4. 恢复密码并重启SAN Switch
    ```
    sh-2.04#
    sh-2.04# mount -o remount,rw,noatime /      //挂载以下/分区,否则的话没有恢复密码的权限
    EXT3 FS on hda1, internal journal
    sh-2.04# 
    sh-2.04# 
    sh-2.04# mount /dev/hda2 /mnt/              //把第二个分区也挂载过来，这样可以把2个操作系统的密码都恢复
    kjournald starting.  Commit interval 5 seconds
    EXT3 FS on hda2, internal journal
    EXT3-fs: mounted filesystem with ordered data mode.
    sh-2.04# 
    sh-2.04# 
    sh-2.04# passwddefault                      //输入passwddefault 来恢复密码
    All account passwords have been successfully set to factory default.
    sh-2.04# reboot -f                          //reboot –f来重启san switch.
    Restarting system.
    重启过程省略......
    ```
5. 开机设置密码
    ```
    moonpac console login: admin
    Password: 
    Please change passwords for switch default accounts now.
    Use Control-C to exit or press 'Enter' key to proceed.
    
    Warning:  Access to  the Root  and Factory accounts may be required  for
    proper  support  of  the switch.  Please  ensure  the Root  and  Factory
    passwords are  documented in a secure location.  Recovery of a lost Root
    or Factory password will result in fabric downtime.
    
    for user - root
    Changing password for root
    Enter new password: 
    Re-type new password: 
    passwd: all authentication tokens updated successfully
    Please change passwords for switch default accounts now.
    for user - factory
    Changing password for factory
    Enter new password: 
    Re-type new password: 
    passwd: all authentication tokens updated successfully
    Please change passwords for switch default accounts now.
    for user - admin
    Changing password for admin
    Enter new password: 
    Re-type new password: 
    passwd: all authentication tokens updated successfully
    Please change passwords for switch default accounts now.
    for user - user
    Changing password for user
    Enter new password: 
    Re-type new password: 
    passwd: all authentication tokens updated successfully
    Saving passwords to stable storage.
    Passwords saved to stable storage successfully
    ```

### 4、Firmware升级操作
1. 备份当前的配置文件
命令: `configupload` ,详细信息请看上面维护操作的配置备份.

2. 查看当前的Firmware版本
    ```
    Firmware版本:
    moonpac:admin> firmwareshow
    Primary partition:	v5.0.1b
    Secondary Partition:	v5.0.1b
    
    也是Fabric OS的版本:
    moonpac:admin> version
    Kernel:     2.4.19     
    Fabric OS:  v5.0.1b
    Made on:    Wed Aug 17 21:28:18 2005
    Flash:	    Tue Jan 24 05:24:32 2006
    BootProm:   4.5.2
    ```  
3. 在FTP Server上解压firmware包
`$ sudo tar zxvf v5.3.2c.tar.gz -C /srv/ftp/`     //选择匿名登录,故而解压到/srv/ftp

4. 使用`firmwareDownload`命令从FTP服务器下载固件并升级。
    ```
    moonpac:admin> firmwareDownload
    You can run firmwareDownloadStatus to get the status
    of this command.
    
    This command will cause the switch to reset and will
    require that existing telnet, secure telnet or SSH
    sessions be restarted.
    
    Do you want to continue [Y]: y
    Server Name or IP Address: 10.172.28.103        //FTP服务器自个搭建哈
    User Name:                                      //匿名,直接回车
    File Name: v5.1.0/release.plist
    Password:                                       //匿名用户没密码,直接回车
    Firmwaredownload has started.
    Removing pcmcia-cs-3.1.29-2
    Removing fabos-fss-5.0.1b-9
    Start to install packages......
    dir                         ##################################################
    此处省略若干行.......
    lkcd                        ##################################################
    sysstat                     ##################################################
    Removing unneeded files, please wait ...
    Finished removing unneeded files. 
    
    All packages have been downloaded successfully.
    Firmwaredownload has completed successfully.
    HA Rebooting ...
    
    重启后验证版本信息:
    moonpac:admin> version
    Kernel:     2.4.19     
    Fabric OS:  v5.1.0
    Made on:    Thu Feb 23 01:55:30 2006
    Flash:	    Sat Jan 1 00:11:50 2000
    BootProm:   4.5.3
    moonpac:admin> firmwareshow
    Primary version: 	v5.1.0
    Secondary version: 	Unknown
    
    
    接着升级到 v6.0.1a 又失败了,只好先升到v5.3.2c,方法一样
    重启后验证版本信息:
    moonpac:admin> firmwareshow
    Appl     Primary/Secondary Versions 
    ------------------------------------------
    FOS      v5.3.2c
             Unknown
    moonpac:admin> version
    Kernel:     2.6.14     
    Fabric OS:  v5.3.2c
    Made on:    Wed Sep 30 16:51:09 2009
    Flash:	    Sat Jan 1 00:27:34 2000
    BootProm:   4.6.5
    
    
    接着升级到 v6.0.1a,步骤稍有点不同:
    moonpac:admin> firmwareDownload
    Server Name or IP Address: 10.172.28.103
    User Name: 
    File Name: v6.0.1a/release.plist
    Network Protocol(1-auto-select, 2-FTP, 3-SCP) [1]: 2
    Password: 
    Checking system settings for firmwaredownload...
    Protocol selected: FTP
    Trying address-->AF_INET IP: 10.172.28.103, flags : 2 
    System settings check passed.
    
    You can run firmwaredownloadstatus to get the status
    of this command.
    
    This command will cause a warm/non-disruptive boot on the switch,
    but will require that existing telnet, secure telnet or SSH sessions
    be restarted.
    
    Do you want to continue [Y]: y
    Firmware is being downloaded to the switch. This step may take up to 30 minutes.
    Preparing for firmwaredownload...
    此处省略若干行......
    
    重启后验证版本信息:
    moonpac:admin> version
    Kernel:     2.6.14.2   
    Fabric OS:  v6.0.1a
    Made on:    Thu May 22 17:55:05 2008
    Flash:	    Sat Jan 1 00:39:02 2000
    BootProm:   4.6.6
    moonpac:admin> firmwareshow
    Appl     Primary/Secondary Versions 
    ------------------------------------------
    FOS      v6.0.1a
             v6.0.1a
    ```
    + 在升级的过程可以用`firmwareDownloadStatus`查看升级状态
    ```
    moonpac:root> firmwareDownloadStatus
    [1]: Sat Jan  1 00:24:39 2000
    Firmware is being downloaded to the switch. This step may take up to 30 minutes.
    
    [2]: Sat Jan  1 00:29:27 2000
    Firmware has been downloaded to the secondary partition of the switch.
    ```
5. 注意
    + 我准备直接升级到v6.0.1a的,结果报`Firmwaredownload failed. (0x29) The pre-install script failed.`错误,猜测应该是不能跨越太大版本.  
    + 接着下载了`v5.3.2c`进行升级,报`Cannot upgrade directly to 5.3. Please upgrade to 5.1 or 5.2 first and then upgrade to 5.3.`,确定是不能跨越太大版本.


## 三、Brocade SAN Switch的zoning配置  
---
> 注意：
> 1. cfgenable和cfgdisable是对configuration的启用和关闭,该命令执行结束后无需执行`cfgsave`.
> 2. 对Alias,zone,configuration三个对象进行任何操作后都要执行`cfgsave`保存,否则重启后操作不会生效.  
> 3. zone配置的命令都可以用`zoneHelp`帮助命令查到.
> 3. Switch中可以有多个配置文件，但只能有一个处于Effective状态的配置文件，故而所有要使用的zone都要加到Effective状态的配置文件；同样在已有的SAN架构中配置新的zone也是加到Effective状态的配置文件，而不是以新的配置文件使其生效。  

### 1、创建zoning配置   
> 注:记住必须用`cfgsave`保存，和`cfgenable`让其生效

1. 创建Alias  
    + 基于`WWPN`的Alias创建:`alicreate "Alias_name","WWN"`   
    + 基于`port`的Alias创建:`alicreate "Alias_name","Domain,prot"`  

2. 创建zone   
把别名或端口或WWPN分配到 zone 中,命令格式如下:
`zonecreate "zone_name","[Alias_name];...[Domain,prot];...[WWN];..."`   
    + "[ ]"是可选的意思,而不是配置中的字符串;  
    + zone的成员是以`;`分割的;  

3. 创建zone的配置文件  
把`zone`加入到配置文件中,命令格式如下:  
`cfgcreate "cfg_name","zone_name;zone_name;..."`  
4. 保存配置   
`cfgsave`  

5. 使`zone`配置生效  
`cfgenable "cfg_name"`  

6. 实践
    ```
    moonpac:admin> switchshow
    此处省略若干行......
    switchDomain:	1
    此处省略若干行......
    Area Port Media Speed State 
    ==============================
      0   0   id    N2   Online    F-Port  20:24:00:a0:b8:26:11:a6
      1   1   id    N2   Online    F-Port  20:25:00:a0:b8:26:11:a6
      2   2   id    N2   Online    F-Port  10:00:00:90:fa:ca:87:02
      3   3   id    N2   Online    F-Port  10:00:00:90:fa:ca:87:03
      4   4   id    N2   No_Light  
      5   5   id    N2   No_Light  
      6   6   id    N2   No_Light  
      7   7   id    N2   No_Light  
    此处省略若干行......
    moonpac:admin> 
    moonpac:admin> alicreate "dsa","20:24:00:a0:b8:26:11:a6"
    moonpac:admin> alicreate "fc1","1,2"
    moonpac:admin> zonecreate "dsa_fc1","dsa;fc1"
    moonpac:admin> zonecreate "dsa_fc2","dsa;1,3"
    moonpac:admin> zonecreate "dsb_fc1","1,1;10:00:00:90:fa:ca:87:02"
    moonpac:admin> zonecreate "dsb_fc2","1,1;1,3"
    moonpac:admin> cfgcreate "cfg0","dsa_fc1;dsa_fc2;dsb_fc1;dsb_fc2"
    moonpac:admin> cfgshow
    Defined configuration:
     cfg:	cfg0	dsa_fc1; dsa_fc2; dsb_fc1; dsb_fc2
     zone:	dsa_fc1	dsa; fc1
     zone:	dsa_fc2	dsa; 1,3
     zone:	dsb_fc1	1,1; 10:00:00:90:fa:ca:87:02
     zone:	dsb_fc2	1,1; 1,3
     alias:	dsa	20:24:00:a0:b8:26:11:a6
     alias:	fc1	1,2
    
    Effective configuration:
     no configuration in effect
    
    moonpac:admin> cfgsave
    You are about to save the Defined zoning configuration. This 
    action will only save the changes on Defined configuration. 
    Any changes made on the Effective configuration will not 
    take effect until it is re-enabled.
    Do you want to save Defined zoning configuration only?  (yes, y, no, n): [no] yes
    Updating flash ...
    moonpac:admin> cfgenble cfg0
    此处省略若干行......
    
    ```
    + 上述中是为了演示各种配置方式,zone成员采用了多种混合的方式表示的,正常情况是统一的一种方式,要不统一使用Alias,要不统一使用port.
### 2、维护zoning配置  
1. 移除zone的成员: `zoneremove "zone_name","要移除的成员(Alias或WWN或Domain,port)"`  
    ```
    moonpac:admin> cfgshow
    此处省略若干行......
     zone:	dsb_fc2	1,1; 1,3
    此处省略若干行......
    moonpac:admin> zoneremove "dsb_fc2","1,3"
    moonpac:admin> cfgshow
    此处省略若干行......
     zone:	dsb_fc2	1,1
    此处省略若干行......
    ```  
2. 向zone中添加成员: `zoneadd "zone_name","要添加的成员(Alias或WWN或Domain,port)"`  
    ``` 
    moonpac:admin> zoneadd "dsb_fc2","1,3"
    moonpac:admin> cfgshow
    ......
     zone:	dsb_fc2	1,1; 1,3
    ......
    ```  
3. 在配置文件中移除zone: `cfgremove "cfg_name","要移除的zone"`    
    ```
    moonpac:admin> cfgshow
    Defined configuration:
     cfg:	cfg0	dsa_fc1; dsa_fc2; dsb_fc1; dsb_fc2
    ......
    moonpac:admin> cfgremove "cfg0","dsb_fc2"
    moonpac:admin> cfgshow
    Defined configuration:
     cfg:	cfg0	dsa_fc1; dsa_fc2; dsb_fc1
    ......
    ```
4. 向已有配置文件添加zone: `cfgadd "cfg_name","要添加的zone"`  
    ```
    moonpac:admin> cfgadd "cfg0","dsb_fc2"
    moonpac:admin> cfgshow
    Defined configuration:
     cfg:	cfg0	dsa_fc1; dsa_fc2; dsb_fc1; dsb_fc2
    ......
    ```
5. **注意**  
    + **一次的维护操作结束后应执行`cfgsave`进行保存;***
    + **维护操作结束后还应执行`cfgenable cfg_name`,让配置立即生效.**
### 3、删除zoning配置     
1. 先看看当前的配置 
    ```  
    moonpac:admin> cfgshow
    Defined configuration:
     cfg:	cfg0	dsa_fc1; dsa_fc2; dsb_fc1; dsb_fc2
     zone:	dsa_fc1	dsa; fc1
     zone:	dsa_fc2	dsa; fc2
     zone:	dsb_fc1	dsb; fc1
     zone:	dsb_fc2	dsb; fc2
     alias:	dsa	1,0
     alias:	dsb	1,1
     alias:	fc1	1,2
     alias:	fc2	1,3
    
    Effective configuration:
     cfg:	cfg0	
     zone:	dsa_fc1	1,0
    		1,2
     zone:	dsa_fc2	1,0
    		1,3
     zone:	dsb_fc1	1,1
    		1,2
     zone:	dsb_fc2	1,1
    		1,3
    ```  

2. 清除当前所有zoning配置  
    + 先关闭处于`Effective`状态的配置文件,命令:`cfgdisable`
    + 接着清除当前所有zone配置,命令: `cfgclear`  
    + 保存当前设置(如果不保存交换机重启后原来的配置还在),命令: `cfgsave`
    + 实践:
    ```
    moonpac:admin> cfgdisable
    You are about to disable zoning configuration. This
    action will disable any previous zoning configuration enabled.
    Do you want to disable zoning configuration? (yes, y, no, n): [no] yes
    Updating flash ...
    moonpac:admin> cfgclear 
    The Clear All action will clear all Aliases, Zones, FA Zones 
    and configurations in the Defined configuration.
    Do you really want to clear all configurations?  (yes, y, no, n): [no] yes
    moonpac:admin>
    moonpac:admin> cfgsave
    You are about to save the Defined zoning configuration. This 
    action will only save the changes on Defined configuration. 
    Any changes made on the Effective configuration will not 
    take effect until it is re-enabled.
    Do you want to save Defined zoning configuration only?  (yes, y, no, n): [no] yes
    Updating flash ...
    moonpac:admin>
    moonpac:admin> reboot
    
    ......
    
    dream@Mint ~ $ telnet 10.172.28.6
    ......
    moonpac:admin> cfgshow
    Defined configuration:
     no configuration defined
    
    Effective configuration:
     no configuration in effect
    ```

3. 删除单个对象   
    + 删除Alias: `alidelete Alias_name`  
    + 删除zone: `zonedelete zone_name`  
    + 删除configuration: `cfgdelete cfg_name` 
    + 实践:
    ```  
    moonpac:admin> alidelete dsa
    moonpac:admin> zonedelete dsa_fc1
    moonpac:admin> cfgdelete cfg0
    moonpac:admin>
    moonpac:admin> cfgsave
    ......
    ```  
