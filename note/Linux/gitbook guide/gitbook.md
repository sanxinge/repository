# gitbook
## 一、gitbook

## 二、gitbook部署
1. 安装g++，编译node.js时用
yum install gcc gcc-c++
2. 安装node.js
[root@www ~]# axel http://nodejs.org/dist/v7.2.0/node-v7.2.0.tar.gz
[root@www ~]# tar zxf node-v7.2.0.tar.gz -C /tmp
[root@www ~]# cd /tmp/node-v7.2.0/
[root@www node-v7.2.0]# ./configure --prefix=/opt/node-v7.2.0
[root@www node-v7.2.0]# make && make install
+ 查看版本号： node -v
3. 安装npm
npm就是Node Package Manager的简写，是node.js的套件管理工具。 既然npm是在node.js基础上产生的工具,所以在安装npm之前就要先安装node.js。
`$ sudo pacman -S npm` //arch linux安装node.js
+ 查看版本号： npm -v
4. 安装git
yum install git
5. 安装gitbook
`$ sudo npm install -g gitbook gitbook-cli` #gitbook-cli让gitbook支持命令行
+ 查看版本号： gitbook -V
6. 为了导出eBook文件：需要安装ebook-convert
`$ sudo npm install ebook-convert -g`
7. 为了导出PDF文件，需要先使用NPM安装上gitbook pdf：
`$ sudo npm install gitbook-pdf -g`
+ 安装时报错：
```
Error: connect ETIMEDOUT 199.101.134.182:80
    at Object.exports._errnoException (util.js:1023:11)
    at exports._exceptionWithHostPort (util.js:1046:20)
    at TCPConnectWrap.afterConnect [as oncomplete] (net.js:1090:14)
/usr/lib
└── (empty)

npm ERR! Linux 4.9.8-1-ARCH
npm ERR! argv "/usr/bin/node" "/usr/bin/npm" "install" "gitbook-pdf" "-g"
npm ERR! node v7.5.0
npm ERR! npm  v4.2.0
npm ERR! code ELIFECYCLE
npm ERR! errno 1

npm ERR! phantomjs@1.9.7-5 install: `node install.js`
npm ERR! Exit status 1
npm ERR!
npm ERR! Failed at the phantomjs@1.9.7-5 install script 'node install.js'.
npm ERR! Make sure you have the latest version of node.js and npm installed.
npm ERR! If you do, this is most likely a problem with the phantomjs package,
npm ERR! not with npm itself.
npm ERR! Tell the author that this fails on your system:
npm ERR!     node install.js
npm ERR! You can get information on how to open an issue for this project with:
npm ERR!     npm bugs phantomjs
npm ERR! Or if that isn't available, you can get their info via:
npm ERR!     npm owner ls phantomjs
npm ERR! There is likely additional logging output above.

npm ERR! Please include the following file with any support request:
npm ERR!     /root/.npm/_logs/2017-02-13T10_14_24_329Z-debug.log
```
原因是下载phantomjs发生了错误，因此我们需要手动下载和安装。
`$ sudo pacman -S phantomjs`
8. 解决国内NPM安装依赖速度慢问题
+ 方法：使用–registry参数指定镜像服务器地址，这里使用阿里巴巴在国内的镜像服务器
`npm install -gd express --registry=http://registry.npm.taobao.org`
+ 为了避免每次安装都需要--registry参数，可以使用如下命令进行永久设置：
`npm config set registry http://registry.npm.taobao.org`

## 三、初始化及配置
