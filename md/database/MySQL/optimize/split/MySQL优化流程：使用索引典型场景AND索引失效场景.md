MySQL优化流程索引问题：MySQL中使用索引典型场景，存在但不能使用索引的场景。

**友情提示**：在某些情况，你测试的结果可能与我演示有所不同，我省略了查询结果的部分参数。

如果你是从MySQL5.6或者5.7版本过渡到MySQL8.0。学习之前，建议线看官方文档这一**1.3 What Is New MySQL8.0** 。在做对比的时候，**文档中带有Note标识是你应该注意的地方**。比如下面这张截图：

![](https://img-blog.csdnimg.cn/img_convert/17d4943de92930dea49aa6fe2eaeac55.png)

## MySQL优化流程——MySQL索引问题

索引问题，是一个老生常谈的问题。如果是数据库优化场景，职场面试中经常被提到。

**索引是在MySQL存储引擎中实现，而不是在服务器层实现**。

每种存储引擎索引不一定完全相同，并不是所有存储引擎支持索引类型都一致。



**以下列举几种常见索引介绍（索引存储分类）**：

1. **B-Tree索引**：最常见的使索引类型，大部分存储引擎都支持B树索引。
2. **HASH索引**：MEMORY、HEAP、NDB支持，使用场景较为简单。
3. **R-Tree索引**（空间索引）：空间索引是MyISAM存储引擎一个特殊索引类型，主要用于地理空间数据类型，一般使用较少。
4. **Full-text**（全文索引）：全文索引是MyISAM存储引擎一个特殊索引类型，主要用于全文索引。**在MySQL5.6版本开始对InnoDB提供全文索引支持**。



**注意**：索引类型子句不能用于FULLTEXT（全文索引）或(在MySQL 8.0.12之前)空间索引规范。**全文索引的实现依赖于存储引擎**。空间索引实现为R-tree索引。



### 1 	索引介绍

**几种常见的MySQL存储引擎支持索引类型**：

| 序号 | 存储引擎    | 支持索引    |
| ---- | ----------- | ----------- |
| 1    | InnoDB      | BTREE       |
| 2    | MyISAM      | BTREE       |
| 3    | MEMORY/HEAP | HASH, BTREE |
| 4    | NDB         | HASH, BTREE |

**以上四种存储引擎支持索引特点对比**：Primary key（主键索引），Unique（唯一索引），key（普通索引），FULLTEXT（全文索引），SPATIAL（空间索引）。

**InnoDB存储引擎**：

| 索引类别    | 索引类型 | Stores NULL 值 | Permits Multiple NULL 值 | IS NULL 扫描类型 | IS NOT NULL 扫描类型 |
| ----------- | -------- | -------------- | ------------------------ | ---------------- | -------------------- |
| Primary key | BTREE    | No             | No                       | N/A              | N/A                  |
| Unique      | BTREE    | Yes            | Yes                      | Index            | Index                |
| Key         | BTREE    | Yes            | Yes                      | Index            | Index                |
| FULLTEXT    | N/A      | Yes            | Yes                      | Table            | Table                |
| SPATIAL     | N/A      | No             | No                       | N/A              | N/A                  |



**MyISAM存储引擎**：

| 索引类别    | 索引类型 | Stores NULL 值 | Permits Multiple NULL 值 | IS NULL 扫描类型 | IS NOT NULL 扫描类型 |
| ----------- | -------- | -------------- | ------------------------ | ---------------- | -------------------- |
| Primary key | BTREE    | No             | No                       | N/A              | N/A                  |
| Unique      | BTREE    | Yes            | Yes                      | Index            | Index                |
| Key         | BTREE    | Yes            | Yes                      | Index            | Index                |
| FULLTEXT    | N/A      | Yes            | Yes                      | Table            | Table                |
| SPATIAL     | N/A      | No             | No                       | N/A              | N/A                  |



**MEMORY存储引擎**：

| 索引类别    | 索引类型 | Stores NULL 值 | Permits Multiple NULL 值 | IS NULL 扫描类型 | IS NOT NULL 扫描类型 |
| ----------- | -------- | -------------- | ------------------------ | ---------------- | -------------------- |
| Primary key | BTREE    | No             | No                       | N/A              | N/A                  |
| Unique      | BTREE    | Yes            | Yes                      | Index            | Index                |
| Key         | BTREE    | Yes            | Yes                      | Index            | Index                |
| Primary key | HASH     | No             | No                       | N/A              | N/A                  |
| Unique      | HASH     | Yes            | Yes                      | Index            | Index                |
| Key         | HASH     | Yes            | Yes                      | Index            | Index                |



**NDB存储引擎**：

| 索引类别    | 索引类型 | Stores NULL 值 | Permits Multiple NULL 值 | IS NULL 扫描类型 | IS NOT NULL 扫描类型 |
| ----------- | -------- | -------------- | ------------------------ | ---------------- | -------------------- |
| Primary key | BTREE    | No             | No                       | Index            | Index                |
| Unique      | BTREE    | Yes            | Yes                      | Index            | Index                |
| Key         | BTREE    | Yes            | Yes                      | Index            | Index                |
| Primary key | HASH     | No             | No                       | Table            | Table                |
| Unique      | HASH     | Yes            | Yes                      | Table            | Table                |
| Key         | HASH     | Yes            | Yes                      | Table            | Table                |

**关于更多用法介绍，你可以找到参考内容**：

> 8.3.9 Comparison of B-Tree and Hash Indexes
>
> 12.10 Full-Text Search Functions
>
> 13.1 Index Types Per Storage Engine
>
> 13.1.15 CREATE INDEX Statement
>
> -- 摘自MySQL8.0官方文档：refman-8.0-en



### 2	MySQL如何使用索引

InnoDB存储引擎Information Schema一些视图脚本名称更新（MySQL8.0.3或者更高版本）：

| 旧名称                  | 新名称                  |
| ----------------------- | ----------------------- |
| INNODB_SYS_COLUMNS      | **INNODB_COLUMNS**      |
| INNODB_SYS_DATAFILES    | **INNODB_DATAFILES**    |
| INNODB_SYS_FIELDS       | **INNODB_FIELDS**       |
| INNODB_SYS_FOREIGN      | **INNODB_FOREIGN**      |
| INNODB_SYS_FOREIGN_COLS | **INNODB_FOREIGN_COLS** |
| INNODB_SYS_INDEXES      | **INNODB_INDEXES**      |
| INNODB_SYS_TABLES       | **INNODB_TABLES**       |
| INNODB_SYS_TABLESPACES  | **INNODB_TABLESPACES**  |
| INNODB_SYS_TABLESTATS   | **INNODB_TABLESTATS**   |
| INNODB_SYS_VIRTUAL      | **INNODB_VIRTUAL**      |

**tips**：如果你升级到MySQL8.0.3或者更高版本：会发现与MySQL绑定的zlib库版本从版本1.2.3提升到版本1.2.11。



#### 2.1	InnoDB存储引擎索引

一般情况，针对InnoDB存储引擎进行描述索引使用，因为MySQL5.5.5开始默认存储引擎是InnoDB。

InnoDB存储引擎支持索引：

- B-tree indexs（B+树索引）；
- Full-text search indexes（全文索引）：需要在MySQL5.6或者更高的版本中使用。

本不支持HASH indexs（NO Support），用户没有控制权，**但InnoDB内部利用哈希索引来实现自适应哈希索引特性**。

B+树索引是传统意义上的索引，目前关系型数据库系统中查找最为常用和最为有效地的引。B+树索引构造类似于二叉树，根据键值（Key Value）快速查找数据。

**注意**：B+树中的B不是代表二叉树（binary），而是平衡树（balance），因为B+树是从平衡二叉树演化而来，但B+树也不是一个二叉树。B+树索引并不能找到一个给定键值的具体行，能找到的是被查找数据行所在页。然后数据库通过将页读到内存，再从内存中进行查找，最后得到要查找的数据。

上面简单介绍了下InnoDB存储引擎支持的索引，以及部分新特性，以及B+树索引。如果想深入理解B+树索引，可以从算法角度去分析，但不是此次内容的重点，可以私下查找文档去了解。**接着讨论如何使用索引**。



#### 2.2	MySQL中使用索引典型场景

1. **匹配全值**（Match the whole value）。对索引中所有列都指定具体指，即索引所有列都有等值匹配条件。
2. **匹配范围查询**（March range）。对索引值能够进行范围查找。
3. **匹配最左前缀**（Matches the leftmost prefix）。仅仅使用到索引中的最左边列进行查找。
4. **仅仅对索引查询**（Only for index queries）。当查询列都在索引字段中，查询效率更高。
5. **匹配列前缀**（Match a column prefix ），仅仅使用索引中的第一列，并且只包含索引第一列开头一部分。
6. **索引匹配部分精确**，其它部分范围匹配（ Match  a part）。
7. **如果列名是索引**，使用column_name is null就会使用索引。

以上是对7种使用到索引场景进行说明，**下面将使用explain执行计划进行详细示例**。



**匹配全值**（Match the whole value）。对索引中所有列都指定具体指，即索引所有列都有等值匹配条件。

```sql
mysql> explain select * from sakila.rental where rental_date='2005-05-27 07:33:54' and customer_id=134 and inventory_id=360\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: rental
   partitions: NULL
         type: const
possible_keys: uk_rental_date,idx_fk_inventory_id,idx_fk_customer_id
          key: uk_rental_date
      key_len: 10
          ref: const,const,const
         rows: 1
     filtered: 100.00
        Extra: NULL
```

通过观察explain输出结果，发现type=const。表示常量；字段key值为uk_rental_date，表示优化器使用索引uk_rental_date进行扫描。



**匹配范围查询**（March range）。对索引值能够进行范围查找。例如，查找租赁表rental中客户编号customer_id在指定范围记录：

```sql
mysql> explain select * from sakila.rental where customer_id>=366 and customer_id<=399\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: rental
   partitions: NULL
         type: range
possible_keys: idx_fk_customer_id
          key: idx_fk_customer_id
      key_len: 2
          ref: NULL
         rows: 925
     filtered: 100.00
        Extra: Using index condition
```

通过explain分析，发现type=range以及Extra: Using index condition。使用到范围性查找，以及索引下放操作。



**匹配最左前缀**（Matches the leftmost prefix）。仅仅使用到索引中的最左边列进行查找，比如在多个字段（col1、col2、col3）字段上的联合索引能够被包含col1、（col1、col2）、（col1、col2、col3）的等值查询利用到，但是不能被（col2、col3）、col2的等值查询利用到。以sakila数据库中支付（payment）表进行示例。

下面创建组合索引 `idx_payment_date`便于测示：

```sql
mysql> ALTER TABLE sakila.payment add index idx_payment_date(payment_date,amount,last_update);
Query OK, 0 rows affected (0.07 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

使用explain执行分析：

```sql
mysql> explain select * from sakila.payment where payment_date='2005-06-15 21:08:46' and last_update='2005-06-15 21:08:46'\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
   partitions: NULL
         type: ref
possible_keys: idx_payment_date
          key: idx_payment_date
      key_len: 5
          ref: const
         rows: 1
     filtered: 10.00
        Extra: Using index condition
```

通过观察执行结果，发现 type=ref 以及Extra: Using index condition，根据最左匹配原则，你会发现payment_date处于索引1号位，此时扫描利用到组合索引idx_payment_date。

如果使用last_update和amount进行测试分析：

```sql
mysql> explain select * from sakila.payment where last_update='2005-06-15 21:08:46' and amount=9.99\G
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
     filtered: 1.00
        Extra: Using where
```

通过观察查询结果，发现type=ALL走全表扫描，索引没有使用到。



**仅仅对索引查询**（Only for index queries）。当查询列都在索引字段中，查询效率更高。

```sql
mysql> explain select last_update from sakila.payment where payment_date='2005-06-15 21:08:46' and amount=9.99\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
   partitions: NULL
         type: ref
possible_keys: idx_payment_date
          key: idx_payment_date
      key_len: 8
          ref: const,const
         rows: 1
     filtered: 100.00
        Extra: Using index
1 row in set, 1 warning (0.00 sec)
```

Extra: Using index，意味着现在直接访问索引就足够获取到所有需要的数据，无需索引回表，Using index也是通常所说的覆盖索引扫描。只访问必须访问的数据，一般而言，减少不必要数据访问可以提高效率。





**匹配列前缀**（Match a column prefix ），仅仅使用索引中的第一列，并且只包含索引第一列开头一部分。例如，查询出标题是AGENT开头的电影信息。

创建列前缀索引：

```sql
mysql> create index idx_title_desc_part on sakila.film_text(title(10),description(20));
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

执行explain进行分析，**注意**：在B-tree索引中使用时，**不要以通配符 % 开头**，不然索引会失效。

```sql
mysql> explain select title from sakila.`film_text` where title like 'AGENT%'\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: film_text
   partitions: NULL
         type: range
possible_keys: idx_title_desc_part,idx_title_description
          key: idx_title_desc_part
      key_len: 42
          ref: NULL
         rows: 1
     filtered: 100.00
        Extra: Using where
```

**分析执行计划，看到idx_title_desc_part被利用到**，type=range，使用范围性查询。Extra: Using where表示优化器需要通过索引回表查询数据。





**索引匹配部分精确**，其它部分范围匹配（Match  a part）。

```sql
mysql> explain select inventory_id from sakila.rental where rental_date='2006-02-14 15:16:03' and customer_id>=300 and customer_id<=400\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: rental
   partitions: NULL
         type: ref
possible_keys: uk_rental_date,idx_fk_customer_id
          key: uk_rental_date
      key_len: 5
          ref: const
         rows: 182
     filtered: 16.86
        Extra: Using where; Using index
```

上面通过explain分析，查询出出租日期（rental_date）、指定日期的客户编号（customer_id）指定范围的库存。根据type=ref，以及key=uk_rental_date，优化器建议走唯一索引。



**如果列名是索引**，使用column_name is null就会使用索引。

```sql
mysql> explain select * from sakila.payment where rental_id is null\G
         type: ref
possible_keys: fk_payment_rental
          key: fk_payment_rental
      key_len: 5
      	Extra: Using index condition
```

通过explain执行分析，查询支付表（payment）租赁编号（rental_id）字段为空的记录使用到了索引。



**MySQL5.6以及更高版本支持Index Condition Pushdown** (ICP)特性，索引条件下放操作，进一步优化了查询。某些情况操作下放到存储引擎。

1. ICP可以用于InnoDB和MyISAM表，包括分区的InnoDB和MyISAM表。
2. 当需要访问全表时，ICP用于range、ref、eq_ref和ref或null访问方法。
3. 对于InnoDB表，ICP仅用于二级索引（次索引、辅助索引）。ICP的目标是减少全行读取的数量，从而减少I/O操作。对于InnoDB聚集索引，完整的记录已经被读取到InnoDB缓冲区。在这种情况下使用ICP不会减少I/O。
4. 如果在虚拟列上创建二级索引，则不支持ICP。InnoDB支持在虚拟列上建立二级索引。
5. 引用到子查询条件不能使用操作下放。
6. 引用存储函数的条件不支持操作下放，存储引擎无法调用存储函数。
7. 使用触发器（触发的条件），不能使用操作下放。

如下示例，查询支付表，强制使用索引查询内容。

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

经过explain分析，看到Extra值为Using index condition，表示MySQL使用了ICP进一步优化查询，在检索时，将条件rental_id过滤操作下推到到存储引擎层来完成，可以降低不必要的IO访问。



**注意**：前缀限制以字节为单位，而CREATE TABLE、ALTER TABLE 和 CREATE INDEX语句中的前缀长度，被解析为非二进制字符串类型(CHAR、VARCHAR、TEXT)的字符数，和二进制字符串类型(binary、VARBINARY、BLOB)的字节数。使用多字节字符集的非二进制字符串列指定前缀长度时，请考虑这一点。



#### 2.3	存在但不能使用索引的场景

1. **以 % 开头 LIKE 查询不能够利用B-Tree索引**。
2. **数据类型出现隐式转换时不会使用索引**，如果列类型是字符串，使用where条件记得将字符常量用引号引起来。
3. **复合索引场景下**，如果查询条件不包含索引列最左部分，**即不满足最左原则**（LeftMost），不会利用到复合索引。
4. **如果 MySQL 判断使用索引比扫描全表慢，则不会使用索引**。
5. **使用 OR 分割开的条件**，如果OR条件前列有索引，OR后列没有索引，那么涉及到的索引都不会被利用。

以上总结了5中存在索引，但不适合使用索引的场景。**下面将给出explain分析示例**。



B-Tree索引可用于使用=、>、>=、<、<=或BETWEEN操作符表达式中的列做比较。如果LIKE的参数是一个不以通配符开头的常量字符串，则索引也可以用于LIKE比较。例如，下面的SELECT语句使用索引场景：

**以 % 开头 LIKE 查询不能够利用B-Tree索引**，执行计划中Key值为NULL表示没有使用索引。如下示例：

```sql
-- 没有利用到索引场景
mysql> explain select * from world.city where countrycode like '%A%'\G
		 type: ALL	
possible_keys: NULL
          key: NULL

-- 索引生效场景
mysql> explain select * from world.city where countrycode like 'A%'\G 
		 type: range
possible_keys: CountryCode
          key: CountryCode
```

第一种场景，使用explain执行优化分析后：key=NULL，没有利用到索引。第二种场景，以 % 结束，执行explain优化分析，明显索引起作用了，type=range，属于范围性扫描。

因为B-Tree索引结构特性，以通配符（%）开头的查询自然无法利用到索引，一般建议使用全文索引（fulltext）来解决类似问题。或者考虑利用InnoDB聚簇表特点，采用一种轻量级别解决方式：一般情况，索引比表小，扫描索引比扫描表更快。

**数据类型出现隐式转换时不会使用索引**，如果列类型是字符串，使用where条件记得将字符常量用引号引起来。MySQL默认将输入的常量值进行转换以后才进行检索。

**如下示例**：

```sql
-- 场景一
mysql> explain select * from world.city where countrycode=1\G
         type: ALL
possible_keys: CountryCode
          key: NULL

-- 场景二
mysql> explain select * from world.city where countrycode='1'\G
         type: ref
possible_keys: CountryCode
          key: CountryCode
      key_len: 12
```

在场景二中，字符串（char）类型将1引起来，通过explain分析使用到索引。场景一中没有加引号，索引没有利用，从而走全表扫描。



**复合索引场景下**，如果查询条件不包含索引列最左部分，**即不满足最左原则**（LeftMost），不会利用到符合索引：

```sql
mysql> explain select * from sakila.payment where amount=9.99 and last_update='2006-02-15 22:12:30'\G
         type: ALL
possible_keys: NULL
          key: NULL
```



**如果 MySQL 判断使用索引比扫描全表慢，则不会使用索引**。比如，返回记录很大，但使用索引扫描更费时间，优化器更倾向于使用全表扫描，这样代价更低，效率更高。（使用Trace可以追踪更多信息，前面也提到过）



**使用 OR 分割开的条件**，如果OR条件前列有索引，OR后列没有索引，那么涉及到的索引都不会被利用。 

```sql
mysql> explain select * from sakila.payment where customer_id=9 or amount=9.99\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: payment
         type: ALL
possible_keys: idx_fk_customer_id
          key: NULL
         rows: 16086
     filtered: 10.15
        Extra: Using where
```

因为 OR 后列没有索引，那么后继查询需要走全表扫描。存在全表扫描情况下，也没必要多走一次索引扫描增加磁盘I/O访问。如果前面列无索引，后面列有索引，执行结果一样走全表扫描。（在接下来的优化OR查询部分，进行了对比）



### 3	查看索引使用情况

查看 `Handler_read_key` 值判断索引工作频率，基于键值读取一行的请求数。如果这个值（Handler_read_key）很高，说明您的表在查询时已经建立了适当的索引。读取一行请求数值很低，则表明增加索引改善并不明显，索引没有经常使用。

可以通过`show status like` 'Handler_read%'查询参数值，分析索引使用状况。

```sql
mysql> show status like 'Handler_read%';
+-----------------------+-------+
| Variable_name         | Value |
+-----------------------+-------+
| Handler_read_first    | 2     |
| Handler_read_key      | 74    |
| Handler_read_last     | 0     |
| Handler_read_next     | 147   |
| Handler_read_prev     | 0     |
| Handler_read_rnd      | 30    |
| Handler_read_rnd_next | 32    |
+-----------------------+-------+
```

初始时（索引还未工作），上述查询出默认值为零，当你使用索引后，这些参数会有变化。

`Handler_read_rnd`：基于固定位置读取一行的请求数。如果执行大量需要对结果进行排序的查询，则该值会很高。你可能有大量需要MySQL扫描全表的查询，或者你没有合理地使用键连接。

`Handler_read_rnd_next`：读取数据文件中下一行的请求数。如果要进行大量的表扫描，这个值就会很高。一般来说，这意味着您的表没有正确索引，或者说是写入查询没有利用到索引。


### 4	MySQL官方示例数据库

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

> 《深入浅出MySQL 第2版 数据库开发、优化与管理维护》。

> 《MySQL技术内幕InnoDB存储引擎 第2版》。

> MySQL8.0官网文档：refman-8.0-en.pdf，如果学习新版本，官方文档是非常不错的选择。

虽然书籍年份比较久远（停留在MySQL5.6.x版本），但仍然具有借鉴意义。

最后，对以上书籍和官方文档所有作者表示衷心感谢。让我充分体会到：前人栽树，后人乘凉。




# 莫问收获，但问耕耘

**能看到这里的，都是帅哥靓妹**。以上是本次MySQL优化篇（上部分）全部内容，希望能对你的工作与学习有所帮助。感觉写的好，就拿出你的一键三连。如果感觉总结的不到位，也希望能留下您宝贵的意见，我会在文章中定期进行调整优化。**好记性不如烂笔头，多实践多积累**。**你会发现，自己的知识宝库越来越丰富**。原创不易，转载也请标明出处和作者，尊重原创。


不定期上传到github仓库：

> [https://github.com/cnwangk/wangk-stick](https://github.com/cnwangk/wangk-stick)