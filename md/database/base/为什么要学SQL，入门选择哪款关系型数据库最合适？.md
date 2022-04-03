MySQL数据库、Oracle数据库、达梦数据库？还是SQLserver数据库？为什么要学SQL，入门选择哪款关系型数据库最合适？

# 前言

**我**：小川，听说你对Linux命令、Java以及数据库SQL方面的知识比较熟悉，公司业务主要也是基于Java开发的web项目。

**小川**：是的，以前学过一点Java方面的知识，用过一段时间的Linux命令，会一点数据库操作。

本文已经收录到github仓库：[https://github.com/cnwangk/SQL-study](https://github.com/cnwangk/SQL-study)

### 构思缘起

这篇文章的构思来源：前段时间公司新招了一名驻场运维人员，基础有点薄弱，SQL方面的知识需要辅导。在我的上一篇文章[《初学者如何入门linux，原来linux还可以这样学》](https://www.cnblogs.com/cnwangk/p/15829648.html)其实也是基于这种想法编写的。我寻思着，如何快速带他先入个门，至少得教会工作中最常用的（select、insert、update、delete）增删改查。我就在思考着，是不是要出一篇文章好好地辅导一下。当然写的很基础，基于给想入门SQL语言的初学者一点小小的建议。

虽然小川基础知识不是很牢靠，但是好学，这点值得肯定。我也经常对他说，多用你的小本本做记录，久而久之你就会积累很多知识。当然，这也是在实际工作中才发现的。起初，通过交谈认为他至少会一点基础，这也是后话了。

如果他有幸看到这篇文章，可能会后悔，当初怎么没早点看到这篇文章问世。

### SQL的简介，SQL是什么？

参考文献：维基百科

全称是Structure Query Language（**结构化查询语言**）是一种特定目的编程语言，一般简称为SQL。用于管理关系数据库管理系统（RDBMS）。它是使用**关系模型的数据库应用语言**，由IBM在20世纪70年代开发出来，作为IBM数据库System R的原型关系语言，实现数据库中信息检索。20世纪80年代初，美国国家标准学会（ANSI）开始着手定制SQL标准。最早的ANSI始于1986年，被称为SQL-86，在1987年成为国际标准化组织（ISO）标准。尽管SQL并非完全按照科德的关系模型设计，但其依然成为最为广泛运用的数据库语言。此后，这一标准经过了一系列的增订，加入了大量新特性。虽然有这一标准的存在，但大部分的SQL代码在不同的数据库系统中并不具有完全的跨平台性。SQL标准几经修改，更趋近于完善。

![](https://gitee.com/dywangk/img/raw/master/images/SQL%E6%B1%87%E6%80%BB%E5%B0%81%E9%9D%A201_proc.jpg)

要问学什么编程语言成效最显著，毫无疑问是SQL语言。当我们接触一个陌生的数据库时，通常需要一种方式与之进行交互，进而完成用户的工作。此时，就需要SQL语言了。

# 正文

推荐入门首选的关系型数据库MySQL，开源免费、社区活跃、教程资源丰富，个人也会着重对MySQL的一些知识进行讲解。篇幅受限，一篇文章也不会做到面面俱到，总会有所遗漏，但侧重点依旧是入门指导。由于是对想入门的同学一些建议，不会过于深入，只会讲一些浅一点的知识。至于核心知识：**存储过程**、**触发器**、**函数以及游标**之类的高级知识，可以参考我在文中推荐的书籍。慢慢累积知识，你的知识宝库自然丰富。

**当你看到本文的时候，观众与本文的约定**：

- MySQL中以sakila数据库作为示例进行讲解；
- Oracle中以scott用户中的emp（员工表）和dept（部门表）作为示例进行讲解。
- Oracle11g安装自带scott用户，Oracle19c默认（CDB模式，新增用户要加c##）没有scott用户，需要手动导入。
- MySQL官方提供的示例数据库sakila以及world，类似于Oracle的scott用户。
- 达梦数据库安装的时候可以选择添加示例用户：PERSON、PRODUCTION、PURCHASING、RESOURCES、SALES。
- 关键字大小并不影响你查询使用，在演示的时候可能会出现有的大写有小写。

## 01 第一夜

小川走进了我的书房（语音会议），开始了求学之路。我对好学之人，一向也是愿意传授多年的九阳神功和玉女心经的。嚯，有点意思哈！玉女心经？

![](https://gitee.com/dywangk/img/raw/master/images/Snipaste_2022-01-25_20-26-02.jpg)

**我**：小川啊，我这边项目线上测试已经接近尾声了。到时候需要你过来完成交接，之前听说你会数据库的基本操作。

**小川**：啊，支支吾吾的回答道：我只会一点点SQL的操作。

**我**：那，你都会些啥呢？

**小川**：实话实说吧，我基本快忘完了。

**我**：好吧。。。没事，还好发现的早，今晚就给你辅导一下。基本的操作是需要掌握的，否则会拖延工作进度。

**小川**：好的。于是拿出了小本本开始记录...

**我**：咱理论知识得到位，分享一下SQL语句的分类。

**DDL**（Data Definition Language）语句，数据定义语句。主要用于对索引、数据表结构、字段等进行创建、删除以及修改。比如我们常用的关键字主要有：CREATE、DROP、ALTER等等。一般是DBA管理员使用的比较频繁。

**DML**（Data Manipulation Language）语句，数据操纵语句。主要用于对数据库表中记录进行增删改查。比如我们常用的关键字主要有：INSERT、DELTE、UPDATE以及SELECT等。一般是开发人员使用的比较频繁。

**DCL**（Data Control Language）语句，数据控制语句。主要用于对用户、表、字段的访问权限进行控制授权。比如我们常用的关键字有：grant（授权）、revoke（撤回授权）等。

### 一、SQL

在梳理SQL方面的知识，我可能会穿插的带入一些MySQL或者Oracle中的使用经验，便于大家更有代入感。这里说的创建数据库，只是大家叫习惯了，更确切的应该是叫用户。

#### 1、创建与切换数据库

MySQL中创建数据库与删除数据库

```sql
-- 创建数据库av（习惯叫数据库）
CREATE DATABASE av;
-- 切换到av数据库，在MySQL或者MariaDB可以这样使用
USE av;
-- 删除av数据库
DROP DATABASE av;
```

Oracle中创建数据库与删除数据库，如果在Oracle中使用`create database`关键字创建，会提示数据库已装载。

```sql
-- Oracle中创建用户
CREATE user av IDENTIFIED BY 你的密码;
-- 在sqlplus中登录用户
conn av/123456 as sysdba; 
-- 删除用户
drop user av;
```

修改（alter）用户密码，需要管理员权限才能执行：

```sql
#MySQL中修改root用户的密码
ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码';
#Oracle中修改scott用户密码
ALTER USER scott IDENTIFIED BY 新密码;
```

在MySQL中修改root用户的密码，Oracle中修改scott用户密码。

#### 2、创建与删除表

创建一张表bols，**数据库、表名和字段要么统一大写要么统一小写**，有的数据库对大小写很敏感。

```sql
create table bols(
	id varchar(32) not null primary key,
    names varchar(64) not null,
    sex varchar(2) not null,
    cup_size varchar(8) not null
);
```

删除表bols

```sql
DROP table bols;
```

**我**：上面列举了一些数据库的基本操作，记住了多少。

**小川**：创建（create user/database）用户/数据库av，创建（create table）表bols。一脸疑问，bols是啥呀！

![](https://gitee.com/dywangk/img/raw/master/images/Snipaste_2022-01-25_20-31-10.jpg)

**我**：波老师啊，很出名的一位老师，很大、很白。

想啥呢？回到正题，抓紧搞定基本的操作。

**小川**：嗯嗯，我也对bols很感兴趣。便拿出了小本本开始书写着。

下面就开始以bols为例子，对小川进行讲解了数据库最基本的增删改查操作。

#### 3、增删改查（CURD）

查询（select）表名（table_name）为bols的全部数据

```sql
-- 查询全部内容，不带条件
select * from bols;
```

**模糊查询like**，使用到关键字：where（条件）、and（并且）、like（模糊查询）

```sql
-- 模糊查询，带条件
select t.* from scott.emp t where t.deptno > 20 and t.ename like '%S%';
```

插入（insert）一条数据

```sql
insert into bols values('1001','bols','女','D');
```

修改（update）id为1001的这条数据，将cup_size修改为D38。D38是个啥概念，咱也没体验过，就举个例子呗。

```sql
update bols b set b.cup_size='D38' where b.id='1001'; 
```

删除（delete）表中的全部数据

```sql
delete from bols;
```

删除（delete）表中单条数据，带条件删除，一般根据主键唯一标识去搜索删除。

```sql
delete from bols b where b.id='1001';
```

在SQL中是支持取别名的，方便我们在查询表的时候提高效率，咱上面给bols取个别名叫b。在你不确定删除的数据是否真的要删掉的时候，最好使用查询（select）查出来分析一下结果，再做删除。删除数据之前，也应该事先做好数据备份，谨慎一点总归没错的。

**我**：基础知识现在想必有所了解了，聚合函数对你今后的工作有大大大的帮助。

**小川**：好耶，我也很感兴趣。

认真的聆听着，然后踏踏实实的进行了实际操作...

#### 4、聚合函数（Aggregate）

**介绍几个常用的函数**。同时使用多个函数，查询Oracle数据库scott用户的emp表：

```sql
-- count(统计条目数),sum（求和）,substr（截取）,avg（取平均值）函数的使用
select count(*), sum(t.sal), substr(avg(t.sal), 0, 7) from scott.emp t;
```

**返回平均值avg**，一般配合substr关键字去截取，通过计算保留小数点后两位。

```sql
-- avg（取平均值）函数的使用
select avg(t.sal) from scott.emp t;
select substr(avg(t.sal), 0, 7) from scott.emp t;
```

**返回统计行数count**

```sql
-- 统计函数count，统计emp表条目数量：14
select count(*) from scott.emp;
```

**返回总数（求和）sum**，sum函数一般会配合decode函数使用

```sql
-- 求和函数sum的使用
select sum(t.sal) from scott.emp t;
-- 配合decode函数使用
select sum(decode(ename, 'SMITH', sal, 0)) SMITH,sum(decode(ename, 'ALLEN', sal, 0)) ALLEN,
	   sum(decode(ename, 'WARD', sal, 0)) WARD,sum(decode(ename, 'JONES', sal, 0)) JONES,
	   sum(decode(ename, 'MARTIN', sal, 0)) MARTIN,sum(decode(ename, 'BLAKE', sal, 0)) BLAKE,
	   sum(decode(ename, 'CLARK', sal, 0)) CLARK,sum(decode(ename, 'SCOTT', sal, 0)) SCOTT,
	   sum(decode(ename, 'KING', sal, 0)) KING,sum(decode(ename, 'TURNER', sal, 0)) TURNER
from scott.emp;
```

**tips**：count函数在工作中使用的很频繁，你不清楚某张表中有多少条记录，需要统计一下再处理。

**返回最大值max**，查看员工中薪水最高的那一位。

```sql
-- max函数的使用
select max(t.sal) from scott.emp t;
```

**返回最小值min**，查看员工中薪水最底的那一位。

```sql
-- min函数的使用
select min(t.sal) from scott.emp t;
```

**Oracle中rownum**。返回emp员工表中的最后一条记录，通过`rownum`实现：

```sql
select t.sal from scott.emp t where rownum <=1;
select t.sal from scott.emp t where rownum <=1 order by t.sal desc;
```

**MySQL中的limit**。通过`limit`关键字实现，根据sakila中的actor为例子返回最后一条记录，使用actor_id进行排序。

**注意**：**limit属于MySQL扩展SQL92后的语法，在其它数据库中不能通用**。

```sql
SELECT t.`first_name` FROM sakila.`actor` t ORDER BY t.`actor_id` DESC LIMIT 1;
```

**group by函数**配合聚合函数sum应用，查询Oracle中scott用户下的emp表：

```sql
SELECT t.deptno, SUM(t.sal) AS sals FROM scott.emp t GROUP BY t.deptno;
```

**having函数**配合聚合函数使用，Oracle中的scott用户下emp与dept表。如下给出简单示例：

**区别**：having和where的区别在于，having是对聚合后的结果进行条件的过滤，而where是在聚合前就对记录进行过滤。如果逻辑允许，应尽可能用where先过滤记录，由于结果集的减小，对聚合的效率明显提升。最后再依据逻辑判断是否用having再次过滤。

```sql
SELECT d.dname, SUM(e.sal) AS sals FROM scott.emp e
INNER JOIN scott.dept d ON e.deptno=d.deptno
WHERE e.deptno < 30 GROUP BY d.dname  HAVING SUM(e.sal) > 10000;
```

**exists运算符**，返回结果true与false。可以配合not使用，示例如下：

```sql
-- exists
select t.deptno,t.sal from scott.emp t where 
exists(select t.deptno from scott.dept d where d.deptno=t.deptno and t.sal > 1500);
-- not exists
select t.deptno,t.sal from scott.emp t where 
not exists(select t.deptno from scott.dept d where d.deptno=t.deptno and t.sal > 1500);
```

**in操作符**，依旧以Oracle中的scott用户示例：

```sql
-- 查询部门编号为10,20的员工薪水
select t.deptno,t.sal from scott.emp t where t.deptno in(10,20);
-- 查询不包含部门编号为10,20的员工薪水
select t.deptno,t.sal from scott.emp t where t.deptno not in(10,20);
```

关于函数和操作符就讲这么多，一般而言工作中足够用了。更多的应用可以参考官方文档或者《菜鸟教程》以及权威的实体书籍。

## 02 第二夜

第一夜的知识点还是比较多的，需要下去踏踏实实的实际操作，多多练习并加以理解。

**我**：小川啊，通过昨晚的探讨，SQL的一些知识应该掌握不少了吧。

**小川**：是的，掌握一些，还有一部分需要多练习才行。

**我**：接下来就开始给你讲讲MySQL方面的一些注意事项。

**小川**：嗯嗯，并点了点头。拿出了小本本开始记录...

### 二、MySQL

#### 1、版本

MySQL有两种版本

- 其中一种是企业版，提供了更加丰富的特性与完善的售后技术支持。
- 另一种是社区版，免费提供给普通用户使用。但MySQL被Oracle收购后，存在闭源的风险。MySQL的创始人开始着手MariaDB，也是基于原版版的MySQL打造的，完全兼容MySQL，拥抱开源。

关于社区版和企业版的最大区别，我个人还是深有体会的。之前有幸接触过政企项目，使用付费版的国产数据库DM8。出了问题，直接电话联系供应商，找来了达梦数据库的**技术支持人员上门排查解决问题**。**划重点，上门服务**。有商业支持确实是好事，但更应该拥抱开源。

#### 2、入门

##### 2.1、下载与安装

MySQL官网下载地址：[https://dev.mysql.com/downloads/](https://dev.mysql.com/downloads/)，下载社区版，社区版是免费提供下载的。

**在linux下安装二进制包，建议事先这样处理**：

```bash
#添加mysql组
$ groupadd mysql
#新增mysql用户到mysql组中
$ useradd -g mysql mysql
```

切换到我们的home目录下进行解压安装：

```bash
$ cd /home/mysql
#解压tar包
$ tar -zxvf /home/mysql/mysql-version-os.tar.gz
#做软链接
$ ln -s mysql-version-os mysql
#安装
$ scripts/mysql_install_db --user=mysql
```

**设置目录权限**，启动mysql：

```bash
$ chown -R root:mysql
$ chown -R mysql:mysql data
$ /usr/bin/mysqld_safe --user=mysql &
```

源码包安装就不做详细讲解，这里对源码包安装提示三点：

- 编译源码并指定安装路径：./configure  --prefix=/usr/local/mysql
- 编译：make 
- 安装：make install

在所有的关系型数据库中，我提醒你要注意的一点是，都有个很重要的过程就是**数据库的实例化**，**没有实例化是无法启动数据库服务的**。更多安装方式可以参考菜鸟教程进行安装：[https://www.runoob.com/mysql/mysql-install.html](https://www.runoob.com/mysql/mysql-install.html)

MySQL数据库的安装配置与Oracle数据库相比要简单的多。下载完后并完成安装，MySQL的官网也提供了示例数据库和Oracle提供的scott用户下的emp和dept类似。你可以**到官网获取MySQL提供的数据库示例sakila和world**，然后进行导入到数据库中。

也给出MariaDB的下载地址：[https://mariadb.org/download/](https://mariadb.org/download/)

**修改密码**，默认安装设置密码大概率为空，手动去指定密码。

```sql
set password for root@localhost=password('123456');
ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码';
```

**创建用户授权**，初学者如果想**使用工具远程连接自己的MySQL**（MariaDB）数据库，需要对用户授权。

```sql
GRANT ALL PRIVILEGES ON *.* TO '你的用户名'@'你的IP地址' IDENTIFIED BY '123456' WITH GRANT OPTION;
```

示例：表示授权root户，所有IP都可连接。

```sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
```

**刷新权限**

```sql
flush privileges;
```



##### 2.2、MySQL的使用

简洁的描述下MariaDB：基于MySQL关系数据库的复刻，由社区开发、有商业支持，目前由MySQL的创始人在维护。

区分平台一般为Windows和Linux服务器。在Windows平台，一般在安装的MySQL的bin目录下，使用CMD命令窗口以管理员身份运行进行登录，并进行交互操作。在登录的时候事先可以在-p参数后输入密码也可以不输入，系统会提示你输入登录密码的。有两种方式登录：

```bash
mysql -uroot -p #指定用户，但不指定密码
mysql -uroot -p123456 #指定用户并且在-p参数后面接上密码
```

下面演示在cmd命令窗口下登录MySQL的情形：

```bash
mysql -uroot -p
d:\work\MariaDB>mysql -uroot -p
Enter password: *******
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 19
Server version: 10.5.6-MariaDB mariadb.org binary distribution
Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
MariaDB [(none)]>
```

登录到MySQL（MariaDB）数据库后，可以进行一些常用的交互，比如我们展示存在哪些数据库。当你要显示表的时候，这时需要使用`use av`切换到av用户，然后使用`show tables；`即可显示当前数据库中的所有表。上面介绍SQL的时候也有提到切换数据库。

```bash
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| av                 |
| sakila             |
| world              |
| test               |
+--------------------+
9 rows in set (0.001 sec)
```

好家伙这个av是啥意思？一颗闷骚（爱学习）掩饰不了我那正直的内心。不就是多了一点什么cnagls、bols、jizels以及longls之类的比喻吗，还顺带研究了她们的cup_size而已，仅此而已。

回到正题，可以看到默认安装就存在的有

- information_schema**、**mysql**、**performance_schema这三个数据库；
- 其它的比如av、**sakila** 、**world**、test是后来自己搭建测试使用的。

提供的sakila数据库示例，包含内容很详细，也涵盖了SQL中的一些核心知识：

- 最基本的表与表结构
- 视图（view），例如：actor_info
- 存储过程（PROCEDURE），例如：film_in_stock
- 函数（FUNCTION），例如：get_customer_balance
- 触发器（TRIGGER），例如：customer_create_date

在我们的linux服务器下，配置好了环境变量，在任意目录下同样使用如下命令进行登录，并操作交互。

```bash
$ mysql -uroot -p
```

在linux下安装的数据库内容我就不展示了，之前搭建MySQL主从复制以及监控系统zabbix弄得比较混乱。

**2.3、MySQL帮助命令**

注意了，帮助命令是在MySQL自带的工具登录中使用的。需要先登录到MySQL命令模式：

```sql
-- 登录到mysql
mysql -uroot -p
```

列举几个示例：

- ? contents：包含了所支持的帮助文档。
- ? data types：查询数据类型的帮助文档
- ? show：比如快速查阅show命令的使用，如果不支持会提示Nothing found。

```sql
? contents
MariaDB [(none)]> ? contents;
You asked for help about help category: "Contents"
For more information, type 'help <item>', where <item> is one of the following
categories:
   Account Management  Administration  Compound Statements
   Data Definition  Data Manipulation Data Types
   Functions  Functions and Modifiers for Use with GROUP BY
   Geographic Features Help Metadata Language Structure
   Plugins Procedures Sequences Table Maintenance Transactions
   User-Defined  Functions Utility
```

列举出MySQL当前版本支持的数据类型：

```sql
MariaDB [(none)]> ? data types;
You asked for help about help category: "Data Types"
For more information, type 'help <item>', where <item> is one of the following
topics:
   AUTO_INCREMENT  BIGINT  BINARY  BIT  BLOB  BLOB and TEXT Data Types
   BOOLEAN  CHAR  CHAR  BYTE  DATE  DATETIME  DECIMAL DOUBLE  ENUM  FLOAT
   Geometry Types JSON Data Type LONGBLOB  LONGTEXT  MEDIUMBLOB
   MEDIUMINT MEDIUMTEXT Numeric Data Type Overview ROW SET Data Type
   SMALLINT String Literals TEXT  TIME  TIMESTAMP  TINYBLOB  TINYINT  TINYTEXT
   VARBINARY VARCHAR YEAR Data Type
```

**2.4、MySQL中支持的类型**（介绍部分）

学以致用。需要连贯学习，使用上面介绍到帮助命令进行查看一些字符串类型的作用。比如我不清楚CHAR类型的使用，可以执行帮助手册进行查询使用方法：

```bash
? CHAR;
```

- 数值类型
- 日期时间类型
- 字符串类型

下面值列举字符串类型，介进行绍：

| 字符串类型   | 作用                                                         |
| ------------ | ------------------------------------------------------------ |
| CHAR(M)      | M的长度为：0~255之间的整数。声明固定长度。                   |
| VACHAR(M)    | M的长度为：0~65535之间的整数，值的长度+1个子节。可自动调节。 |
| TINYBLOB     | 允许长度0~255字节，值的长度+1个字节。                        |
| BLOB         | 允许长度0~65535字节，值的长度+2个字节。                      |
| MEDIUMBLOB   | 允许长度0~16,777,215字节，值的长度+3个字节。                 |
| LONGBLOB     | 允许长度0~65535字节，值的长度+4个字节。                      |
| TINYTEXT     | 允许长度0~255字节，值的长度+2个字节。                        |
| TEXT         | 允许长度0~65535字节，值的长度+2个字节。                      |
| MEDIUMTEXT   | 允许长度0~16,777,215字节，值的长度+3个字节。                 |
| LONGTEXT     | 允许长度4,294,967,295字节，值的长度+4个字节。                |
| VARBINARY(M) | 允许0~M个字节的**变长**字节字符串，值的长度为+1个字节。      |
| BINARY(M)    | 允许0~M个字节的**定长**字节字符串                            |

**2.5、MySQL中其它常用的函数**

列举了部分函数做成表格以供参考，具体的使用就不一一列举了，可以自行测试验证。对部分进行了加粗显示。

同样函数的使用，一样可以使用帮助文档进行查看：

```bash
MariaDB [sakila]> ? abs;
Name: 'ABS'
Description:
Syntax
------
ABS(X)
Description
```

| 函数                   | 功能                                                         |
| ---------------------- | ------------------------------------------------------------ |
| ABS(x)                 | 返回x的绝对值                                                |
| CEIL(x)                | 返回大于x的最小整数值                                        |
| FLOOR(x)               | 返回小于x的最大整数值                                        |
| MOD(x,y)               | 返回x/y的模                                                  |
| RAND()                 | 返回0~1之间的随机值                                          |
| ROUND(x,y)             | 返回参数x四合五入的有y位小数的值                             |
| **DATABSE()**          | **返回当前数据库名**                                         |
| **VERSION()**          | **返回当前数据库版本**                                       |
| **USER()**             | **返回当前登录用户名**                                       |
| INET_ATON(IP)          | 返回IP地址的数字表示                                         |
| INET_NTOA(num)         | 返回数字代表的IP地址                                         |
| PASSWORD(str)          | 返回字符串str加密版本                                        |
| MD5(str)               | 返回字符串str的MD5值                                         |
| LTRIM(str)             | 去掉字符串str左侧的空格                                      |
| RTRIM(str)             | 去掉字符串行尾的空格                                         |
| REPEAT(str,x)          | 返回str重复x次的结果                                         |
| REPLACE(str,a,b)       | 用字符串b替换字符串str中所有出现的a字符串                    |
| STRCMP(s1,s2)          | 比较字符串s1与s2                                             |
| **TRIM(str)**          | **去掉str字符串的空格**                                      |
| **SUBSTRING(str,x,y)** | 返回字符串str中起始位置x到y个字符长度的字符串，一般用于截取小数点后位数过多。 |

一般通过select 接函数去插叙，例如：

```sql
MariaDB [(none)]> use sakila;
Database changed
MariaDB [sakila]> select DATABASE();
+------------+
| DATABASE() |
+------------+
| sakila     |
+------------+
1 row in set (0.000 sec)
```



#### 3、连接工具介绍

推荐几个比较常用的工具：[phpMyAdmin](https://www.phpmyadmin.net/)、[SQLyog](https://webyog.com/product/sqlyog/trial/)、[MySQL Workbench](https://dev.mysql.com/downloads/workbench/)、Navicat可视化工具进行连接操作。工具的使用是其次的，更重要的在于对MySQL命令语句的运用。

**tips**：包含了SQLyog、plsqldev、Navicat，还整理了部分安装包以及MySQL官方提供的**sakila** 、**world**示例哟！

链接: [https://pan.baidu.com/s/11gIlZKxoTG5BCCcoXdVJRg ](https://pan.baidu.com/s/11gIlZKxoTG5BCCcoXdVJRg )   提取码： ntu7

给出一个使用Navicat逆向生成的示例数据库world的模型：

![](https://gitee.com/dywangk/img/raw/master/images/world%E7%89%A9%E7%90%86%E6%A8%A1%E5%9E%8B_proc.jpg)

**如果真的要使用到建物理模型**：推荐你学习Sybase PowerDesigner设计工具的使用，而且需要了解关系数据库设计遵循的三范式。现在数据库设计最多满足3NF，普遍认为范式过高，虽然具有对数据关系更好的约束性，但也导致数据关系表增加而令数据库IO更易繁忙，原来交由数据库处理的关系约束现更多在数据库使用程序中完成。

#### 4、找回root用户密码

无论是初学者或者是熟手都有可能忘记之前设置的密码。咱当初安装MySQL也是吃过亏的，采用生成随机密码坑过自己一次。

这里介绍在linux下如何找回root用户密码：

- 思路：绕过MySQL的权限验证
- 具体方法：使用update语句修改本地localhost的root用户密码

解决方案：登录到MySQL所在服务器，通过进程命令`ps -ef`查询MySQL服务：

```bash
#查看mysql服务进程
$ ps -ef | grep mysql
#或者使用
$ ps -aux | grep mysql
mysql     2122  0.4  7.1 971244 133536 ?
--datadir=/var/lib/mysql
$ cat /var/run/mysqld/mysqld.pid 
2122
```

经过上面的对比，你会发现**ps命令**查出来的和**mysql.pid**里记录的是一致的。查询到MySQL默认安装到了**/var/lib/mysql**下，存储MySQL进程pid在/var/run/mysqld/mysqld.pid。通过kill命令停止：

```bash
$ kill -9 2122
```

**使用--skip-grant-tables**参数越过权限表认证，然后启动MySQL。

```bash
#越过权限验证,然后启动mysql并放入后台运行，如果你用root用户测试的，将user后的参数改为root
--skip-grant-tables
$ /usr/bin/mysqld_safe --skip-grant-tables --user=mysql &
```

```sql
-- 修改密码
update user set password=password('123456') where user='root' and host='locahost';
```

越过权限验证,然后启动mysql并放入后台运行，如果你用root用户测试的，将user后的参数改为root。然后使用update语句修改密码。以上就是root用户密码忘记了，通过越过权限认证表修改密码。看完之后，是不是感觉很简单。

#### 5、常用网络资源

- MySQL官网下载地址：[https://dev.mysql.com/downloads/](https://dev.mysql.com/downloads/)
- 目前最权威的MySQL数据库以及工具在线手册：[https://dev.mysql.com/doc/](https://dev.mysql.com/doc/)
- MySQL发布的bug列表：[https://bugs.mysql.com/](https://bugs.mysql.com/)

## 03 第三夜

第二夜的知识点对MySQL进行了简单的介绍，也需要下去踏踏实实的实际操作。尤其是核心知识：视图、函数、存储过程以及触发器。

**我**：小川啊，通过昨晚的探讨，MySQL的一些知识应该掌握不少了吧。

**小川**：大概入了个门，需要消化消化。

**我**：接下来就开始给你讲讲Oracle方面的一些注意事项，也是公司主要使用的数据库，目前依旧以Oracle11g为主。

**小川**：嗯嗯，并点了点头。拿出了小本本开始记录...

### 三、Oracle

#### 1、版本

Oracle主要分为两种版本，目前貌似逐渐从Oracle11g转向Oracle19c了。

- 其中一种是带g结尾的，比如现在依旧使用广泛的Oracle11g
- 另外一种就是带c结尾的，以标志性的Oracle12c为代表。加入了很多新特性，对云端（cloud）支持更友好。

这年头互联网的下一个风口浪尖，绝对是瞄准了云（云计算、云原生）。

#### 2、入门

**2.1、安装**

Windows下安装Oracle的过程，就不详细介绍了，给出三点注意事项：

- 数据库软件的安装（一般选企业版，就算个人使用你也不会去选标准版之类的）
- 数据库监听程序配置（以管理员身份运行）：Net Configuration Assistant
- 数据库实例化（以管理员身份运行）：Database Configuration Assistant

Linux下部署Oracle可以参考我之前的博文《【linux环境】Oracle11g以及Oracle19c基于centos7安装与优化》：

[https://blog.csdn.net/Tolove_dream/article/details/122136388](https://blog.csdn.net/Tolove_dream/article/details/122136388)

**2.2、SQL*Plus工具使用**

以经典的Oracle11g作为讲解，无论是在Windows平台还是linux平台都要设置对应支持的中文字符集，否则看到中文会是乱码。安装完成并配置好了环境变量，在任何目录下都可以打开cmd命令窗口运行sqlplus。如果没有配置环境变量，在当前Oracle客户端的BIN目录D:\app\product\11.2.0\client\BIN下执行sqlplus一样可以进行登录。

登录SQL*Plus，提示输入用户名和密码。

```bash
SQL*Plus: Release 11.2.0.1.0 Production on 星期六 11月 22 21:18:17 2021
Copyright (c) 1982, 2010, Oracle.  All rights reserved.
请输入用户名?    system as sysdba
输入口令:
连接?
  Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
```

可以使用如下方式运行SQLPlus，然后进行连接：

```bash
C:\Users\sky>sqlplus/nolog
SQL*Plus: Release 11.2.0.1.0 - Production on 星期六 11月 22 21:18:17 2021
Version 11.2.0.1.0
Copyright (c) 1982, 2010, Oracle.  All rights reserved.
SQL> conn system(用户名)/123456(密码) as sysdba(以DBA身份登录)
Connected.
```

查询安装Oracle11g就已经自带的scott用户下的emp和dept表，在Oracle19c中默认是没有的，需要手动导入。

```sql
select * from scott.emp;
select * from scott.dept;
#使用desc命令展示scott用户下的dept表结构
SQL> desc scott.dept;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 DEPTNO                                    NOT NULL NUMBER(2)
 DNAME                                              VARCHAR2(14)
 LOC                                                VARCHAR2(13)
```

在linux中使用Oracle的SQL*Plus就不详细介绍了，感兴趣的可以使用虚拟机搭建测试环境进行验证，参考文中提到的教程哟！

```bash
#运行sqlplus，执行命令参考上面讲解Windows的
$ /home/oracle/app/product/11.2.0/dbhome_1/bin/sqlplus as sysdba
```

**创建用户test**，注意SQL语句结束以分号结尾。

```sql
create user test;
```

**创建表空间TEST.DBF**，设置表空间的大小为1024M

```sql
create tablespace TEST DATAFILE 'D:\app\product\11.2.0\oradata\orcl\TEST.DBF' SIZE 1024M;
```

**赋予表空间**，赋予用户TEST的默认表空间为TEST。如果想偷懒，就直接用system表空间。

```sql
alter user TEST default tablespace TEST;
alter user TEST default tablespace system;
```

**2.3、SQL Developer工具**

安装Oracle服务端或者客户端自带**SQL Developer**，我个人使用的是客户端自带的。需要依赖**Java.exe**启动，并且以管理员身份运行。

```bash
D:\app\product\11.2.0\client\sqldeveloper
```

以前的我，也是不知道Oracle原来还有SQL Developer工具的，最近看了实体书籍才知道的。带大家看看：

你可以看到上面将Oracle中的部分用户列举出来了：

- 超级管理员：sys
- 普通管理员system
- 自带的普通用户：scott，**Oracle12c改为c##scott**
- 海量数据用户（大数据用户）：sh

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_SQL_Developer_proc.jpg)

展示一下我登录的system和scott用户，顺带演示个人测试环境中，创建了test用户和student01表。并使用SQL Developer工具进行查询，使用到之前介绍过的**统计函数count**，总条数为：1kw条数据。如果你打开emp表，会用中文显示如下内容哟：

![](https://gitee.com/dywangk/img/raw/master/images/%E5%9C%A8SQLDeveloper%E6%89%A7%E8%A1%8CSQL%E8%AF%AD%E5%8F%A5_proc.jpg)

- 列、数据、**约束条件**；
- 授权、统计信息、**触发器**；
- **闪回技术**、相关性、详细资料、**索引**以及SQL

我没有放截图，图片不宜过多，所以就用文字描述出来了，希望不要介意哟。

**2.4、PLSQL Developer工具**

![](https://gitee.com/dywangk/img/raw/master/images/plsqldev_proc.jpg)

我相信在实际工作中Oracle的SQL操作，使用的最频繁的还是PLSQL Developer，毕竟功能强大界面更加美观。本人使用的是汉化版本1207，官方支持汉化包。可以直接到官网获取，也可以在文中找到我提供的度盘链接获取汁源哟！Windows平台下的相关操作可以参考我之前写的文章：[《Oracle11gR2部署与卸载，附带plsqldev工具使用》](https://blog.csdn.net/Tolove_dream/article/details/118661951)

#### 3、优势

有商业支持，完善的售后技术支持。海量数据处理，对比其它关系型数据库，其性能更强大。

**1kw数据的统计**

与MySQL不同的是，Oracle处理大数据时能承受更大的压力，在查找1kw的数据时候有明显的区别。当然，也可能是我对MySQL的了解比较浅（在分库分表以及存储引擎这块知识点我比较缺乏）。我统计Oracle下student01表中有1kw条数据，在PLSQLDeveloper工具中测试输入下：

```sql
select count(*) from test.student01;
/** Oracle11g R2 for Windows10 测试随机生成200w~1000w数据的表 此次测试对DM8数据库同样适用**/
/**  **/
-- 创建用户，如果指定的表空间大小不够，不足以满足1kw条数据存储，测试至少需要设置表空间大小为512M
create user test;
-- 从Oracle12c开始，默认CDB模式创建用户需要加上c##
create user c##test;
-- 在test用户下创建表
CREATE TABLE test.student
(
    ID NUMBER not null primary key,
    STU_NAME VARCHAR2(60) not null,
    STU_AGE NUMBER(4,0) not null,
    STU_SEX VARCHAR2(2) not null
)
-- 学生表随机生成200w数据
insert into test.student select rownum,dbms_random.string('*',dbms_random.value(6,10)),dbms_random.value(14,16),
'女' from dual
connect by level<=2000000

-- 创建student01表直接将student表中数据复制过来了
create table test.student01 as select * from test.student;
-- 执行4次，生成1kw条数据，不到10秒搞定
insert into test.student01 select * from test.student;
select count(*) from test.student01;
-- 优化
update test.student set ID=rownum where 1=1
-- 修改年龄随机14-16岁之间
update test.student set STU_AGE=dbms_random.value(14,16) where 1=1
-- 提交
commit;
```

**Oracle表空间的创建与调整**

创建用户，如果指定的表空间大小不够，不足以满足1kw条数据存储。本人测试至少需要设置表空间大小为512M，具体还需要依据字段存储内容大小来判断。一般情况会设置表空间大小并开启自动扩展，扩展的语句示例为：

```sql
-- 创建表空间
create tablespace TEST DATAFILE 'D:\app\product\11.2.0\oradata\orcl\TEST.DBF' SIZE 1024M;
-- 调整空间允许自动扩容 AUTOEXTEND ON代表自动扩展。每次扩展100M，最大上限为2048M
alter DATABASE DATAFILE 'D:\app\product\11.2.0\oradata\orcl\TEST.DBF' AUTOEXTEND ON NEXT 100M MAXSIZE 2048M;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle%E7%BB%9F%E8%AE%A11kw%E6%9D%A1%E6%95%B0%E6%8D%AE%E8%80%97%E6%97%B6_proc.jpg)

值得注意的是VARCHAR2字段属性在Oracle中支持，但在MySQL中是不支持的。

**Oracle中的rowid伪列**，在plsqldev工具中点击带锁的标志即可进行编辑数据。这里以scott用户为例子进行展示：

```sql
select t.*,t.rowid from scott.dept t;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle%E4%BD%BF%E7%94%A8rowid%E6%9F%A5%E8%AF%A2_proc70.jpg)

在sqlplus中解锁scott用户，登录系统账户修改scott用户密码。

```sql
SQL> alter user scott account unlock;
用户已更改。
SQL> alter user scott identified by 123456;
用户已更改。
```

推荐这本《Oracle开发实战经典》的理由有如下3点：

- 个人阅读了一些书籍都停留在Oracle11g；
- 《Oracle开发实战经典》不仅讲了Oracle11g，还不包含了Oracle12c的内容；
- 从C开始，Oracle开始布局云端，我们也需要了解新版本的特性。



## 04 第四夜

第三夜的知识点并不多，对Oracle的安装以及优势进行了介绍，穿插着讲了一些对表空间的操作。

**我**：小川啊，通过昨晚的探讨，Oracle的一些知识应该有所了解，希望下去好好实践多部署几次。

**小川**：是的，部署过一次，有很多地方不是很明白。

**我**：接下来就开始给你讲讲SQLserver方面的一些注意事项。

**小川**：嗯嗯，并点了点头。拿出了小本本开始记录...

### 四、SQLserver

关于Windows平台的一些镜像或者工具下载，推荐去msdn itellyou这个小站去获取，提供的都是原生纯净版的iso镜像地址。这年头，为爱发电的良心小站已经不多了。

[https://msdn.itellyou.cn/](https://msdn.itellyou.cn/)

#### 1、版本

版本使用的较经典的三个版本，当然都是微软家的那一套.NET（C#、Winform）

- 第一版是比较久远的SQLserver2005，当年入门学的第一门SQL语言就是SQLserver2005了，堪称入门经典。
- 第二版就是SQLserver2008了，在我的印象中使用还是比较广的。
- 第三版就是SQLserver2012了，新特性也有，也不算太老。

#### 2、入门

个人推荐，使用版本不老也不新的版本SQLserver2012。

**2.1、安装SQLserver2012**

SQLserver的安装很简单，毕竟是微软自家的，在Windows上安装就不做描述了。

非要推荐，咱之前也写了个粗糙的记录，凑合着看看呗《【附带Java采用JDBC连接数据库】SQLServer2012的安装与注意事项详解》：

[https://blog.csdn.net/Tolove_dream/article/details/118864855](https://blog.csdn.net/Tolove_dream/article/details/118864855)

登录验证提供了两种选择方案：

- Windows身份验证
- SQL server身份验证，也就是用户名和密码验证

**注意**：安装的时候建议采取Windows身份验证和SQL server身份验证的混合模式。

交互使用，Windows平台全是中文的。有了之前SQL的基础，相信很容易上手的。

## 05 第五夜

前四夜的知识点还是很丰富的。需要下去认认真真、踏踏实实地实际操作，多多练习并加以理解。必要的时候学会举一反三，在实际工作中灵活运用。

**我**：小川，今晚的知识都是些不可多得的工作经验，需要好好记住。

**小川**：好的，具体都有哪些呢？

**我**：接下来就开始给你讲讲国创达梦数据库方面的一些注意事项。

**小川**：嗯嗯，并点了点头。拿出了小本本开始记录...

### 五、达梦数据库（抓重点）

原本打算专门出一篇进行总结归纳的，现在就整合到一篇文章中了，便于大家参考。

**tips**：对于使用过Oracle的小伙伴来说，使用达梦更容易上手，是兼容Oracle的。无论是在Windows平台还是Linux平台，请找到dm.ini文件。建议开启兼容Oracle模式，设置值为2：

```bash
#这是Windows平台dm.ini配置文件所在目录
D:\software\dmdbms\data\DAMENG
#linux下默认安装在opt目录中
$ /opt/dmdbms/data/DAMENG
#在dm.ini文件中找到COMPATIBLE_MODE，设置值为2，兼容Oracle
COMPATIBLE_MODE  = 2 #Server compatible mode, 0:none, 1:SQL92, 2:Oracle, 3:MS SQL
```

无论是在Windows平台还是在Linux平台，在dm.ini文件中找到COMPATIBLE_MODE，设置值为2，兼容Oracle。都是通过对dm.ini配置文件进行设置参数COMPATIBLE_MODE去兼容其它数据库。

#### 1、版本

以我熟悉的达梦数据库来说明，目前逐渐开始推广DM8。

- 其中一种版本是DM7；
- 另一种版本是目前最新版的DM8，也是鄙人接触的第一个版本的达梦数据库。

#### 2、入门

**2.1、Windows平台安装DM8**

官方有提供DM8安装手册，在官网进行注册登录即可下载，安装请进行参考：

DM8官网直通车：[https://www.dameng.com/view_61.html](https://www.dameng.com/view_61.html)

> DM8安装手册.pdf

登录到disql，默认自带的命令窗口，支持绝大部分操作。值得注意的是在银河麒麟版本的DM8中默认没有开启自动提交事务（commit），需要手动提交事务（commit）。

```bash
D:\software\dmdbms\bin\DIsql.exe
disql V8
用户名:SYSDBA
密码:
服务器[LOCALHOST:5236]:处于普通打开状态
登录使用时间 : 5.466(ms)
SQL> 
```

在Windows平台安装达梦数据库，选择安装带有管理客户端的安装包。在我们安装的数据库目录下有doc目录和tool目录，作用如下：

- doc目录：存储达梦数据库的官方文档，无论是DBA还是开发人员，都可以参考。
- tool目录：主要存放一些管理工具。比如manager管理客户端、DTS数据迁移工具。

```bash
D:\software\dmdbms\tool\manager.exe
D:\software\dmdbms\tool\dts.exe
```

**2.2、Linux下安装DM8**

看完整个DM8的使用过程，你会发现其实与标准的SQL使用时差不多的。只是多了一些注意事项，安装需要注意一下。

**关于安装只提重点**，请注意先实例化数据库，再注册脚本服务，Linux发行版Redhat系列环境参考：

```bash
#初始化，数据库实例化，这里注意进入dminit目录，一般在/opt/dmdba/dmdbms/bin下面
./dminit PATH=/opt/dmdba/dmdbms/data
#进入对应脚本目录，个人ARM架构银河麒麟V10脚本服务所在位置 
cd /opt/dmdba/dmdbms/script/root/
#1.通过指定服务类型注册服务
./dm_service_installer.sh  -t dmserver -dm_ini /opt/dmdba/dmdbms/data/DAMENG/dm.ini -p DMSERVER
#2.通过服务脚本注册服务
./dm_service_installer.sh -s /opt/dmdba/dmdbms/bin/DmServiceDMSERVER
```

初始化，数据库实例化，这里注意进入dminit目录，一般在/opt/dmdba/dmdbms/bin下面。然后进入对应脚本目录，个人ARM架构银河麒麟V10脚本服务所在位置。通过指定服务类型注册服务或者通过服务脚本注册服务。更多安装详细步骤请参考达梦官方文档哟。

**DM8一些参考文献**

官方有提供**DM8安装手册**，在Linux环境安装请进行参考：

> DM8安装手册.pdf
>
> DM8_Linux服务脚本使用手册.pdf
>
> DM8备份与还原.pdf
>
> DM8_DIsql使用手册.pdf

在某些特定环境，disql真的帮了大忙。以上推荐参考额几个文档，是我平时在工作中参考的比较频繁的，希望对你有所帮助。

**你也可以参考我写的博文**。虽说有点混乱，凑活着看呗，但毕竟是亲身部署过两次的经历：

> 【arm架构】银河麒麟V10部署DM8数据库

[https://blog.csdn.net/Tolove_dream/article/details/119395777](https://blog.csdn.net/Tolove_dream/article/details/119395777)

**依据个人真实现场部署实施使用经验编写**，不可多得的关于安全版（特供版）的使用经验。

终端启用客户端：

- manager：Linux下达梦数据库管理客户端
- dts：Linux下达梦数据库数据迁移工具

```bash
$ /opt/dmdbms/bin/tool/manager &
$ /opt/dmdbms/bin/tool/dts &
```

**tips**：建议配合nohup与&启动并输出指定日志

#### 3、DM8实战注意事项

- 服务器是特供版
- 数据库也是特供版

DM8数据库的操作（安全版、也称特供版）。理一下思路`SYADBA`与`SYSSSO`权限区分的明明白白，就如同Linux操作系统权限足够透明，分工明确。

**必须用SYSDBA用户执行的操作**

1、只能使用SYSDBA用户创建普通用户

```sql
CREATE USER TEST;
```

2、授权DBA给TEST用户（这里强调一下，权限遵循最小范围内满足即可的原则）

```sql
GRANT DBA TO TEST;
```

3、创建默认表空间并且设置大小为1024，建议根据实际应用情况设定表空间大小，可以参考官方文档。

```sql
CREATE TABLESPACE TEST DATAFILE '/opt/dmdbms/data/DAMENG/TEST.dbf' size 1024;
```

4、授权resource，public给用户

```sql
GRANT RESOURCE,PUBLIC TO TEST;
```

**必须用SYSSSO用户执行的操作**

1、只能使用安全用户的操作：

- 设置密码、修改密码；
- 解锁用户；
- 赋予表空间。

2、给创建的用户TEST设置密码

```sql
ALTER USER TEST IDENTIFIED BY 'SYSOFT1234';
```

3、赋予默认表空间TEST

```sql
ALTER USER TEST default tablespace TEST;
```

4、密码限制等问题处理，当然这些操作可以在管理客户端上进行，中文支持也很友好。

```sql
ALTER USER TEST LIMIT password_life_time UNLIMITED,
PASSWORD_LOCK_TIME UNLIMITED, 
PASSWORD_GRACE_TIME UNLIMITED, 
FAILED_LOGIN_ATTEMPS UNLIMITED,
PASSWORD_REUSE_TIME UNLIMITED,
PASSWORD_REUSE_MAX UNLIMITED;
```

通过五晚的知识交流，小川现在也能在工作中积极的运用所学知识。时不时还喊着老哥老哥，与我套近乎。想get到更多的知识点，这点小九九我还能不清楚吗？当然是开个玩笑，我一向是乐于助人的。

持续更新优化中...

# 总结

以后**优先发布到微信公众平台**。**我的微信公众号与其他平台昵称同样是龙腾万里sky**。**能看到这里的，都是帅哥靓妹**。以上就是此次文章的所有内容的，希望能对你的工作有所帮助。感觉写的好，就拿出你的一键三连。如果感觉总结的不到位，也希望能留下您宝贵的意见，我会在文章中进行调整优化。![](https://gitee.com/dywangk/img/raw/master/images/Snipaste_2022-01-25_20-24-05.jpg)

原创不易，转载也请标明出处和作者，尊重原创。不定期上传到github或者gitee。认准龙腾万里sky，如果看见其它平台不是这个ID发出我的文章，就是转载的。**linux系列文章**：《**初学者如何入门linux，原来linux还可以这样学**》已经上传至github和gitee。个人github仓库地址，一般会先更新PDF文件，然后再上传markdown文件。如果访问github太慢，可以使用gitee进行克隆。

[https://github.com/cnwangk/SQL-study](https://github.com/cnwangk/SQL-study)

<H5><a href="https://github.com/cnwangk/SQL-study">作者：龙腾万里sky </a></H5>
