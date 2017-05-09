# Net File System——NFS
##网络文件系统
NFS是一种基于TCP/IP的文件系统，可以视为一个RPC（远程过程调用） Server


## Linux下搭建NFS
1. 环境及需求：
+ 软件：rpcbind（RPC主程序）、nfs-utils（服务主程序）、 nfs-utils-lib（库）、nfs4-acl-tools
+ 需启动的服务：rpcbind、nfs。
+ NFS IP：192.168.5.10
+ 关闭防火墙及SELinux或开启相应的端口
2. 安装

3. 启动服务
+ RCP服务
service rpcbind start或 /etc/rc.d/init.d/rpcbind start   ——sysV
systemctl start rpcbind             ——systemd
netstat -antlp|grep rpcbind     ——查看rpcbind服务端口
rpcinfo -p localhost        ——查看此时rpc服务上面是否有端口注册
+ FNS服务

4. 配置
vim /etc/exports
