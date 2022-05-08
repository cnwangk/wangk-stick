MySQL优化流程SQL优化流程：show status查询SQL执行频率、explain分析、show profile分析和trace追踪。

﻿**MySQL优化流程——SQL优化流程**。MySQL优化篇（基于MySQL8.0.28测试验证）。

只停留在看上面，提升效果甚微。应该带着思考去测试佐证，或者使用（同类书籍）新版本进行对比，这样带来的效果更好。最重要的一环，**养成阅读官方文档**，是一个良好的习惯。能编写官方文档，至少证明他们在这个领域是有很高的造诣，对用法足够熟练。

**我**：我可以和您多聊几句吗？
**面试官**：就你那点小心思，我还不知道吗？面试官微微一笑：一样揍得你鼻青脸肿。

**我**：只是想借点技能过来，多学点总归没坏处。
**面试官**：小伙子，真不错，年纪轻轻，挺有觉悟的。

**面试官**：对SQL语句优化流程，你了解多少。
**我**：会那么一丢丢，也总结了一些。

**面试官**：请开始你的表演。
**我**：很荣幸与你展开讨论，请看继续往下看。

在对MySQL进行举例并使用到数据库表，大多数情况使用MySQL官方提供的sakila（模拟电影出租信息管理系统）和world数据库，类似于Oracle的scott用户。



你可以将这篇博文，当成过度到MySQL8.0的参考资料。**友情提示：经验是用来参考，不是拿来即用**。如果您能看到并分享这篇文章，我很荣幸。如果有误导您的地方，我表示抱歉。

如果没有进行特别说明，一般是基于MySQL8.0.28进行测试验证。官方文档非常具有参考意义。目前市面上针对MySQL8.0书籍还比较少，部分停留在5.6.x和5.7.x版本，但仍然具有借鉴意义。


