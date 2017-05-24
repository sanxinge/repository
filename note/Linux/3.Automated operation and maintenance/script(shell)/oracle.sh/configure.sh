#! /bin/bash
#
#author:Dream
#create date:2016-09-09
#desc:Oracle 11gR2 Grid and Database for linux
#
#################################################
#database安装前配置
function configure_database()
{
# Create Groups and Users
  groupadd -g 5000 oinstall
  groupadd -g 5001 dba
  groupadd -g 5002 oper
  useradd -m -u 1000 -g oinstall -G dba,oper oracle
  passwd oracle
# Create directory
  mkdir -p "$base_path"/oracle
  chown oracle:oinstall "$base_path"
  chmod -R 775 "$base_path"
#
# Users PATH configuring
echo "
export TMP=/tmp
export TMPDIR=\$TMP
export ORACLE_BASE=$base_path/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/dbhome_1
export PATH=\$PATH:\$ORACLE_HOME/bin
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/lib64:/usr/lib:/usr/lib64
export NLS_DATE_FORMAT=\"YYYY-MM-DD HH24:MI:SS\"" >> /home/oracle/.bash_profile
#
# modifing system resources
echo '
oracle soft nproc 2047 
oracle hard nproc 16384 
oracle soft nofile 1024 
oracle hard nofile 65536 
oracle soft stack 10240 ' >> /etc/security/limits.conf
}
#
# grid安装配置
function configuer_grid()
{
  groupadd -g 5000 oinstall
  groupadd -g 5001 dba
  groupadd -g 5002 oper
  groupadd -g 5003 asmdba
  groupadd -g 5004 asmoper
  groupadd -g 5005 asmadmin
  useradd -m -u 1001 -g oinstall -G dba,asmdba,asmoper,asmadmin,oper grid
  passwd grid
# Create directory
  mkdir -p "$base_path"/grid
  chown -R grid:oinstall "$base_path"
  chown -R oracle:oinstall "$base_path"/oracle
  chmod -R 775 "$base_path"
#
# Users PATH configuring
echo "
export TMP=/tmp
export TMPDIR=\$TMP
export ORACLE_BASE=$base_path/grid
export ORACLE_HOME=$base_path/product/11.2.0/grid
export PATH=\$PATH:\$ORACLE_HOME/bin:/usr/sbin:/usr/bin
export ORACLE_SID=+ASM1  #第二节点需改为+ASM2
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/lib64:/usr/lib:/usr/lib64
export NLS_DATE_FORMAT=\"YYYY-MM-DD 24HH:MI:SS\"" >> /home/grid/.bash_profile
source /home/grid/.bash_profile
#
# modifing system resources
echo '
grid soft nproc 2047 
grid hard nproc 16384 
grid soft nofile 1024 
grid hard nofile 65536 
grid soft stack 10240' >> /etc/security/limits.conf
#
# Configuring Network
echo '127.0.0.1       localhost.localdomain   localhost
::1             localhost.localdomain   localhost
#Pubilc IP
192.168.5.31   node1.oracle.com node1
192.168.5.32   node2.oracle.com node2
#Private IP
10.10.100.11   node1-priv.oracle.com node2-priv
10.10.100.12   node2-priv.oracle.com node2-priv
#Virtual IP
192.168.5.21   node-vip1.oracle.com node1-vip1
192.168.5.22   node-vip2.oracle.com node2-vip2
#SCAN IP
192.168.5.200  scan.oracle.com scam' > /etc/hosts
}
#
# Configuring Kernel parameters for CentOS6.5 Linux
#
function system_par()
{
sed -i "s/kernel.shmmax/#kernel.shmmax/" /etc/sysctl.conf  #注釋kernel.shmmax參數
sed -i "s/kernel.shmall/#kernel.shmall/" /etc/sysctl.conf  #注釋kernel.shmall參數
echo "
fs.aio-max-nr = 1048576 
fs.file-max = 6815744 
kernel.shmall = 2097152 
kernel.shmmax = 1073741824 
kernel.shmmni = 4096 
kernel.sem = 250 32000 100 128 
net.core.rmem_default = 262144 
net.core.rmem_max = 4194304 
net.core.wmem_default = 262144 
net.core.wmem_max = 1048586 
net.ipv4.ip_local_port_range = 1024 65000" >> /etc/sysctl.conf
#
modprobe bridge
lsmod |grep bridge
sysctl -p
#
echo 'session    required     pam_limits.so' >> /etc/pam.d/login
}
#
#本脚本的开始执行的入口
while [ "$string" != 1 -a "$string" != 2 -a "$string" != 3 -a "$string" != "q" -a "$string" != "r" ];do
    read -p "[1.Database 2.Grid 3.Grid and Database q.Quit  r.Restore]:" string
done
  test "$string" == "q" && exit 2;
  test "$string" == "r" && restore;
  back		#自定义的备份函数
# Selinux and iptables
  sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config  #永久性关闭SELinux
  setenforce 0 			 #立即关闭SELinux
  #service iptables stop 		 #system V关闭防火墙
  systemctl stop firewall	 #systemd关闭防火墙
  #chkconfig iptables off 		 #system V永久性关闭防火墙
  systemctl disable firewall 	 #systemd永久性关闭防火墙
  system_par
#输入软件安装基路径，比如：/opt/app
  read -p "[Grid or Database ORACLE_BASE PATH]:" base_path
case "$string" in
	1)
	    configure_database
	     ;;
	2)
	    configuer_grid
	     ;;
	3)
	    configure_database
	    configuer_grid
	     ;;
esac
