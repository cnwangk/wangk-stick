
# 前言
MySQL主从复制实战。以前总听说集群之类的，从来没有好好思考过。如今有空余时间，终于亲自搭建环境得以实现MySQL主从复制。

从搭建虚拟机环境，以及安装Redhat系列的centos7.5服务器，部署MySQL5.6环境。嘿嘿，测试使用虚拟机搭建美滋滋。当然你也可以花money，多建几台云服务器实现集群环境。


# 正文
MySQL主从复制实战

## 主要使用到的环境说明
![在这里插入图片描述](https://img-blog.csdnimg.cn/b4f0f1eb4dae4cc0a6d57b0507ab1fe6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)

**数据库版本**

```powershell
#使用centos7.3初始安装就可选择安装所需基本环境
5.6.51-log MySQL Community Server (GPL)
```

**操作系统**

```powershell
linux for centos7.3  or centos7.5
```

**测试环境**：VMware12虚拟机搭建三台centos7.3服务器
**服务器IP地址**：

```powershell
IP_MASTER：192.168.245.131
IP_SLAVE：192.168.245.132
IP_SLAVE：192.168.245.132
```
**搭建服务器环境参考文章**：[VMware12配合使用Centos7搭建Linux开发环境](https://blog.csdn.net/Tolove_dream/article/details/116085467)

**测试模型**：一主两从，即（master、slave、slave）
**知识宝库**：VMware的简单使用，Linux基本命令、MySQL数据库CRUD
**tips**：VMware8亦可搭建，解决内存过小，这个小伙子有点东西啊！
**目标实现**：MySQL主从复制


## 一、binlog与relay-log

### 1.1 binlog
**作用**：记录数据库改变的数据，在第四步可以进行验证。

**查看binlog日志** 

```sql
/** 查看binlog日志 **/
SHOW BINLOG EVENTS IN 'mysql-bin.000004'
```

**mysqlbinlog查看binlog日志** 

```sql
/** mysqlbinlog查看binlog日志 **/
mysqlbinlog --short-form --force-if-open --base64-output=never /var/lib/mysql/mysql-bin.000004 //对应你MySQL的安装目录
```

### 1.2 relay-log
**作用**：连接master与slave节点的核心

```powershell
01 master.info
02 relay-log.info
```

### 1.3 参考文章（理论知识详解）
第一篇对binlog与relay-log讲解很透彻（个人理解）
[https://www.cnblogs.com/ilovejaney/p/13649345.html](https://www.cnblogs.com/ilovejaney/p/13649345.html)
第二篇讲解整体性更好
[https://juejin.cn/post/6967224081410162696?share_token=a491f9eb-ff33-4ea3-a171-0ad2d878eca8](https://juejin.cn/post/6967224081410162696?share_token=a491f9eb-ff33-4ea3-a171-0ad2d878eca8)

## 二、master节点配置
### 2.1 master节点配置
MySQL数据库配置文件my.cnf

```powershell
vim /etc/my.cnf
```

加入配置
```sql
[mysqld]
#开启binlog
log-bin=mysql-bin
#不与其它从节点重复即可
server-id=101
#需要同步的数据，如果不配置则同步全部
binlog-do-db=test_db
#binlog日志保留的天数，清除超过10天的日志；防止日志文件过大，导致磁盘空间不足
expire-logs-days=10
#开启混合模式
binlog_format=mixed
innodb_file_per_table=ON
skip_name_resolve=ON
```

### 2.2 重启mysql

```powershell
#readhat7系列使用方式
systemctl restart mysql
```

### 2.3 通过命令查看主节点状态

```sql
show master status\G;
```

注意查看：master_log_pos的值，这点很重要，master与搭建集群的两个slave节点保持一致。

### 2.4 授权slave节点账号
关联授权搭建的两个slave子节点

```sql
#关联授权搭建的两个slave子节点
GRANT REPLICATION SLAVE ON *.* TO 'root'@'192.168.245.132' IDENTIFIED BY '123456';
```

```sql
#关联授权搭建的两个slave子节点
GRANT REPLICATION SLAVE ON *.* TO 'root'@'192.168.245.133' IDENTIFIED BY '123456';
```

刷新权限

```sql
#刷新权限
flush privileges;
```

### 2.5 查看验证
显示查看日志

```sql
#显示查看日志
show global variables like '%log%';
```

显示查看服务

```sql
#显示查看服务
show global variables like '%server%';
```

## 三、slave节点配置
### 3.1 slave节点配置
MySQL数据库配置文件my.cnf

```powershell
#slave01（从节点配置）
vim /etc/my.cnf
```

```sql
[mysqld]
#不与主节点以及其它从节点重复即可
server-id=102
```

### 3.2 登录mysql设置

```sql
mysql -uroot -p
```

输入命令如下

```sql
CHANGE MASTER TO
MASTER_HOST='192.168.245.131',//MASTER主节点IP
MASTER_USER='root',//创建的用户
MASTER_PASSWORD='123456',//用户密码
MASTER_LOG_FILE='mysql-bin.000001',//MASTER主机binlog日志名称，必须是最新的一个
MASTER_LOG_POS=120,//binlog日志偏移量，对应master节点的
master_port=3306;/端口号
```

### 3.3 开启中继日志

```sql
[mysqld]
server-id=102 #必须
relay-log=relay-log #必须
relay-log-index=relay-log.index #必须
innodb_file_per_table=ON #非必须
skip_name_resolve=ON #非必须
```

### 3.4 辅助操作
查看slave子节点状态

```sql
#查看slave子节点状态
show slave status\G;
```

启动slave节点

```sql
#启动slave节点
start slave;
```

关闭slave节点

```sql
#关闭slave节点
stop slave;
```

### 3.5 slave02（从节点配置）
修改MySQL从节点配置文件
```powershell
vim /etc/my.cnf
```

```sql
[mysqld]
#不与主节点以及其它从节点重复即可
server-id=103
```

查看slave子节点状态

```sql
#查看slave子节点状态
show slave status\G;
```

启动slave节点

```sql
#启动slave节点
start slave;
```


## 四、创建表以及新增数据进行验证

### 4.1 创建数据库用户
建议使用SQLyog工具创建用户，比较方便。

链接：[ https://pan.baidu.com/s/11gIlZKxoTG5BCCcoXdVJRg](https://pan.baidu.com/s/11gIlZKxoTG5BCCcoXdVJRg) 提取码: ntu7

### 4.2 创建表

```sql
/** 创建测试表GIRL **/
CREATE TABLE `GIRL` (
  `ID` varchar(64) CHARACTER SET utf8 NOT NULL,
  `GIRE_NAME` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `GIRL_AGE` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `CUP_SIZE` varchar(2) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin
```

### 4.3 生成测试数据

```sql
/** 插入测试数据 **/
insert into GIRL values('tolove16B','梦梦','16','B');
```



### 4.4 采用SQLylog工具验证
**master节点插入测试数据**
![在这里插入图片描述](https://img-blog.csdnimg.cn/267f0cde8fb84b08ba10885ef226dc8a.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)

**master节点binlog日志验证**
![在这里插入图片描述](https://img-blog.csdnimg.cn/1171a1cb58cb4ccf89f43c155e7be038.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)
**slave_check_RELAYLOG（133服务器）**
![在这里插入图片描述](https://img-blog.csdnimg.cn/65093ffc14f447389d1409f724f24261.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


132_slave_insert_data_girl同步数据
![在这里插入图片描述](https://img-blog.csdnimg.cn/e3879a0a4d994b55bbab91d63ec0ac2a.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


133_slave_check_RELAYLOG日志
![在这里插入图片描述](https://img-blog.csdnimg.cn/7e2c75a6733a4db0907e4062191a1aaa.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


133_slave_同步数据
![在这里插入图片描述](https://img-blog.csdnimg.cn/635b955eec404eeaa64fa2a4d42df58e.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)



## 五、排查问题
### 5.1 error 1236
**master_log_pos与从节点不一致导致error 1236**
![在这里插入图片描述](https://img-blog.csdnimg.cn/19ebc56a514245fba120997f467d81f8.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)
**分析日志：position日志偏移量与master节点不一致**
设置的master_log_pos发生改变，导致position不一致，出现无法同步（报：error 1236）
![在这里插入图片描述](https://img-blog.csdnimg.cn/79dfcf85f972466c91740a83a132a17b.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


**slave节点正常状态参考**

*注意：我截图上的是后期优化处理过的，所以看到的pos和上面的不一致*
![在这里插入图片描述](https://img-blog.csdnimg.cn/4ccd9a581e494d7d9b990d3edc83f052.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


### 5.2 解决问题
通过如下设置保持与master节点一致
首先关闭slave节点

```sql
stop slave
```

查看master节点日志偏移量

```sql
show master status\G;
```

在slave节点修改日志偏移量与master一致

```sql
change master to master_log_file ='mysql-bin.000005',master_log_pos=950;
```

最后启动slave节点

```sql
start slave
```

### 5.3 数据库授权远程登录
5.3.1 授权命令
```sql
GRANT ALL PRIVILEGES ON *.* TO '你的数据库用户名'@'单个ip或者%表示所有' IDENTIFIED BY '你的数据库连接密码' WITH GRANT OPTION;
```

```sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
```

5.3.2 修改用户密码：
```sql
set password for root@localhost=password('123456');
```


### 5.4 防火墙问题
5.4.1 本次实战中使用到的是centos7，默认安装的是firewalld
5.4.2 临时关闭防火墙：
```powershell
systemctl stop firewalld.service
```

5.4.3 实际工作中推荐需要使用哪些端口采取开放，比如开放MySQL默认的3306：
公共区域设置开放3306端口永久生效（--permanent）：

```powershell
firewall-cmd --zone=public --add-port=3306/tcp --permanent
```

操作完记住重启或重载：

```powershell
firewalld-cmd --reload
```

移除：
```powershell
firewall-cmd --zone=public --remove-port=3306/tcp --permanent
```

查看是否开放：
```powershell
firewall-cmd --zone=public --query-port=3306/tcp
```
### 5.5 连接工具
推荐使用Navicat和SQLyog可视化工具。
链接: https://pan.baidu.com/s/11gIlZKxoTG5BCCcoXdVJRg 提取码: ntu7
SQLyog官网下载
https://sqlyog.en.softonic.com/


## 六、实现MySQL主从复制
### 6.1 分析模型
分析模型：一主一从，一主多从，多主一从

### 6.1.1 一主一从模型：master->slave
![在这里插入图片描述](https://img-blog.csdnimg.cn/9421b86c2f2b4519a0e7cc6216ef5693.png#)

	
### 6.1.2 一主多从
在slave节点再配置slave缓解master服务器压力
![在这里插入图片描述](https://img-blog.csdnimg.cn/6a6ea12e0dbe4fb5a07a5f2b683b8c3f.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_18,color_FFFFFF,t_70,g_se,x_16#)


### 6.1.3 多主一从
![在这里插入图片描述](https://img-blog.csdnimg.cn/0058c7bfdb584e039ae7b0bd0c6a12a0.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_18,color_FFFFFF,t_70,g_se,x_16#)


### 6.1.4 特例：主-主复制
（每一个主既是从又是主）
![在这里插入图片描述](https://img-blog.csdnimg.cn/3b12ec87b3894e54ac2b0d222ef65cc7.png#)

### 6.1.5 使用SQLylog操作验证
分别登陆三台数据库服务器（推荐SQLylog工具）
同时登陆xshell工具连接查看三台服务器状态（推荐使用xshell或者SecureCRT）

```powershell
ip:192.168.245.131 //master
```

数据库：test_db //与master节点配置单一用户对应
数据库表：GIRL

```powershell
ip:192.168.245.132 //slave
```

master节点创建GIRL表，slave同步创建

```powershell
ip:192.168.245.133 //slave
```

master节点创建GIRL表，slave同步创建

tips：如果想实现主-主同步，则需要在其它两台配置数据库用户关联授权，参考第二步。
	  我并没有验证主-主同步，嘿嘿，当然你可以私下验证哟！


## 七、附件（搭建环境）
### 7.1 虚拟机搭建环境
**搭建服务器环境参考文章**：[VMware12配合使用Centos7搭建Linux开发环境](https://blog.csdn.net/Tolove_dream/article/details/116085467)

7.1.1 搭建虚拟机环境
![在这里插入图片描述](https://img-blog.csdnimg.cn/5f71fb1bf7a541659167e279e64a9c1f.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


7.1.2 虚拟机服务器配置
![在这里插入图片描述](https://img-blog.csdnimg.cn/a1c23c5687f744b8baba899c2cfb0122.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


### 7.2  xshell远程连接

7.2.1  使用xshell远程连接
![在这里插入图片描述](https://img-blog.csdnimg.cn/870c93fdf05544f58019209b9fd6d940.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)



### 7.3 搭建linux环境 
准备三台MySQL服务器配置主从复制（master：131，slave：132，slave：133）
![在这里插入图片描述](https://img-blog.csdnimg.cn/55f2fb392b7f4685ad41a24b41ae5bc2.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)

131 master主节点my.cnf配置
![在这里插入图片描述](https://img-blog.csdnimg.cn/7e4ac3f916084c32bdc3d3d347449790.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


131 验证master节点log_bin开启
![在这里插入图片描述](https://img-blog.csdnimg.cn/f8d6c4bac4244a9590bafcca13d67534.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


131 show_master_status查看状态（注意：此时master的pos为120）
![在这里插入图片描述](https://img-blog.csdnimg.cn/d15885b813824b98b49461c8e9fb1961.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


131查看主节点master的server服务（131服务器）
![在这里插入图片描述](https://img-blog.csdnimg.cn/ecee6f893de949d894e1cb38c7f6f39b.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


131查看主节点binlog日志所在目录（131服务器）
![在这里插入图片描述](https://img-blog.csdnimg.cn/e32b155a20b543e8a3db6c9c63a272df.png#)



start_slave启动从节点132（此时master的pos为120，没对应上导致slave无法读取）
![在这里插入图片描述](https://img-blog.csdnimg.cn/19ebc56a514245fba120997f467d81f8.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)
![在这里插入图片描述](https://img-blog.csdnimg.cn/79dfcf85f972466c91740a83a132a17b.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


参考**步骤五排查问题**进行解决
在slave节点修改日志偏移量与master一致，master_log_file对应先查出主节点最新的：

```sql
show master status\G;
```
**查看此时master的pos为120**

![在这里插入图片描述](https://img-blog.csdnimg.cn/c477973816274cbbb448fd207cc7567a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

**此时设置master_log_pos=120**
```sql
change master to master_log_file ='mysql-bin.000001',master_log_pos=120;
```
**正常slave节点读取_IO_SQL_Running为YES，如下图**
![在这里插入图片描述](https://img-blog.csdnimg.cn/4ccd9a581e494d7d9b990d3edc83f052.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)

**slave_mysql_log（132服务器对应的slave节点）**
![在这里插入图片描述](https://img-blog.csdnimg.cn/1fada42a85e34709aab98c0c042aa647.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)

**启动从节点slave（对应slave节点133服务器）**

```sql
/**（此时master的pos为120，没对应上导致slave无法读取）
参考132服务器正常状态，修改pos对应上master节点 **/

start slave
```

**slave节点MySQL日志（slave节点对应133服务器）**
![在这里插入图片描述](https://img-blog.csdnimg.cn/9accbacee2144cabab2b78ff23723f78.png#)

132开启从节点中继日志
![在这里插入图片描述](https://img-blog.csdnimg.cn/d4d77ff463b043b783ccaf03b4c838f2.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


### 7.4 采用SQLylog工具进行测试
131_master_插入测试数据
![在这里插入图片描述](https://img-blog.csdnimg.cn/267f0cde8fb84b08ba10885ef226dc8a.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)

131_master_binlog_日志验证
![在这里插入图片描述](https://img-blog.csdnimg.cn/1171a1cb58cb4ccf89f43c155e7be038.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)
132_slave_check_RELAYLOG
![在这里插入图片描述](https://img-blog.csdnimg.cn/65093ffc14f447389d1409f724f24261.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


132_slave_insert_data_girl同步数据
![在这里插入图片描述](https://img-blog.csdnimg.cn/e3879a0a4d994b55bbab91d63ec0ac2a.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


133_slave_check_RELAYLOG日志
![在这里插入图片描述](https://img-blog.csdnimg.cn/7e2c75a6733a4db0907e4062191a1aaa.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


133_slave_同步数据
![在这里插入图片描述](https://img-blog.csdnimg.cn/635b955eec404eeaa64fa2a4d42df58e.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#)


**持续更新优化中...**





# 开心一刻
> 只要你找个好老板，找一份好工作，好好工作。
> 辛勤工作，早起晚归，经常加班。
> 早晚有一天，这个老板，会更有钱。换更好的车，换更好的房。
> 再给我一个机会，我想回到昨天，因为我安眠药吃多了。

开心一刻，乐呵乐呵。创作乐无边，学而思有境。**你会发现，自己的知识宝库越来越丰富**。好了，到此为止就是此篇文章的全部内容了，**能看到这里的都是帅哥靓妹啊**！！！善于总结，其乐不穷。**好记性不如烂笔头**，多收集自己第一次尝试的成果，收获也颇丰。**你会发现，自己的知识宝库越来越丰富**。白嫖有瘾，原创不易。


<H3 align=center><a href="https://blog.csdn.net/Tolove_dream">by 龙腾万里sky 原创不易，白嫖有瘾</a></H3>

