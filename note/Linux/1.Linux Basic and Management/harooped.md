---
date: 2016-06-26 20:14
status: public
title: 'Haroopad 安装后打不开的解决方案'
---

# Haroopad 安装后打不开的解决方案
**1、首先我们用命令查看一下udev.so在哪个目录下：**
```
locate udev.so  / 
```
**2、接下来会看到以下输出信息：**
```/lib/x86_64-linux-gnu/libudev.so.1
/lib/x86_64-linux-gnu/libudev.so.1.6.4

```
**3、前两行就是我们要找的，进入这个目录：**
```
cd /lib/x86_64-linux-gnu/
sudo cp libudev.so.1 libudev.so.0 #在当前目录复制一个
```
现在我们再次打开Haroopad，一切正常。o(∩∩)o...