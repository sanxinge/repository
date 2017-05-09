# NTP服务
## 一、NTP简介
NTP是网络时间协议（Network Time Protocol），作用是同步网络中各个计算机节点的时间，可以使计算机连接到世界协调时UTC或其他服务器进行时间的同步。由于在计算机的世界里，时间的统一性和准确性是非常重要的，所以NTP服务也是常见的服务之一。
## 二、原理
NTP原理：使一台或多台服务器（Client端）与时间服务器（Server端）进行时间同步，以保证时间的统一性。
## 三、搭建
1. 安装软件包
+ 验证是否安装NTP软件包
  `[root@node1 ～]# rpm -qa|grep ntp`
  `fontpackages-filesystem-1.44-8.el7.noarch`
+ 安装
  `[root@node1 ～]# yum install ntp`
2.
## 配置
### 1、主配置

### 2、安全配置
