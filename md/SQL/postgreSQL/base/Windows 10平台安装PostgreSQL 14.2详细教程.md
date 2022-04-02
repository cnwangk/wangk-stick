Windows 10平台安装postgreSQL 14.2.1，安装步骤很简单，基本上是点击下一步（next）。

使用SQL Shell（psql）进行交互；使用pgAdmin工具进行管理。

**tips**：注意选择安装目录（请不要放到C盘，虚拟机搭建测试环境另说）。

[toc]

# postgreSQL安装详细教程 

## 一	postgreSQL 安装步骤

### 01 下载postgreSQL 

Windows版本（64位）postgreSQL 14.2.1下载地址：

> [https://www.enterprisedb.com/postgresql-tutorial-resources-training?uuid=db55e32d-e9f0-4d7c-9aef-b17d01210704&campaignId=7012J000001NhszQAC](https://www.enterprisedb.com/postgresql-tutorial-resources-training?uuid=db55e32d-e9f0-4d7c-9aef-b17d01210704&campaignId=7012J000001NhszQAC)

**官网**：[https://www.postgresql.org](https://www.postgresql.org)

**官方文档**：

> [https://www.postgresql.org/docs/](https://www.postgresql.org/docs/)
>
> 最新版本14的PDF下载地址：[https://www.postgresql.org/files/documentation/pdf/14/postgresql-14-A4.pdf](https://www.postgresql.org/files/documentation/pdf/14/postgresql-14-A4.pdf)



### 02	Windows 10安装postgreSQL 14.2

**2.1	安装步骤01**

Setup	—— PostgreSQL

进入PostgreSQL安装界面

![](https://gitee.com/dywangk/img/raw/master/images/01.jpg)



**2.2	安装步骤02**

Installation Directory

**注意**：选择安装目录，推荐安装至D盘或者顺延。

![](https://gitee.com/dywangk/img/raw/master/images/02.jpg)



**2.3	安装步骤03**

Select components

**选择需要安装的服务**：

1. PostgreSQL Server：数据库（DBMS）服务，**必选项**。
2. pgAdmin 4：客户端管理工具，建议勾选。
3. Stack Builder：依据需求选择。
4. Command Line Tools：命令行工具，交互**必选项**。

![](https://gitee.com/dywangk/img/raw/master/images/03.jpg)



**2.4	安装步骤04**

Data Directory

设置数据库实例化数据存放目录。类似于MySQ初始化生成data目录。

![](https://gitee.com/dywangk/img/raw/master/images/04.jpg)



**2.5	安装步骤05**

Set Password

设置数据库超级用户（postgres）密码。

如果初始化失败，后续则不会生效。

![](https://gitee.com/dywangk/img/raw/master/images/05.jpg)



**2.6	安装步骤06**

Port

设置默认监听端口（port）：5432

![](https://gitee.com/dywangk/img/raw/master/images/06.jpg)



**2.7	安装步骤07**

Advanced Options

建议选择数据库群组（database cluster），下拉有中文简体可选。

cluster有集群的意思，但在此处指的是组、群组、国别地区（安装支持的语言）。

**注意**：这一步初始化后生成的data目录是空的，可能是权限问题（**会有警告提示**，导致初始化失败，虽然最终安装完成）。

![](https://gitee.com/dywangk/img/raw/master/images/07.jpg)



**2.8	安装步骤08**

Pre Installation Summary

**打印出安装配置信息**，其它数据库厂商（DBMS）提供的可视化界面安装一样会有信息显示，例如Oracle数据库。

![](https://gitee.com/dywangk/img/raw/master/images/08.jpg)



**2.9	安装步骤09**

Ready to Install

到了这一步，真正开始执行安装过程。

![](https://gitee.com/dywangk/img/raw/master/images/09.jpg)



关于遇到的警告问题，会在遇到问题解决方案进行展示说明，并给出个人解决方案。



### 03	postgreSQL 安装目录说明

**3.1	postgreSQL 安装目录重点说明**

1. bin：bin目录一般存放与数据库服务进行交互的命令脚本。
2. data：data目录是初始化完成后生成的数据库文件，包含配置文件postgresql.conf。
3. pgAdmin 4 ：存放pgAdmin 4客户端管理工具文件。
4. uninstall-postgresql.dat与uninstall-postgresql.exe：提供便捷式卸载。

![](https://gitee.com/dywangk/img/raw/master/images/13%20%E5%AE%89%E8%A3%85%E7%9B%AE%E5%BD%95%E8%AF%B4%E6%98%8E_proc.jpg)



**3.2	data目录**

1. 主要注意postgresql.conf配置文件，比如配置监听端口（port）和主机（IP）地址。

![](https://gitee.com/dywangk/img/raw/master/images/14%20data%E7%9B%AE%E5%BD%95%E8%AF%B4%E6%98%8E_proc.jpg)

**3.3	配置文件设置**

1. listen_addresses：设置监听主机地址，重启服务生效。
2. port：设置监听服务默认端口，重启服务生效。

![](https://gitee.com/dywangk/img/raw/master/images/15%20postgresql%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6_proc.jpg)



## 二	postgreSQL 遇到问题解决方案

### 01	遇到问题处理方法 

1. **定位问题**：遇到问题别慌，也别急着去使用搜索引擎，先将问题定位好。
2. 文档：**参考官方文档**。
3. 善于使用搜索引擎和**StackOverflow**以及**github的Issues**。
4. 使用浏览器过滤方式：-xx网址或者-site:xx网址。



例如，**个人安装遇到问题**（Warning）警告：

> Problem running  post-install  step. Installation may not complete correctly
>
> The database cluster installation failed  

![](https://gitee.com/dywangk/img/raw/master/images/10%20%E9%81%87%E5%88%B0%E7%9A%84%E9%97%AE%E9%A2%98.jpg)

我第一时间联想到的是初始化出问题了，**去检查data目录**，果不其然是空的。

如果你有一些英语底子（说实话，个人基本是靠平时积累的词汇量和有道），一些命令基本上可以猜个八九不离十。

以前我的同事问我，你是猜的？结果发现还挺准的。后面还有一句话没说出来而已，其实是有一定依据才去试一试的。



### 02	实际解决方案

个人根据以前使用MySQL（其它数据库）的经验进行判断，结合官方文档进行思考的临时解决方案。

出现警告后，使用以下方式解决无法启动postgreSQL：

1. 检查data目录是空的（初始化失败了）。

2. 使用cmd（管理员身份）执行initdb命令初始化。

```bash
D:\software\PostgreSQL\14\bin>initdb "D:\software\PostgreSQL\14\data"
```

3. 继续在cmd（管理员身份）窗口执行创建用户。

```bash
D:\software\PostgreSQL\14\bin>createuser postgres
```

4. 普通用户身份启动postgreSQL。

​	   如果没有配置环境变量，注意在**PostgreSQL\14\bin目录下执行postgres命令**。使用这种方式启动服务，**使用Ctrl + c快捷键即可退出服务**。

```bash
D:\software\PostgreSQL\14\bin>postgres --config-file="D:\\software\\PostgreSQL\\14\\data\\postgresql.conf" -D "D:\\software\\PostgreSQL\\14\\data"
```

5. 或者使用`pg_ctl start`命令启动服务（postgreSQL加入path环境变量）。

```bash
D:\>pg_ctl start -D "D:\software\PostgreSQL\14\data"
```

6. 使用`pg_ctl stop`命令关闭服务。

```bash
D:\>pg_ctl stop -D "D:\software\PostgreSQL\14\data"
```

如下是使用`pg_ctl`命令启动服务，然后使用`netstat`命令去验证服务是否启动。

![](https://gitee.com/dywangk/img/raw/master/images/%E5%90%AF%E5%8A%A8postgreSQL_proc.jpg)



安装后第二天查阅StackOverflow：其实解决方案相差不大，和我思考分方向是一致的，可以参考。

> https://stackoverflow.com/questions/32453451/postgres-installation-the-database-cluster-initialization-failed-postgresql-ve



## 三	使用SQL Shell（psql）进行交互

### 01	使用select语句验证

进入SQL Shell（psql）交互界面，直接回车即可进入（**前提是服务启动成功**）

如同在MySQL中，使用select 1直接返回结果，这种方式是不走表的，通过explain分析就可看出。

```sql
select 1;
```



![](https://gitee.com/dywangk/img/raw/master/images/11%20%E5%88%9D%E6%AD%A5%E4%BD%BF%E7%94%A8psql%E4%BA%A4%E4%BA%92_proc.jpg)



### 02	使用explain进行测试

使用explain测试select 1：

```sql
explain select 1;
```

![](https://gitee.com/dywangk/img/raw/master/images/12%20%E6%B5%8B%E8%AF%95%E6%89%A7%E8%A1%8C%E8%AE%A1%E5%88%92explain_proc.jpg)



## 四	使用pgAdmin进行管理

**01	配置服务名称**

**注意**：Name是必填项。

![](https://gitee.com/dywangk/img/raw/master/images/01%20pgAdmin_proc.jpg)



**02	配置连接**

1. HOST name、address：配置主机名或者IP地址。
2. Port：配置连接监听端口（启动服务时，在配置文件设置的端口）。
3. Usernam：用户名。
4. Password：用户密码。

![](https://gitee.com/dywangk/img/raw/master/images/02%20pgAdmin%E9%85%8D%E7%BD%AE%E8%BF%9E%E6%8E%A5_proc.jpg)



**03	初次进入pgAdmin需要配置密码**

![](https://gitee.com/dywangk/img/raw/master/images/%E4%BD%BF%E7%94%A8pgAdmin%204_01_proc.jpg)



**04	配置完后的界面**

progres和test是自己使用命令创建的：

```sql
createuser progres
createuser test
```



![](https://gitee.com/dywangk/img/raw/master/images/03%20pgAdmin%E8%BF%9E%E6%8E%A5postgreSQL_proc.jpg)



# 莫问收获，但问耕耘

以上是本文全部内容，希望能对你的工作与学习有所帮助。善于总结，其乐不穷。**好记性不如烂笔头**，多收集自己第一次尝试的成果，收获也颇丰。**你会发现，自己的知识宝库越来越丰富**。原创不易，转载也请标明出处和作者，尊重原创。不定期上传到github仓库SQL-study。

![](https://img-blog.csdnimg.cn/img_convert/9274af9e14216005237b8c9698286908.png)
