# Linux通过ssh远程登陆服务端
    ssh 即 Secure Shell，建立在应用层基础上的安全协议，是目前较安全远程登录协议之一，也是 Linux 远程管理的默认协议。适用于多平台。
##  一、ssh简介
1. SSH协议
>SSL提供了握手和加密手段，不是一个独立的应用层协议，可以基于它修改现有的应用使之安全，而SSH是基于SSL之上的应用层协议，跟一般的通过SSL加密的应用层协议只是简单的修改socket接口替换为ssl接口的机制不同，SSH是一个完全替换telnet和ftp的应用，并且可以基于之上使用端口转发功能为其他应用层提供安全通道。

+ SSH是专为远程登录会话和其他网络服务提供安全性的协议。利用 SSH 协议可以有效防止远程管理过程中的信息泄露问题。是大多数服务器采用的远程登录协议。SSH有很多功能，它既可以代替Telnet，又可以为FTP、PoP、甚至为PPP提供一个安全的"通道"。
+ SSH由两个不兼容的版本，分别是SSH 1.x和SSH 2.x，SSH 2.x的客户端程序不能连接到SSH 1.x的服务器程序。SSH 2.x更安全。
+ 注意：SSH是基于应用层基础上的安全协议，记住是协议哦！

2. SSH程序
一般情况协议的实现是通过程序来实现的，SSH程序分服务端和客户端两部分。
+ 服务器程序
  + 目前比较常用的SSH服务端程序是openssh，同时支持SSH 1.x和SSH 2.x，同时它也自带客户端工具。一般linux都自带此程序，且默认开启。
  + openssh是命令行模式，还有vnc server图形界面的服务器程序，用于特殊用途。
  + SSH服务是通过sshd这个daemon（守护进程）来实现的，它在OS后台一直运行，负责时刻监听着来自客户端的连接请求并进行处理，这些请求一般包括公共密钥认证、密钥交换、对称密钥加密和非安全连接。
  + 注意：一般会安装openssl程序为ssh提供连接加密。
+ 客户端程序
  + windows
  SecureCRT、Xshell、putty
  + linux
  openssh、vnc

##二、服务端ssh服务部署（本例服务端为CentOS 7）
---
### 1、软件
 1. 登陆CentOS 7并切换到root账号（或sudo）

 2. 查看ssh服务器软件是否安装

	<1>.`rpm -qa | grep ssh`

	<2>.若未安装则通过命令安装：`yum install openssh-server`
 3. 启动ssh服务
	<1>.启动：`service sshd start`或`systemctl start sshd`
	<2>.停止：`service sshd stop`或`systemctl stop sshd`
	<3>.重启：`service sshd restart`或`systemctl restart sshd`
 4. 设置开机启动ssh服务
	`chkconfig sshd on	#(on换成off则禁止开机启动)`或`systemctl enable sshd`
### 2、配置ssh
/etc/ssh/sshd_config文件（服务端配置）
 5. 禁止root账户远程登陆（没新增账号的登不上别打我～）：

       有的Linux默认禁止，而CentOS 7默认容许任何帐号通过ssh登入
	<1>.登陆root账号（或sudo）
	<2>.打开/etc/ssh/sshd_config文件，这里用vim
	    `vim /etc/ssh/sshd_config`
	<3>.修改文件
	    在sshd_config文件中找到＃PermitRootLogin yes（有的没#号，比如我的），将yes改为no.
