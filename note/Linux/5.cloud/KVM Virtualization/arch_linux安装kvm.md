
#  arch linux安装kvm
Created 星期日 21 八月 2016

	此案例以Arch Linux进行操作，其他Linux发行版本借鉴，注意大多旧点的版本系统没有采用systemd来管理系统，而是init、chkconfig、service等进行管理。我知道的红帽系从7版本开始采用systemd，其他的就不确定了。而这只是操作方法的不同而已(当然底层实现也不一样)，目的和结果是一致的。
## 一、检测电脑是否支持kvm  
1. 硬件支持
	kvm需要宿主机cpu支持虚拟化（inter cpu的VT-x技术、AMD cpu的AMD-v技术），检测命令：
	`$ grep -E "(vmx|svm)" --color=always /proc/cpuinfo`
		如果flags: 里有vmx 或者svm就说明支持VT；如果没有任何的输出，说明你的cpu不支持，将无法成功安装KVM虚拟机（系统中有xen时也会导致没有输出）。
		注意：要确保BIOS里开启interVT-x或AMD-v。  
2. 内核（kernel）支持  
Arch Linux的内核提供了相应的KVM和VirtIO内核模块
+ KVM模块
	`$ zgrep KVM /proc/config.gz`
	若模块设定返回的不是y或m，则该模块不可用。
+ VirtIO 模块
准/半虚拟化是在全虚拟化的基础上，把客户操作系统进行了修改，增加了一个专门的API，这个API可以将客户操作系统发出的指令进行最优化。 KVM提供Virtio作为hypervisor和来宾之间的一层API。所有的Virtio有两部分组成：主机设备和客户驱动程序。
	`$ zgrep VIRTIO /proc/config.gz`
	若模块设定返回的不是y或m，则该模块不可用。
+ 查看内核模块是否装载
	`$ lsmod | grep kvm`
	`$ lsmod | grep virtio`
	若不返回任何信息，则说明该内核模块没有装载，请进行“内核模块的加载与卸载”这一步，若有信息返回，则忽略这一步。

## 二、内核模块的加载与卸载
	内核模块（kernel modules）是可以按需加载或卸载的内核代码，可以不重启系统就扩充内核的功能。此步骤视情况进行选择。
1. 信息查询
	显示当前装入的模块：`$ lsmod`
	显示模块信息：`$ modinfo module_name`
	显示所有模块配置信息：`$ modprobe -c | less`
	显示某个模块配置信息：`$ modprobe -c |grep module_name`

2. 手动加/卸载
	控制内核模块载入/移除的命令是kmod 软件包提供:
	加载：`# modprobe  module_name`
	移除：`# modprobe  -r  / rmmod  module_name`

3. 开机加载
	systemd 读取 /etc/modules-load.d/ 中的配置加载额外的内核模块。配置文件名称通常为 /etc/modules-load.d/ <-program-> .conf。格式很简单，一行一个要读取的模块名，而空行以及第一个非空格字符为#或;的行会被忽略，如：

		/etc/modules-load.d/virtio-net.conf
		# Load virtio-net.ko at boot
		virtio-net
4. 我的virtio模块加载配置

		[xxx@xxx ~]$ cat /etc/modules-load.d/virtio-net.conf
		# Load virtio-net.ko at boot
		virtio-net		#网络设备
		virtio-blk		#块设备
		virtio-scsi		#控制器设备
		virtio-serial		#串行设备

## 三、安装qemu和libvirt
1. 安装qemu

		Qemu是一个广泛使用的开源计算机仿真器和虚拟机，当作为仿真器时，可以在一种架构(如PC机)下运行另一种架构(如ARM)下的操作系统和程序。通过动态转化，可以获得很高的运行效率。当 QEME 作为虚拟机时，可以使用 xen 或 kvm 访问 CPU 的扩展功能(HVM)，在主机 CPU 上直接执行虚拟客户端的代码，获得接近于真机的性能表现。
		`$ sudo pacman -S qemu`
	其他可选包：
	qemu-arch-extra - 其它架构支持
	qemu-block-gluster - glusterfs block 支持
	qemu-block-iscsi - iSCSI block 支持
	qemu-block-rbd - RBD block 支持
	samba - SMB/CIFS 服务器支持
2. 安装libvirt

		libvirt是Linux上实现虚拟化功能的库，是长期稳定的C语言API，支持KVM/QEMU、Xen、LXC等主流虚拟化方案。
	`$ sudo pacman -S libvirt virt-manager	#virt-manager为图形前端，可选`
	为了网络连接，安装这些包：
	+ ebtables 和 dnsmasq 用于默认的 NAT/DHCP网络
	+ bridge-utils 用于桥接网络
	+ openbsd-netcat 通过 SSH 远程管理

## 四、配置
1. 启动/开机自起守护进程

		systemctl start libvirtd	#启动libvirtd进程
		systemctl enable libvirtd	#开机自起
2. 添加用户到kvm用户组
`usermod -a -G kvm user_name`
-a 代表 append， 将自己添加到新用户组且不离开原来用户组


## 五、安装UEFI功能（可选）
1. 首先我们安装用于虚拟机上的UEFI固件：
`$ sudo pacman -S ovmf`
2. 配置 libvirtd以启用UEFI,libvirt需要知道UEFI—>NVRAM中的配置文件映射
`#vim  /etc/libvirt/qemu.conf`
找到nvram = []去掉注释，默认的配置文件中NVRAM配置的是ovmf_code.fd和ovmf_vars.fd两文件的路径，而且网上教程大多也这样说的；但在我的arch linux中的OVMF 18419-1版本中没有这两文件，整了半天在发现人家变成ovmf_x64.bin和ovmf_ia32.bin两文件，不知其他版本的有没有这回事？？?

+ 我的NVRAM配置如下：

		nvram = [
		"/usr/share/ovmf/ovmf_x64.bin:/usr/share/ovmf/ovmf_ia32.bin"
		]

现在可以通过virt-manager或命令安装虚拟系统了，具体操作我会在后期写相关的文章。
