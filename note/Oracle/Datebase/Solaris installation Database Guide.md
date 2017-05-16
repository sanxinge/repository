# Database Installation Guide for Solaris on x86-64
-------
## 一、环境部署   
---
### 1、 Creating installation Directories  
1. `# mkdir -p /opt/app/oracle`
2. `# chown -R oracle:oinstall /opt/app`
3. `# chmoe -R 775 /opt/app/oracle`  

### 2、Creating Groups and User    
1. Groups  
`# groupadd oinstall`：Oracle Inventory 组
`# groupadd dba`：OSDBA 组
`# groupadd oper`：OSOPER 组，可选
2. User  
`# useradd -u 1000 -g oinstall -G dba,oper -m -d /export/home/oracle -s /bin/bash oracle`：Oracle software owner
	+ `-u`：新账户的用户UID
	+ `-g`：新账户主组的名称或 ID
	+ `-G`：新账户的附加组列表，多个组时用`,`分割
	+ `-m`：创建用户的主目录
	+ `-d`：新账户的主目录
	+ `-s`：新账户的登录 shell   
3. Password    
`# passwd oracle`  
4. Configuring the oracle User's Environment  
	```bash
	#　echo 'export ORACLE_BASE=/opt/app/oracle
	export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
	export ORACLE_SID=orcl
	export LD_LIBRARY_PATH=$ORACLE_HOME/lib
	export PATH=$ORACLE_HOME/bin:$PATH' >> /export/home/oracle/.profile
	```
### 3、Install dependency package
1. 检查是否有一下软件包
	```bash
	#　pkginfo -i SUNWarc SUNWbtool SUNWhea SUNWlibC SUNWlibm SUNWlibms SUNWsprot SUNWtoo SUNWi1of SUNWi1cs SUNWi15cs SUNWxwfnt SUNWcsl
	system      SUNWarc   Lint Libraries (usr)
	system      SUNWbtool CCS tools bundled with SunOS
	system      SUNWcsl   Core Solaris, (Shared Libs)
	system      SUNWhea   SunOS Header Files
	system      SUNWi1of  ISO-8859-1 (Latin-1) Optional Fonts
	system      SUNWlibC  Sun Workshop Compilers Bundled libC
	system      SUNWlibm  Math & Microtasking Library Headers & Lint Files (Usr)
	system      SUNWlibms Math & Microtasking Libraries (Usr)
	system      SUNWsprot Solaris Bundled tools
	system      SUNWtoo   Programming Tools
	system      SUNWxwfnt X Window System platform required fonts
	ERROR: information for "SUNWi1cs" was not found
	ERROR: information for "SUNWi15cs" was not found
	```   
2. 可以看到缺`SUNWi1cs`和`SUNWi15cs`软件包，请安装（系统镜像中都有）
	``` bash
	# cd /cdrom/sol_10_113_x86/Solaris_10/Product		//进入镜像的软件包目录，solaris是自动mount光盘的，一般mount到`/cdrom`目录下
	# pkgadd -d . SUNWi1cs SUNWi15cs
	此处省略输出提示，按`y`确认安装即可
	```

### 4、Configuring Kernel Parameters
1. Solaris10以前是编辑/etc/system文件
	``` bash
	# vi /etc/system
	添加如下内容
	set noexec_user_stack = 1
	set semsys:seminfo_semmni = 100  
	set semsys:seminfo_semmns = processes×2+10 
	set semsys:seminfo_semmsl = processes+10 
	set semsys:seminfo_semvmx = 32767  
	set shmsys:shminfo_shmmax = 建议内存一半
	set shmsys:shminfo_shmmni = 100 
	 ```  
 2. 在Oracle Solaris 10及以后，不需要对/etc/system文件进行更改来实现System V IPC。而改使用resource control facility（资源控制工具）实现，方法如下：
	```
	1. 运行命令id以验证oracle用户
	＃ su  -  oracle
	$ id -p
	uid=1001(oracle) gid=100(oinstall) projid=100(user.oracle)
	$exit
	2. 要将最大共享内存大小设置为2 GB，请运行以下projmod命令：
	＃ projmod -sK "project.max-shm-memory=(privileged,2G,deny)" user.oracle
	3. 完成这些步骤后，/etc/project使用以下命令检查文件的值：
	＃cat /etc/project
	system:0::::
	user.root:1::::
	noproject:2::::
	default:3::::
	group.staff:10::::
	user.oracle:100::oracle::project.max-shm-memory=(privileged,2147483648,deny)
	```
## 二、安装
-----
1. 切换到oracle用户：`# su - oracle`
2. 进入软件包目录：`[oracle@unknown]$ cd /tmp/database`
3. 执行`[oracle@unknown database]$ ./runInstaller`开始安装；如图：
	+ 在运行完成上面的./runInstaller命令之后出现下图的界面，提示配置安全更新；其中有电子邮件的配置项，没有配置它会弹出提示信息，可以忽略，点Next
	![enter description here][1]
	+ 安装选项，在这里我们可以选技下面三种安装选项（创建和配置数据库，仅安装数据库软件，升级现有的数据库）中的仅安装数据库软件来进行安装，Next
	![enter description here][2]
	+ Grid选项，选择单实例或者是RAC模式，在这里我们没有集群环境，所以就选择单实例来进行安装，Next
	![enter description here][3]
	+ 选择语言，Next
	![enter description here][4]
	+ 选择数据库版本，这里选择企业版，Next
	![enter description here][5]
	+ 安装路径，Next
	![enter description here][6]
	+ 创建Inventory文件夹，Ｎext
	![enter description here][7]
	+ 选择用户组，Next
	![enter description here][8]
	+ 安装前（安装先决条件）检测，出现问题如缺包，参数配置等问题徐解决后Next
	![enter description here][9]
	+ 安装过程
	![enter description here][10]
	+ 在root用户下执行两个脚本后点击OK
	![enter description here][11]


  [1]: ./images/install/database_install1.png "database_install1"
  [2]: ./images/install/database_install2.png "database_install2"
  [3]: ./images/install/database_install3.png "database_install3"
  [4]: ./images/install/database_install4.png "database_install4"
  [5]: ./images/install/database_install5.png "database_install5"
  [6]: ./images/install/database_install6.png "database_install6"
  [7]: ./images/install/database_install7.png "database_install7"
  [8]: ./images/install/database_install8.png "database_install8"
  [9]: ./images/install/database_install9.png "database_install9"
  [10]: ./images/install/database_install10.png "database_install10"
  [11]: ./images/install/database_install11.png "database_install11"