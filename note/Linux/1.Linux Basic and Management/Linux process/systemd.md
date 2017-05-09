---
date: 2016-06-28 18:07
status: public
title: systemctl
---
## 一、systemd、systemctl简介
1. Systemd是一个系统管理守护进程、工具和库的集合，用于取代System V初始进程。Systemd的功能是用于集中管理和配置类UNIX系统。
2. systemctl 是systemd的一个命令行工具，用于控制systemd系统和系统服务管理，Systemctl接受服务（.service），挂载点（.mount），套接口（.socket）和设备（.device）作为单元。
## 二、常见操作
### 1、systemd常见操作
1. 检查systemd和systemctl的二进制文件和库文件的安装位置
`[root@www ~]# whereis systemd`
[root@www ~]# whereis systemctl
2. 检查systemd是否运行
[root@www ~]# ps -eaf | grep systemd
3.  分析systemd启动进程
[root@www ~]# systemd-analyze
Startup finished in 830ms (kernel) + 3.194s (initrd) + 40.074s (userspace) = 44.099s
4. 分析启动时各个进程花费的时间
[root@www ~]# systemd-analyze blame
5. 分析启动时的关键链
[root@www ~]# systemd-analyze critical-chain
### 2、对服务的常见操作
1. system V指令和systemd指令对比

|   任务   |  system V指令    |  systemd指令  |
|:---------:|:----------------------:|:-----------------:|
|使某服务自动启动|chkconfig --level 3 httpd on|	systemctl enable httpd.service|
|使某服务不自动启动| 	chkconfig --level 3 httpd off |	systemctl disable httpd.service|
|检查服务状态 |	service httpd status |	systemctl status httpd.service （服务详细信息） systemctl is-active httpd.service （仅显示是否 Active)|
|显示已启动的服务|	chkconfig --list |	systemctl list-units --type=service|
|启动某服务 	|service httpd start 	|systemctl start httpd.service|
|停止某服务|	service httpd stop |	systemctl stop httpd.service|
|重启某服务 	|service httpd restart |	systemctl restart httpd.service|
|重载某服务 	| |	systemctl reload httpd.service |
2.  列出所有运行中单元
[root@www ~]# systemctl list-units
3. 列出所有失败单元
[root@www ~]# systemctl --failed
4. 使用systemctl命令杀死服务
[root@www ~]# systemctl kill httpd
5. 下面以nfs服务为例：
+ 启动nfs服务
systemctl start nfs-server.service
+ 设置开机自启动
systemctl enable nfs-server.service
+ 停止开机自启动
systemctl disable nfs-server.service
+ 查看服务当前状态
systemctl status nfs-server.service
+ 重新启动某服务
systemctl restart nfs-server.service
+ 查看所有已启动的服务
systemctl list -units --type=service
### 3、使用Systemctl控制并管理挂载点
1. 列出所有系统挂载点
[root@www ~]# systemctl list-unit-files --type=mount
UNIT FILE STATE
dev-hugepages.mount static
dev-mqueue.mount static
proc-sys-fs-binfmt_misc.mount static
sys-fs-fuse-connections.mount static
sys-kernel-config.mount static
sys-kernel-debug.mount static
tmp.mount disabled

2. 挂载、卸载、重新挂载、重载系统挂载点并检查系统中挂载点状态
[root@www ~]# systemctl start tmp.mount
[root@www ~]# systemctl stop tmp.mount
[root@www ~]# systemctl restart tmp.mount
[root@www ~]# systemctl reload tmp.mount
[root@www ~]# systemctl status tmp.mount
3. 在启动时激活、启用或禁用挂载点（系统启动时自动挂载）
[root@www ~]# systemctl is-active tmp.mount
[root@www ~]# systemctl enable tmp.mount
[root@www ~]# systemctl disable tmp.mount
4. 在Linux中屏蔽（让它不能启用）或可见挂载点
[root@www ~]# systemctl mask tmp.mount
ln -s '/dev/null''/etc/systemd/system/tmp.mount'
[root@www ~]# systemctl unmask tmp.mount
rm '/etc/systemd/system/tmp.mount'
### 4、使用Systemctl控制并管理套接口
1. 列出所有可用系统套接口
[root@www ~]# systemctl list-unit-files --type=socket
UNIT FILE STATE
dbus.socket static
dm-event.socket enabled
lvm2-lvmetad.socket enabled
rsyncd.socket disabled
sshd.socket disabled
syslog.socket static
systemd-initctl.socket static
systemd-journald.socket static
systemd-shutdownd.socket static
systemd-udevd-control.socket static
systemd-udevd-kernel.socket static
11 unit files listed.

