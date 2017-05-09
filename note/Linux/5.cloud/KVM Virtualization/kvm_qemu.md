# QEMU/KVM
-----  
## 一、KVM
----

## 二、QEMU安装
---
### 1、包管理器安装
根据发行版本相应的包管理器进行安装，这里不做详细介绍。
### ２、编译安装
1. 源码下载
git：`git clone git://git.qemu.org/qemu.git`，当然也可以去网站下载。   
2. 进入qemu源码包文件夹并执行./configure检测你的安装平台的目标特征并生成Makefile文件
`[test@node1 tmp]$ cd qemu`
`[test@node1 qemu]$ ./configure` 可以加参数进行优化定制
	+ `--prefix = PREFIX` 指定安装路径，默认在`/usr/local`
	+ `--target-list = LIST`设置目标列表（默认：构建所有内容），可以只选择 x86_64的，编译速度快
	+ 其他的参数请执行`./configure -h`查看
	+ 编译过程中提示缺什么依赖库文件或软件包就按相应的软件包
3. 执行make从Makefile中读取指令进行编译
`[test@node1 qemu]$ make`
4. 用root权限的用户执行make install进行安装
`[test@node1 qemu]$ sudo make install`
5. 报错处理
+ ./confingure时dtc报错
	``` bash
	dream@Dreamer:/tmp/qemu$ ./configure 

	ERROR: DTC (libfdt) version >= 1.4.2 not present. Your options:
			 (1) Preferred: Install the DTC (libfdt) devel package
			 (2) Fetch the DTC submodule, using:
				 git submodule update --init dtc
	```
	解决方法
	+ clone源码到/tmp`git clone https://github.com/dgibson/dtc.git`
	+ 复制dtc源码到qemu源码文件夹下的dtc文件夹：`cp -r /tmp/dtc/* /tmp/qemu/dtc/`
	+ 当然也可以直接安装相应的包，但可能版本太低。
+  正常编译后运行时出现 “VNC server running on '127.0.0.1:5900'”问题
	+ 原因：这是缺少SDL （Simple DirectMedia Layer），它是一个跨平台的多媒体库，因此在make之前一定要先安装该库，不然又要重新make
	+ 解决方法：make安装该软件包
	` sudo apt-get install libsdl1.2-dev`