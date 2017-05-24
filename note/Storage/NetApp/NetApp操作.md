## NetApp开\关机操作
---
> NetApp断电加电操作流程
### 1、方案总览
此文档适用于NetApp FAS/V系列，含两个控制器及若干磁盘拓展柜，其中两个控制器为双活关系。
### 2、断电操作流程
1.  分别登录FAS/V两个控制器，使用下面命令收集检查配置信息，以便加电后检查存储状态：
命令：`sysconfig -a`
sysconfig -r
ifconfig -a
lun show
igroup show
lun show -m
ifgrp status
df -h
df -Ah
cf status
2. 在AB两台控制器上分别输入命令关机：
命令：`halt -f`
3. 使用串口线连接到AB两个控制器的console口，确认AB两个控制器均进入LOADER-A>模式；
4. 关闭AB两台控制器的电源模块；
5. 关闭所有拓展磁盘柜电源模块；
### 3、加电操作流程
1. 打开所有磁盘拓展柜电源模块，等待磁盘拓展柜前面板所有硬盘亮起绿灯，说明所有硬盘已经启动完成；
2. 打开AB两个控制器的电源模块，等待AB两控制器启动；
3. 控制器启动后，使用root账号登录AB两个控制器，根据断电前收集的配置信息检查系统状态；
4.  系统状态检查完成，系统正常启动；
### 4、回退方案
1. 如果系统加电后无法正常启动，使用串口线连入控制器的console口，在LOADER-A模式下输入命令：boot_ontap启动；如果boot_ontap无法启动系统，在LOADER-A模式下输入命令：boot_backup，使用备份系统镜像启动系统；
2. 如果系统启动后，系统配置不准确，使用关机前收集的系统配置信息进行修正。

## Linux
---
### 1. CMWASP01/P02
+ 关机
1. 信息收集
	+ 文件系统挂载及磁盘信息:`mount`,`df -h`,`fdisk -l`
	+ IP信息:`ip addr`
2. 确认业务应用已停止  
	+ 和客户确认
	+ 查看有无数据库进程:`ps -ef|grep ora`  

3. 关机后关闭电源: `shutdown -h now`   

+ 开机
1. 加电并开机  
2. 查看文件系统挂载状态
3. 确认网络信息是否正常
4. 启动业务应用

### 2. CMDBP01/P02  
+ 关机  
1. 信息收集
	+ 文件系统挂载及磁盘信息:`mount`,`df -h`,`fdisk -l`
	+ IP信息:`ip addr`
2. 确认业务应用已停止  
	+ 和客户确认
	+ 查看有无数据库进程:`ps -ef|grep ora`  
3. RHCS集群状态查看,具体操作看开机部分  
4. 手动切换集群,具体操作看开机部分
5. `umount`本机的共享存储GFS2文件系统  
如果不`umount`掉GFS2文件系统,cman守护进程无法停止   

6. 关闭RHCS集群
	+ 先stop各节点`rgmanager`守护进程:`service rgmanager stop`  
	+ 再stop各节点的`cman`守护进程:`service cman stop`


+ 开机  
1. 加电并开机  
2. 查看文件系统挂载状态
3. 确认网络信息是否正常  
4. 启动RHCS集群(没有在开机自启的情况下)
	+ 先start各节点的`cman`守护进程:`service cman start`   
	+ 再start各节点的`rgmanager`守护进程:`service rgmanager start` 
	+ 如果发现启动cman和rgmanager服务后，clustat查询资源状态长时间为disabled，如下:
		```
		# clustat
		Cluster Status for Cluster @ Thu Nov 26 10:17:58 2015
		Member Status: Quorate

		 Member Name                                                     ID   Status
		 ------ ----                                                     ---- ------
		 DB1_Heart                                                           1 Online, Local, rgmanager
		 DB2_Heart                                                           2 Offline

		 Service Name                                             Owner (Last)                                             State        
		 ------- ----                                             ----- ------                                             -----        
		 service:Service                                          (none)                                                   disabled  
		```  
		原因资源可能不是自动启动的，那么就需要手工启动资源：`clusvcadm -e Service`  
		
5. 查看RHCS的状态
	+ `clustat -i 3` :每三秒刷新一次集群状态  
	+ `cman_tool status` :详细的集群信息  
	+ `cman_tool nodes -a` :查看nodes信息  
6. 手动切换,命令格式如下:
`clusvcadm -r service_name -m nodename`  
	+ RHCS日志检查:`tail -f /var/log/cluster/rgmanager.log`  

## SAN Switch
---
### 1. 关机
1. 确保所有的主机存储都已关闭.  
2. 登录交换机收集信息
	+ 端口信息:`switchshow`  
	+ zoning配置信息:`cfgshow`,`zoneshow`  
	+ Licenses信息：`licenseshow`
3. 备份配置(已完成)
4. 关机:`sysshutdown`  

### 2. 开机
1. 所有的设备SAN Switch最先启动  
2. 检查交换机的级联状态是否正常:
	+ 看端口信息:`switchshow` 级联的端口显示为`E-Port`  
	+ 查看交换机的数量:`fabricshow` 可以看到两台,domain ID不同  
3. 查看zoning配置是否正确
	+ 主机存储开启后看LUN映射是否成功
	+ 用`cfgshow`或`zoneshow`查看并与关机前的收集的信息核对  

### 3.回退方案
1. 级联失败  
方法:重新设置级联
步骤:
	+ 如果级联License丢失,导入级联license:`licenseadd xxxxxxxxx`   
	+ 修改switch domain ID
		```
		moonpac:admin> switchdisable
		moonpac:admin> configure 
		Configure...
		  Fabric parameters (yes, y, no, n): [no] yes

			Domain: (1..239) [1] 2					//这里修改
			R_A_TOV: (4000..120000) [10000] 
			E_D_TOV: (1000..5000) [2000] 
			WAN_TOV: (0..30000) [0] 
			MAX_HOPS: (7..19) [7] 
		......
		```
	+ 在要做级联的端口连线,在端口指示灯正常后登录交换机查看级联是否成功  
2. zoning配置损坏   
	+ 从备份恢复  
	+ 手动重新配置  