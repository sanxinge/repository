---
date: 2016-08-06 11:05
status: public
title: 'CentOS 7升级内核4.4.10——在线升级法（其他发行版借鉴）'
---

# CentOS 7升级内核4.4.10——在线升级法（其他发行版借鉴）
#### 一、准备工作
 升级内核常用方法有两种：一种是内核源码编译升级，一种是在线升级。这里介绍在线升级。
1. 查看当前正在使用的内核：`uname -a`（可略）
2. 查看所有内核：`rpm -qa | grep kernel`（可略）
3. 在线升级法需要使用 elrepo 的yum 源（也适合Rad h7）
 elrepo的yum源地址：http://elrepo.org/tiki/tiki-index.php   #(可以找到其他版本的yum源)

#### 二、安装及测试（root登陆或sudo命令）
1. 导入公钥：`rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org`
2. 安装elrepo的yum源:`rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm`
3. 安装内核:`sudo yum --enablerepo=elrepo-kernel install  kernel-ml-devel kernel-lt` 
4. 安装后用`rpm -qa | grep kernel`检测是否安装成功，成功后在/boot文件夹下有新内核启动文件

#### 三、更改启动时内核加载顺序
1. 查看默认启动顺序：
`cat /boot/grub/grub.conf`

2. 修改默认启动：
编辑grub.conf文件
`vim /boot/grub/grub.conf`

![选区_012.png](/home/user-dream/文档/博客/截图/选区_012.png)

要默认启动第几个内核，将default的值改成几。若grub.conf文件中没有新内核启动配置，请自行仿照原来内核启动配置文件进行添加。

#### 四、删除多余内核
方法如下：

1. 首先列出系统中正在使用的内核:
`uname -a`

![选区_009.png](/home/user-dream/文档/博客/截图/选区_009.png)

2. 查询系统中全部的内核
`rpm -qa | grep kernel`

![选区_010.png](/home/user-dream/文档/博客/截图/选区_010.png)

3. 将你想删除的内核删除掉，本例中,我要删掉kernel-3.10.0-229.1.2.el7.x86_64的内核,就需要把所有含有kernel-3.10.0-229.1.2.el7.x86_64字样的全部删掉。
`yum remove kernel-3.10.0-229.1.2.el7.x86_64`

4. 删除完毕后，重启电脑
`reboot`