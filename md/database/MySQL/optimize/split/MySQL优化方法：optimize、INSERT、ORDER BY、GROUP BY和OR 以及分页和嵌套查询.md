主要介绍：MySQL定期分析表、定期优化表；批量（大量）插入数据优化技巧；优化 INSERT、ORDER BY、GROUP BY 语句、优化 OR 条件；优化嵌套查询、分页查询；使用SQL提示。

只停留在看上面，提升效果甚微。应该带着思考去测试佐证，或者使用（同类书籍）新版本进行对比，这样带来的效果更好。最重要的一环，**养成阅读官方文档**，是一个良好的习惯。能编写官方文档，至少证明他们在这个领域是有很高的造诣，对用法足够熟练。

[toc]

示例数据库使用MySQL官方提供的sakila（模拟电影出租信息管理系统）和world数据库，类似于Oracle的scott用户。


你可以将这篇博文，当成过度到MySQL8.0的参考资料。**友情提示：经验是用来参考，不是拿来即用**。如果您能看到并分享这篇文章，我很荣幸。如果有误导您的地方，我表示抱歉。

如果没有进行特别说明，一般是基于MySQL8.0.28进行测试验证。官方文档非常具有参考意义。

![](https://img-blog.csdnimg.cn/img_convert/acf1fd88c4b72660309388d03852a999.png)

**注意**：在某些情况，你自己测试的结果可能与我演示有所不同，我省略了查询结果的部分参数。

如果你是从MySQL5.6或者5.7版本过渡到MySQL8.0。学习之前，建议线看官方文档这一章节：1.3 What Is New MySQL8.0 。在做对比的时候，**文档中带有Note标识是你应该注意的地方**。比如下面这张截图：

![](https://img-blog.csdnimg.cn/img_convert/17d4943de92930dea49aa6fe2eaeac55.png)





# MySQL优化——SQL语句常用优化方法

### 01 简单优化方法

对于开发人员来说，可能只需掌握简单实用的优化方法。比较复杂的优化，一般交给DBA来管理。

1. `analyze`：分析表，analyze table table_name;
2. `check`：检查表，check table table_name;
3. `checksum table`：检查表；
4. `optimize table`：优化表，同时支持MyISAM和InnoDB表。回收删除操作造成的空洞，比如回收索引。
5. `repair table`：修复表，支持 MyISAM，ARCHIVE以及CSV 表。



#### 1.1	定期分析表和检查表

定期分析与检查主要有两个关键命令：

1. `analyze`：分析表，analyze table table_name;
2. `check`：检查表，check table table_name;

**分析（analyze）表语法**：

```sql
ANALYZE [NO_WRITE_TO_BINLOG | LOCAL]
TABLE tbl_name [, tbl_name] ...

ANALYZE [NO_WRITE_TO_BINLOG | LOCAL]
TABLE tbl_name

UPDATE HISTOGRAM ON col_name [, col_name] ...
[WITH N BUCKETS]

ANALYZE [NO_WRITE_TO_BINLOG | LOCAL]
TABLE tbl_name
DROP HISTOGRAM ON col_name [, col_name] ...
```

**示例分析表**：可以使用官方示例库进行分析，个人使用自己创建test数据库进行测试tolove表

```sql
analyze table test.tolove;
+-------------+---------+----------+-----------------------------+
| Table       | Op      | Msg_type | Msg_text                    |
+-------------+---------+----------+-----------------------------+
| test.tolove | analyze | status   | Table is already up to date |
+-------------+---------+----------+-----------------------------+
1 row in set (0.01 sec)
```



**总结**：analyze语句用于分析存储表关键字分布，分析结果使系统得到更准确的信息，SQL生成预期执行计划。如果你感觉实际执行计划没有达到预期结果，不妨尝试执行一次分析表计划。



**检查（check）表语法**：

```sql
CHECK TABLE tbl_name [, tbl_name] ... [option] ...
option: {
FOR UPGRADE
| QUICK	| FAST	| MEDIUM
| EXTENDED	| CHANGED
}
```



**示例检查表**：这张tolove表创建后修改为`MyISAM`存储引擎进行测试，**数据量1kw**，所以分析起来有点耗时。

**tips**：同时测试使用InnoDB表，数据量1kw，花了5.21sec，这里就不贴出来了。

```sql
mysql> check table test.tolove;
+-------------+-------+----------+----------+
| Table       | Op    | Msg_type | Msg_text |
+-------------+-------+----------+----------+
| test.tolove | check | status   | OK       |
+-------------+-------+----------+----------+
1 row in set (1.63 sec)
```



**check table作用**：用于检查一张或多张表是否有错误，前面提到过，同时支持MyISAM和InnoDB表。同样支持检查视图，这里不做示范，可以自行参考文档进行测试验证。



#### 1.2	定期优化表

**优化（optimize ）表语法**：

```sql
OPTIMIZE [NO_WRITE_TO_BINLOG | LOCAL]
TABLE tbl_name [, tbl_name] ...
```

如果已经删除了表中一大部分数据，或已经对含有可变长度行的表（例如含有：varchar、blob或者txt列的表）进行很多更改，则可以使用`optimize table`命令 进行优化表。

**作用**：`optimize`命令可以将表中空间碎片进行合并，消除由于删除或者更新造成的空间浪费。**同样支持MyISAM和InnoDB表**。

**示例（optimize）优化表**：演示的tolove表前面说过指定MyISAM存储引擎

```sql
mysql> optimize table test.tolove\G
*************************** 1. row ***************************
   Table: test.tolove
      Op: optimize
Msg_type: status
Msg_text: Table is already up to date
1 row in set (0.01 sec)
```



**测试test表使用InnoDB存储引擎**。对于InnoDB存储引擎，通过设置`innodb_file_per_table`参数（默认值为1），改为独立表空间模式，每个数据库每张表会生成独立ibd文件，用于存储表和索引，可以在一定程度上减轻 InnoDB表回收空间问题。此外，在删除大量数据后，可以通过`alter table`命令不修改表引擎方式回收不用的空间：

```sql
mysql> optimize table test.test\G
*************************** 1. row ***************************
   Table: test.test
      Op: optimize
Msg_type: note
Msg_text: Table does not support optimize, doing recreate + analyze instead
*************************** 2. row ***************************
   Table: test.test
      Op: optimize
Msg_type: status
Msg_text: OK
2 rows in set (17.85 sec)

mysql> alter table test.test engine=innodb;
Query OK, 0 rows affected (20.30 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

**注意**：`analyze`、`check`、`optimize`以及`alter table`**执行期间将对表进行锁定**，**一定要注意在数据库不频繁使用期间，再进行相关操作**。



**提到优化方法**，在MySQL8.0文档中你可以找到参考内容：

> 1.7 MySQL Standards Compliance
>
> 13.7.3 Table Maintenance Statements



### 02 常用SQL优化

在某种场景下，查询使用很频繁，针对查询优化确实很有必要。

但实际开发中，还会面临使用其它常用SQL，比如insert、group by、order by等等。

#### 2.1	批量（大量）插入数据

在使用load命令导入数据时，适当进行设置可以提高导入效率。

对于MyISAM表可以通过以下方式快速导入大量数据。

**操作命令**：

```sql
ALTER TABLE tbl_name DISABLE KEYS;	-- 禁用MyISAM表非唯一索引更新
ALTER TABLE tbl_name ENABLE KEYS;	-- 开启MyISAM表非唯一索引更新
```

disable keys和enable keys用于开启和关闭MyISAM表非唯一索引更新。

MyISAM存储引擎默认，导入大量数据至一张空MyISAM表，默认先导入数据，然后创建索引，不用进行设置。

**示例导入数据语句**：

```sql
load data infile 'file_name' into table tbl_name;
```

自行测试时，可以先手动开启非唯一索引，然后关闭非唯一索引进行对比导入时间。

通过测试关闭唯一索引，导入数据效率确实要高很多。**这是对MyISAM表进行测试优化，对InnoDB类型表上述方式作用不是很大**。



**InnoDB表导入表同样也有相应优化措施**：

1. 导入数据按主键顺序排列，可以提高效率。（**InnoDB表是按主键顺序排列**）
2. 导入数据前执行set unique_checks=0，关闭唯一性校验；导入完成，再设置set unique_checks=1，恢复唯一性校验。从而提高导入效率。
3. 如果应用使用自动提交（autocommit），建议导入前执行set autocommit=0，关闭自动提交。导入数据后，再设置set autocommit=1，开启自动提交，同样可以提高导入效率。

MyISAM表和InnoDB表导入数据语句是一样的。以上介绍MyISAM表和InnoDB表导入数据优化方式，可进行参考测试验证。



更多关于MyISAM表插入数据优化方法可以参考如下引用说明： **对于文档理应善于使用搜索Ctrl + f**

> 8.5 Optimizing for InnoDB Tables	
>
> 8.6 Optimizing for MyISAM Tables
>
> 13.2.7 LOAD DATA Statement



#### 2.2	优化 INSERT、ORDER BY、GROUP BY 语句

你可以找到参考内容：

> 13.2.6 INSERT Statement
>
> 8.2.1.16 ORDER BY Optimization
>
> 8.2.1.17 GROUP BY Optimization



**2.2.1	INSERT语句**

当进行数据库`INSERT`操作时，可以考虑以下几种优化方式。

如果同时从同一用户表插入多行，应尽量**使用多个值表的INSERT语句**，这种方式大大缩减客户端与数据库之间的连接、关闭等消耗。一般情况下，比单个执行INSERT语句效率要高得多，但也分场景。下面给出一次插入多值示例：

```sql
INSERT INTO tbl_name(a,b,c) VALUES(1,2,3), (4,5,6), (7,8,9);
```

上述演示，指定字段。从安全角度考虑，实际开发过程中也是推荐指定字段，因为这种方式更加安全。多年前，我还是一位菜鸡开发人员，虽然现在也是一名菜鸟。当时不是很理解，为何在DAO中非要在前面指明字段。直到某天翻阅实体书籍时，才意识到。

如果从不同用户插入多行。**使用到DELAYED语句，需要注意了**，在MySQL5.6之前版本还没被移除，**从MySQL5.6开始已经弃用**。使用**DELAYED之所以快，其实数据被存放在内存队列中，并没有真正写入从磁盘**。

**注意事项**：`DELAYED`关键字计划在未来的版本中删除。延迟插入（ DELAYED INSERT ）和替换在MySQL 5.6中已弃用。在MySQL 8.0中，不支持DELAYED。服务器可以识别，但会忽略DELAYED关键字，将插入处理视为非延迟插入，并生成ER_WARN_LEGACY_SYNTAX_CONVERTED 警告：INSERT DELAYED is no longer supported. The statement was converted to INSERT。

**可以将索引文件与数据文件在不同的磁盘上存放，建表时可以选择**。

如果进行批量插入，可以通过增减`bulk_insert_buffer_size`变量值的方法来提高速度。对MyISAM表有效，MyISAM使用一种特殊的树状缓存，使批量插入更快。 INSERT ... SELECT，INSERT ... VALUES (...)，(...)，...，和LOAD DATA在添加数据到非空表时。这个变量以每个线程的字节为单位限制缓存树的大小。将其设置为0将禁用此优化。默认值为8MB。

**注意事项**：从MySQL 8.0.14开始，设置`bulk_insert_buffer_size`这个系统变量的会话值是一个受限制的操作。会话用户必须具有设置受限制会话变量的权限。

**当从一个文本装载一张表时，使用LOAD DATA INFILE，一般比使用INSERT语句快得多**。

从MySQL 8.0.19版本开始，你也可以使用INSERT…TABLE在MySQL 8.0.19及以后版本中插入一行，使用TABLE替换SELECT。

```sql
mysql> CREATE TABLE tb (i INT);
Query OK, 0 rows affected (0.02 sec)

mysql> INSERT INTO tb TABLE t;
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0
```

以上演示，是将表 t 中所有记录插入到 tb 表中，与之前`insert into tb select * from t`用法是一样的执行效果。



**2.2.2	ORDER BY语句**

看到`ORDER BY`语句，可以联想到排序方式。那么，了解一下MySQL中的排序方式。

查看world数据库中city表索引情况：此处省略掉了一些参数值，全部展示篇幅太长。

```sql
mysql> show index from city\G
*************************** 1. row ***************************
        Table: city
   Non_unique: 0
     Key_name: PRIMARY
 Seq_in_index: 1
  Column_name: ID
    Collation: A
  Cardinality: 4046
   Index_type: BTREE
      Visible: YES
   Expression: NULL
*************************** 2. row ***************************
        Table: city
   Non_unique: 1
     Key_name: CountryCode
 Seq_in_index: 1
  Column_name: CountryCode
    Collation: A
  Cardinality: 232
   Index_type: BTREE
      Visible: YES
   Expression: NULL
2 rows in set (0.01 sec)
```



**MySQL中有两种排序方式**：

1. Use of Indexes to Satisfy ORDER BY，使用using index。
2. Use of filesort to Satisfy ORDER BY，使用filesort。 

在某些情况下，MySQL可能会使用索引来满足ORDER BY子句，从而避免执行filesort操作时涉及的额外排序。**第一种通过有序使用顺序扫描直接返回有序数据**，这种方式在使用explain分析查询时显示`Using index`，无需额外排序，操作效率较高，示例如下：

```sql
mysql> explain select id from city order by id\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: city
   partitions: NULL
         type: index
possible_keys: NULL
          key: PRIMARY
      key_len: 4
          ref: NULL
         rows: 4046
     filtered: 100.00
        Extra: Using index
1 row in set, 1 warning (0.00 sec)
```



如果索引不能满足ORDER BY子句，MySQL执行一个filesort操作，读取表行并对它们排序。filesort在查询执行中构成一个额外的排序阶段。**第二种是通过对返回数据进行排序**，也是通常所说的`filesort`排序，所有不是通过索引直接返回结果的排序都称为filesort排序。

filesort并不代表通过磁盘文件进行排序，只是说明进行了一个排序操作，至于操作是否使用了磁盘文件或者临时表等，则取决于MySQL服务器对排序参数的设置和需要排序数据的大小。

如果结果集太大，无法装入内存，则 filesort 操作将根据需要使用临时磁盘文件。有些类型的查询特别适合于完全在内存中的filesort操作。例如，优化器可以使用filesort在内存中有效地处理，而不需要临时文件。示例：

```sql
SELECT ... FROM single_table ... ORDER BY non_index_column [DESC] LIMIT [M,]N;
```

以下给出使用 Using filesort 情况示例：

```sql
mysql> explain select store_id,email,customer_id from sakila.customer order by email\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: customer
   partitions: NULL
         type: index
possible_keys: NULL
          key: idx_storeid_email
      key_len: 204
          ref: NULL
         rows: 599
     filtered: 100.00
        Extra: Using index; Using filesort
1 row in set, 1 warning (0.00 sec)
```

**注意**：为了获得 filesort 操作的内存，**从MySQL 8.0.12开始，优化器根据需要增量分配内存缓冲区(sort_buffer_size )**，直到由排序缓冲区大小系统变量指示的大小，而不是像在**MySQL 8.0.12之前那样，预先分配固定数量的排序缓冲区(sort_buffer_size )大小字节**。这使用户可以将排序缓冲区大小设置为更大的值，以加快更大的排序，而不用担心小排序会占用过多的内存。(这种好处可能不会出现在Windows上的多个并发排序，因为Windows有一个弱多线程malloc。）

了解MySQL排序方式后，优化目的清晰了：**尽量减少额外排序，通过索引直接返回数据**。

添加组合索引，然后使用explain执行测试：

```sql
mysql> ALTER TABLE sakila.customer ADD INDEX idx_storeid_email(store_id,email);
Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> explain select store_id,email,customer_id from sakila.customer where store_id=1 order by email desc\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: customer
   partitions: NULL
         type: ref
possible_keys: idx_fk_store_id,idx_storeid_email
          key: idx_storeid_email
      key_len: 1
          ref: const
         rows: 326
     filtered: 100.00
        Extra: Backward index scan; Using index
1 row in set, 1 warning (0.00 sec)
```

依据上面测试演示结果，可以分析出返回索引扫描。如果是在8.0之前显示有所区别，比如在MySQL5.7出现的是Extra: Using where; Using index。

查询商店编号store_id大于等于1小于等于3，按照email进行排序记录主键customer_id时，由于优化器评估使用索引idx_storeid_email进行范围扫描const最低，所以最终对索引进行扫描的结果，进行额外email逆序操作：

```sql
mysql> explain select store_id,email,customer_id from sakila.customer where store_id>=1 and store_id<=3 order by email desc\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: customer
   partitions: NULL
         type: index
possible_keys: idx_fk_store_id,idx_storeid_email
          key: idx_storeid_email
      key_len: 204
          ref: NULL
         rows: 599
     filtered: 100.00
        Extra: Using where; Using index; Using filesort
1 row in set, 1 warning (0.00 sec)
```



**优化filesort**：通过建立合适的索引减少 filesort 出现，但在某种情况下，条件限制无法让 filesort 消失，可以想办法加快 filesort 操作。如何加快，可以通过控制`sort_buffer_size` 和  `max_length_for_sort_data`（max_sort_length ） 大小进行优化。

**注意**：对于没有使用filesort的慢`ORDER BY`查询，尝试将排序数据系统变量（max_length_for_sort_data）的最大长度降低到适合触发filesort的值。(将此变量值设置过高的一个症状是高磁盘活动和低CPU活动的结合。)这种技术只适用于MySQL 8.0.20之前。从8.0.20开始，排序数据的最大长度已弃用，因为优化器的更改使其过时且无效。



**2.2.3	GROUP BY语句**

满足`GROUP BY`子句的最常用方法是扫描全表，并创建一个新的临时表，其中每个组中所有行都是连续的，然后使用这个临时表来发现组并应用聚合函数(如果存在的话)。在某些情况下，MySQL能够做得更好，并通过使用索引访问避免创建临时表。

GROUP BY使用索引最重要的前提条件：所有GROUP BY列引用来自同一索引的属性，并且该索引按顺序存储其键(例如，对于BTREE索引是这样，但对于HASH索引则不同)。临时表的使用是否可以被索引访问替代，还取决于查询中使用索引的哪些部分、为这些部分指定的条件以及所选的聚合函数。

**访问索引执行 GROUP BY 两种扫描方式**：

1. 松散索引扫描（Loose Index Scan）
2. 密集索引扫描（Tight Index Scan）

默认情况下，MySQL对所有`GROUP BY` c1，c2，...字段进行排序，与查询中指定`ORDER BY`  c1，c2，...类似。因此，如果显示包括一个相同列的`ORDER BY`子句，对MySQL实际执行性能没有什么影响。

如果查询包括GROUP BY，但用户想避免排序结果的消耗，则可以指定ORDER BY NULL禁止排序。如下示例：

```sql
mysql> explain select payment_date,sum(amount) from sakila.payment group by payment_date\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
   partitions: NULL
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 16086
     filtered: 100.00
        Extra: Using temporary
1 row in set, 1 warning (0.00 sec)
```

分析查询出来的结果，发现Extra: Using temporary，使用一个临时表。type=ALL，执行全表扫描。

**注意**：在MySQL5.7或者更低的版本中使用 `ORDER BY NULL`有显示优化作用，`GROUP BY`在特定条件下隐式排序。在MySQL8.0中不再出现这种情况，所以在最后指定 ORDER BY NULL 来抑制隐式排序，就没有必要了。但是，查询结果可能与之前的MySQL版本有所不同。要生成给定的排序顺序，请使用 ORDER BY子句。

即使在MySQL8.0中显示使用`ORDER BY NULL` 来抑制隐式排序，结果并没变化。但在MySQL5.7或者MariaDB10.5.6中使用时有变化，而且你会发现执行结果出现：Extra: Using temporary; Using filesort。对于filesort吗，上面也给出了简单处理方法。

```sql
mysql> explain select payment_date,sum(amount) from sakila.payment group by payment_date order by null\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
   partitions: NULL
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 16086
     filtered: 100.00
        Extra: Using temporary
1 row in set, 1 warning (0.00 sec)
```





#### 2.3	优化嵌套查询、分页查询

**2.3.1	嵌套查询**

你可以找到参考内容：8.2.1 Optimizing SELECT Statements

MySQL4.1中开始支持SQL子查询。这个技术可以使用SELECT语句来创建一个单列的查询结果，然后将查询的结果作为过滤条件作用在另一个查询中。使子查询可以一次性完成更多逻辑上需要多个步骤才能完成的SQL操作，同时可以表面事务或者表锁死，编写相对容易。但在某些情况下，使用连接（join）效率更高，可以被替代。

**示例**：在顾客表查询排除支付表中的所有顾客信息，使用子查询实现。

```sql
mysql> EXPLAIN SELECT * FROM sakila.`customer` WHERE customer_id
  NOT IN(SELECT customer_id FROM sakila.`payment`)\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: customer
   partitions: NULL
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 599
     filtered: 100.00
        Extra: NULL
*************************** 2. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
   partitions: NULL
         type: ref
possible_keys: idx_fk_customer_id
          key: idx_fk_customer_id
      key_len: 2
          ref: sakila.customer.customer_id
         rows: 26
     filtered: 100.00
        Extra: Using where; Not exists; Using index
2 rows in set, 1 warning (0.00 sec)
```

可使用join进行改进，我提供思路，用left join进行连接查询，主要以customer表为主，也是以左表为主。

```sql
EXPLAIN SELECT * FROM sakila.`customer` a LEFT JOIN sakila.`payment` b ON
a.`customer_id`=b.`customer_id` WHERE b.`customer_id` IS NULL\G
```

**注意**：当时还纳闷测试看不出index_subquery。查询后，发现在MySQL8.0.16之前可以看到type由index_subquery变为ref，而在MySQL8.0.16开始优化器调整并做优化（in和exists），与上面子查询得到结果并无区别。

连接（join）之所以效率更高，因为MySQL不需要在内存中创建临时表来完成这个逻辑上需要两个步骤完成的工作。



**2.3.2	分页查询**

你可以找到参考内容：8.2.1.19 LIMIT Query Optimization

一般分页查询时，通过创建覆盖索引能够比较好地提高性能。一个很头痛的分页场景：limit 996,20，此时MySQL排序出前996记录后仅仅只需要返回第996到1016条记录，前996条记录会被抛弃，查询和排序代价非常高。

通过分析上述描述场景，使用explain进行分析：

```sql
mysql> explain select * from world.city limit 996,20\G
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
1 row in set, 1 warning (0.00 sec)
```

可以看出，type=ALL，优化分析器走了全表扫描。

**第一种优化思路**：在索引上完成排序分页操作，最后根据关联原表查询所需要的其它列内容。

通过思考，对上面SQL语句进行调整优化：

```sql
mysql> explain select * from world.city c inner join(select id from world.city order by countrycode limit 996,20)a on c.id=a.id\G
*************************** 1. row ***************************
           id: 1
  select_type: PRIMARY
  ...
         type: ALL
        Extra: NULL
*************************** 2. row ***************************
           id: 1
  select_type: PRIMARY
  ...
         type: eq_ref
        Extra: NULL
*************************** 3. row ***************************
           id: 2
  select_type: DERIVED
        table: city
   partitions: NULL
         type: index
possible_keys: NULL
          key: CountryCode
      key_len: 12
          ref: NULL
         rows: 1016
     filtered: 100.00
        Extra: Using index
3 rows in set, 1 warning (0.00 sec)
```

上述结果，前两页省略掉了一些内容。这种方式使MySQL扫描尽可能少的页面来提高分页效率，缺点是SQL语句变长了。



**第二种优化思路**：将limit查询转换成某个位置的查询，实际上是将limit m,n转换为limit n查询，只适合排序字段不会出现重复值的特定环境，能减轻分页翻页压力。如果排序字段现大量重复值，则不适合进行这种优化，因为会丢失部分记录。



**注意**：对于带有ORDER BY或GROUP BY和LIMIT子句的查询，优化器在默认情况下尝试选择一个有序索引，这样做会加快查询的执行速度。在MySQL 8.0.21之前，即使在使用一些其它优化，可能更快的情况下，没有办法覆盖这种行为。从MySQL 8.0.21开始，可以通过设置优化器开关（optimizer_switch）系统变量的优先排序索引（prefer_ordering_index）标志来关闭这种优化。

默认情况`optimizer_switch` 和 `prefer_ordering_index`是开启的：

```sql
mysql> SELECT @@optimizer_switch LIKE '%prefer_ordering_index=on%'\G
*************************** 1. row ***************************
@@optimizer_switch LIKE '%prefer_ordering_index=on%': 1
1 row in set (0.00 sec)
```



#### 2.4	优化 OR 条件

你可以查找到参考内容：12.4.3 Logical Operators

在介绍OR条件时，可以先了解MySQL中的逻辑操作符（Logical Operators）。有如下几种：

- AND, &&：逻辑与、并且，在两个条件中必须都满足。
- NOT, !：否定、取反。
- OR, ||：逻辑或、在两个条件中满足一个条件即可。
- XOR：逻辑XOR。如果是NULL，返回NULL；如果是non-NULL，返回1；如果奇数个非零操作数，则计算结果为1，否则返回0。

示例XOR：

```sql
SELECT 1 XOR 1\G		-- return:0
SELECT 1 XOR 0\G		-- return:1
SELECT 1 XOR NULL\G		-- return:NULL
SELECT 1 XOR 1 XOR 1\G	-- return:1
```

对于含有OR查询的子句，如果要利用索引、则OR之间的每个条件列都必须用到索引，如果没有索引，应该考虑增加索引。

可以使用show index from tal_name语句查看表索引情况：

```sql
mysql> show index from city\G
...
Column_name: city_id
Column_name: country_id
...
```

然后查询存在索引的两列，并使用OR条件联合查询：

```sql
mysql> explain select * from city where city_id=6 or country_id=101\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: city
   partitions: NULL
         type: index_merge
possible_keys: PRIMARY,idx_fk_country_id
          key: PRIMARY,idx_fk_country_id
      key_len: 2,2
          ref: NULL
         rows: 4
     filtered: 100.00
        Extra: Using union(PRIMARY,idx_fk_country_id); Using where
1 row in set, 1 warning (0.01 sec)
```

可以发现查询正确地使用到索引，并且从执行计划描述中，发现MySQL在处理含有OR子句查询时，实际对OR各个字段分别查询后的结果进行了union操作。

在有复合索引的列上做OR操作，却无法使用到索引，查询结果如下：

```sql
mysql> explain select * from inventory where inventory_id=6 or store_id=2\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: inventory
   partitions: NULL
         type: ALL
possible_keys: PRIMARY,idx_store_id_film_id
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 4581
     filtered: 50.01
        Extra: Using where
1 row in set, 1 warning (0.01 sec)
```





#### 2.5	使用 SQL 提示

可以找到参考的内容：8.9.4 Index Hints

SQL提示（SQL Hints）是优化数据库的一项重要手段，简单说是在SQL语句中**加入一些人为的提示达到优化目的**。下面将给出一个使用SQL提示的示例：

```sql
SELECT SQL_BUFFER_RESULT FROM t1...
```

其默认值为0，即是关闭状态，设置为1则启用。如果启用，SQL_BUFFER_RESULT将强制SELECT语句的结果放入临时表中。在需要很长时间向客户端发送结果的情况下，帮助比较大，因为这有助于MySQL尽早释放表锁。

**以下介绍一些在MySQL中常用的SQL提示：索引提示**（Index Hints）

**索引提示语法**：

```sql
tbl_name [[AS] alias] [index_hint_list]

index_hint_list:
		index_hint [index_hint] ...
		
index_hint:
	USE {INDEX|KEY}
		[FOR {JOIN|ORDER BY|GROUP BY}] ([index_list])
		| {IGNORE|FORCE} {INDEX|KEY}
		[FOR {JOIN|ORDER BY|GROUP BY}] (index_list)

index_list:
		index_name [, index_name] ...
```

看完提示语法，可以了解到索引提示三种技巧USE INDEX、IGNORE INDEX以及FORCE INDEX。

**2.5.1	USE INDEX**

在查询语句中表名的背后，使用USE INDEX希望MySQL去参考索引列表，此时达到不让MySQL去参考其它可用索引的目的。

**示例**：使用explain进行分析

```sql
mysql> explain select count(*) from countrylanguage use index(CountryCode)\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: countrylanguage
   partitions: NULL
         type: index
possible_keys: NULL
          key: CountryCode
      key_len: 12
          ref: NULL
         rows: 984
     filtered: 100.00
        Extra: Using index
1 row in set, 1 warning (0.00 sec)
```

根据上面分析结果，可以看出type=index，走索引扫描；Extra内容是Using index，达到我们预期要求。



**2.5.2	IGNORE INDEX**

如果用户只是单纯地想让MySQL忽略某一个或多个索引，则可以使用`IGNORE INDEX`作为索引提示（HINTS）。

下面使用IGNORE INDEX进行演示：

```sql
mysql> explain select count(*) from countrylanguage ignore index(CountryCode)\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: countrylanguage
   partitions: NULL
         type: index
possible_keys: NULL
          key: PRIMARY
      key_len: 132
          ref: NULL
         rows: 984
     filtered: 100.00
        Extra: Using index
1 row in set, 1 warning (0.00 sec)
```

通过上述执行分析，放弃了默认索引，此时走的索引是PRIMARY。



**2.5.3	FORCE INDEX**

强制MySQL使用一个特定索引，可以在查询中使用`FORCE INDEX`作为HINTS。

例如，不强制使用索引时，此时支付表中大部分rental_id都是大于1的，因此MySQL默认会全表扫描，而不使用索引。如下所示：

```sql
mysql> explain select * from sakila.payment where rental_id > 1\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
   partitions: NULL
         type: ALL
possible_keys: fk_payment_rental
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 16086
     filtered: 50.00
        Extra: Using where
1 row in set, 1 warning (0.01 sec)
```

此时，尝试指定使用索引fk_payment_rental，发现MySQL依旧走全表扫描。

```sql
mysql> explain select * from sakila.payment use index(fk_payment_rental) where rental_id > 1\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
   partitions: NULL
         type: ALL
possible_keys: fk_payment_rental
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 16086
     filtered: 50.00
        Extra: Using where
1 row in set, 1 warning (0.00 sec)
```

当使用`FORCE INDEX`进行提示时，即使使用索引效率不是最高，MySQL还是选择使用索引，这是MySQL将选择执行计划的权利交给了用户。加入FORCE INDEX进行测试索引提示：

```sql
mysql> explain select * from sakila.payment force index(fk_payment_rental) where rental_id > 1\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
   partitions: NULL
         type: range
possible_keys: fk_payment_rental
          key: fk_payment_rental
      key_len: 5
          ref: NULL
         rows: 8043
     filtered: 100.00
        Extra: Using index condition
1 row in set, 1 warning (0.00 sec)
```

通过测试验证，发现MySQL确实强制走了索引，印证了MySQL将选择计划使用索引提示权利交给了用户。



**注意**：在MySQL8.0.20版本，此时服务支持index-level分析优化提示这些索引：JOIN_INDEX，GROUP_INDEX，ORDER_INDEX以及 INDEX。它们相当于取代了FORCE INDEX提示，同样地NO JOIN INDEX、NO GROUP INDEX、NO ORDER INDEX和NO INDEX优化器提示，它们相当于并打算取代IGNORE INDEX索引提示。因此，你应该预料到使用USE INDEX、FORCE INDEX和IGNORE INDEX会在未来的MySQL版本中被弃用，并且在以后的某个时候会被完全删除。



### 03	MySQL官方示例数据库

给出**sakila-db数据库**包含三个文件，便于大家获取与使用：

1. sakila-schema.sql：数据库表结构；
2. sakila-data.sql：数据库示例模拟数据；
3. sakila.mwb：数据库物理模型，在MySQL workbench中可以打开查看。

> [https://downloads.mysql.com/docs/sakila-db.zip](https://downloads.mysql.com/docs/sakila-db.zip)



**只是用于用于简单测试学习，建议使用world-db**：

**world-db数据库**，包含三张表：city、country、countrylanguage。

> [https://downloads.mysql.com/docs/world-db.zip](https://downloads.mysql.com/docs/world-db.zip)

最后附上官方示例数据库，**sakila-db数据库**一个非常完整的示例。包含：视图、函数、触发器以及存储过程，当然也存在使用外键。



**参考资料&鸣谢**：

- 《深入浅出MySQL 第2版 数据库开发、优化与管理维护》。
- 《MySQL技术内幕InnoDB存储引擎 第2版》。
- MySQL8.0官网文档：refman-8.0-en.pdf，如果学习新版本，官方文档是非常不错的选择。

虽然书籍年份比较久远（停留在MySQL5.6.x版本），但仍然具有借鉴意义。

最后，对以上书籍和官方文档所有作者表示衷心感谢。让我充分体会到：前人栽树，后人乘凉。



# 莫问收获，但问耕耘

**能看到这里的，都是帅哥靓妹**。以上是本次MySQL优化篇（上部分）全部内容，希望能对你的工作与学习有所帮助。感觉写的好，就拿出你的一键三连。如果感觉总结的不到位，也希望能留下您宝贵的意见，我会在文章中定期进行调整优化。**好记性不如烂笔头，多实践多积累**。**你会发现，自己的知识宝库越来越丰富**。原创不易，转载也请标明出处和作者，尊重原创。

一般情况下，会优先在公众号发布：龙腾万里sky。

不定期上传到github仓库：

> [https://github.com/cnwangk/wangk-stick](https://github.com/cnwangk/wangk-stick)