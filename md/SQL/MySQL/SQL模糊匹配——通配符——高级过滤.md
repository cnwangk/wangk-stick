SQL查漏补缺：like模糊匹配、通配符、高级过滤。

[toc]

## SQL查漏补缺

个人感觉对实际工作作用比较大的一些SQL关键字总结。

### 1	通配符过滤数据

**通配符**：用来匹配值的一部分的特殊字符。

**搜索模式**：由字面值、通配符或者两者组合构成的搜索条件。



#### 1.1	百分号%通配符

**作用**：个人在工作中，最常用通配符是百分号（%）。在搜索字符中，%表示任何字符出现任意次数。

**例如**：在使用show查询MySQL自带一些参数时，配合like去模糊匹配，并且使用通配符百分号%。

**查询当前session所有统计记录**，如果直接在字符命令界面去查询，共有175条记录

```sql
show status LIKE 'com_%';
+-------------------------------------+-------+
| Variable_name                       | Value |
+-------------------------------------+-------+
| Com_commit    					  | 0     |
| Com_rollback              		  | 0     |
+-------------------------------------+-------+
...
175 rows in set (0.00 sec)
```

![](https://gitee.com/dywangk/img/raw/master/images/show_status用法_proc.jpg)

**Com_xx部分参数作用说明**：

1. Com_xx：代表某某语句执行次数，一般我们关心的是CURD操作（select、insert、update、delete）。
2. Com_select：执行select操作次数，每次累加1次。
3. Com_insert：执行insert操作次数，对于批量执行插入的insert操作只累加1次。
4. Com_update：执行update操作次数。
5. Com_delete：执行delete操作次数。

有几个参数**便于用户了解数据库情况**：

```sql
show status LIKE 'conn%';
show status LIKE 'upti%';
show status LIKE 'slow_q%';
```

![](https://gitee.com/dywangk/img/raw/master/images/c_u_s了解数据库基本情况_proc.jpg)

- Connections：试图连接MySQL服务器次数。
- Uptime：服务器工作时间。
- Slow_queries：慢查询次数。



#### 1.2	下划线（_）通配符

**作用**：这同样是一个比较有用的通配符。下划线用途和%一样，但有限制，只匹配单个字符。

**示例**：在MySQL中创建数据库、表以及插入演示数据。

```sql
-- 1.创建数据库test
create database test;
use test;

-- 2.创建一张表演示。
CREATE TABLE `bols` (
  `id` int NOT NULL AUTO_INCREMENT,
  `girl_names` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `sex` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `cup_size` varchar(8) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8_bin

-- 3.插入数据,省略掉了字段，实际工作开发中建议加上字段。
insert into test.bols values(1001,'18 bols D','女','D');
insert into test.bols values(1005,'20 bols D','女','D');
insert into test.bols values(1006,'9 bols A','女','A');

-- 4.使用通配符下划线_匹配。
mysql> select * from test.bols where girl_names like  '__ bols D'; -- 两个占位符
+------+------------+-----+----------+
| id   | girl_names | sex | cup_size |
+------+------------+-----+----------+
| 1001 | 18 bols D  | 女  | D        |
| 1005 | 20 bols D  | 女  | D        |
+------+------------+-----+----------+
2 rows in set (0.00 sec)

mysql> select * from test.bols where girl_names like  '_ bols A'; -- 1个占位符
+------+------------+-----+----------+
| id   | girl_names | sex | cup_size |
+------+------------+-----+----------+
| 1006 | 9 bols A   | 女  | A        |
+------+------------+-----+----------+
1 row in set (0.00 sec)
```

**tips**：DB2不支持下划线（_）通配符。



#### 1.3	方括号\[ ]通配符

**作用**：方括号\[ ]通配符用来指定一个字符集，它必须匹配指定位置（通配符的位置）的一个字符。

**tips**：与上述示范的通配符不一样，并不是所有DBMS都支持用来创建集合的\[ ]。微软的SQL Server支持集合，但是MySQL，Oracle，DB2，SQLite都不支持。验证你使用的DBMS是否支持集合，请参考各自厂商提供的官方文档。

**例如**：我想匹配含有b和o的老师姓名，**在SQL Server2012中演示**。

```sql
select * from dbo.girl where girl_name like  '[bo]%';
+------+------------+-----+----------+
| id   | girl_name  | sex | cup_size |
+------+------------+-----+----------+
| 1004 | bols D 18  | 女  | 	   D    |
| 1005 | bols D 20  | 女  | 	   D    |
+------+------------+-----+----------+
```



**1.4	使用通配符技巧**

1. 不过度使用通配符。
2. 尽量不要将通配符放搜索模式的最开始处。
3. 注意通配符位置。



### 2	高级数据过滤

**操作符**：用来联结或改变where子句中的子句的关键字，也称为逻辑操作符（local operator）。

我们通常使用where子句进行过滤数据时，一般是单过滤条件。

**组合where子句**：为了进行更强的过滤控制。当然也可以使用多个`where`子句过滤，比如使用`and`子句或者`or`子句。

1. and操作符；
2. or操作符；
3. in操作符；
4. not操作符。



#### 	2.1	and操作符

使用and操作符给where子句附加条件，多重过滤。

**作用**：用在where子句中的关键字，用来指示检索满足所有给定条件的行。通俗点讲，给定条件都要满足才能检索出数据行。

**示例**：接着上面通配符bols示例继续，查询尺寸为D并且ID小于1005。

```sql
select * from test.bols where (cup_size='D' and id<1005);
+------+------------+-----+----------+
| id   | girl_names | sex | cup_size |
+------+------------+-----+----------+
| 1001 | 18 bols D  | 女  | D        |
| 1004 | 16 bols C  | 女  | D        |
+------+------------+-----+----------+
```



#### 2.2	or操作符

or操作符与and操作符正好相反，指示DBMS满足任意一个条件即可检索出数据行。

实际上，许多DBMS在 `or where`子句的第一个条件得到满足情况下，就不再计算第二个条件（即在第一个条件满足时，无论第二个条件是否满足，相应行都将被匹配出来）。

**作用**：where子句中使用的关键字，用来表示检索匹配任意给定条件的行。

**示例**：查询尺寸为D或者尺寸为C的数据行。

```sql
select * from test.bols where (cup_size='D' or cup_size='C');
+------+------------+-----+----------+
| id   | girl_names | sex | cup_size |
+------+------------+-----+----------+
| 1001 | 18 bols D  | 女  | D        |
| 1002 | 18 jizels  | 女  | C        |
| 1003 | longls     | 女  | C        |
| 1004 | 16 bols C  | 女  | D        |
| 1005 | 20 bols D  | 女  | D        |
+------+------------+-----+----------+
```

**分析**：使用or操作符，满足D或者C任一条件，返回匹配行，5条数据全部检索出。如果换成and操作符，则不会检索到匹配的数据行。

**总结**：任何时候使用and和or操作符的where子句，应该使用圆括号明确地分组操作符。不应过分依赖默认求值顺序，即使它明确是你希望得到的结果。使用圆括号并没啥坏处，相反可以养成好习惯。



#### 2.3	in操作符

in操作符用来指定条件范围，范围中每个条件都可以进行匹配。in取一组逗号分隔，圈在圆括号中的合法值。

**作用**：where子句中用来指定要匹配值清单的关键字，功能与or相当。

**示例**：取姓名为longls和jizels两条数据行。

```sql
-- 1.示例，修改一条数据，便于演示
update test.bols set girl_names='jizels' where id=1002;
commit;-- 提交事务

-- 2.使用in操作符
select * from test.bols where girl_names in('longls','jizels');
+------+------------+-----+----------+
| id   | girl_names | sex | cup_size |
+------+------------+-----+----------+
| 1002 | jizels     | 女  | C        |
| 1003 | longls     | 女  | C        |
+------+------------+-----+----------+
```

**in操作符优点**：

1. 很多场景下，in操作符语法更清楚，更直观。
2. 与其它and和or操作符组合使用时，求职顺序更容易管理。
3. 一般比一组or操作符执行更快。
4. 最大优点可以包含其它select语句，动态建立where子句。



#### 2.4	not操作符

where子句中的操作符有且只有一个功能，否定其后多跟的任何条件。因为not基本不单独使用，，往往与其它操作符组合使用。

**作用**：where子句中用来否定其后条件的关键字。

**示例**：匹配出不包含longls和jizels的数据行，和in操作符组合使用，否定in条件中的两条数据行。

```sql
select * from test.bols where girl_names not in('longls','jizels');
+------+------------+-----+----------+
| id   | girl_names | sex | cup_size |
+------+------------+-----+----------+
| 1001 | 18 bols D  | 女  | D        |
| 1004 | 16 bols C  | 女  | D        |
| 1005 | 20 bols D  | 女  | D        |
| 1006 | 9 bols A   | 女  | A        |
+------+------------+-----+----------+
```

**tips**：MariaDB中的not操作符。MariaDB支持使用not否定in、between和exists子句。大多数DBMS允许not否定任何条件。



###  3 	show关键字（MySQL）

列举一些MySQL中常用show使用方式。

#### 3.1	查询MySQL有哪些自带数据库

```sql
>mysql show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

**tips**：在mysql中可以使用系统帮助命令 ? show查看用法。



#### 3.2	SQL优化，统计CURD（增删改查）操作次数

从下面Com_select为44，可以看出select查询次数已经使用了44次。

**示例**：同理可以查询Com_insert、Com_delete和Com_update，一般情况会配合通配符使用哟。

```sql
mysql> show status like 'Com_se%';
+------------------------+-------+
| Variable_name          | Value |
+------------------------+-------+
| Com_select             | 44    |
| Com_set_option         | 2     |
| Com_set_password       | 0     |
| Com_set_resource_group | 0     |
| Com_set_role           | 0     |
+------------------------+-------+
```

**注意**：在MySQL中不同存储引擎查询结果可能略微有所不同。



**参考文献**：

- 《SQL必知必会第五版》
- MySQL8.0官方文档



# 莫问收获，但问耕耘

**养得胸中一种恬静，方得始终**。

学无止境，向阳而生。好啦！到此为止就是此篇文章的全部内容了！**能看到这里的都是帅哥靓妹啊**！！！善于总结，其乐不穷。**好记性不如烂笔头**，多收集自己第一次尝试的成果，收获也颇丰。**你会发现，自己的知识宝库越来越丰富**。