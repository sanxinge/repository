# vsftp服务的搭建
Created 星期三 17 八月 2016
## 一、简介及安装

##  二、配置
vsftpd的大多数配置都可以通过编辑/etc/vsftpd.conf文件实现. 这个文件自身有大量注释说明, 所以这一章节只就一些重要的配置予以说明. 如果要了解所有的选顶和文档, 请使用man vsftpd.conf。
1. 允许上传
必需将/etc/vsftpd.conf中的write_enable值设为YES, 以便允许修改系统, 比如上传:
`write_enable=YES`
2. 本地用户登录
可以修改/etc/vsftpd.conf中的如下值, 以便允许/etc/passwd中的用户登录:
`local_enable=YES`
3. 匿名用户登录
/etc/vsftpd.conf如下行控制着匿名用户登录:
`anonymous_enable=YES` # 允许匿名用户登录
`no_anon_password=YES` # 匿名用户登录不再需要密码
`anon_max_rate=30000`  # 每个匿名用户最大下载速度(单位:字节每秒)
4. Chroot限制
为了阻止用户离开家目录, 可以设置chroot环境. 在/etc/vsftpd.conf添加如下行实现:
`chroot_list_enable=YES`
`chroot_list_file=/etc/vsftpd.chroot_list`
chroot_list_file 定义了可通过chroot限制的用户列表.
如果要设置更严格的chroot环境, 可以按如下方式设置:
`chroot_local_user=YES`
默认为所有用户启用chroot环境, 此时chroot_list_file 定义了不使用chroot的用户列表.
5. 限制用户登录
在/etc/vsftpd.conf添加如下二行:
`userlist_enable=YES`
`userlist_file=/etc/vsftpd.user_list`
userlist_file 列出了不允许登录的用户.
如果你只想要允许特定的用户登录, 添加这一行:
`userlist_deny=NO`
此时userlist_file 列出的就是允许登录的用户.
6. 限制连接数
可以为本地用户设定数据传输数率, 最大客户端数以及每个IP的连接数目, 在/etc/vsftpd.conf添加如下行:
`local_max_rate=1000000` # 最大数据传输速率(单位:字节每秒)
`max_clients=50`         # 同时在线的最大客户端数目
`max_per_ip=2`           # 每个IP允许的连接数
7. 使用xinetd
如果要启用xinetd引导vsftpd,创建/etc/xinetd.d/vsftpd文件, 并加入如下内容:
service ftp
{
　　　　socket_type = stream
　　　　wait = no
　　　　user  = root,username
　　　　server = /usr/sbin/vsftpd
　　　　log_on_success  += HOST DURATION
　　　　log_on_failure  += HOST
　　　　disable = no
}
并启用/etc/vsftpd.conf中的如下选顶:
`pam_service_name=ftp`
最后, 把xinetd加入/etc/rc.conf守护程序列表, 此时不再需要再添加vsftpd,因为它将由xinetd调用:
如果连接服务器时获得如下错误信息:
500 OOPS: cap_set_proc
你需要在/etc/rc.conf的 MODULES= 一行添加capability
升级到2.1.0版本后, 连接服务器时可能会出现如下错误:
500 OOPS: could not bind listening IPv4 socket
在先前的版本中, 将下述行注释掉就足够了:
\# Use this to use vsftpd in standalone mode, otherwise it runs through (x)inetd
\# listen=YES
但在新版本以及未来的版本中, 必须显示的指定守护程序启动方式:
\# Use this to use vsftpd in standalone mode, otherwise it runs through (x)inetd
listen=NO
