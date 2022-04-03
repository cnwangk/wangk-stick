# 前言

本文主要介绍zabbix4.0在Redhat7系列的入门环境搭建，并记录搭建过程中的注意事项，偏向于实战。

距离我上次使用zabbix大概在3个月之前。当时也工作需要，公司用到了大数据看板需要配合zabbix做后台监控运维。

看过我之前发的文章，其实就会发现我写的基本上都是些与linux服务器相关的。基本上所有的环境都是Windows配合虚拟机使用linux发行版，比如Centos、Ubuntu还有国产化的银河麒麟以及统信UOS。

![](https://gitee.com/dywangk/img/raw/master/images/zabbix_proc.jpg)







# 正文

## 一、安装zabbix前的准备

### 1、软件环境

#### 1.1、linux服务器

推荐使用虚拟机+linux镜像，其次使用云服务器。我个人倾向Centos7或者Centos6，或者使用Ubuntu一样可行，选择自己熟悉的一款。

#### 1.2、数据库环境

推荐安装MySQL5.6（MariaDB也行）或者以上版本。MySQL的安装参考网上教程，这里不做过多介绍。

**可以参考菜鸟教程**：[https://www.runoob.com/mysql/mysql-install.html](https://www.runoob.com/mysql/mysql-install.html)

MariaDB是MySQL的开源社区版，由MySQL创始人开发维护，所以测试安装MariaDB也是一样的。

```bash
#安装MySQL
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
yum install mysql-server
```

```bash
#使用yum命令安装MariaDB
yum install mariadb-server mariadb 

MariaDB数据库的相关操作命令：
(注意：centos6版本可用service命令替换systemctl)
#启动MariaDB
systemctl start mariadb 

#停止MariaDB 
systemctl stop mariadb 

#重启MariaDB 
systemctl restart mariadb 

#设置开机启动 
systemctl enable mariadb  
```

**登录命令**

```bash
mysql -u root -p
```

**开放远程连接限制**

```bash
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
```

**修改用户密码**

```bash
set password for root@localhost=password('123456');
```



## 二、修改防火墙规则

既然使用了Redhat7系列，那就习惯使用systemd环境。

### 1、临时关闭防火墙

```bash
systemctl stop iptables.service 
```

### 2、加入zabbix到防火墙规则

加入zabbix-server与zabbix-agent规则时，**此时是在你已经安装好了zabbix服务为前提**。

通过命令查看zabbix服务

```bash
#查看服务
ps -aux | grep zabbix
ps -aux | grep zabbix_server
ps -aux | grep zabbix_agent
#或者
ps -ef | grep zabbix
#查看端口
netstat -tlunp | grep zabbix
```



**说明**：`--permanent`参数代表永久生效，不熟悉的命令，**建议使用**`firewall-cmd --help`查看**帮助命令**。

2.1、永久生效，加入zabbix-server与zabbix-agent

```bash
firewall-cmd --zone=public --add-service=zabbix-agent --permanent 
firewall-cmd --zone=public --add-service=zabbix-server --permanent 
```

2.2、开放80端口，zabbix前端访问默认使用80端口

```bash
firewall-cmd --zone=public --add-port=80/tcp --permanent 
```

2.3、额外开放10050与10051，监控使用到

```bash
firewall-cmd --zone=public --add-port=10050/tcp --permanent 
firewall-cmd --zone=public --add-port=10051/tcp --permanent 
```





## 三、安装zabbix

安装后zabbix目录文件

```bash
#查看安装目录
ls /etc/zabbix/
```



![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6_proc.jpg)

本人测试环境是Redhat系列Centos7.3配合MySQL5.6使用搭建zabbix监控系统。下面是官方文档，同样有中文版，如下：

[https://www.zabbix.com/documentation/4.0/zh/manual/installation/install_from_packages/rhel_centos](https://www.zabbix.com/documentation/4.0/zh/manual/installation/install_from_packages/rhel_centos)

### 1、zabbix-server服务安装

1.1、准备好官方提供的yum源

```bash
#编辑
vim /etc/yum.repos.d/zabbix.repo
#加入如下内容
[zabbix]
name=Zabbix Official Repository - $basearch
baseurl=http://repo.zabbix.com/zabbix/4.0/rhel/7/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591

[zabbix-non-supported]
name=Zabbix Official Repository non-supported - $basearch
baseurl=http://repo.zabbix.com/non-supported/rhel/7/$basearch/
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
gpgcheck=1
```



 **1.2、安装zabbix软件仓库**

 ```bash
 rpm -ivh http://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
 ```

**安装额外基础包**

```bash
yum-config-manager --enable rhel-7-server-optional-rpms
```

**1.3、安装zabbix-server**

```ba
yum install zabbix-server-mysql
```

### 2、zabbix-proxy安装

```bash
yum install zabbix-proxy-mysql
```

**安装 Zabbix 前端**

```bash
yum install zabbix-web-mysql
```

**导入数据**（MySQL数据库，事先创建好zabbix用户）

```bash
#对于zabbix-server
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
#对于zabbix-proxy
zcat /usr/share/doc/zabbix-proxy-mysql*/schema.sql.gz | mysql -uzabbix -p zabbix
```

**Zabbix server/proxy 配置数据库**

编辑zabbix_server.conf配置文件

```bash
vim /etc/zabbix/zabbix_server.conf
```

加入如下配置

```bash
#Zabbix
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=123456
```

**zabbix-server进程启用**

```bash
#设置开机自启
systemctl enable zabbix-server
#启动服务
systemctl start zabbix-server
#关闭服
systemctl stop zabbix-server
#禁止开机启动
systemctl disable zabbix-server
```



### 3、zabbix-agent服务安装

```bash
#安装zabbix-agent
yum install zabbix-agent
#设置开机自启
systemctl enable zabbix-agent
#启动
systemctl enable zabbix-agent
```

同时启动用`zabbix-server zabbix-agent httpd`

```bash
systemctl enable zabbix-server zabbix-agent httpd
```

### 4、创建组与用户

```bash
#组
groupadd --system zabbix
#用户
useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix 监控系统" zabbix
```

### 5、selinux配置(Redhat7系列)

解除selinux对zabbix的限制

```bash
setsebool -P httpd_can_connect_zabbix on
#如果数据库可以通过网络访问（在 PostgreSQL 情况下包括 'localhost')，您也需要允许 Zabbix 前端连接到数据库：
setsebool -P httpd_can_network_connect_db on
```

RHEL 7 之前的版本

```
setsebool -P httpd_can_network_connect on
setsebool -P zabbix_can_network on
```

待前端和 SELinux 配置完成后，**需要重新启动 Apache web 服务器**

```
systemctl restart httpd
```

**安装完zabbix后**，记得看**第二步的防火墙规则**，否则会影响前端的访问。

## 四、zabbix前端

### 1、登录zabbix前端

```bash
#IP地址换成你自己的本机或者远程IP
http://192.168.245.131/zabbix
```

**注意**：默认用户名是Admin，密码是zabbix。

### 2、界面介绍

首先建议将语言调成自己熟悉的，比如中文简体。

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E5%89%8D%E7%AB%AF%E8%AE%BE%E7%BD%AE%E4%B8%AD%E6%96%87_proc.jpg)



### 1、默认管理员界面

1.1、监测模块功能列表展示

- 仪表板、问题、概览、web监测、最新数据
- 图形、聚合图形、拓扑图、自动发现、服务

其实，配置好后，用的最多的还是监控模块的仪表板功能，通过添加图形化界面，实时监控动态。

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E5%89%8D%E7%AB%AF%E7%9B%91%E6%B5%8B%E6%A8%A1%E5%9D%97_proc.jpg)

1.2、资产记录模块功能列表

- 概览
- 主机

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E5%89%8D%E7%AB%AF%E8%B5%84%E4%BA%A7%E8%AE%B0%E5%BD%95%E6%A8%A1%E5%9D%97_proc.jpg)

