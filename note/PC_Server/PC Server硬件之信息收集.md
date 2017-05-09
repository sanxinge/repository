# PC Server之硬件信息收集  
--------
> 目的：
> 找出备件的备件号，方便主机硬件坏掉后可以快速、准确的找到匹配的备件。  
>  
> 思路：
> 1. 直接能看到或查到设备备件号的，直接记录备件号就OK，但也最好记录下备件的属性信息 。  
> 2. 若无法直接查到备件号的，请尽可能详细的记录备件属性信息，再拿服务器的SN号和备件描述信息通过相应的网站查找备件号。   
## 一、从服务器外观收集硬件信息  
----
1.	标签：各设备的PN号和描述信息，如图  
  ![enter description here][1]  
2.	磁盘和磁盘笼子
 ![enter description here][2]
 如图所示：
	+ Disk可以直接获取PN号及接口等描述信息
	+ 磁盘笼子可以获得磁盘尺寸和磁盘背板可接磁盘的数量  
## 二、从管理口收集硬件信息  
----
### 1. HP 的iLo 4口收集硬件信息  
1. 用浏览器登陆iLO4管理口  
2. 进入管理界面后，information栏中的System information，就可以看到各硬件信息。如图所示是CPU的信息：  
![enter description here][3]  
3. 内存信息，可以直接看到PN号。  
 ![enter description here][4]  
+ 注意：  
iLO 4管理口也有无法直接查到备件号的（目前为止我在iLO 2是没查到过备件号，而且备件描述信息都很少，不建议用iLO 2收集硬件信息），请详细记录备件属性信息。     
## 三、通过服务器厂商或第三方管理软件收集硬件信息
-----
 1. 这里以HP的HP Insight Diagnostics Onlin Edition工具为例：  
 + 打开HP Insight Diagnostics Onlin Edition，输入用户名密码，进入后如下图所示可以看到备件信息，但可以直接看到备件号的很少，大多是描述信息。
![enter description here][5]  
## 四、通过OS收集硬件信息  
----
>OS中一般是直接收集不到备件号的（但也不是绝对），所以请尽可能的收集备件属性的描述。由于系统中有些备件的信息是查不到的，故而这个方法不是最好的，但却在某个特殊环境是唯一的办法。
### 1、Linux系统收集信息  
1.	OS配置信息收集  
	+ 主机名：`hostname`  
	+ 操作系统版本：`lsb_release -a`
2.	硬件信息收集
	+	CPU信息：`lscpu` 或 `cat /proc/cpuinfo`
	+	内存信息：`dmidecode -t memory`
	+	阵列卡：`lspci -v |grep "RAID" -A 12`
3. 拿备件属性描述去相应网站去查备件号
	+ HP查备件号网址：`http://partsurfer.hpe.com `
### 2、Windonws系统收集信息
1.	OS信息收集
	+ 主机名：`systeminfo`
	+ 操作系统版本：`systeminfo`  
2.	硬件信息收集
	+ CPU信息：`systeminfo`、`wmic cpu`、查看系统属性  
	+ 内存信息：`wmic memorychip`  
	+ 阵列卡：打开设备管理器查看存储控制器信息
3. 拿备件属性描述去相应网站去查备件号  
	+ HP查备件号网址：`http://partsurfer.hpe.com `

+ **注：**
**通常上述几种方法搭配使用。**


  [1]: ./images/HP%E8%AE%BE%E5%A4%87%E6%A0%87%E7%AD%BE%E7%A1%AC%E4%BB%B6%E4%BF%A1%E6%81%AF%E6%94%B6%E9%9B%86.png "HP设备标签硬件信息收集.png"
  [2]: ./images/HP%20Disk%20and%20cage.png "HP Disk and cage.png"
  [3]: ./images/ilo%E5%8F%A3%E6%94%B6%E9%9B%86%E7%A1%AC%E4%BB%B6%E4%BF%A1%E6%81%AF1.PNG "ilo口收集硬件信息1.PNG"
  [4]: ./images/ilo%E5%8F%A3%E6%94%B6%E9%9B%86%E7%A1%AC%E4%BB%B6%E4%BF%A1%E6%81%AF2.PNG "ilo口收集硬件信息2.PNG"
  [5]: ./images/%E7%AC%AC%E4%B8%89%E6%96%B9%E8%BD%AF%E4%BB%B6%E6%94%B6%E9%9B%86%E7%A1%AC%E4%BB%B6%E4%BF%A1%E6%81%AF1.PNG "第三方软件收集硬件信息1.PNG"