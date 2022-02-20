

# 前言

今天给大家带来的是linux中比较实用的命令scp。善用小技巧，解决工作中的痛点。
掌握一门好的技术或者说一门好的艺术，最快捷的方式就是融入到工作中。

在工作的不断鞭策之下，我其实也想偷偷懒，有时候觉得怎样简单快捷怎样来。在某种特定的工作环境下，有些操作被限制死了，只能用传统的方式传输（比如定制的商业加密U盘、光盘刻录）。当你了解实际情况后，可能有更优解，你会寻求其它的突破口或者折中方案。

夸张的说法，我用了1分钟熟悉了scp的用法，并直接运用于工作当中。然而，我教同事使用，他却花了远远不止10倍的时间。其中的小窍门，你知道是为啥吗？我的回答是：善用系统提供的帮助工具或者提示。

![](https://gitee.com/dywangk/img/raw/master/images/%E5%AE%89%E5%85%A8%E5%BF%AB%E6%8D%B7_proc.jpg)

# 正文

## 一、SCP命令简介

在Redhat系列可以使用帮助命令：`man scp`，快速上手，掌握使用方法。

如下图使用`scp`或者`man scp`命令：

![](https://gitee.com/dywangk/img/raw/master/images/man_scp%E5%91%BD%E4%BB%A4.png)

### 1、简介

- **NAME**：scp — 安全复制(远程文件复制程序)

- scp 在网络中的主机间进行文件复制。 它用 ssh(1) 来传输及验证数据，提供与 ssh(1)相同的安全保护。 它不象 rcp(1), scp 会根据需要询问口令。 在任何文件名中都可以包含主机名和用户名，用来指定从/向该主机复制此文件。

- Linux scp 命令主要用于 Linux 之间复制文件和目录。
- scp 是 secure copy 的缩写, scp 是 linux 系统下基于 ssh 登陆进行安全的远程文件拷贝命令。
- scp 是加密的，rcp 是不加密的，scp 是 rcp 的加强版。

### 2、前世今生

- 作者

  Timo Rinne <tri@iki.fi> 和 Tatu Ylonen <ylo@cs.hut.fi>

- 起源

  scp 基于University of California BSD 的 rcp(1) 源代码

- 参考 
  rcp(1)，sftp(1)， ssh(1)， ssh-add(1)，ssh-agent(1)，ssh-keygen(1)，ssh_config(5)，sshd(8)

  



## 二、测试环境搭建

### 1、排除干扰因素

- 防火墙规则
- 所在用户的scp访问权限
- 默认端口是否变更



### 2、建议

可以租多台云服务器测试，按时计费那种（腾讯云或者阿里云）。

个人建议：采用VMware虚拟机搭建两台linux服务环境进行测试学习。或者安装git，使用git bash测试scp传输文件。有人会问，你为啥不直接用WinSCP或者FileZilla传输。生活在于折腾，消磨时间呗。从Windows到linux也是一样的，当然这是本机搭建的VMware虚拟环境网络是打通的。不要问我为什么，问就是省money呗。

### 3、准备环境

- VMware虚拟机工具
- Redhat系列、Ubuntu或者国产银河麒麟
- 系统环境：X86平台
- ssh远程工具**xshell**、SecureCRT、putty以及**Git Bash**等等，只要支持ssh远程连接的工具。

这里可以看看利用Git Bash工具，从Windows本地传文件到搭建的linux服务器上。

![](https://gitee.com/dywangk/img/raw/master/images/%E6%B5%8B%E8%AF%95%E6%9C%AC%E5%9C%B0win%E4%BC%A0%E8%BE%93%E5%88%B0VMware%E6%90%AD%E5%BB%BA%E7%9A%84linux_proc.jpg)




## 三、SCP命令详细操作说明

### 1、语法

```powershell
usage: scp [-12346BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file]
           [-l limit] [-o ssh_option] [-P port] [-S program]
           [[user@]host1:]file1 ... [[user@]host2:]file2
```



**简单来看**：

scp [可选参数] 本地文件 目标目录

```powershell
scp /root/av/local_file.av  remote_username@ip:/root/av
```

scp [可选参数] 本地目录 目标目录

```powershell
scp -r /root/av/  remote_username@ip:/root/
```







### 2、参数解析

默认scp传输情况下，会显示传输的速率以及进度。

只介绍部分，具体可以参考官方文档。常用的、重要的也就那么几个。

| 参数             | 作用                                                         |
| ---------------- | ------------------------------------------------------------ |
| -1               | 强制scp命令使用协议ssh1                                      |
| -2               | 强制scp命令使用协议ssh2                                      |
| -4               | 强制scp命令只使用IPv4寻址                                    |
| -6               | 强制scp命令只使用IPv6寻址                                    |
| -B               | 使用批处理模式（传输过程中不询问传输口令或短语）             |
| -C               | 允许压缩。（将-C标志传递给ssh，从而打开压缩功能）            |
| **-p**           | **保留原文件的修改时间，访问时间和访问权限**                 |
| -q               | 不显示传输进度条                                             |
| **-r**           | **递归复制整个目录**                                         |
| -v               | 详细方式显示输出。scp和ssh(1)会显示出整个过程的调试信息。这些信息用于调试连接，验证和配置问题 |
| -c cipher        | 以cipher将数据传输进行加密，这个选项将直接传递给ssh          |
| -F ssh_config    | 指定一个替代的ssh配置文件，此参数直接传递给ssh               |
| -i identity_file | 从指定文件中读取传输时使用的密钥文件，此参数直接传递给ssh    |
| -l limit         | 限定用户所能使用的带宽，以Kbit/s为单位                       |
| -P port          | **注意此处是大写P**, port是指定数据传输用到的端口号          |
| -S program       | 指定加密传输时所使用的程序。此程序必须能够理解ssh(1)的选项   |



### 3、应用场景

一点小建议：如果不是很理解操作的意义。你可以这样看待：本机到服务器或者是服务器到到服务器，将其都看作是仓库，我需要将一壶油或一箱香飘飘者是转移到另一个仓库（目的地）。单件的时候，直接传一个过去；量大的时候，将其所在目录打包传输过去。操作方便快捷，只需要简单的几行命令搞定文件传输。



**命令格式介绍**

```powershell
#复制文件格式
scp local_file remote_username@remote_ip:remote_directory 
#或者 
scp local_file remote_username@remote_ip:remote_file 
#或者 
scp local_file  remote_ip:remote_directory 
#或者 
scp local_file remote_ip:remote_file 
```



**复制目录命令格式**

```powershell
#复制命令格式
scp -r local_directory remote_username@remote_ip:remote_directory 
#或者 
scp -r local_directory remote_ip:remote_directory 
```



#### 3.1、本地到远程

1、准备了两台Centos7服务器，已经设置好了静态IP

**采用虚拟机搭建环境**

- ip：192.168.245.147
- ip：192.168.245.131



**2、在147服务器上准备测试内容**

下面举例子的内容，啊啊啊就不要多幻想哈。只是想骚一骚而已，哈哈哈！！！

程序员都懂的，形象生动的sex教育片。

```powershell
#新增一个av目录
mkdir /root/av
#新增cangls文件并添加内容
echo "cangls av" > /root/av/cangls.av
```



3、**指定用户名**

个人推荐使用指定用户名，方便快捷。

**a、传输文件**

注意：**第一次使用scp命令时会提示验证，输入yes即可通过**。

```powershell
#切记传输文件时，目标目录后面不要加/,否则会提示拒绝,这个习惯至今没改过来
scp /root/av/cangls.av  root@192.168.245.131:/root
```

**传文件时，root目录后面的 / 需要去掉，传输完成如下**

![](https://gitee.com/dywangk/img/raw/master/images/%E4%BC%A0%E8%BE%93%E5%AE%8C%E6%88%90.png)



**b、验证**

![](https://gitee.com/dywangk/img/raw/master/images/%E4%BC%A0%E8%BE%93%E6%88%90%E5%8A%9F.png)

**传输文件并指定文件名**

```powershell
#传输文件，指定文件名，注意看目标文件名改了方便区别
scp /root/av/cangls.av  root@192.168.245.131:/root/test.av
```

![](https://gitee.com/dywangk/img/raw/master/images/%E4%BC%A0%E8%BE%93%E6%96%87%E4%BB%B6%E6%8C%87%E5%AE%9A%E6%96%87%E4%BB%B6%E5%90%8D.png)

**指定文件名并验证**

![](https://gitee.com/dywangk/img/raw/master/images/%E6%8C%87%E5%AE%9A%E6%96%87%E4%BB%B6%E5%90%8D%E9%AA%8C%E8%AF%81.png)



**传输目录**：加上参数-r

```powershell
#传输目录，需要加上-r参数
scp -r /root/av/  root@192.168.245.131:/root/
```

![](https://gitee.com/dywangk/img/raw/master/images/%E4%BC%A0%E8%BE%93%E7%9B%AE%E5%BD%95%E5%8A%A0%E4%B8%8A-r%E5%8F%82%E6%95%B0.png)

**传输目录，到目标服务器验证**

![](https://gitee.com/dywangk/img/raw/master/images/%E9%AA%8C%E8%AF%81%E7%9B%AE%E5%BD%95%E5%AE%8C%E6%95%B4%E4%BC%A0%E8%BE%93.png)

4、不指定用户名

输入的时候需要手动输入用户名和密码。

**传输文件并沿用原始文件名**

```powershell
#传输文件，沿用原始文件名
scp /root/av/cangls.av  192.168.245.131:/root
```

**传输文件，指定文件名**

```powershell
#传输文件，指定文件名，注意看目标文件名改了方便区别
scp /root/av/cangls.av  192.168.245.131:/root/test.av
```

**传输目录，需要加上-r参数**

```powershell
#传输目录，需要加上-r参数
scp -r /root/av/  192.168.245.131:/root/
```



#### 3.2、远程到本地

从远程复制到本地，说白了就是需要知道远程的服务器IP以及用户名密码，反过来操作即可从远程取货物。换个角度思考就是原本从A端传到B端，此时从B端传到A端。前提是两端互通，不然会只进不出。



1、从**远程取cangls.av文件到本地**的root目录下

```powershell
scp root@192.168.245.147:/root/av/cangls.av /root
```

![](https://gitee.com/dywangk/img/raw/master/images/%E4%BB%8E%E8%BF%9C%E7%A8%8B%E4%BC%A0%E6%96%87%E4%BB%B6%E5%88%B0%E6%9C%AC%E5%9C%B0.png)

2、从**远程取av目录到本地**的root目录下

```powershell
scp -r root@192.168.245.147:/root/av/ /root/
```

![](https://gitee.com/dywangk/img/raw/master/images/%E4%BB%8E%E8%BF%9C%E7%A8%8B%E5%8F%96%E7%9B%AE%E5%BD%95%E5%88%B0%E6%9C%AC%E5%9C%B0.png)



### 4、注意事项

如果远程服务器防火墙有为scp命令设置了指定的端口，我们需要使用 -P 参数来设置命令的端口号，命令格式如下：
scp 命令使用指定端口号 6022

```powershell
#从远程服务器获取文件到本地，指定端口
scp -P 6022  remote@ip:/usr/local/av.sh  /root
```

**使用scp需要具备读取文件的权限，如果没有权限则无法传输**。



<H5 align=center><a href="https://blog.csdn.net/Tolove_dream">by 龙腾万里sky 原创不易，白嫖有瘾</a></H5>