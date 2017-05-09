——挂载iscsi存储
1： 安装软件：`yum install iscsi-initiator-utils`
2：启动iscsi服务并设置开机自启动
`service iscsi start`
`chkconfig iscsi on`
3：查找存储对外提供的逻辑卷
[root@node2 ~]# iscsiadm --mode discovery --type sendtargets --portal 192.168.5.5
192.168.5.5:3260,1 iqn.2006-01.com.openfiler:tsn.775b2a314655
4：映射逻辑卷到Linux系统中
[root@node2 ~]# iscsiadm -m node -T iqn.2006-01.com.openfiler:tsn.775b2a314655  -p 192.168.5.5:3260 -l
Logging in to [iface: default, target: iqn.2006-01.com.openfiler:tsn.775b2a314655, portal: 192.168.5.5,3260] (multiple)
Login to [iface: default, target: iqn.2006-01.com.openfiler:tsn.775b2a314655, portal: 192.168.5.5,3260] successful.
5：设置开机自动映射
`iscsiadm -m node -T iqn.2006-01.com.openfiler:tsn.775b2a314655  -p 192.168.5.5:3260 --op update -n node.startup -v automatic`
6：对映射出来的磁盘进行分区
7：分区之后进行格式化
`[root@node1 ~]# mkfs.ext4 /dev/sdb1`
8：挂载分区
`[root@node1 ~]# mkdir /data`
`[root@node1 ~]# mount /dev/sdb1 /data`
