# RHCS集群之搭建
## 一、模拟环境
1. 硬件：两台vbox虚拟机
2. 系统：CentOS Linux6.5_x86_64
3. 所需组件及功能
+ RHCS（Red Hat Cluster Suite）：能够提供高可用性、高可靠性、负载均衡、存储共享且经济廉价的集群工具集合。
+ LUCI：是一个基于web的集群配置方式，通过luci可以轻松的搭建一个功能强大的集群系统。
+ CLVM：Cluster逻辑卷管理，是LVM的扩展，这种扩展允许cluster中的机器使用LVM来管理共享存储。
+ CMAN：分布式集群管理器。
+ GFS（Google File System）：以本地文件系统的形式出现。多个Linux机器通过网络共享存储设备，每一台机器都可以将网络共享磁盘看作是本地磁盘，如果某台机器对某个文件执行了写操作，则后来访问此文件的机器就会读到写以后的结果。
4. 模拟：
做两台web(Apache)服务器的双机热备，共享存储由FNS网络存储实现。
+ 目的：一台服务器宕机，另一台服务器接管并提供web服务，保证服务的不间断提供。
+ 环境（三台主机）：
集群管理主机IP：192.168.5.5　　主机名：manage
集群节点一IP：192.168.5.11　                   　主机名：node1
集群节点二IP：192.168.5.12　　                  主机名：node2

## 二、准备阶段
1. hosts文件解析：保证三台服务器的hosts文件一样。
[root@node1 ~]# echo  '
192.168.5.5 manage
192.168.5.11 node1
192.168.5.12 node2
' >> /etc/hosts
重启网络
`service network restart`
2. 配置/关闭selinux、iptables，这里关闭。
    ```
    sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config  #永久性关闭SELinux
    setenforce 0            #立即关闭SELinux
    service iptables stop       #system V关闭防火墙
    chkconfig iptables off       #system V永久性关闭防火墙
    ```
3. 确保两节点的时间同步
可以搭建ntp服务，也可以通过其他方法，只要确保时间同步即可。
4. 共享存储
5. 各节点之间ssh互信
+ 配置ssh互信的步骤如下：
1> 首先，在要配置互信的机器上，生成各自的经过认证的key文件；
2> 其次，将所有的key文件汇总到一个总的认证文件中；
3> 将这个包含了所有互信机器认证key的认证文件，分发到各个机器中去；
4> 验证互信。
+ 在主机名为node1,node2上以相同的用户创建ssh互信。
1.在每个节点上创建 RSA密钥和公钥
使用test用户登陆
mkdir ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
ssh-keygen -t rsa
2.整合公钥文件
在node1上执行以下命令
ssh node1 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ssh node2 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
3.分发整合后的公钥文件
在node1上执行以下命令
scp ~/.ssh/authorized_keys  node2:~/.ssh/
4.测试ssh互信
在各个节点上运行以下命令，若不需要输入密码就显示系统当前日期，就说明SSH互信已经配置成功了。
ssh node1 date
ssh node2 date
## 三、集群部署
### 1、群集管理主机部署
1. 安装软件
[root@manage ~]#yum install luci -y
2. 安装完成，执行luci初始化操作：
[root@manage ~]#luci_admin init
Initializing the Luci server
Creating the 'admin' user
Enter password:
Confirm password:
Please wait...
The admin password has been successfully set.
Generating SSL certificates...
Luci server has been successfully initialized
输入两次密码后，就创建了一个默认登录luci的用户admin。
3. 启动并开机自启luci服务
[root@manage ~]# /etc/init.d/luci  start
[root@manage ~]# chkconfig luci on
服务成功启动后，就可以通过https://ip:8084访问luci了。
为了能让luci访问集群其它节点，还需要在/etc/hosts增加如下内容（上面已经配置了）：
192.168.5.5 manage
192.168.5.11 node1
192.168.5.12 node2
### 2、集群各节点主机部署
为了保证集群每个节点间可以互相通信，需要将每个节点的主机名信息加入/etc/hosts文件中（上面已配置过）
1. 在两节点分别yum安装 ricci、rgmanager、cman
`yum install ricci rgmanager cman -y`
2. 启动并开机自启各服务
service ricci start
service rgmanager start
service cman start
chkconfig ricci on
chkconfig rgmanager on
chkconfig cman on
+ 启动cman如出现错误：
Starting cman… xmlconfig cannot find /etc/cluster/cluster.conf [FAILED] 是因为节点还没有加入集群，没有产生配置文件/etc/cluster/cluster.conf
3. 在两台节点上给ricci用户设置与root相同的密码
[root@gfs1 /]# passwd ricci
### 3、集群配置
1. 集群web管理界面配置
