################################################
#
#author:Dream
#create date:2016-04-09
#desc:DNS for linux
#
################################################
#功能：CentOS6.5 Linux 搭建DNS服务器
#DNS服务器ip：192.168.5.1
#软件：bind、bind-chroot、bind-utils、bind-libs(一般会依赖安装）

################################################
#安装软件包
yum install -y bind bind-utils bind-chroot bind-libs
################################################
#配置DNS主配置文件:/etc/named.conf
cp /etc/named.conf /etc/named.conf.bak
sed -i "s/127.0.0.1;/any;/" /etc/named.conf
sed -i "s/allow-query { localhost; }/allow-query { any; }/" /etc/named.conf

################################################
#配置域的配置文件/etc/named.rfc1912.zones
################################################
#配置正向解析文件
echo "
\$TTL 1D
@       IN SOA  localhost. root.localhost. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
@       IN      NS      localhost.
@       IN      A       127.0.0.1
scan    IN      A       192.168.5.200
" > /var/named/oracle.com.zone  #

################################################
#配置反向解析文件
echo "
\$TTL 1D
@       IN SOA   localhost. root.localhost. (
                                 0       ; serial
                                 1D      ; refresh
                                 1H      ; retry
                                 1W      ; expire
                                 3H )    ; minimum
@       IN      NS      localhost.
@       IN      A       127.0.0.1
200     IN      PTR     scan.oracle.com.
" > /var/named/5.168.192.zone
