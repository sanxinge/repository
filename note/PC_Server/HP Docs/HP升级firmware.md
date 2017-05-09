# 通过iLO界面升/降级iLO的firmware
-----------------------------------
### 一、Firmware包准备
1.	在HP官网下载对应.scexe格式的firmware包  
 网站：https://h20566.www2.hpe.com/hpsc/swd/public/detail?sp4ts.oid=1121413&swItemId=MTX_ab90093287a14896b02f537b7b&swEnvOid=4024
 ![enter description here][1]
官网说明：  
此组件提供可直接安装于支持的 Linux 操作系统的 iLO 固件。此组件还可用于通过 iLO 界面、实用程序或者脚本界面获取固件镜像升级。另外，此组件可与 HP Smart Update Manager 共同使用。

2.	在Linux中解压firmware包  
 此包只能在Linux中解压，执行命令： `sh CP017013.scexe --unpack=directory`，该命令会将该包 解压到用户指定的“目录”中。如果该目录不存在，解压缩程序会创建一个目录。（注意文件夹权限问题）  
![enter description here][2]
 
### 二、通过iLO界面升级iLO固件
1.	进入iLO的upgrade iLO firmware界面，选择上面解压后ilo2_209.bin的文件
 ![enter description here][3]
2.	更新完成，重启操作
 ![enter description here][4]
注意：
Please wait - iLO 2 is being reset with new changes
You will automatically be redirected to the login page in seconds. If an SSL error message is displayed, please restart your browser and re-login. 
3.	升级结果
 ![enter description here][5]   
 ### 三、通过Linux升级iLo firmware
 1. 解包后直接执行：  
 `[root@www ~]# ./ilo2_209.bin`
 + 注：
 不同版本的linux的共享库不同，可能由于某些库文件缺失造成不能成功执行，需要安装相应的库文件，虽说这种可能性不大，但还是建议通过iLo口升级或在windows系统中升级。


  [1]: ./images/hp%20%E5%8D%87firmware.png "hp 升firmware.png"
  [2]: ./images/hp%20%E5%8D%87firmware2.png "hp 升firmware2.png"
  [3]: ./images/hp%20%E5%8D%87firmware3.png "hp 升firmware3.png"
  [4]: ./images/hp%20%E5%8D%87firmware4.png "hp 升firmware4.png"
  [5]: ./images/hp%20%E5%8D%87firmware5.png "hp 升firmware5.png"