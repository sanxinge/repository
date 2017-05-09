# TCP Wrappers  
-----------------
> TCP Wrapper是一个基于主机的网络访问控制表系统，用于过滤对类Unix系统（如Linux或BSD）的网络访问。其能将主机或子网IP地址、名称及ident查询回复作为筛选标记，实现访问控制。
	> + 采用许可协议：BSD license  
	
## 一、Summary  
----
### 1. 安装TCP Wrappers  

### 2. 须知  
1. 确认服务是否支持TCP Wrappers  
Linux系统TCP Wrappers并不是所有的服务都支持（目前支持TCP Wrappers的服务有sendmail、pop3、imap、sshd、telnet等等），可以使用ldd命令查看指定服务是否支持TCP Wrappers。ldd用于查看二进制文件所需动态链接库，如果某服务中含有“libwrap.so”则表示该服务支持TCP Wrappers，以sshd为例：  
`[root@test ~]# ldd /usr/sbin/sshd | grep libwrap.so`

## 二、TCP Wrappers Configution Files     
----
### 1. TCP Wrappers配置文件     
1. 在TCP Wrappers中通过/etc/hosts.allow和/etc/hosts.deny配置规则允许或阻止指定客户端对指定服务的访问，修改保存此文件后配置无须重新启动服务立即生效。TCP Wrappers规则生效原则如下：    
	+ **/etc/hosts.allow**：允许与该文件中规则匹配的主机访问    
	+ **/etc/hosts.deny**：阻止与该文件中规则匹配的主机访问    
	+ 当 **/etc/hosts.allow** 与 **/etc/hosts.deny** 中的规则冲突时，执行 **/etc/hosts.allow** 中的规则    
	
### 2. 书写格式
1. /etc/hosts.allow与/etc/hosts.deny规则的书写格式是一致的，如下：  
 `<daemon list>:<client list>[:<option>:<option>:......`  
	+ `<daemon list>`：是以逗号分隔的daemon（而不是service name）列表或 ALL等通配符。`<daemon list>`还接受operators，以允许更大的灵活性。 
	+ `<client list>`： 是以逗号分隔的主机名、主机IP地址，特殊模式或通配符列表，用于标识受规则影响的主机。`<client list>`还接受operators，以允许更大的灵活性。 
	+ `<option>`：选项（可选），以冒号分隔多个字段。选项字段支持扩展、启动shell命令、允许或拒绝访问以及更改日志记录行为。 其中`:allow`和`:deny`可以省略不写。  
	+ Operators：  
	目前，控制规则只接受一个operators：`EXCEPT`。 它可以在规则的`<daemon list>`和`<client list>`中使用。EXCEPT operators允许在相同的规则中的更广泛匹配主机。例如：  
		+ 以hosts.allow文件为例，所有example.com主机都允许连接到除cracker.example.com之外的所有服务：
		   `ALL: .example.com EXCEPT cracker.example.com`  
		+ 以hosts.allow文件为例，来自192.168.0.x网段的客户端可以使用除FTP之外的所有服务：  
		   `ALL EXCEPT vsftpd: 192.168.0.`  
2. 例子：  
	+ 阻止所有客户端访问本机的telnet服务，在`/etc/hosts.deny`文件加入规则：  
	   `in.telnetd:ALL:deny`   `deny`可以省略
	+ 允许192.168.0.0/24网段的所有客户端访问本机的ssh服务,在`/etc/hosts.allow`文件加入规则：  
	   `sshd:192.168.0.:allow`  
