# 前言

主要以Windows server2012R2为主进行介绍，解决实际工作中遇到到的一些问题。

比如服务器CPU核心数过高，导致Oracle数据库安装时卡在2%的情况。

在Windows下，你安装VMware工具模拟使用Windows server达到熟悉的目的。

![](win_server2012_%E7%B3%BB%E7%BB%9F%E9%85%8D%E7%BD%AE_proc.jpg)

说句心里话，我真没想到过我会在Windows服务器上总结这么多。一分耕耘一分收获，但是血赚不亏。



# 正文

第一次接触Windows服务器大约在5年前，那会的活动价我入手了入门级的Windows服务器。第一次安装了Windows server2012，低配版的服务器确实很吃力。*用了一段时间熟悉了就弃用了，后来果断换成了linux操作系统（Centos）。centos被（Redhat）红帽收购后，逐渐。。。说白了还是利益二字。感慨了一番，关于centos的这段话可以忽略。*

想熟悉Windows server服务器最新版，建议使用VMware配合服务器镜像。

**镜像获取地址**，推荐msdn我告诉你。良心网站，专业收集原版镜像。

[https://msdn.itellyou.cn/](https://msdn.itellyou.cn/)

**关于想体验最新版的Windows11或者Windows server2022服务器**，可以访问新地址

[[https://next.itellyou.cn](https://next.itellyou.cn/Original/Index)](https://next.itellyou.cn)

## 一、Oracle数据库安装开在2%

### 1、问题描述

1.1、**服务器CPU核心数过高**。在使用Windows server2012或者是其它Windows服务器，可能也会遇到这类问题。

### 2、解决问题

2.1、**解决问题，进入服务器的系统配置**，一次找到引导->高级选项，**设置处理器的核心数为16，然后重启即可生效**。

2.2、小技巧

**快捷键win + r，然后输入msconfig**命令即可快速进入系统配置。

![](https://gitee.com/dywangk/img/raw/master/images/win_server2012_%E7%B3%BB%E7%BB%9F%E9%85%8D%E7%BD%AE_proc.jpg)

## 二、安装.net3.5失败

### 1、准备工作，提取sxs

1.1、准备服务器镜像，可以**通过我上面提到的网址进行获取**。

![](https://gitee.com/dywangk/img/raw/master/images/01%E5%87%86%E5%A4%87Windows_server%E9%95%9C%E5%83%8F.png)

**1.2、提取sxs**

使用解压缩软件或者iso模拟软件打开镜像包，然后**进入/source/找到sxs**复制出来。在安装.net3.5时作为备用源使用，安装Oracle11gR2时需要安装.net3.5。

解压缩软件推荐360zip国际版（旧版1.0几的无广告）或者7z（体积小）。

![](https://gitee.com/dywangk/img/raw/master/images/02%E8%8E%B7%E5%8F%96sxs_proc.jpg)

### 2、再次安装.net3.5

#### 2.1、指定依赖sxs，安装.net3.5

将之前从**Windows server中提取的sxs**复制到系统盘根目录下，然后在服务器仪表板中添加角色和功能（安装依赖），按照图上的提示**指定我们准备好的sxs源路径**，最终完美解决服务器上.net3.5无法安装的问题。

![](https://gitee.com/dywangk/img/raw/master/images/03%E6%B7%BB%E5%8A%A0net3.5%E6%97%B6%E8%AE%BE%E7%BD%AEsxs_proc.jpg)

#### 2.2、Windows server仪表板

添加角色与功能，选择需要安装的功能时用得上，比如上面安装.net3.5

![](https://gitee.com/dywangk/img/raw/master/images/%E6%B7%BB%E5%8A%A0%E8%A7%92%E8%89%B2%E4%B8%8E%E5%8A%9F%E8%83%BD_proc.jpg)

## 三、操作小技巧

### 1、以Oracle服务为例

1.1、进入服务快捷命令，**win + r快捷键输入service.msc**，如下图所示

![](https://gitee.com/dywangk/img/raw/master/images/win_server_%E8%BF%9B%E5%85%A5%E6%9C%8D%E5%8A%A1%E7%AE%A1%E7%90%86.png)



1.2、定位Oracle服务，你看到的Oracle服务是双倍的，因为我安装了双实例。实际工作中，并不推荐在单台服务器上部署双实例。不要问我为什么，因为实际中遇到过。内存也耗不起，最终把服务器拖挂掉了，最后通过清理日志解决。

![](https://gitee.com/dywangk/img/raw/master/images/win_server_oracle_proc.jpg)

### 2、配置IP地址与DNS

配置IP地址与DNS与平时使用的win7或者win10是一样的配置方法

2.1、**进入控制面板找到网络和共享中心**

`win + r` 快捷键运行`control`命令进入控制面板，下图是VMware搭建的测试环境。

![](https://gitee.com/dywangk/img/raw/master/images/win_server2012_%E7%BD%91%E7%BB%9C%E5%85%B1%E4%BA%AB%E4%B8%AD%E5%BF%83_proc.jpg)

**2.2、配置IP地址和DNS**

![](https://gitee.com/dywangk/img/raw/master/images/windows_server2012%E9%85%8D%E7%BD%AEip_dns_proc.jpg)

### 3、磁盘管理

最后再介绍一个小技巧，关于磁盘管理。当我们并不熟悉仪表板的操作时，或者旧版的服务器压根就没这玩意，如何处理。这是我们可以采用命令方式，先打开计算机管理。

同样使用`win + r` 快捷键，然后运行`compmgmt.msc`命令进入计算机管理，最后定位到磁盘管理。

![](https://gitee.com/dywangk/img/raw/master/images/win_server2012_%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%AE%A1%E7%90%86_proc.jpg)



以上均为实际运维工作中使用到的小技巧，方便我们去管理维护服务器。在实际工作中，更多的是经验的累积。在之前的公司遇到这样一种，服务器的硬盘突然就gg思密达了。结果去查看后简直是让我措手不及，服务器版本那叫一个老，一些命令都不适用。心里真想来句mmp，最后还是硬着头皮上解决问题。

说实话，当时我在Windows服务器的实施与运维经验还没linux上丰富，现在想来完全是**工作让你不得不去适应**。

<H5 align=center><a href="https://blog.csdn.net/Tolove_dream">by 龙腾万里sky 原创不易，白嫖有瘾</a></H5>