#  libvirt
Created 星期日 21 八月 2016

## 一、简介
1. libvirt
libvirt是基于守护进程/客户端的架构的一组软件的汇集，提供了管理虚拟机和其它虚拟化功能（如：存储和网络接口等）的便利途径。这些软件包括：一个长期稳定的 C 语言 API、一个守护进程（libvirtd）和一个命令行工具（virsh）。Libvirt 的主要目标是提供一个单一途径以管理多种不同虚拟化方案以及虚拟化主机，包括：KVM/QEMU，Xen，LXC，OpenVZ 或 VirtualBox hypervisors 等主流虚拟化方案。
2. 主要功能
+ VM management（虚拟机管理）：各种虚拟机生命周期的操作，如：启动、停止、暂停、保存、恢复和迁移等；多种不同类型设备的热插拔操作，包括磁盘、网络接口、内存、CPU等。
+ Remote machine support（支持远程连接）：Libvirt 的所有功能都可以在运行着 libvirt 守护进程的机器上执行，包括远程机器。通过最简便且无需额外配置的 SSH 协议，远程连接可支持多种网络连接方式。
+ Storage management（存储管理）：任何运行 libvirt 守护进程的主机都可以用于管理多种类型的存储：创建多种类型的文件镜像（qcow2，vmdk，raw，...），挂载 NFS 共享，枚举现有 LVM 卷组，创建新的 LVM 卷组和逻辑卷，对裸磁盘设备分区，挂载 iSCSI 共享，以及更多......
+ Network interface management（网络接口管理）：任何运行 libvirt 守护进程的主机都可以用于管理物理的和逻辑的网络接口，枚举现有接口，配置（和创建）接口、桥接、VLAN、端口绑定。
+ Virtual NAT and Route based networking（虚拟 NAT 和基于路由的网络）：任何运行 libvirt 守护进程的主机都可以管理和创建虚拟网络。Libvirt 虚拟网络使用防火墙规则实现一个路由器，为虚拟机提供到主机网络的透明访问。
3. openstack, kvm, qemu-kvm以及libvirt之关系
	>KVM是最底层的hypervisor，它是用来模拟CPU的运行，它缺少了对network和周边I/O的支持，所以我们是没法直接用它的。QEMU-KVM就是一个完整的模拟器，它是建基于KVM上面的，它提供了完整的网络和I/O支持. Openstack不会直接控制qemu-kvm，它会用一个叫libvit的库去间接控制qemu-lvm， libvirt提供了夸VM平台的功能，它可以控制除了QEMU的模拟器，包括vmware, virtualbox xen等等。所以为了openstack的夸VM性，所以openstack只会用libvirt而不直接用qemu-kvm。libvirt还提供了一些高级的功能，例如pool/vol管理。

## 二、工具
1. 服务端工具
	eatables和dnsmasq：默认的NAT/DHCP网络
	bridge-utils：用于桥接网络
	openbsd-netcat：通过SSH远程管理

2. 网络


## 三、管理及配置
### 1、管理工具
virt-install、virt-manager、

一.虚拟机常用命令
[root@www ~]# virsh list                            //查看已打开虚拟机列表
[root@www ~]# virsh list --all                    //查看所有虚拟机列表
[root@www ~]# virsh version                      //查看virsh版本号
[root@www ~]# virsh start node1              //启动node1虚拟机
[root@www ~]# virsh shutdown node1          //关机node1虚拟机
[root@www ~]# virsh destroy node1          //强制关机node1虚拟机
[root@www ~]# virsh dumpxml node1 > node1.xml  //导出node1虚拟机配置文件
[root@www ~]# virsh undefine node1          //取消node1定义
[root@www ~]# virsh define node1.xml      //重新定义node1
[root@www ~]# virsh autostart node1              //设置开机自启动node1
[root@www ~]# virt-clone -o node1 -n node1-clone -f  /data/images/node1-clone.img //克隆虚拟机

使用命令安装新的虚拟机：可根据需要调整选项

virt-install \
--name node1 \
--noautoconsole \
--ram 512 \
--arch=x86_64 \
--vcpus=1 \
--os-type=linux \
--os-variant=rhel6 \
--hvm \
--accelerate \
--disk path=/data/images/node1.img \
--network bridge=br0 \
--location nfs:192.168.100.1:/var/ftp/pub/iso/RedHat/6.4 \
--extra-args="ks=http://192.168.100.1/rhel-ks.cfg  ip=192.168.100.10 netmask=255.255.255.0 gateway=192.168.100.254  dns=192.168.100.2 noipv6"

二.使用LVM方式管理虚拟主机磁盘
1.创建LV
[root@www ~]# fdisk -l | grep /dev/sda6                  //创建分区
/dev/sda6            6170      39163  265015296  8e  Linux LVM
PV  --> VG --> LV
[root@www ~]# pvcreate /dev/sda6                        //创建PV
[root@www ~]# vgcreate vg_data /dev/sda6                //创建VG
[root@www ~]# lvcreate -L 10G -n lv_kvm_node1 vg_data      //创建LV

2.使用创建的LV安装Guest
[root@www ~]# virt-install \
--name kvm_node1 \
--noautoconsole \
--ram 1024 \
--arch=x86_64 \
--vcpus=1 \
--os-type=linux \
--os-variant=rhel6 \
--hvm \
--accelerate \
--disk path=/dev/vg_data/lv_kvm_node1 \              //安装在刚创建的LV中
--network bridge=br0 \
--location nfs:192.168.100.1:/var/ftp/pub/iso/RedHat/6.4 \
--extra-args="ks=http://192.168.100.1/rhel-ks.cfg  ip=192.168.100.10 netmask=255.255.255.0 gateway=192.168.100.254  dns=192.168.100.2 noipv6"
3.设置模板虚拟机，去掉一些个性信息（在刚装好的虚拟机kvm_node1上操作）
[root@www ~]# touch  /.unconfigured
4.对已安装好lv_kvm_node1的生成快照(快照大小只要为被快照的逻辑卷的15~20%就可以了)
[root@www ~]# lvcreate -s -n kvm_snap1 -L 2G  /dev/vg_data/lv_kvm_node1
5.将快照定义到virt-manager
[root@www ~]# vim /etc/libvirt/qemu/kvm_node1.xml        //默认配置文件位置
[root@www ~]# virsh dumpxml kvm_node1 >  /root/kvm_snap1.xml  //也可导出配置文件




## 四、使kvm/qemu支持UEFI启动
1. 首先我们安装用于虚拟机上的UEFI固件：
	安装ovmf包
 `# yum install ovmf		//红帽系
  #apt-get install 		//
 `
2. 配置 libvirtd以启用UEFI,libvirt需要知道UEFI—>NVRAM中的配置文件映射
`#vim  /etc/libvirt/qemu.conf`
找到nvram = []去掉注释，默认的配置文件中NVRAM配置的是ovmf_code.fd和ovmf_vars.fd两文件的路径，而且网上教程大多也这样说的；但在我的arch linux中的OVMF 18419-1版本中没有这两文件，整了半天在发现人家变成ovmf_x64.bin和ovmf_ia32.bin两文件，不知其他版本的有没有这回事？？?

		我的NVRAM配置如下：
			nvram = [
				"/usr/share/ovmf/ovmf_x64.bin:/usr/share/ovmf/ovmf_ia32.bin"
			]
