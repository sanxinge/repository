#linux下java、Eclipse的安装和配置

——二进制包安装（几乎适合所有linux发行版本）

-------------------
      我是刚接触Linux，这篇博文也是我的第一篇博文，我写的有不足之处望各位指出。
	                           ——我热爱linux、热爱开源、热爱分享、热爱自由。
一、 准备工作
-------
 1. 安装环境：Ubuntu 16.04（其他发行版本基本一样）
 2. 所需软件（下载时选择Linux版tar.gz格式）：
	<1>、Oracle  jdk1.8.0    [下载地址：](http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html)
	<2>、Eclipse  Mars2     [下载地址：](http://www.eclipse.org/downloads/)
## 二、安装过程 ##
1、Oracle jdk的安装:
<1>.打开终端，切换路径到软件所在文件夹
```
cd /media/dream/iOS、软件/软件包/linux  #我下载在移动硬盘
```
<2>解压.tar.gz格式的软件包
```
sudo tar -xzvf jdk-8u74-linux-x64.tar.gz  #其中jdk-8u74-linux-x64.tar.gz为你的软件包名字
```

![这里写图片描述](http://img.blog.csdn.net/20160511193047292)

![这里写图片描述](http://img.blog.csdn.net/20160511193244138)
	<3>.将解压后的文件夹复制到安装路径（我的是/opt）
	
```
 sudo cp -r ./jdk1.8.0_74 /opt
```
![这里写图片描述](http://img.blog.csdn.net/20160511194334382)
	<4>.测试jdk是否安装成功
```
cd ./jdk1.8.0_74/bin #环境变量未配置，切换到bin目录。
java -version  #输出产品版本并退出
```
![这里写图片描述](http://img.blog.csdn.net/20160511195429478)

 2.Eclipse Mars2的安装（和jdk类似，就不上图了）
```
cd /media/dream/iOS、软件/软件包/linux #软件所在路径
sudo -xzvf tar eclipse-jee-mars-2-linux-gtk-x86_64.tar.gz  #解压软件
sudo cp -r ./eclipse /opt  #复制到/opt，其中./代表当前路径
#现在还不能在/opt/eclisp文件夹中打不开Eclipse，因为java环境变量没配置
```

三、 配置
-----

1.java配置
	 <1>. java环境变量在文件/etc/profile中配置
```
sudo vim /etc/profile #我使用vim编辑器，其他编辑器都可以
```
<2>.在proflie文件末尾添加代码
```
export JAVA_HOME=/opt/jdk1.8.0_74 
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```
![这里写图片描述](http://img.blog.csdn.net/20160511203730381)
 <3>.测试
	![这里写图片描述](http://img.blog.csdn.net/20160511203704090)
     现在可以在/opt/eclisp文件夹中打开Eclipse了。
2.使Eclipse在终端打开

```
cd /usr/local/bin #文件符号链接到/usr/local/bin
sudo ln -s /opt/eclipse/eclipse  #/opt/eclipse/eclipse为你Eclipse的路径
```