2. 在Linux中启动、重启、停止、重载套接口并检查其状态
[root@www ~]# systemctl start cups.socket
[root@www ~]# systemctl restart cups.socket
[root@www ~]# systemctl stop cups.socket
[root@www ~]# systemctl reload cups.socket
[root@www ~]# systemctl status cups.socket
3. 在启动时激活套接口，并启用或禁用它（系统启动时自启动）
[root@www ~]# systemctl is-active cups.socket
[root@www ~]# systemctl enable cups.socket
[root@www ~]# systemctl disable cups.socket
4. 屏蔽（使它不能启动）或显示套接口
[root@www ~]# systemctl mask cups.socket
ln -s '/dev/null''/etc/systemd/system/cups.socket'
[root@www ~]# systemctl unmask cups.socket
rm '/etc/systemd/system/cups.socket'
### 5、服务的CPU利用率（分配额）
1. 获取当前某个服务的CPU分配额（如httpd）
[root@www ~]# systemctl show -p CPUShares httpd.service
CPUShares=1024
注意：各个服务的默认CPU分配份额=1024，你可以增加/减少某个进程的CPU分配份额。
2. 将某个服务（httpd.service）的CPU分配份额限制为2000 CPUShares/
[root@www ~]# systemctl set-property httpd.service CPUShares=2000
[root@www ~]# systemctl show -p CPUShares httpd.service
CPUShares=2000
注意：当你为某个服务设置CPUShares，会自动创建一个以服务名命名的目录（如 httpd.service），里面包含了一个名为90-CPUShares.conf的文件，该文件含有CPUShare限制信息，你可以通过以下方式查看该文件：
[root@www ~]# vi /etc/systemd/system/httpd.service.d/90-CPUShares.conf
[Service]
CPUShares=2000
3. 检查某个服务的所有配置细节
[root@www ~]# systemctl show httpd
4. 分析某个服务（httpd）的关键链
[root@www ~]# systemd-analyze critical-chain httpd.service
5. 获取某个服务（httpd）的依赖性列表
[root@www ~]# systemctl list-dependencies httpd.service
httpd.service
6. 按等级列出控制组
[root@www ~]# systemd-cgls
7. 按CPU、内存、输入和输出列出控制组
[root@www ~]# systemd-cgtop
### 6、控制系统运行等级
1. 启动系统救援模式
[root@www ~]# systemctl rescue
Broadcast message from root@tecmint on pts/0(Wed2015-04-2911:31:18 IST):
The system is going down to rescue mode NOW!
2. 进入紧急模式
[root@www ~]# systemctl emergency
Welcome to emergency mode!After logging in, type "journalctl -xb" to view
system logs,"systemctl reboot" to reboot,"systemctl default" to try again
to boot intodefault mode.
3. 列出当前使用的运行等级
[root@www ~]# systemctl get-default
multi-user.target
4. 启动运行等级5，即图形模式
[root@www ~]# systemctl isolate runlevel5.target
或
[root@www ~]# systemctl isolate graphical.target
5. 启动运行等级3，即多用户模式（命令行）
[root@www ~]# systemctl isolate runlevel3.target
或
[root@www ~]# systemctl isolate multiuser.target
6. 设置多用户模式或图形模式为默认运行等级
[root@www ~]# systemctl set-default runlevel3.target
[root@www ~]# systemctl set-default runlevel5.target
7. 重启、停止、挂起、休眠系统或使系统进入混合睡眠
[root@www ~]# systemctl reboot
[root@www ~]# systemctl halt
[root@www ~]# systemctl suspend
[root@www ~]# systemctl hibernate
[root@www ~]# systemctl hybrid-sleep
对于不知运行等级为何物的人，说明如下。
Runlevel 0 : 关闭系统
Runlevel 1 : 救援？维护模式
Runlevel 3 : 多用户，无图形系统
Runlevel 4 : 多用户，无图形系统
Runlevel 5 : 多用户，图形化系统
Runlevel 6 : 关闭并重启机器


开启防火墙22端口

iptables -I INPUT -p tcp --dport 22 -j ACCEPT

如果仍然有问题，就可能是SELinux导致的

关闭SElinux：

修改/etc/selinux/config文件中的SELINUX=”” 为 disabled，然后重启

彻底关闭防火墙：

sudo systemctl status  firewalld.service
sudo systemctl stop firewalld.service          
sudo systemctl disable firewalld.service
