## 一、安装pptp
1. 查看是否有ppp模块
`sudo cat /dev/ppp`
2. 确定你的内核是否支持mppe
`modprobe ppp-compress-18 && echo ok `
如果显示ok，那么恭喜，你的内核已经具备了mppe支持。请跳过下一步
3. 升级内核支持mppe
wget http://poptop.sourceforge.net/yum/stable/packages/dkms-2.0.17.5-1.noarch.rpm
wget http://poptop.sourceforge.net/yum/stable/packages/kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
dkms是一个新的软件，能让你在不编译内核的基础上，外挂一些内核的模块。
kernel_ppp_mppe就是mppe支持的内核模块了。
rpm -ivh dkms-2.0.17.5-1.noarch.rpm
rpm -ivh kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
以上二个是为CENTOS加载MPPE[MICROSOFT的加密协议] ..不安装的话就不能使用加密连接
ok后重起你的系统
4. 所需要软件
+ pppd    ppp拨号服务器
+ pptpd   在pppd拨号的基础上增加pptpd的支持
`yum install ppp pppd`
## 二、配置
1. 配置你的pppd和pptpd

/etc/pptpd.conf中需要配置的地方只有几个

option /etc/ppp/options.pptpd

# logwtmp 如果日志里出现类似以下问题一定要注释掉logwtmp！！！！

#Jun 21 15:39:55 center pppd[1374]: /usr/lib/pptpd/pptpd-logwtmp.so: wrong ELF class: ELFCLASS32
#Jun 21 15:39:55 center pppd[1374]: Couldn't load plugin /usr/lib/pptpd/pptpd-logwtmp.so
localip 192.168.9.1
remoteip 192.168.9.11-30

配置/etc/ppp/options.pptpd
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
proxyarp
lock
nobsdcomp
novj
novjccomp
nologfd
idle 2592000
ms-dns 8.8.8.8
ms-dns 8.8.4.4

编辑 /etc/ppp/chap-secrets

添加一个测试用户

# Secrets for authentication using CHAP
# client     server   secret      IP addresses
 test      pptpd    test           *
第一个test是用户，第二个test是密码 ，*表示任意ip

配置文件/etc/sysctl.conf
# vim /etc/sysctl.conf
修改以下内容开启ip转发：
net.ipv4.ip_forward = 1
保存、退出后执行：
sysctl -p
7.打开防火墙端口
将Linux服务器的1723端口和47端口打开，并打开GRE协议。
iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -p tcp --dport 47 -j ACCEPT
iptables -A INPUT -p gre -j ACCEPT
iptables -A POSTROUTING -t nat -s 192.168.9.0/24 -o eth0 -j MASQUERADE
iptables -A INPUT -p UDP --dport 53 -j ACCEPT   ##这个最蛋疼，开始没注意，能连接上怎么都打不开网页，搞了半天才发现DNS端口没有打开，差点昏死过去！！
service iptables save

8.测试pptpd

如果是默认安装，你在任意路径打pptpd就可以了。
如果成功，你就会在
/var/log/messages里面看到
Feb 10 09:51:46 kdfng pptpd[926]: MGR: Manager process started

Feb 10 09:51:46 kdfng pptpd[926]: MGR: Maximum of 100 connections available





9.Win7下PPTP VPN客户端设置
