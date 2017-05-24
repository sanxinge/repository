# 通过pex自动化安装Linux系统
## 一、应用实现原理
原理：本架构是基于c/s架构的pex协议来实现的。
### 1、整套架构的需求
+ Server端
   1. DHCP Server：提供Client端的ip
   2. TFTP Server：通过网络服务提供Client端的启动文件
   3. OS Server：可以是ftp、http、nfs等服务器，通过网络服务提供Client端的安装镜像文件
+ Client端
　　只需Client端的网卡支持pex启动即可（现在机子几乎全都支持），由于pex中有tftp-client(tftp服务的客户端)，故而server端要有tftp-server软件。
### 2、实现的原理（具体流程）
1. Client端通过网络启动（最好是通过启动热键选择网络启动，不要设置BIOS第一启动选项为网络启动，因为自动安装并重启时你不在或稍不注意就会重新安装）
2. Clinet端会自动搜索局域网中的dhcp服务器，找到Server端的DHCP服务器并获取ip
3. Clinet端获取ip的同时DHCP服务告诉Client端
### 3、本案例的环境
Server端三个服务都可以部署在不同同服务器上，也可以部署在同一服务器上，本次是部署在同一服务器上的，环境部署要求如下：
+ Server端
系统：CentOS Linux6.5（其他的发行版都可以，我的本子就是以Arch Linux实现这套架构的）
ip：192.168.5.222
OS Server：httpd
DHCP Server和TFTP Server就不说了，没得选。
+ Client端启动：通过网络启动，自动获取192.168.5网段的ip
### 2、涉及技术

## 二、Server端的部署
### 1、DHCP Server的实现
1. 安装
`[root@www ~]# yum install dhcp`
`[root@dream ~]# pacman -S dhcp`    #ARCH Linux
2. 配置
### 2、TFTP Server的实现
1. 安装tftp
`[root@www ~]# yum install tftp-server`
`[root@dream ~]# pacman -S tftp-hpa`    #ARCH Linux
2. 配置
+ 查看是否有 /etc/xinetd.d/tftp文件，有修改没有新建。
`cat /etc/xinetd.d/tftp`
service tftp
{
disable = no
socket_type = dgram
protocol = udp
wait = yes
user = root
server = /usr/sbin/in.tftpd
server_args = -s /var/tftp
}
+ 建立tftp服务文件目录
mkdir /var/tftpfiles
+ 从新启动服务
systemctl restart xinetd
+ 安装完成！测试方法：
在/tftpboot 目录下随便放个文件abc
然后 运行tftp 192.168.123.202 进入tftp命令行
输入get abc 看看是不是能把文件下下来，如果可以就可以了，也可以put 文件上去。
3. 数据准备
+ 拷贝镜像中isolinux和imges/pxeboot两文件夹下的文件到tftp的根目录
[root@www ~]# cp /media/cdrom/images/pxeboot/{vmlinuz,initrd.img} /var/tftp/
[root@www ~]# cp /media/cdrom/isolinux/{boot.msg,vesamenu.c32,splash.jpg} /var/tftp/
也可以把这两文件夹下的所有文件都拷到tftp的根目录，反正有不大且不会出错。
+ pexlinux.0文件准备（也是tftp的根目录）
root@www ~]# yum -y install syslinux
[root@www ~]#  cp /usr/share/syslinux/pxelinux.0  /var/tftp/
+ pxelinux
[root@www ~]# mkdir /var/lib/tftpboot/pxelinux.cfg
[root@www ~]# cp /media/cdrom/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default

[root@www ~]# chmod u+w /var/lib/tftpboot/pxelinux.cfg/default
[root@www ~]# vim /var/lib/tftpboot/pxelinux.cfg/default
### 3、OS Server的实现

## 三、Client端启动安装
