# PC Server硬件之更换总纲
--------  
> 思路：
	> + 更换的动作或许不难，但致命的是不清楚每一步的风险点在哪
	> + 风险最大的就是丢数据，而与数据有直接关系且最重要的就是存储；对PC服务器来说存储最常见的硬件就是磁盘和阵列卡，故而更换磁盘和RAID卡的风险最大，需清楚每一步操作会带来什么后果。
	>
> 成功的因素：
	> + 拿到匹配的备件，这是更换操作进行的前提；  
	> + 合适的工具。螺丝刀和静电手环是拆机操作必备的工具；  
	> + 每一次的操作都事先做好SOP；  
	> + 找个二线确认SOP和提供操作过程中的技术支持。 
## 一、找到匹配的备件 —— 前提
----------------------
1. 最佳选择是找到相同PN号的备件，但是在拿到备件后还要再次确认是否与主机匹配（供货商渠道问题）
2. 找不到相同PN号的备件，就要找可替代的备件，可替代备件除了看物理上的属性值（比如内存的频率、电压、颗粒等）外，还要看firmware版本。
3. 查找备件的方法祥见 **`PC Server硬件之信息收集`**
## 二、更换方法及注意事项  
----------------
> 所有的操作的共同的风险点（尤其是hot-swap操作）：
	> + 拔错硬件（尤其电源和磁盘）
	> + 不小心碰掉其他服务器的电源
	> 
> 避免上述风险：
	> + 对操作的服务器开UID定位灯；
	> + 理清机柜中的线路
	> + 思路清晰，多重确认故障硬件（如Disk可以通过状态指示灯、管理口、系统报错日志等多重方式确认故障磁盘的槽位）
### 1. Hot-swap
---
> 这块的操做风险最大，一不小心可能会造成宕机，甚至数据丢失
1. Power
+ 拿到正确的备件，直接插拔即可。
	+ 风险点：拔错电源。
2. Fan
+ 拿到正确的备件后，风扇是可以直接插拔的，但要根据环境（机柜空间和连线等因素）选择是否热插拔更换。
	+ 风险点：
3. Disk
+  必须先判断是否做RAID以及做了那个级别的RAID；
+  磁盘更换详见：**`PC Server硬件之Disk更换`**
	+  风险点：拔错磁盘，raid管理软件的操作不当。
### 2. Non hot-swap
-----
> Non hot-swap操作相对来说风险小点（除了RAID卡）
1. Memory
+ 拿到正确的备件后，可直接更换。
	+ 风险点：
2. CPU
+ 拿到正确的备件后，可直接更换，需在CPU上涂硅脂，所以换CPU需要带硅脂。 
	+ 风险点：
3. RAID卡
+ RAID卡更换详见：**`PC Server硬件之Raid卡更换`**
	+ 风险点：RAID卡换后配置信息也没了，应从磁盘启动并导入RAID配置信息 ,导入raid信息有风险，建议备份好数据。
4. Motherboard  
+  独立RAID卡的主板   
	+ 操作：拿到正确的备件可直接更换，更换后应升级主板firmware和更改firmware程序（BIOS或UEFI）的设置，如：主板SN号的重新导入、启动模式（UEFI或legacy）、启动介质顺序等。  
	+ 风险点：
+  集成RAID卡的主板
	+ 操作：除了上述主板更换的操作外，最该注意的是RAID这块，也应从磁盘导入RAID配置信息。
	+ 风险点：更换主板后RAID的配置信息也没了，应从磁盘启动并导入RAID配置信息 ,导入raid信息有风险，建议备份好数据。
