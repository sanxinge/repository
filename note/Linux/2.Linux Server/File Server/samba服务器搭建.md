# samba服务器搭建
Created 星期二 16 八月 2016

## 一、samba介绍
用途：实现不同操作系统的文件和打印共享
1. SMB 协议
　　SMB（Server Messages Block，服务信息块）是一种在局域网上的共享文件或打印机的协议。
2. Samba 简介
Samba 主要具有以下的功能：
	+ 使用Windows 系统能够共享的文件和打印机。
	+ 共享安装在Samba 服务器上的打印机。
	+ 共享Linux 的文件系统。
	+ 支持Windows 客户使用网上邻居浏览网络。
	+ 支持Windows 域控制器和Windows 成员服务器对使用Samba 资源的用户进行认证。
	+ 支持WINS 名字服务器解析及浏览。
	+ 支持SSL 安全套接层协议。
3. Samba 工作原理
两种协议：
	+ NETBIOS（Windows“网络邻居”的通讯协议）；
	+ SMB（Server Message Block）协议。
## 二、samba安装
1. `[root@www ~]# yum install samba`
2. 启动：service smb start
3. 停止：service smb stop
## 三、samba配置
1. 在主配置文件：/etc/samba/smb.conf中配置
+ Global Settings（全局变量配置区域）
该部分以【global】字段开始
其通用格式为：字段=设定值
		下面我们对[global]常用字段及设置方法进行介绍。
（1）设置工作组或域名名称
		workgroup = school
（2）服务器描述
	Server string = RHEL5 server
（3）设置samba服务器安全模式
		五种安全等级：share、user、server、domain和ads5种安全模式。
		默认情况下，使用user等级
		Share：使用此等级，用户不需要账号及密码可以登录samba服务器。
	User：使用此等级，由提供服务的samba服务器检查用户账号及密码。
	Server：使用此等级，检查账号及密码的工作可指定另一台samba服务器负责。
	Domain：使用此等级，需要指定一台windows NT/2000/XP服务器（通常为域控制器）。以验证用户输入的账号及密码。
	Ads：当samba服务器使用ads安全级别加入到Windows域环境中，其包括有domain级别中的所有功能，并可以具备域控制器的功能
