
# 前言
默认情况下，无论是Windows还是linux，一般为动态获取IP地址以及DNS。

日常工作中，推荐配置静态IP地址。本文将教你如何在linux下配置IP地址。


# 正文

基于Redhat系列，使用centos进行讲解。


安装操作参考我的历史博客（linux养成达人之入门实践图文超详细（工欲善其事，必先利其器篇））
[https://blog.csdn.net/Tolove_dream/article/details/103823216](https://blog.csdn.net/Tolove_dream/article/details/103823216)

磁盘相关的管理命令，可以参考菜鸟教程
[https://www.runoob.com/](https://www.runoob.com/)（服务端->linux->linux命令大全）

## 一、设置静态IP
在Linux服务器网卡配置文件中新增如下配置
```powershell
IPADDR=192.168.245.130  #静态ip地址
NETMASK=255.225.225.0   #子网掩码
GATEWAY=192.168.245.2   #网关地址
DNS1=114.114.114.114    #配置DNS 可配置多个DNS
```

### 1、Centos6设置静态IP
修改网卡if-eth0，个人使用虚拟机测试。

使用cat命令只查看ifcfg-eth0网卡配置文件
```powershell
#使用cat命令只查看ifcfg-eth0网卡配置文件
cat /etc/sysconfig/network-scripts/ifcfg-eth0
```
**使用vim命令修改编辑**
```powershell
#使用vim命令修改编辑
vim /etc/sysconfig/network-scripts/ifcfg-eth0
```
**配置文件内容**
```powershell
#配置文件内容
DEVICE=eth0
HWADDR=00:0C:29:66:15:29
TYPE=Ethernet
UUID=c805e85a-aa4e-4e35-9eaa-9fb4457c4568
ONBOOT=yes #设置为yes，重启系统，可以用ifconfig查看ip在哪个网段
NM_CONTROLLED=yes
BOOTPROTO=static #设置为静态static，动态则为dhcp
IPADDR=192.168.245.130 #静态ip地址
NETMASK=255.225.225.0 #子网掩码
GATEWAY=192.168.245.2 #网关地址
DNS1=114.114.114.114 #配置DNS
DNS2=8.8.8.8
```


### 2、Centos7设置静态IP
修改网卡配置文件if-ens33

使用vim命令修改编辑
```powershell
#使用vim命令修改编辑
vim /etc/sysconfig/network-scripts/if-ens33
```
**配置文件内容**
```powershell
#配置文件内容 
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=8a75b801-6f56-48e6-b351-50620a66a1a3
DEVICE=ens33
ONBOOT=yes
IPADDR=192.168.245.129
NETMASK=255.225.225.0
GATEWAY=192.168.245.2
DNS1=114.114.114.114
ZONE=public 
```


### 3、修改完重启网卡生效

```powershell
#centos6
service network restart
```

centos7使用systemctl，同样在redhat系列可以使用service命令

```powershell
systemctl restart network
```


顺带讲一下相关知识点。这里是区分源码包和rpm包，根据安装位置不同，以及启动方式略微不同来区分，不然容易混淆。


**这里介绍一个检测开机自启的命令，以nginx中间件为例子**
```powershell
chkconfig -list
```

**设置服务自启**

```powershell
chkconfig -list 2345 nginx on
```

**查询nginx服务启动**

```powershell
ps -aux | grep nginx
```

**查询nginx的端口号监听**

```powershell
netstat -tlunp | grep nginx
```



**linux下（通用方式）是使用绝对路径找到服务然后启动**
例如：启动源码包安装的nginx

绝对路径
```powershell
/usr/local/nginx/sbin/nginx
```

 
重新加载配置文件
```powershell
/usr/local/nginx/sbin/nginx  -s reload
```

测试配置文件
```powershell
/usr/local/nginx/sbin/nginx -t
```

停止服务
```powershell
/usr/local/nginx/sbin/nginx -s stop
```



### 4、测试访问外网
ping命令的其它带参数使用，参考ping -help，或者使用man命令去查看学习。

```powershell
#ping接参数，ping 5次
ping baidu.com -c 5
```

接收数据成功，证明配置完好。

当然还有fping以及hping可以去官网找相关的源码包安装
这里讲到源码包安装，源码包目录有configure文件
一般三大步骤：
01、 ./configure
02、 make
03、 make install





## 二、优化篇
### 1、配置阿里源
阿里源链接
```powershell
http://mirrors.aliyun.com/repo/
```

修改使其失效
```powershell
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
```

### 2、安装wget命令
```powershell
yum -y install wget
```

下载阿里云的repo，替换掉原来的repo。**替换之前做好备份**。
```powershell
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```


### 3、清除缓存，生成新的缓存

```powershell
yum clean all 
yum makecache
```

### 4、firewalld火墙工具
firewalld和iptables启用其中一个就行。

查看防火墙状态
```powershell
systemctl status firewalld.service
```

临时关闭防火墙
```powershell
systemctl stop firewalld.service
```

开机禁止防火墙
```powershell
systemctl disable firewalld.service
```


### 5、安装并配置启用iptables

安装iptables
```powershell
yum -y install iptables-services.x86_64
```
启动iptable
```powershell
systemctl start iptables.service
```

开机启用iptables
```powershell
systemctl enable iptables.service
```



### 6、关闭selinux
查看状态
```powershell
getenforce
```

临时关闭
```powershell
setenforce 0
```

永久关闭
vim /etc/selinux/config

```powershell
selinux=disable;
```

### 7、htop工具
htop工具下载地址
[https://github.com/htop-dev/htop/archive/refs/tags/3.0.5.tar.gz](https://github.com/htop-dev/htop/archive/refs/tags/3.0.5.tar.gz)

**好记性不如烂笔头**，积少成多，收获也颇丰。**你会发现，自己的知识宝库越来越丰富**。白嫖有瘾，原创不易！

<H5 align=center><a href="https://blog.csdn.net/Tolove_dream">by 龙腾万里sky 原创不易，白嫖有瘾</a></H5>
