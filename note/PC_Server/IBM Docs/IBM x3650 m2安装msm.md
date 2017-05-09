# 安装msm
## 一、部署环境
1. 系统：CentOS6.5
2. 软件包：ibm_utl_msm_15.11.53.00_linux_32-64.bin
3. 参考文档：软件包中的readme.txt
4. 系统版本检测——准备相应的安装光盘
```
uname -a
Linux node1 2.6.32-431.el6.x86_64 #1 SMP Fri Nov 22 03:15:09 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
或者：
cat /proc/version
```
## 二、安装部署
### 1、软件包准备
1. 在LINUX系统中查看使用阵列卡型号
`dmesg |grepRAID`
本例中阵列卡使用的是IBM SERVRAID M5015
2. 在IBM网站下载对应的包
### 2、解压.bin格式的msm软件包
1. 命令
`./ibm_utl_msm_15.11.53.00_linux_32-64.bin -x .
`
2. 报错
错误：-bash: ./ibm_utl_msm_15.11.53.00_linux_32-64.bin: /lib/ld-linux.so.2: bad ELF interpreter: No such file or directory
解决：由于缺少ld-linux.so.2共享库（32bit），安装glibc.i686包
### 3、msm包的依赖处理
1. 参考readme.txt安装msm所需软件包
`yum install -y  compat-libstdc++ libstdc++ libXau libxcb libX11 libXext libXi libXtst`
2. 安装net-snmp
yum install -y net-snmp  net-snmp-utils
3. 安装csh
`yum isntall csh`
### 4、安装msm
1. cd到msm包的路径
2. sh .install.sh
### 5、防火墙配置
在/etc/sysconfig/iptables文件中添加下面内容，打开3071，5571，161端口
-A INPUT -m state --state NEW -m udp -p udp --dport 161  -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3071  -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 5571  -j ACCEPT


