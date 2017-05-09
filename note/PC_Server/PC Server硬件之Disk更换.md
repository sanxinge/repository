
## 一、LSI RAID卡
------------
> 目前LSI RAID卡使用的配置工具主要有：
	> + 图形环境：Megaraid Storage Manager（MSM） 
	> + 字符界面：MegaCLI、StorCLI。其中StorCLI整合了LSI和原来3ware的产品支持，相对MegaCLI命令更加简洁，并且兼容MegaCLI的命令，估计两者已经整合了（有待确认）。

### 1. storcli更换硬盘
----------------------  
> storcli已经基本代替了megacli，
1.	检查一下当前物理盘的状态，假如显示0槽位的硬盘出现问题，我们需要对其进行更换  
storcli64.exe /c0   show all 
 ![enter description here][1]
2. 改变故障盘的状态，处于offline状态
`storcli64.exe /c0/e62/s0 set offline`
 ![enter description here][2]
查看一下，现在该盘的状态
 ![enter description here][3]
3. 让该盘处于missing状态，我们便可将该盘拔下。.
`storcli64.exe /c0/e62/s0 set missing`
 ![enter description here][4]
 状态
 ![enter description here][5]
4. 当我们换上新的硬盘以后，该raid组会自动进行数据重建，该硬盘组指示灯会频繁闪烁，黄灯闪烁。正在重建中
5. 查看重建过程进度
`storcli64.exe /c0/e62/s0 show rebuild`
![enter description here][6]
 + **注：** 如果，系统不能自动进行重建过程，我们要手动进行。
`storcli64 .exe/c0/e62/s0 set start rebuild`

### 2. MSM更换硬盘
----------------------
1. 安装好MSM，打开软件，进入到 Configure Host 页面，添加服务器的ip
 ![enter description here][7]
2. 通过扫描，我们可以发现两个我们已经配置好server raid的服务器
 ![enter description here][8]
 3. 通过输入登录用户名，及密码。我们会登录到相应服务器上，下图是仪表板界面（仪表盘，顾名思义就是一个信息的概述显示）
  ![enter description here][9]
4. 物理盘的管理页面，在这个页面我们可以看到磁盘的信息
  ![enter description here][10]
5. 下面是逻辑盘的管理页面，在这里我们可以看到我们raid配置情况，逻辑磁盘的健康情况
  ![enter description here][11]
6. 如果某一块硬盘出现了问题，我们要先停止这一块盘，让其处于offline状态，然后可以拔去坏盘插入新盘
  ![enter description here][12]
7. 新盘插上以后，会开始同步数据，
  ![enter description here][13]
切记不要直接online ，直接online磁盘的状态显示正常但是数据并没有同步过去。硬盘更换完毕告警消失。
  ![enter description here][14]



 


  [1]: ./images/Disk/storcli_disk1.png "storcli_disk1"
  [2]: ./images/Disk/storcli_disk2.png "storcli_disk2"
  [3]: ./images/Disk/storcli_disk3.png "storcli_disk3"
  [4]: ./images/Disk/storcli_disk4.png "storcli_disk4"
  [5]: ./images/Disk/storcli_disk5.png "storcli_disk5"
  [6]: ./images/Disk/storcli_disk6.png "storcli_disk6"
  [7]: ./images/Disk/msm_disk1.png "msm_disk1"
  [8]: ./images/Disk/msm_disk2.png "msm_disk2"
  [9]: ./images/Disk/msm_disk3.png "msm_disk3"
  [10]: ./images/Disk/msm_disk4.png "msm_disk4"
  [11]: ./images/Disk/msm_disk5.png "msm_disk5"
  [12]: ./images/Disk/msm_disk6.png "msm_disk6"
  [13]: ./images/Disk/msm_disk7.png "msm_disk7"
  [14]: ./images/Disk/msm_disk8.png "msm_disk8"