![在这里插入图片描述](https://img-blog.csdnimg.cn/c31371bb6fe54667a734649308365ddd.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_18,color_FFFFFF,t_70,g_se,x_16#pic_center)



个人理解有限，难免出现错误偏差。**所有测试，仅供参考**。

如果感觉对你起到作用，有参考意义，想获取原markdown文件，那就看完文章在文末给出的仓库链接进行获取吧。

[toc]

# MySQL优化流程——SQL语句优化流程



**注意**：在某些情况，你自己测试的结果可能与我演示有所不同，我省略了查询结果的部分参数。

**本文侧重点在SQL优化流程以及MySQL锁问题**（MyISAM和InnoDB存储引擎）。图片可能会挂，演示时尽量使用SQL查询语句返回结果进行示例。篇幅很长，因此使用markdown语法加了目录。

起初，也只是想看MySQL8.0.28有哪些变化，后面索性结合书籍和官方文档总结了一篇。花了将近两周，基本是每天完善一点，因为个人只有晚上和周末有时间总结并测试验证。如果有错别字，也请多多担待。如果你能看到并分享这篇文章，我很荣幸。如果有误导你的地方，我表示抱歉。

如果你是从MySQL5.6或者5.7版本过渡到MySQL8.0。学习之前，建议线看官方文档这一章节：1.3 What Is New MySQL8.0 。在做对比的时候，**文档中带有Note标识是你应该注意的地方**。比如下面这张截图：

![](https://img-blog.csdnimg.cn/img_convert/17d4943de92930dea49aa6fe2eaeac55.png)


## 01	优化SQL语句流程

**登录到mysql字符命令界面**：

```sql
mysql -uroot -p
```

登录时指定端口和主机地址方式：

```sql
mysql -h 192.168.245.147 -uroot -p -P 3307
```

使用？ show帮助命令查询**show status用法**，**截取部分语法如下**：

```sql
? show
SHOW [GLOBAL | SESSION] STATUS [like_or_where]
```
![](https://img-blog.csdnimg.cn/img_convert/b78f03ed8efd1d3d48f17a646350ca55.png)


### 1  通过show status查询SQL执行频率

如果不加参数，默认采用session级别，也可以加上global参数进行测试一下。

使用session与global参数区别：

- session：当前连接统计的结果，默认为session级别；

- global：上次数据库启动至今统计结果，需要手动那个指定global参数。

**下面就列举示例进行说明**，分别使用`like`去查询所有以及匹配CURD操作（select、insert、update、delete）：

**查询当前session所有统计记录**，如果直接在字符命令界面去查询，共有175条记录，大多数情况会采用工具去执行：

```sql
show status LIKE 'com_%';
+-------------------------------------+-------+
| Variable_name                       | Value |
+-------------------------------------+-------+
| Com_admin_commands                  | 0     |
| Com_assign_to_keycache              | 0     |
| Com_alter_db                        | 0     |
| Com_commit    					  | 0     |
| Com_rollback              		  | 0     |
+-------------------------------------+-------+
...
175 rows in set (0.00 sec)
```

![](https://img-blog.csdnimg.cn/img_convert/1aa0bee7b72cbf9b7bfc8dd12223a68c.png)



**Com_xx部分参数作用说明**：

1. Com_xx：代表某某语句执行次数，一般我们关心的是CURD操作（select、insert、update、delete）。
2. Com_select：执行select操作次数，每次累加1次。
3. Com_insert：执行insert操作次数，对于批量执行插入的insert操作只累加1次。
4. Com_update：执行update操作次数。
5. Com_delete：执行delete操作次数。

以上这些参数对所有存储引擎表操作均会进行累计。但也有一些参数只针对InnoDB存储引擎，累加算法有些许不同。

查询innodb参数如下，列举部分：

```sql
show status LIKE 'innodb_rows%';
+---------------------------------------+--------------------------------------------------+
| Variable_name                         | Value                                            |
+---------------------------------------+--------------------------------------------------+
| Innodb_rows_deleted                   | 0                                                |
| Innodb_rows_inserted                  | 0                                                |
| Innodb_rows_read                      | 0                                                |
| Innodb_rows_updated                   | 0                                                |
+---------------------------------------+--------------------------------------------------+
...
61 rows in set (0.00 sec)
```



- InnoDB_rows_read：执行select查询返回行数。
- InnoDB_rows_inserted：执行insert插入操作返回行数。
- InnoDB_rows_updated：执行update更新操作返回行数。
- InnoDB_rows_deleted：执行delete删除操作返回行数。

通过上面几个参数，可以轻松了解当前数据库应用是以插入更新为主还是查询操作为主，以及各种SQL大概执行比例是多少。

**对于更新操作执行次数计数，无论是提交还是回滚都会进行累加**。

对于事务型应用，可以通过`Com_commit`和`Com_rollback`了解事务提交与回滚情况。对回滚操作非常频繁的数据库，可能存在应用编写问题。

有几个参数**便于用户了解数据库情况**：

```sql
show status LIKE 'conn%';
show status LIKE 'upti%';
show status LIKE 'slow_q%';
```



- Connections：试图连接MySQL服务器次数。
- Uptime：服务器工作时间。
- Slow_queries：慢查询次数。

对优化SQL语句流程就介绍这么多，主要对关心的（CURD以及事务）各个参数熟练操作运用。



### 2	定位执行效率较低的SQL语句

可以通过两种方式定位执行效率较低SQL语句：

1. 使用参数：\--log-slow-queries [=file_name]，MySQL会将long_query_time的SQL语句日志写入文件；
2. 使用参数`show  processlist`：查询MySQL线程状态、是否锁表。



慢查询日志在查询结束以后才记录，在应用反映执行效率问题时查询慢查询慢查询日志并不能定位问题。可以使用show  processlist，查看当前MySQL在进行的线程：线程状态、是否锁表，实时查看SQL执行状态。



### 3	使用explain分析执行效率低的SQL语句

参考mysql8.0官方文档explain：

> [https://dev.mysql.com/doc/refman/8.0/en/explain-output.html](https://dev.mysql.com/doc/refman/8.0/en/explain-output.html)
>
> [(https://dev.mysql.com/doc/refman/8.0/en/explain.html) ]((https://dev.mysql.com/doc/refman/8.0/en/explain.html) )

通过上述步骤查询到低效率SQL语句，然后使用`explain`或者`desc`命令获取MySQL如何执行查询select语句。

**语法**：`explain` \[SQL语句]

```sql
explain [SQL语句]
-- 例如
mysql> explain select * from sakila.city\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: city
   partitions: NULL
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 600
     filtered: 100.00
        Extra: NULL
```



**desc语法**：`desc` \[SQL语句 & 表名]

world数据库是官方提供，文初有给链接。

```sql
-- 示例查询world数据库city表结构
desc world.city;
+-------------+----------+------+-----+---------+----------------+
| Field       | Type     | Null | Key | Default | Extra          |
+-------------+----------+------+-----+---------+----------------+
| ID          | int      | NO   | PRI | NULL    | auto_increment |
| Name        | char(35) | NO   |     |         |                |
| CountryCode | char(3)  | NO   | MUL |         |                |
| District    | char(20) | NO   |     |         |                |
| Population  | int      | NO   |     | 0       |                |
+-------------+----------+------+-----+---------+----------------+
5 rows in set (0.00 sec)

-- 分析查询语句信息
mysql> desc select * from world.city\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: city
   partitions: NULL
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 4046
     filtered: 100.00
        Extra: NULL
```

以上是对explain与desc语法的介绍，以及简单使用。侧重点不在desc，主要以explain进行说明。



**接下来对各个参数进行演示说明**：

| 序号 | explain & desc参数 | 作用                                                         |
| ---- | ------------------ | ------------------------------------------------------------ |
| 1    | id                 | 查询标识符。                                                 |
| 2    | select_type        | select类型，一般有simple、primary、union、subquery。         |
| 3    | table              | 输出结果集表。查询的表名，如果使用了别名，则显示别名。       |
| 4    | partitions         | 对分区的支持。                                               |
| 5    | type               | 执行计划分析使用**访问类型**，ALL代表全表扫描。              |
| 6    | possible_keys      | 查询时可使用的索引。                                         |
| 7    | key                | 实际使用到的索引。                                           |
| 8    | key_len            | 使用到索引字段长度。                                         |
| 9    | ref                | 与索引比较的列。在type中类型的一种，使用到索引。             |
| 10   | rows               | 扫描行数，并不代表实际使用count(*)检索的所有行数，是一个估值。 |
| 11   | filtered           | 过滤恒定成立条件。                                           |
| 12   | Extra              | 执行情况说明和描述，包含不适合在其它列中显示，但对执行计划有帮助的额外信息。 |



**常见访问类型（type）**：

![在这里插入图片描述](https://img-blog.csdnimg.cn/c8fe3652f71146d69da660db55c137d4.png#pic_center)

```sql
+------+--------+--------+------+---------+---------------+----------+
| ALL  | index  | range  | ref  | eq_ref  | const,system  |   NULL   | 
+------+--------+--------+------+---------+---------------+----------+
```

**性能天梯排行榜**：**由左至右，依次递增**。



**3.1、type=ALL**：代表全表扫描，MySQL遍历全表匹配行。

**示例**：演示type为ALL执行计划

```sql
explain select * from world.city;
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/1d9ab46b817d47b79c0dd84d6bfcbb0a.png#pic_center)




**3.2、type=index**：索引全扫描，MySQL遍历整个索引匹配行。

如果不清除哪一个是主键或者是index，使用desc命令查看，`desc world.city`

**示例**：演示type为index执行计划

```sql
explain select id from world.city;
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/8940892215ba4482939f98cc1e091dae.png#pic_center)




**3.3、type=range**：索引范围扫描，常见于<、<=、>、>=、between等操作符。

>  =, <>, >, >=, <,<=, IS NULL, <=>, BETWEEN, LIKE, or IN()
>
>  8.8.2 explain output format range介绍



**示例**：演示type为range执行计划

```sql
explain select * from world.city c where c.id<6;
```

![](https://img-blog.csdnimg.cn/img_convert/17261baa29a2a75703bf7b353f18ae21.png)



**3.4、type=ref**：使用非唯一索引扫描或唯一索引的前缀扫描，返回某个单独值匹配记录行。

**示例**：演示type为ref执行计划

```sql
explain select * from world.city where countrycode='AFG';
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/7e0ec0745b6742c2973db31d6ec96c7b.png#pic_center)


**ref往往还经常出现在join操作中**。

**示例**：演示type为ref执行计划，使用inner join内连接

```sql
 explain select * from world.city t1 inner join world.countrylanguage t2 on t1.countrycode=t2.countrycode;
```

![](https://img-blog.csdnimg.cn/img_convert/8790eef2b206aaa39ce8eefec5e3d448.png)



**3.5、type=eq_ref**：与ref类似，区别eq_ref使用唯一索引。每个索引键值，表中只有一条匹配记录行。简单来说，在多表连接查询中使用`primary key`或者`unique index`作为**关联条件**。

**示例**：演示type为eq_ref执行计划

```sql
explain select * from sakila.film t1,sakila.film_text t2 where t1.film_id=t2.film_id;
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/b207db6a34eb419997f6e419881415b5.png#pic_center)


**3.6、type=const&system**：单表中最多有一条匹配行，查询速度很快。这条匹配行中其它列值可以被优化器在当前查询中当做常量来处理。例如，根据主键`primary key`或者唯一索引`unique key`进行查询。


**示例**：演示type为const执行计划

```sql
explain select * from world.city t where t.id=7;
```

![](https://img-blog.csdnimg.cn/img_convert/1b03276c215792cd95734f6bcaf9fb39.png)



**3.7、type=NULL**：MySQL不用访问表或索引，直接得到结果。

**示例**：演示type为NULL执行计划

```sql
explain select 1;
```

![](https://img-blog.csdnimg.cn/img_convert/216ef482816324d89eae93d9450b347e.png)



以前，只知道统计查询表使用MyISAM存储引擎非常快，但不知其原理。使用explain分析了下，看到访问类型（type）是NULL，瞬间有点明白了。**下图是使用InnoDB与MyISAM存储引擎表的对比**：

![](https://img-blog.csdnimg.cn/img_convert/3e8a204178603f84a6d1c2dcb181e7d2.png)

个人只演示常见的几种。官方示例比较多，比如：ref_or_null、index_merge以及index_subquery等等。

你可以找到参考文档：

> 8.8.3 Extended EXPLAIN Output Format

**tips**：在MySQL8.0中移除了`explain extended`，使用这条命令分析SQL语句会报（1064（42000））。

某种场景下，使用explain并不能满足我们需求，需要更高效定位问题，此时可以配合`show profile`命令联合分析。



### 4	show profile分析SQL

查看当前MySQL版本对`profile`是否支持：**如果是YES，代表是支持的**。

```sql
mysql> select @@have_profiling;
+------------------+
| @@have_profiling |
+------------------+
| YES              |
+------------------+
1 row in set, 1 warning (0.00 sec)
```



**默认show profiling是关闭的**，可以通过set命令设置session级别开启profiling：

```sql
select @@profiling;
+-------------+
| @@profiling |
+-------------+
|           0 |
+-------------+
1 row in set, 1 warning (0.00 sec)
```

**开启profiling**：设置profiling参数值为1，默认是0。

```sql
mysql> set profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> select @@profiling;
+-------------+
| @@profiling |
+-------------+
|           1 |
+-------------+
1 row in set, 1 warning (0.00 sec)
```

**示例**：

1. 统计查询world数据库city表行记录数；
2. 执行show profiles命令分析SQL。

**统计city表记录**：

```sql
mysql> select count(*) from world.city;
+----------+
| count(*) |
+----------+
|     4079 |
+----------+
1 row in set (0.01 sec)
```



**使用show profiles命令分析**：

**示例**：

```sql
mysql> show profiles;
+----------+------------+---------------------------------+
| Query_ID | Duration   | Query                           |
+----------+------------+---------------------------------+
|        1 | 0.00017800 | select @@profiling              |
|        2 | 0.00115675 | select count(*) from world.city |
+----------+------------+---------------------------------+
2 rows in set, 1 warning (0.00 sec)
```



使用`show profile for query`语句可以**查询到执行过程中线程更多信息**：状态、消耗时间

**示例**：截取部分参数作为演示。

```sql
mysql> show profile for query 2;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000059 |
| Executing hook on transaction  | 0.000003 |
...
+--------------------------------+----------+
17 rows in set, 1 warning (0.01 sec)
```



 **更具上面查到的参数值，可以进一步分析是哪些影响到查询效率**。

**更多用法请参考官方文档**：

> 13.7.7.30 SHOW PROFILE Statement
>
> 13.7.7.31 SHOW PROFILES Statement

```sql
SHOW PROFILE [type [, type] ... ]
[FOR QUERY n]
[LIMIT row_count [OFFSET offset]]
type: {
ALL
| BLOCK IO | CONTEXT SWITCHES | CPU 	| IPC
| MEMORY   | PAGE FAULTS      | SOURCE 	| SWAPS
}
```

比如从BLOCK IO（锁输入和输出操作）、CPU（用户系统CPU消耗时间）、内存等等着手分析。

**判断用户CPU消耗时间**，**可以统计数据量大一点的表**：我统计这张表模拟数据为1kw条。

```sql
show profile CPU for query 1;
+--------------------------------+----------+----------+------------+
| Status                         | Duration | CPU_user | CPU_system |
+--------------------------------+----------+----------+------------+
| executing                      | 1.685893 | 5.593750 |   0.375000 |
+--------------------------------+----------+----------+------------+
```



### 5	使用trace分析优化器如何选择执行计划

查看trace是否开启：`OPTIMIZER_TRACE`

- enabled：默认为off。on代表开启，off代表关闭。
- one_line：json格式显示，是否以一行显示。on代表一行显示，off代表多行显示（格式化）。

```sql
select @@OPTIMIZER_TRACE;
+-------------------------+
| @@OPTIMIZER_TRACE       |
+-------------------------+
| enabled=on,one_line=on  |
+-------------------------+
```



**示例**：临时开启`trace`，在字符命令行中使用，测试建议还是使用一行显示比较好。

```sql
set OPTIMIZER_TRACE="enabled=on,one_line=on";
```

**示例**：

1. 查询world数据库city（城市）表前两行记录。
2. 然后使用trace（optimizer_trace分析）追踪。

```sql
-- 1. 查询world数据库city（城市）表前两行记录。
select * from world.city limit 0,2;
-- 2. 然后使用trace追踪。
select * from information_schema.optimizer_trace\G
*************************** 1. row ***************************
                            QUERY: select * from world.city limit 0,2
                            TRACE: {"steps": [{"join_preparation": {"select#": 1,"steps": [{"expanded_query": "/* select#1 */ select `world`.`city`.`ID` AS `ID`,`world`.`city`.`Name` AS `Name`,`world`.`city`.`CountryCode` AS `CountryCode`,`world`.`city`.`District` AS `District`,`world`.`city`.`Population` AS `Population` from `world`.`city` limit 0,2"}]}},{"join_optimization": {"select#": 1,"steps": [{"table_dependencies": [{"table": "`world`.`city`","row_may_be_null": false,"map_bit": 0,"depends_on_map_bits": []}]},{"rows_estimation": [{"table": "`world`.`city`","table_scan": {"rows": 4046,"cost": 9.375}}]},{"considered_execution_plans": [{"plan_prefix": [],"table": "`world`.`city`","best_access_path": {"considered_access_paths": [{"rows_to_scan": 4046,"access_type": "scan","resulting_rows": 4046,"cost": 413.975,"chosen": true}]},"condition_filtering_pct": 100,"rows_for_plan": 4046,"cost_for_plan": 413.975,"chosen": true}]},{"attaching_conditions_to_tables": {"original_condition": null,"attached_conditions_computation": [],"attached_conditions_summary": [{"table": "`world`.`city`","attached": null}]}},{"finalizing_table_conditions": []},{"refine_plan": [{"table": "`world`.`city`"}]}]}},{"join_execution": {"select#": 1,"steps": []}}]}
MISSING_BYTES_BEYOND_MAX_MEM_SIZE: 0
          INSUFFICIENT_PRIVILEGES: 0
1 row in set (0.00 sec)
```



### 6	定位问题后采取相应优化方法

**建立索引**：在常用字段上建立，不常用字段（应该考虑是否建立）。

经过上述步骤第3步explain分析SQL查询语句，使用explain执行计划发现使用全表扫描（大量数据）非常耗时间。

**在相应字段建立索引**，然后进行分析，扫描行数明细减少，大大提高数据库访问速度。

## 02	MySQL官方示例数据库

给出**sakila-db数据库**包含三个文件，便于大家获取与使用：

1. sakila-schema.sql：数据库表结构；
2. sakila-data.sql：数据库示例模拟数据；
3. sakila.mwb：数据库物理模型，在MySQL workbench中可以打开查看。

> [https://downloads.mysql.com/docs/sakila-db.zip](https://downloads.mysql.com/docs/sakila-db.zip)

**只是用于用于简单测试学习，建议使用world-db**：

**world-db数据库**，包含三张表：city、country、countrylanguage。

> [https://downloads.mysql.com/docs/world-db.zip](https://downloads.mysql.com/docs/world-db.zip)

最后附上官方示例数据库，**sakila-db数据库**一个非常完整的示例。包含：视图、函数、触发器以及存储过程，当然也存在使用外键。


关于MySQL索引问题，会在后续博文中进行总结。


**参考资料&鸣谢**：

- 《深入浅出MySQL 第2版 数据库开发、优化与管理维护》
- 《MySQL技术内幕InnoDB存储引擎 第2版》
- MySQL8.0官网文档：refman-8.0-en.pdf，**如果学习新版本，官方文档是非常不错的选择**。

虽然书籍年份比较久远（停留在MySQL5.6.x版本），但仍然具有借鉴意义。

最后，对以上书籍和官方文档所有作者表示衷心感谢。让我充分体会到：前人栽树，后人乘凉。



# 莫问收获，但问耕耘

**能看到这里的，都是帅哥靓妹**。以上是本次MySQL优化流程——SQL语句优化流程的全部内容，希望能对你的工作与学习有所帮助。感觉写的好，就拿出你的一键三连。如果感觉总结的不到位，也希望能留下您宝贵的意见，我会在文章中定期进行调整优化。**好记性不如烂笔头，多实践多积累**。**你会发现，自己的知识宝库越来越丰富**。原创不易，转载也请标明出处和作者，尊重原创。

一般情况下，会优先在公众号发布：龙腾万里sky。

不定期上传到github仓库：

> [https://github.com/cnwangk/wangk-stick](https://github.com/cnwangk/wangk-stick)