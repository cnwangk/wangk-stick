国产适配linux银河麒麟V10下arm版本部署DM8

tips：安装过程仅供参考，具体因你的实际部署路径而定

# 前言

### 一、下载好对应的Linux版本的达梦数据库
DM8官网直通车：[https://www.dameng.com/view_61.html](https://www.dameng.com/view_61.html)

下载中心，需要注册登录
[https://www.dameng.com/ucenter/docs.html](https://www.dameng.com/ucenter/docs.html)
![在这里插入图片描述](https://img-blog.csdnimg.cn/3eabbe2a2f6c4210860e28496d0b6037.png?x-oss-process=,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)

**系统检测，参考官网技术文档**

```sql
#获取系统位数
getconf LONG_BIT
```

查询操作系统 release 信息，Redhat系列

```sql
#如果没安装对应的服务包，无法使用该命令
lsb_release -a
```

查询系统信息

```sql
cat /etc/issue
```

查询系统名称

```sql
uname -a
```

linux下检查操作系统限制
运行 `ulimit -a` 进行查询

官方文档建议如下设置
参数使用限制：

```sql
1.data seg size
data seg size (kbytes, -d)
```

建议用户设置为 1048576(即 1GB)以上或 unlimited(无限制)，此参数过小
将导致数据库启动失败。

```sql
2. file size
file size(blocks, -f)
```

建议用户设置为 unlimited(无限制)，此参数过小将导致数据库安装或初始化
失败。

```sql
3. open files
open files(-n)
```

建议用户设置为 65536 以上或 unlimited(无限制)。

```sql
4.virtual memory
virtual memory (kbytes, -v)
```

建议用户设置为 1048576(即 1GB)以上或 unlimited(无限制)，此参数过小将导致数据库启动失败。


检查系统内存，获取内存总大小

```powershell
grep MemTotal /proc/meminfo
```

获取交换分区大小

```powershell
grep SwapTotal /proc/meminfo
```

获取内存使用详情

```powershell
free
```

检查存储空间
查询目录可用空间

```powershell
df -h /mount_point/dir_name
```


如果/tmp 目录不能保证 1GB 的存储空间，用户可以扩展/tmp 目录存储空间或者通
过设置环境变量 DM_INSTALL_TMPDIR 指定安装程序的临时目录。具体命令如下所示:
以 BASH 为例：

```powershell
mkdir -p /mount_point/dir_name
```

```powershell
DM_INSTALL_TMPDIR=/mount_point/dir_name
export DM_INSTALL_TMPDIR
```


配置JAVA环境，无特殊需求忽略此步骤
#以 BASH 为例:

```powershell
vim /etc/profile
```

```powershell
export DM_JAVA_HOME=/mount_point/jdk_home_dir
```


arm架构银河麒麟V10 
数据库文件：

```powershell
#准备arm架构版本的
dm8_20200907_FTarm_kylin4_64_ent_8.1.1.126.iso
```


### 二、使用mount命令挂载准备好的iso镜像

```powershell
mount dm8_20200907_FTarm_kylin4_64_ent_8.1.1.126.iso  /mnt/data/dm8
```

赋予权限755

```powershell
#找到/mnt/data/dm8下的DMInstall.bin
chmod 755 ./DMInstall.bin 
```


### 三、使用命令进行安装

此步骤，官方不推荐使用root用户安装，采用新建用户授权形式。

创建安装用户

为了减少对操作系统的影响，用户不应该以 root 系统用户来安装和运行 DM。用户可以在安装之前为 DM 创建一个专用的系统用户。可参考以下示例创建系统用户和组(并指定用户 ID 和组 ID)，具体细节可向系统管理员咨询。

1. 创建安装用户组 dinstall

```powershell
groupadd -g 12349 dinstall
```

2. 创建安装用户 dmdba。

```powershell
useradd -u 12345 -g dinstall -m -d /home/dmdba -s /bin/bash dmdba
```

3. 初始化用户密码。

```powershell
passwd dmdba
```

4. 之后通过系统提示进行密码设置。
注意：创建安装系统用户完成后，安装手册之后的操作默认使用安装系统用户进行
操作。

5. 切换用户进行安装

```powershell
sudo dmdba
```

切回root用户，需要验证密码。


```powershell
./DMInstall.bin -i
```

如果当前操作系统中已存在 DM，将在终端弹出提示，输入选项：继续，将进行下一
步的命令行安装，否则退出命令行安装。


6. 选择语言

7. 验证key文件

8. 输入时区

9. 选择安装类型
1 ：典型安装
2 ：服务器
3 ：客户端
4 ：自定义

10. 选择安装路径

默认安装路径：
```bash
/opt/dmdbms
```

官方文档推荐安装路径

```bash
/home/dmdba/dmdbms
```

这里官方推荐安装路径，与之前推荐新建用户dmdba对应起来。
（个人推荐还是安装在/opt/下）

11. 静默安装

```bash
#配置文件全路径
./DMInstall.bin -q 
```

例如通过配置文件安装，需要配置auto_install.xml文件

```powershell
./DMInstall.bin -q /opt/dmdba/auto_install.xml
```

### 四、初始化数据库与注册服务
1、dminit命令初始化创建实例，初始化生成data数据文件。无论是安装MySQL、MariaDB、Oracle亦或是DM数据库都是需要注册服务与实例化的过程，最终生成配置文件以及data数据文件。

```powershell
./dminit PATH=/opt/dmdba/dmdbms/data
```

### 五、通过脚本命令注册达梦数据库服务
1.通过指定服务类型注册服务，或者手动添加

dm_service_installer.sh所在路径，linux_银河麒麟V10_arm版本

```powershell
/opt/dmdba/dmdbms/script/root
```
执行命令注册服务

```powershell
./dm_service_installer.sh  -t dmserver -dm_ini /opt/dmdba/dmdbms/data/DAMENG/dm.ini -p DMSERVER
```



### 六、测试启动DmServiceDMSERVER服务

```powershell
#如果报错请看第八步
systemctl start DmServiceDMSERVER
```


### 七、设置管理员口令模式
比如同时采用（2+4）口令长度不小于9且必须包含一个大写字母
设置系统默认口令策略，修改参数PWD_POLICY。

 1. 0： 无策略；
 2. 1： 禁止与用户名相同；
 3. 2： 口令长度不小于 9；
 4. 4：至少包含一个大写字母（A-Z）；
 5. 8 ：至少包含一个数字（0－9）；
 6. 16：至少包含一个标点符号（英文输入法状态下，除―和空格外的所有符号；若为其他数字，则表示配置值的和，如 3
＝1+2,表示同时启用第 1 项和第 2 项策略。当COMPATIBLE_MODE=1 时，PWD_POLICY 的实际值均为 0

**一般推荐2+4的组合设置密码策略**



### 八、排查错误
启动DmServiceDMSERVER，需要找到对应的ini文件，没有实例化导致报错，是因为达梦数据库默认去/opt/dmdbms/下找dm.ini文件

```powershell
root@localhost]# ./DmServiceDMSERVER start
Starting DmServiceDMSERVER: 上一次登录：二 5月 11 22:59:33 CST 2021
                                                           [ FAILED ]
Invalid input %INI_PATH%
格式: ./dmserver [ini_file_path] [-noconsole] [mount] [path=ini_file_path] [dcr_ini=dcr_path]
```
**例如:** 

```powershell
./dmserver path=/opt/dmdbms/bin/dm.ini
./dmserver /opt/dmdbms/bin/dm.ini
```


**关键字             说明**

--------------------------------------------------------------------------------
path              		 dm.ini绝对路径或者dmserver当前目录的dm.ini
dcr_ini            		如果使用css集群环境，指定dmdcr.ini文件路径
-noconsole         	以服务方式启动
mount              	配置方式启动
help               		打印帮助信息


解决方案可以通过dminit初始化创建实例，生成data文件
#执行如下命令
1、初始化

```powershell
./dminit PATH=/opt/dmdba/dmdbms/data
```


2、通过指定服务类型注册服务
2.1、dm_service_installer.sh所在路径，linux_银河麒麟_arm版本

```powershell
/opt/dmdba/dmdbms/script/root/
```

2.2、注册服务

进入对应脚本目录 

```bash
cd /opt/dmdba/dmdbms/script/root/
```

执行命令

```powershell
./dm_service_installer.sh  -t dmserver -dm_ini 

/opt/dmdba/dmdbms/data/DAMENG/dm.ini -p DMSERVER
```


3、通过服务脚本文件注册服务

```powershell
./dm_service_installer.sh -s /opt/dmdba/dmdbms/bin/DmServiceDMSERVER
```

4、通过命令启动服务

```powershell
systemctl start DmServiceDMSERVER
```


### 九、手动注册服务（官方文档提供）
以下步骤将以 Red Hat Enterprise Linux 6 for x86-64 系统为例，由于不同
操作系统系统命令不尽相同，具体步骤及操作请以本机系统为准，具体细节可向系统管理员
咨询。

1、拷贝服务模板文件（DmService）到系统服务目录（/etc/rc.d/init.d），并将
新文件命名为 DmServiceDMSERVER。

init.d环境

```powershell
cp /opt/dmdba/dmdbms/bin/service_template/DmService
/etc/rc.d/init.d/DmServiceDMSERVER

chmod 755 /etc/rc.d/init.d/DmServiceDMSERVER
```

2、修改服务脚本（/etc/rc.d/init.d/DmServiceDMSERVER）配置。
#修改 DmServiceDMSERVER
INI_PATH=INI 路径


3、创建启动服务的连接

```powershell
ln -s /etc/rc.d/init.d/DmServiceDMSERVER /etc/rc.d/rc0.d/K02DmServiceDMSERVER
ln -s /etc/rc.d/init.d/DmServiceDMSERVER /etc/rc.d/rc1.d/K02DmServiceDMSERVER
ln -s /etc/rc.d/init.d/DmServiceDMSERVER /etc/rc.d/rc2.d/S98DmServiceDMSERVER
ln -s /etc/rc.d/init.d/DmServiceDMSERVER /etc/rc.d/rc3.d/S98DmServiceDMSERVER
ln -s /etc/rc.d/init.d/DmServiceDMSERVER /etc/rc.d/rc4.d/S98DmServiceDMSERVER
ln -s /etc/rc.d/init.d/DmServiceDMSERVER /etc/rc.d/rc5.d/S98DmServiceDMSERVER
ln -s /etc/rc.d/init.d/DmServiceDMSERVER /etc/rc.d/rc6.d/K02DmServiceDMSERVER
```

如果没有dm.ini文件,新建一份


4、启动与停止服务

```powershell
#停止服务
service DmServiceDMSERVER stop
```

```powershell
#启动服务
service DmServiceDMSERVER start
```


4.1、systemd 环境
以下步骤将以 Red Hat Enterprise Linux 7 for x86-64 系统为例，由于不同
操作系统系统命令不尽相同，具体步骤及操作请以本机系统为准，具体细节可向系统管理员
咨询。

4.2、拷贝服务模板文件（DmService）到目录（/opt/dmdbms/bin），并将新文件命
名为 DmServiceDMSERVER。

```powershell
cp /opt/dmdba/dmdbms/bin/service_template/DmService
/opt/dmdba/dmdbms/bin/DmServiceDMSERVER

chmod 755 /opt/dmdba/dmdbms/bin/DmServiceDMSERVER
```

4.3、修改服务脚本（/opt/dmdbms/bin/DmServiceDMSERVER）配置
修改 DmServiceDMSERVER，手动指定dm.ini路径
INI_PATH=INI 路径


4.4、创建系统服务配置文件

```bash
/usr/lib/systemd/system/DmServiceDMSERVER.service
```

文件内容，如下所示：

```powershell
[Unit]
Description=DmServiceDMSERVER
[Service]
Type=forking
PIDFile=/opt/dmdba/dmdbms/bin/pids/DmServiceDMSERVER.pid
ExecStart=/opt/dmdba/dmdbms/bin/DmServiceDMSERVER start
ExecStop=/opt/dmdba/dmdbms/bin/DmServiceDMSERVER stop
PrivateTmp=true
[Install]
WantedBy=multi-user.target
```


4.5、在使用服务前，需要启用服务。相关命令如下所示:

centos7版本开始推荐使用systemctl命令

```powershell
#启用服务，设置开机自弃
systemctl enable DmServiceDMSERVER
```

```powershell
#停止服务
systemctl stop DmServiceDMSERVER
```

```powershell
#启动服务
systemctl start DmServiceDMSERVER
```


4.6、卸载服务
服务卸载脚本文件为 

```bash
dm_service_uninstaller.sh
```

用户可以使用服务卸载脚本
删除已经注册成操作系统服务的 DM 服务脚本，参数如下表：

4.7、删除服务参数
标志 参数  说明
-n 服务名  指定服务名，删除指定的操作系统随机启动服务
-h 帮助

使用方法：
操作之前，需要使用root系统用户登录或切换至root系统用户。
删除指定的操作系统服务。假设存在DM的操作系统随机启动服务

DmServiceDMSERVER，命令如下：

```powershell
./dm_service_uninstaller.sh -n DmServiceDMSERVER
```

大部分是参考DM8官方文档进行操作的，安装后也会在部署的doc目录下生成相关文档。部署过两次，就将安装的过程记录下来，以备不时之需。

持续优化更新中...


# 开心一刻
> 只要你找个好老板，找一份好工作，好好工作。
> 辛勤工作，早起晚归，经常加班。
> 早晚有一天，这个老板，会更有钱。换更好的车，换更好的房。
> 再给我一个机会，我想回到昨天，因为我安眠药吃多了。

上面的引用就当玩笑话，乐呵乐呵。创作乐无边，学而思有境。你会发现，了解的越多，不了解的越多。好了，到此为止就是此篇文章的全部内容了，**能看到这里的都是帅哥靓妹啊**！！！善于总结，其乐不穷。**好记性不如烂笔头**，多收集自己第一次尝试的成果，收获也颇丰。**你会发现，自己的知识宝库越来越丰富**。白嫖有瘾，原创不易，快乐阅读！如果感觉文章还行，你的一键三连，是博主最大的创作动力。


<H3 align=center><a href="https://blog.csdn.net/Tolove_dream">by 龙腾万里sky 原创不易，白嫖有瘾</a></H3>
