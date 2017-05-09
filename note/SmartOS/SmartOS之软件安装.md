# SmartOS之软件安装
-------
## 一、SmartOS上使用pkgsrc来安装软件
### 1、pkgsrc简介
> pkgsrc 是一个基于源码的软件包管理系统，使用的是 BSD 许可证。pkgsrc 实际上分发的是软件包的 patch，不会与许多软件的授权许可冲突，避免了二进制软件包和直接分发源码包形式下的种种限制。因此，用户可以广泛地使用大量的优秀软件。 

## 二、SmartOS上使用pkgin来安装软件   
### 1、pkgin简介
> pkgin, a binary package manager for pkgsrc（pkgin，pkgsrc的二进制包管理器）。所有依赖pkgsrc的OS都有pkg_add和pkg_delete等工具，但是这些工具无法正确处理二进制升级，有时甚至无法安装binary package。这是pkgin出现的原因，为用户提供一种方便的方式来处理二进制包，使用与apt-get/yum等工具相同的工作机制。
### 2、安装pkgin  
1. 下载pkgin安装包，这里是64位的
`[root@www tmp]# wget http://pkgsrc.joyent.com/packages/SmartOS/bootstrap/bootstrap-2016Q4-x86_64.tar.gz`    
+ 注：可以在`http://pkgsrc.joyent.com/packages/SmartOS/bootstrap/`网站选择不同的版本，这个是目前最新的。 
2. 解包至`/`目录
+ 命令：
`[root@www tmp]# tar xzf bootstrap-2016Q4-x86_64.tar.gz -C / `  
+ 解包至/的原因：
这是一个二进制软件包，解压即用。下面是这个包的3级目录结构，可以看出解压到/可以自动的与系统原有的/opt目录和/var目录合并，这样只需将`/opt/local/sbin`和`opt/local/bin`配置到path即可。
	```
	[dream@Dream ~]$ tree -L 3 pkgin/
	pkgin/
	├── opt
	│   └── local
	│       ├── bin
	│       ├── etc
	│       ├── gcc49
	│       ├── include
	│       ├── info
	│       ├── lib
	│       ├── libdata
	│       ├── libexec
	│       ├── man
	│       ├── pkg
	│       ├── pkg.refcount
	│       ├── sbin
	│       └── share
	└── var
		└── db
			└── pkgin
	```   
3. 配置   
	```
	[root@www /opt]# echo 'PATH=/opt/local/sbin:/opt/local/bin:$PATH
	> MANPATH=/opt/local/man:$MANPATH' >> /etc/profile
	```  
4. 更新最新版本的pkgin数据库  
`[root@www ~]# pkgin -y update`  
### 3、安装软件，这里以gcc为例  
1. 查询gcc软件包  
	```
	[root@www ~]# pkgin se gcc
	mingw-w32api-bin-3.11nb1  GCC libraries for win32 cross-development
	mingw-runtime-bin-3.14nb1  GCC runtime libraries for win32 cross-development
	lcov-1.9nb5          Front-end for GCC's coverage testing tool gcov
	isl-0.17.1           Integer set library required by gcc graphite
	gccmakedep-1.0.3     Create dependencies in Makefiles using gcc
	gcc6-aux-20160822    GNAT Ada compiler based on GCC 6
	gcc5-libs-5.4.0nb3   The GNU Compiler Collection (GCC) support shared libraries
	gcc5-aux-20160603nb4  GNAT Ada compiler based on GCC 5
	gcc5-5.4.0nb2        The GNU Compiler Collection (GCC) - 5 Release Series
	gcc49-libs-4.9.4nb1 = The GNU Compiler Collection (GCC) support shared libraries
	gcc49-4.9.4          The GNU Compiler Collection (GCC) - 4.9 Release Series
	gcc-mips-4.9.2nb2    The GNU Compiler Collection (GCC) - 4.9 for mips (especially playstation2)
	gcc-aux-20141023nb1  GNAT Ada compiler based on GCC 4.9
	cross-arm-none-eabi-gcc-6.2.0  GCC for bare metal ARM EABI
	cloog-0.18.4         Code generator for loop optimization (used by gcc)
	```  
2. 安装`gcc6-aux-20160822`包，安装过程自动解决依赖问题。  
`[root@www ~]# pkgin install gcc6-aux-20160822`  


**注意：pkgin和pkgsrc不仅仅适合Smart OS，也适合许多BSD和Linux**