![选区_002.png](http://img.blog.csdn.net/20160522115545003)
	<4>.重启sshd
	`systemctl restart sshd.service`

 6. 更改ssh默认端口：
	在sshd_config文件中找到Port 22，将22改掉(注意别和其他服务端口起冲突哈)，并重启sshd。
+ 其实是可以不用配置的（在ssh默认端口开启的情况下）就能登陆的，为了安全还是配置下。让我来说道说道～其一：禁止root登陆，只能普通账号登陆，好处你懂得...其二:ssh默认端口是22，黑客经常对22端口扫描并进行暴力破解，更改端口号的好处你也懂得...
## 三、ssh客户端及远程验证登陆
### 1、密码登陆
1. ssh端口为默认时（22）：
ssh  [-v ] [-p port]  username@hostname
    + -v：显示详细信息
    + -p：ssh端口非22时，需写上端口号（port）
	例：ssh -v -p 298 root@192.168.5.1
### 2、密钥认证登陆
+ 原理：

+ 实现：
    1. 客户端创建密钥（公钥和私钥，天生的一对哈.....）
    用openssh自带工具生成，执行过程可以无视一切，一路回车即可；也可设置密钥生成路径及密钥的密码。
    + `ssh-keygen [-t rsa] [-C 'sam@msn.com']`
    -t：指定密钥类型，默认rsa，可以不写
    -C：注释文字，可以不写
    2. 上传公钥到ssh服务器
    将客户端生成密钥的公钥～/.ssh/id_rsa.pub文件上传到服务器并生成对应用户的～/.ssh/authorized_keys文件，方法较多，此处只介绍两种。
    + `ssh-copy-id username@hostname`
    此方法需ssh-copy-id工具，但直接将id_rsa.pub文件信息写入～/.ssh/authorized_keys文件。
    + `$ scp ~/.ssh/id_rsa.pub username@hostname:~/.ssh/`
     ` $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`
     `$ rm -f id_rsa.pud`
     scp是openssh自带的，无需单独安装，但需要将id_rsa.put文件内容写入authorized_keys文件
    + 此时已经可以不需要密码登陆了，但是需要输入ssh username@hostname
    3. 创建快捷登陆
    + 在客户端编辑或创建～/.ssh/config,此文件可以有多个ssh账号。
    $ cat ~/.ssh/config
    HOST 123        #自定义别名
    HOSTNAME 192.168.5.20       #ssh服务器ip或domain
    PORT 22     #sshd的端口号
    USER root       #登陆ssh服务器的用户
    IDENTITYFILE ~/.ssh/id_rsa      #本地私钥路径
    \
    HOST 234
    HOSTNAME 192.168.5.21
    PORT 22
    ..........
    + 现在可以用：`$ ssh 123`登陆192.168.5.20这个服务器了
## 五、通过SSH转发X窗口
$ ssh -X xxxx@xxx.xxxx.xxxx
报错：X11 forwarding request failed on channel 0
1. 应用场景说明
+ 目的：有时可能需要运行远程主机上的一些 GUI 程序。
+ 我们知道SSH有Client（客户）端和Server（服务）端，这个应用场景是通过SSH的X参数进行Client端远程Server端，并使用Server端的gui的程序，且Server端主机没有桌面环境及X Window System。
2. 实现原理
+ 我们知道 Linux 的 X Window System具有网络透明性。X Window System里有一个统一的 X Server 来负责各程序与各种设备（显示器，键盘，鼠标等）的交互，每个 GUI 应用程序都可以通过网络协议与 X Server 进行交互。对任何一个应用程序来说，本地运行和远程运行的差别仅仅是 X Server 地址的不同。所以为了在 Client端的主机上运行远程的 X 程序首先需要一个本地的 X Server。

+ 同时，OpenSSH 具有 X 转发功能，可以将 Linux 服务端主机上的 gui 程序通过 SSH 管道转发给客户端。

3. 前提条件
+ Server端：
   + 配置 OpenSSH Server 的配置文件/etc/ssh/sshd_config 使其允许 X 转发，修改X11Forwarding 参数为yes ，有些默认开启了。
   + 并且还必须装有 xauth（xorg-x11-xauth）软件包 ，安装后重新登陆一次，会自动生成.Xauthority。
   + DISPLAY 和 XAUTHORITY 变量不用设置，安装xorg-x11-xauth之后自己就配置正确了，如果在执行 ssh 命令的过程中报错说DISPLAY 没有设置好，那么说明 ssh 根本就没有转发 X11 连接。
   + 注意：Server端的配置结束后必须重启sshd服务。

+ Client端
   + linux系统环境：只要你的是桌面版的linux就可以，如果客户端都是命令行模式的，自己都不能运行gui软件，还搞个鬼......其实用的是Client端系统的x server服务，
   + windows系统环境：你需要给你的windows机器准备一个X显示服务器，如Cygwin/X，X-win32，Exceed或X-Deep/32。

4. 连接
+ 在客户端，通过在 ssh 命令时添加参数
   + –X（大写的哦）参数来启用 X11 转发，不过你可以通过设置~/.ssh/config 文件中 ForwardX11 yes 来使得X11转发为所有的连接或者指定的连接是默认的。
   + -q参数用来。。。反正不加此参数有些软件无法进行输入，比如Oracle安装




# 基于SSH的文件传输sftp和scp
Created 星期三 17 八月 2016

## 一、sftp简介
	sftp是基于SSH协议的文件传输，因SSH是目前最安全可靠的传输协议之一，所以使用sftp进行文件传输有助于保护用户账户和传输安全。



## 二、使用方法

	建立连接：sftp username@xxx.xxx.xxx.xxx
	sftp的常用命令		：
------------
命令说明: 命令                 | 说明                         | 命令        | 说明                    |
----------
	|:-------|:----------------------------------------|:-----------------------|:-------------------------------|:--------------|:--------------------------|
	|  cd    | 切换远程所在目录                | rm                     |                                | exit/bye/quit | 关闭sftp客户端程序 |
	| ls/dir | 显示远程所在目录文件列表    | rename oldname newname | 修改远程文件名          |               |                           |
	| mkdir  | 建立远程所在目录                |                        |                                |               |                           |
	| rmdir  | 删除远程所在目录                | lcd                    | 切换本地所在目录       |               |                           |
	| pwd    | 显示远程所在目录的绝对路径 | lls                    | 显示当前目录文件列表 |               |                           |
	| chgrp  | 修改远程目录的所属             | lmkdir                 |                                |               |                           |
	| chown  |                                         |                        |                                |               |                           |
