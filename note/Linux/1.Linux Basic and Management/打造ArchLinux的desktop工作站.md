# 打造Arch Linux的desk工作站
---
> 前言
        我接触Linux一年时间了（完全是个新手），先后使用了Ubuntu和CentOS，再到现在的Arch，我不想说发行版本哪个好哪个坏，任何一个Linux发行版本学通了，其他的也基本就会用了，毕竟他们都叫Linux而不叫Windows。
        但是，Linux奉养着free精神，选择一个你认为适合你的发行版本是你的自由，而我目前选择了Arch，主要是因为它的轻量和对用户的透明及可高度的定制。
----
### 一、准备阶段
+ 镜像文件：
+ 安装介质：U盘和光盘都可以
+ BIOS/UEFI的选择，相关介绍请移至
+ 网络环境：Arch不提供DVD版的镜像，所以需要网络

## 二、安装介质的引导启动
1. BIOS设置，请移至
2. 启动选项
    
## 三、部署阶段
1. 设置键盘布局（只对安装过程有效）
默认键盘布局为us（美式键盘映射），一般都us映射键盘吧！当然.....修改方法如下：
`# loadkeys <键盘布局>`
2. 连接因特网
 + 有线连接
 + 无线连接
3. 更新系统时间
4. 存储设备的部署（这里采用parted工具分区，它有自动对齐硬盘扇区的功能）
    1. 分区规划
     + 首先是分区表的选择，MBR呢还是GPT......
     + 其次是选择分几个分区，但至少要分个/分区。
    2. 进入parted工具，并选择要操作的磁盘    
    3. 创建分区表
    4. 分区实现
    5. 分区的格式化文件系统以及使用（挂载）
    
## 四、安装阶段
1. 选择镜像源
2. 安装基本软件包

## 五、配置阶段
1. 生成fstab文件
2. chroot
3. Local
4. 时间
5. 创建初始ramdisk环境
6. 设置root密码
7. 配置网络
8. 配置主机名
9. bootloader(启动加载器)的安装及配置

## 六、卸除分区并重启系统
1. 离开chroot环境
2. 卸除分区
3. 重启计算机
到此，Arch系统安装完毕，当然只是控制台环境。

---
## 七、新系统的基本配置
1. 创建普通用户，Linux中root可是神一样的存在，神做错事导致的结果是很严重滴......
`# useradd -d `
2. 普通用户的权限提升
`# vim `

## 八、桌面环境的搭建

##一、新系统的基本配置     
1. 创建用户组
`# groupadd ` hggh
1. 创建普通用户，Linux中root可是神一样的存在，神做错事导致的结果是很严重滴......
`# useradd -m -g <> `
2. 普通用户的权限提升
`# visudo`  #进入sudo配置文件，等同于vim /etc/sudoers,但visudo有语法书写错误提示功能
提升用户权限,在sudoers文件添加
`<用户名> ALL=（ALL） ALL`
提升用户组权限,在sudoers文件添加
`%<用户组> ALL=(ALL) ALL`

##二、桌面环境的搭建(xfce桌面环境)
 所需软件：
 * 必用软件：xrog-server,xfce4(桌面环境)，显卡驱动
 * 可选软件：xrog-server-utils(工具） xorg-xinit（用来启动X窗口）
1. 安装X Window System——xrog
```$ sudo pacman -S xrog-server ```
可选安装软件：xrog-server-utils，xorg-xinit
    一般安装xrog是会有依赖选择安装显卡驱动（旧版本不知道有着个功能否？）有依赖安装的请跳过第二步。
2. 安装显卡驱动
    查看本机显卡驱动
    `$ lspci | grep VGA`
    查看能安装的所有开源驱动
    `pacman -Ss xf86-video | less`
    安装显卡驱动（双显卡的本机两个都要安装）
    X服务不能正常启动的一般是显卡驱动的原因，要不驱动没打上，要不打的驱动有问题，就像我的本子的独显，开始打的开源驱动，结果startx后一直灰屏，后来改成闭源驱动，启动正常。
3. 安装触摸板驱动

4. 如果想用 Ctrl+Alt+Backspace 关闭 X，需要在 /etc/X11/xorg.conf.d/10-evdev.conf 中增加一段：

复制代码代码如下:
Section "InputClass"
Identifier "Keyboard Defaults"
MatchIsKeyboard "yes"
Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection


##三、美化及常用工具

https://wiki.archlinux.org/index.php/Xinitrc_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29
~/.xinitrc 文件是 xinit 和它的前端 startx 第一次启动时会读取的脚本。通常用在启动 X 时执行窗口管理器 和其他程序，例如启动守护进程和设置环境变量。xinit程序用来启动X窗口系统
如果用户主目录中存在 .xinitrc，startx 和 xinit 会执行此文件。如果不存在，startx 会执行 /etc/X11/xinit/xinitrc。
~/.xinitrc 中应该只有 一个 未注释掉的 exec 行，而且 exec 行必须位于配置文件的末尾。exec 后面的所有命令只有窗口退出后才会被执行。在窗口~/.xinitrc 中应该只有 一个 未注释掉的 exec 行，而且 exec 行必须位于配置文件的末尾。exec 后面的所有命令只有窗口退出后才会被执行。在窗口管理器前启动的命令应该用 & 在后台启动, 否则启动程序会等待它们退出。使用 exec 作为前缀会替换当前的进程，这样进程进入后台时 X 不会退出。
