# Remote Connetction
----  

## 一、Linux Online tools
-----
### 1. COM口连接
1. Linux 串口设备文件名
	+ Linux 使用 ttySx 作为一个串口设备的名称。例如，COM1 (DOS/Windows下的名字) 是 ttyS0, COM2 是 ttyS1 等等。
	+ USB串口设备文件名为`/dev/ttyUSBx`,也是从零开始，即第一个USB设备为`/dev/ttyUSB0`。
	+ PC上的串口一般是ttyS，板子上Linux的串口一般叫做ttySAC
2. 查看串口驱动
Z-TEK的USB串口设备在kernel2.4之后大多数都可以支持
	``` bash
	[dream@Dream ~]$ cat /proc/tty/drivers 
	/dev/tty                  /dev/tty        5       0 system:/dev/tty
	/dev/console         /dev/console  		  5       1 system:console
	/dev/ptmx             /dev/ptmx   	    5       2 system
	/dev/vc/0              /dev/vc/0          4       0 system:vtmaster
	usbserial               /dev/ttyUSB      188 0-511 serial
	serial                    /dev/ttyS       4 64-95 serial
	pty_slave              /dev/pts           136 0-1048575 pty:slave
	pty_master          /dev/ptm    		  128 0-1048575 pty:master
	unknown             /dev/tty      		  4 1-63 console
	```
	
3. 查一下板子上的串口有没有设备
	``` bash
	[dream@Dream ~]$ grep tty /proc/devices
		4   tty
		4   ttyS
		5   /dev/tty
		188 ttyUSB
	```
	
4. 连接工具
+ 命令行工具
大多数 linux 自带一个串口命令：minicom，需要经过设置，之后就可以连接了。
	+ 设置：
	1. 执行`minicom -s`弹出菜单：
			
			+-----[configuration]------+
            | Filenames and paths      |
            | File transfer protocols  |
            | Serial port setup        |
            | Modem and dialing        |
            | Screen and keyboard      |
            | Save setup as dfl        |
            | Save setup as..          |
            | Exit                     |
            | Exit from Minicom        |
            +--------------------------+
	2. 选择：`serial port setup`，串口设置会进入二级菜单，这个菜单如下：
	A -    Serial Device      : /dev/ttyS0                                                    串口的编号，第一个为“0”   
	B - Lockfile Location     : /var/lock                                                    lockfile路径
	C -   Callin Program      :                                                         
	D -  Callout Program      :                                          
	E -    Bps/Par/Bits       : 38400 8N1                                                  波特率，默认38400
	F - Hardware Flow Control : Yes                                                       硬件流量控制是否开启
	G - Software Flow Control : No                                                        软件流量控制是否开启
		+ 每个选项的第一个大写字母，是可以按相应的按键进行设置。
 	3. 我的设置如下：
	A -    Serial Device      : /dev/ttyUSB0                                              我的笔记本用的是Z-TEK的USB串口         B - Lockfile Location     : /var/run                                                    lockfile路径默认
	C -   Callin Program      :                                                         
	D -  Callout Program      :                                          
	E -    Bps/Par/Bits       : 9600 8N1                                                   设置波特率 9600
	F - Hardware Flow Control : No                                                      关闭硬件流量控制
	G - Software Flow Control : No                                                       关闭软件流量控制
	4. 设置完成之后键入 enter,之后选择：Save setup as dfl 保存设置，再Exit from Minicom退出minicom设置
	5. 现在可以直接在linux上执行：minicom连接了。
+ putty
不做过多介绍了，只需注意Serial line的默认值是/dev/ttyS0,使用时需按实际情况填写。

### 2. Telnet



### 3. secureCRT安装与破解
> sercureCRT就不在这里介绍了，这里直说安装与破解。

方法如下：
1. 去secureCRT官网下载自己系统版本及位数的文件  
下载地址：http://www.vandyke.com/download/index.html  
我下载的是`scrt-8.1.1.1319.ubuntu16-64.tar.gz`  

2. 安装secureCRT  
在终端里面执行 命令：`sudo tar zxf scrt-8.1.1.1319.ubuntu16-64.tar.gz -C /opt` 安装到`/opt`目录。
	+ 安装完成之后，现在直接连是链接不上的。因为你没有按照 openSSH server。

3. 安装ssh   
很简单，只需执行 sudo apt-get install openssh-server

4. 上面算是已经安装成功，下来做的就是对他今天破解工作，下载破解程序
`wget http://download.boll.me/securecrt_linux_crack.pl`

5. `whereis SecureCRT` 查看安装路径，我的是二进制解压版的，`SecureCRT`二进制文件的目录为`/opt/scrt-8.1.1/SecureCRT`

6. 执行`dream@Mint ~ $ sudo perl securecrt_linux_crack.pl /opt/scrt-8.1.1/SecureCRT`进行破解，结果如下：
	```
	dream@Mint ~ $ sudo perl securecrt_linux_crack.pl /opt/scrt-8.1.1/SecureCRT
	crack successful

	License:

		Name:		xiaobo_l
		Company:	www.boll.me
		Serial Number:	03-94-294583
		License Key:	ABJ11G 85V1F9 NENFBK RBWB5W ABH23Q 8XBZAC 324TJJ KXRE5D
		Issue Date:	04-20-2017

	```
7. 运行CRT

### 4. reamsh