---
date: 2016-06-14 13:44
status: public
title: 1、BIOS知识普及
---

##一、BIOS
* BIOS是装载在`主板BIOS ROM芯片`的一个基本输入输出系统（一组程序）。
* BIOS是对硬件最底层的设置与控制。
* BIOS只有在开机时才可以进行设置。
* BIOS芯片中主要存放程序
    + 自检程序
    + 系统设置程序
    + POST上电自检
    + 主要I/O设备的驱动程序和中断服务
* 当今，BIOS系统已成为一些病毒木马的目标。一旦此系统被破坏，其后果不堪设想。
* 引用百科：
 >BIOS是英文"Basic Input Output System"的缩略词，直译过来后中文名称就是"基本输入输出系统"。其实，它是一组固化到计算机内主板上一个ROM芯片上的程序，它保存着计算机最重要的基本输入输出的程序、开机后自检程序和系统自启动程序，它可从CMOS中读写系统设置的具体信息。 其主要功能是为计算机提供最底层的、最直接的硬件设置和控制。
 
------
##二、CMOS
1. CMOS(在计算机领域)是微机主板上的一块可读写的RAM芯片，主要用来保存BIOS的硬件配置和用户对某些参数的设定。CMOSRAM芯片由系统通过一块后备电池供电，因此无论是在关机状态中，还是遇到系统掉电情况，CMOS信息都不会丢失（CMOS电池没电情况除外哦）。
2. 由于CMOSRAM芯片本身只是一块存储器，只具有保存数据的功能（主要保存着系统基本情况、CPU特性、软硬盘驱动器、显示器、键盘等部件的信息），所以对CMOS中各项参数的设定要通过专门的程序。早期的CMOS设置程序驻留在软盘上的(如IBM的PC/AT机型)，使用很不方便。现在多数厂家将CMOS设置程序做到了BIOS芯片中，在开机时通过按下某个特定键就可进入CMOS设置程序而非常方便地对系统进行设置，因此这种CMOS设置又通常被叫做BIOS设置。
3. 一旦CMOS RAM芯片中关于微机的配置信息不正确时，轻者会使得系统整体运行性能降低、软硬盘驱动器等部件不能识别，严重时就会由此引发一系统的软硬件故障（不清楚CMOS具体参数的不要乱修改哦，小心你的电脑···）。

---
##三、BIOS和CMOS的关系与区别
1. 关系：
 * BIOS中的系统设置程序是完成CMOS参数设置的手段。
 * CMOSRAM既是BIOS设定系统参数的存放场所，又是BIOS设定系统参数的结果。
 * 通过BIOS设置程序对CMOS参数进行设置（在 BIOS ROM芯片中装有"系统设置程序"，主要用来设置CMOS RAM中的各项参数）。
2. 区别：
 * BIOS是主板上的一块EPROM或EEPROM芯片里的一组程序，里面装有系统的重要信息和设置系统参数的设置程序（BIOS Setup程序)。
 * CMOS是主板上的一块可读写的RAM芯片，里面装的是关于系统配置的具体参数，其内容可通过设置程序进行读写。CMOSRAM芯片靠后备电池供电，即使系统掉电后信息也不会丢失。
 * 由于 BIOS和CMOS都跟系统设置密初相关，所以在实际使用过程中造成了BIOS设置和CMOS设置的说法，其实指的都是同一回事，但BIOS与CMOS却是两个完全不同的概念，千万不可搞混淆。 　
 +  **简单理解：BIOS是一组设置程序，CMOS只是一种存储介质。**

---
##四、BOIS分类
市面上较流行的主板BIOS主要有 Award BIOS、AMI BIOS、Phoenix BIOS三种类型:
 1. Award BIOS：由AWARD公司生产，其产品也被广泛使用。但由于AWARD BIOS里面的信息都是基于英文且需要用户对相关专业知识的理解相对深入，使得普通用户设置起来感到困难很大。
 2. AMI BIOS：是由AMI公司所设计生产的。早期的286、386大多采用AMI BIOS，它对各种软、硬件的适应性好，能保证系统性能的稳定，当然现在的ami也有非常不错的表现，新版本的功能依然强劲。
 3. Phoenix BIOS：由Phoenix 公司生产，多用于高档的原装品牌机和笔记本电脑上，其画面简洁，便于操作，而且从性能和稳定性看，要好过于Award和AMI。所以应该是目前最常见的Bios。
 4. Insyde bios: (目前不咋滴流行)是台湾的一家软件厂商的产品，是一种新兴的BIOS类型，被某些基于英特尔芯片的笔记本电脑采用，如神舟、联想。
 
最后再啰嗦一句，当你深入了解时你会知道其实显卡、网卡等也有BIOS......