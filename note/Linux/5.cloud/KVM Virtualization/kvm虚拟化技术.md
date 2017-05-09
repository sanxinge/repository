# kvm虚拟化技术
Created 星期日 21 八月 2016

## 一、简介
kVM 是指基于 Linux 内核的虚拟机（Kernel-based Virtual Machine）。 2006 年 10 月，由以色列的Qumranet 组织开发的一种新的“虚拟机”实现方案。 2007 年 2 月发布的 Linux 2.6.20 内核第一次包含了 KVM 。增加 KVM 到 Linux 内核是 Linux 发展的一个重要里程碑，这也是第一个整合到 Linux 主线内核的虚拟化技术。

KVM 在标准的 Linux 内核中增加了虚拟技术，从而我们可以通过优化的内核来使用虚拟技术。在 KVM 模型中，每一个虚拟机都是一个由 Linux 调度程序管理的标准进程，你可以在用户空间启动客户机操作系统。一个普通的 Linux 进程有两种运行模式：内核和用户。 KVM 增加了第三种模式：客户模式（有自己的内核和用户模式）。

## 二、管理
KVM提供了图像界面的管理接口(Virtual Machine Manager)和命令行式的管理接口（virsh）。可以根据使用的场景采用不同的方式，当然也可以使用Libvirt库进行管理虚拟机，并且使用libvirt库进行虚拟机的管理是业界很推崇的做法，这都源于libvirt库良好的移植性和强大的API，并且提供了多种语言接口（如C语言，python语言，JAVA语言，C#语言和PHP语言）能对Xen，KVM以及QEMU等多类虚拟机进行管理管理。