1.3、报表模块功能列表

- 系统信息、可用性报表
- 触发器Top 100
- 审计、动作日志、警报

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E5%89%8D%E7%AB%AF%E6%8A%A5%E8%A1%A8%E6%A8%A1%E5%9D%97_proc.jpg)

1.4、配置模块功能列表

- 主机群组、模板、主机、动作
- 关联项事件、自动发现、服务

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E5%89%8D%E7%AB%AF%E9%85%8D%E7%BD%AE%E6%A8%A1%E5%9D%97_proc.jpg)

1.5、管理模块功能列表

- 一般、agent代理程序、认证、用户群组
- 用户、报警没接类型、脚本、队列

**值得注意的是，用户功能模块，可以配置多个用户，不同用户权限不一样**。

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E7%AE%A1%E7%90%86%E6%A8%A1%E5%9D%97_proc.jpg)

1.6、切换用户，**不同的用户（权限）看到的界面也会有所不同**，如下会介绍普通管理员看到的界面。

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E7%94%A8%E6%88%B7%E7%AE%A1%E7%90%86.png)

### 2、普通管理员界面

2.1、监测模块功能列表

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E6%99%AE%E9%80%9A%E7%AE%A1%E7%90%86%E5%91%98%E6%A3%80%E6%B5%8B%E6%A8%A1%E5%9D%97_proc.jpg)

2.2、资产记录模块功能列表

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E6%99%AE%E9%80%9A%E7%AE%A1%E7%90%86%E5%91%98%E8%B5%84%E4%BA%A7%E8%AE%B0%E5%BD%95%E6%A8%A1%E5%9D%97_proc.jpg)

2.3、报表模块功能列表

![](https://gitee.com/dywangk/img/raw/master/images/zabbix%E6%99%AE%E9%80%9A%E7%AE%A1%E7%90%86%E5%91%98%E6%8A%A5%E8%A1%A8%E6%A8%A1%E5%9D%97_proc.jpg)



此时，在进行对比，你会发现普通管理员监控到的界面功能相对比较少，大的模块也少了两个。

以上就是本文此次对zabbix监控系统入门做的一个简单总结。

当然，如果配合Java等后端开发语言进行使用，需要安装支撑Java的网关服务，官网也有介绍。



拥抱开源，今天推荐一款开源的终端管理工具Tabby，在github仓库可以搜索到。确实很方便，我的win powershell、cmd、git bash和ssh都可以在这一个终端中使用。

![](https://gitee.com/dywangk/img/raw/master/images/Tabby_proc.jpg)

<H5 align=center><a href="https://blog.csdn.net/Tolove_dream">by 龙腾万里sky  转载请标明出处！</a></H5>