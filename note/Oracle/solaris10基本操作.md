# Solaris 基本操作


### window环境和command环境切换  
1. 开机进入是否进入desktop  
	+ `/usr/dt/bin/dtconfig -d` : desktop auto-start disabled.  
	+ `/usr/dt/bin/dtconfig -e` : desktop auto-start enabled.

2. command转window
`# /usr/dt/bin/dtlogin -daemon;exit`  
	+ 或者：`#/etc/rc2.d/S92dtlogin start;exit`  

3. window转command
`
## 服务（守护进程）管理
> Solaris中使用的服务管理工具是Service Management Facility，缩写为SMF  

### 1. SMF简介
1. SMF服务
SMF框架中的基本管理单元是服务实例;比如:配置为在端口 80 侦听的特定 Web 服务器守护进程就是一个实例。  