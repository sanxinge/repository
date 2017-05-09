# DNS服务
## 一、DNS简介
### 1、DNS服务简介
1. DNS作用
主要用于ip与域名的解析
2. DNS的前身—/ect/hosts
hosts文件现在还存在，主要作用是在本地进行域名与ip的解析，hosts中存有的ip将免去访问DNS的步骤，以提高访问速度，而DNS的作用和hosts文件是一样的，但功能增强了不是一星半点。
3. BIND出现
随着互联网的高速发展，hosts文件不能满足需求，于是就出现了DNS服务器进行解析。
4. 域名与IP解析的默认顺序
先通过/etc/hosts文件解析------->没有解析信息时，再到DNS服务器进行域名解析

### ２、DNS原理

## 主DNS服务搭建
1. 部署需求：
+ 系统：Linux（本例CentOS 7）
+ 软件：
bind：提供了域名服务的主要程序及相关文件
bind-utils：提供对DNS服务器的测试工具，如：nslookup、dig
bind-libs：
bind-chroot：提供一个伪装的根目录以增强安全性
2. 安装软件
`$ sudo yum install bind bind-utils bind-libs bind-chroot`
2. 配置主配置文件
[root@www ~]# vim /etc/named.conf
options {
　　　　listen-on port 53 { 127.0.0.1; };   #默认53号端口监听的ip为本地循环ip：127.0.0.1，改为any（任何ip）
　　　　listen-on-v6 port 53 { ::1; };  #ipv6的端口监听
　　　　directory       "/var/named";   #配置文件存放目录
　　　　dump-file       "/var/named/data/cache_dump.db";
　　　    statistics-file "/var/named/data/named_stats.txt";
　　　    memstatistics-file "/var/named/data/named_mem_stats.txt";
　　　    allow-query     { localhost; };localhost改为any；
　 　　   recursion yes;
　　　    ......
　   　　 dnssec-enable yes;
　  　　  dnssec-validation yes;
　  　　  /* Path to ISC DLV key */
　  　　  bindkeys-file "/etc/named.iscdlv.key";
　 　　   managed-keys-directory "/var/named/dynamic";
　　　　pid-file "/run/named/named.pid";
　   　　 session-keyfile "/run/named/session.key";
};
4. 域文件配置
在/etc/named.rfc1912.zones文件加入
zone "dream.org." IN {
　　　　type master;
　　　　file "dream.org.zone";
　　　　#allow-update { none; }
};
zone "5.168.192.in-addr.arpa" IN {
　　　　type master;
　　　　file "5.168.192.zone";
　　　　#allow-update { none; };
};
5. 正向解析文件
[root@www ~]# vim /var/named/dream.org.zone
$TTL 1D
@       IN SOA  localhost. root.localhost. (
　　　　　　　　　　　　　　　0       ; serial
　　　　　　　　　　　　　　　1D      ; refresh
　　　　　　　　　　　　　　　1H      ; retry
　　　　　　　　　　　　　　　1W      ; expire
　　　　　　　　　　　　　　　3H )    ; minimum
@     IN      NS      localhost.
@     IN      A       127.0.0.1
scan    IN      A       192.168.5.200

6. 反向解析文件
[root@www ~]# vim /var/named/5.168.192.zone
$TTL 1D
@       IN SOA   localhost. root.localhost. (
　　　　　　　　　　　　　　　0       ; serial
　　　　　　　　　　　　　　　1D      ; refresh
　　　　　　　　　　　　　　　1H      ; retry
　　　　　　　　　　　　　　　1W      ; expire
　　　　　　　　　　　　　　　3H )    ; minimum
@       IN      NS      localhost.
@       IN      A       127.0.0.1
200     IN      PTR     scan.oracle.com.
