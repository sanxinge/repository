#! /bin/bash
#
#author:Dream
#create date:2016-09-09
#desc:Oracle 11gR2 Grid and Database for CentOS linux6.5
#
#################################################
#backup
function back()
{
   mkdir /root/backup
   cp /etc/selinux/config /root/backup/selinux.conf
   cp /etc/sysctl.conf /root/backup
   cp /etc/security/limits.conf /root/backup
   cp /etc/pam.d/login /root/backup
}
#restort
function restore()
{
   read -p "[Grid or Database ORACLE_BASE PATH]:" base_path
   service iptables start
   chkconfig iptables on
   userdel -r oracle
   userdel -r grid
   groupdel oinstall
   groupdel dba
   groupdel asmdba
   groupdel asmoper
   groupdel asmadmin
   groupdel oper
   cp /root/backup/selinux.conf /etc/selinux/config
   cp /root/backup/sysctl.conf  /etc/sysctl.conf
   cp /root/backup/limits.conf  /etc/security/limits.conf
   cp /root/backup/login  /etc/pam.d/login
   cp /root/backup/CentOS-Media.repo  /etc/yum.repos.d/CentOS-Media.repo
   rm -rf $base_path
   rm -rf /root/backup
#验证
   echo '+++++++++++limits.conf++++++++++++++++'
   cat /etc/security/limits.conf
   echo '++++++++++++sysctl -p+++++++++++++++++'
   /sbin/sysctl -p
   echo '++++++++++++++++grid++++++++++++++++++'
   cat /home/grid/.bash_profile
   echo '+++++++++++++++oracle+++++++++++++++++'
   cat /home/oracle/.bash_profile
   echo '++++++++++++++++++++++++++++++++++++++'
   find $base_path
   echo '++++++++++++++login+++++++++++++++++++'
   cat /etc/pam.d/login
   exit 10
}
#
if test "`whoami`" == "root";then
#环境部署
. ./configure.sh 
#yum配置
. ./yum.sh
# configuring X window zhuanfa
  yum install -y xauth xorg-x11-utils vim
  yum install -y openssh-server* openssh-cl*
  /etc/rc.d/init.d/sshd restart
  #systemctl sshd restart
# 安装依赖软件
echo "<++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++>"
. ./paclages.sh
# ASM搭建
  while [ "$choose1" != "y" -a "$choose1" != "n" ];do
    read -p "Whether or not tobuild ASM [y/n]:" choose1
  done
  if test "$choose1" == "y";then
      . ./asm.sh
    else
      echo '------Thanks---------'
  fi
#
#验证
  echo '+++++++++++1.limits.conf++++++++++++++++'
  cat /etc/security/limits.conf
  echo '++++++++++++2.sysctl -p+++++++++++++++++'
  /sbin/sysctl -p
  echo '++++++++++++++++3.grid++++++++++++++++++'
  cat /home/grid/.bash_profile
  echo '+++++++++++++++4.oracle+++++++++++++++++'
  cat /home/oracle/.bash_profile
  echo '+++++++++++++++5.+++++++++++++++++++++++'
  find $base_path
  echo '++++++++++++++6.login+++++++++++++++++++'
  cat /etc/pam.d/login
  echo '++++++++++7.iptables/SELinux++++++++++++'
  #chkconfig iptables --list
  systemctl status firewall
  #/etc/rc.d/init.d/iptables status
  getsebool
#
  else
  	echo 'User not root.'
fi

