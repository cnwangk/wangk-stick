在你邀请我之前，我看到了已经有人回答了，按照那个步骤去执行是可行的。既然有幸受到邀请，我也补充一下。

借用你原始表结构，加了一行联合（组合）索引`INDEX BOOK_ID_storeID (ID,storeID)`

```sql
CREATE TABLE IF NOT EXISTS `test`.`book` (
  `ID` INT UNSIGNED NOT NULL,
  `storeID` INT UNSIGNED NULL,
  PRIMARY KEY (`ID`),
  INDEX IDX_ID_storeID (`ID`,`storeID`),   -- 新增组合索引BOOK_ID_storeID
  UNIQUE INDEX `storeID_UNIQUE` (`storeID` ASC))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `test`.`shoppingCartItem` (
  `userID` INT UNSIGNED NOT NULL,
  `bookID` INT UNSIGNED NOT NULL,
  `storeID` INT UNSIGNED NULL,
  PRIMARY KEY (`userID`, `bookID`),
  INDEX `fk_idx` (`bookID` ASC, `storeID` ASC),
  CONSTRAINT `fk`
    FOREIGN KEY (`bookID` , `storeID`)
    REFERENCES `test`.`book` (`ID` , `storeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
```



**查看外键状态**

```sql
mysql> SHOW CREATE TABLE `test`.`shoppingCartItem`\G
*************************** 1. row ***************************
       Table: shoppingCartItem
Create Table: CREATE TABLE `shoppingcartitem` (
  `userID` int unsigned NOT NULL,
  `bookID` int unsigned NOT NULL,
  `storeID` int unsigned DEFAULT NULL,
  PRIMARY KEY (`userID`,`bookID`),
  KEY `fk_idx` (`bookID`,`storeID`),
  CONSTRAINT `fk` FOREIGN KEY (`bookID`, `storeID`) REFERENCES `book` (`ID`, `storeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```





个人建议：有不明白的地方，可以参考官方文档，官方文档是非常好的帮手。关于FOREIGN KEY Constraints ，有详细使用说明。

> 13.1.20.5 FOREIGN KEY Constraints 

给出官方文档外键使用示例（example）：

```sql
-- 普通使用外键，没有设置级联关系
CREATE TABLE parent (
id INT NOT NULL,
PRIMARY KEY (id)
) ENGINE=INNODB;

CREATE TABLE child (
id INT,
parent_id INT,
INDEX par_ind (parent_id),
FOREIGN KEY (parent_id)
REFERENCES parent(id)
ON DELETE CASCADE
) ENGINE=INNODB;

-- 多表外键使用级联特性CASCADE，同样在Oracle中也支持
CREATE TABLE product (
category INT NOT NULL, id INT NOT NULL,
price DECIMAL,
PRIMARY KEY(category, id)
) ENGINE=INNODB;

CREATE TABLE customer (
id INT NOT NULL,
PRIMARY KEY (id)
) ENGINE=INNODB;

CREATE TABLE product_order (
no INT NOT NULL AUTO_INCREMENT,
product_category INT NOT NULL,
product_id INT NOT NULL,
customer_id INT NOT NULL,
PRIMARY KEY(no),
INDEX (product_category, product_id),
INDEX (customer_id),
FOREIGN KEY (product_category, product_id)
REFERENCES product(category, id)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY (customer_id)
REFERENCES customer(id)
) ENGINE=INNODB;
```





下面是我之前看InnoDB锁问题，顺带看了下外键，同样可以参考。



# 01  外键用法

**tips**：目前MySQL支持外键的存储引擎有InnoDB和NDB。

**外键的作用**：用来保证参照完整性。比如有两张表主表parent table和子表child table，在子表中拥有主表外键约束；你想同时干掉两张表；MySQL告诉你，没门，不给删；需要先删除约束，才能彻底删除，使用第三方工具删除表时深有体会。MySQL数据库InnoDB存储引擎完整支持外键。

**外键语法定义**：

```sql
[CONSTRAINT [symbol]] FOREIGN KEY
[index_name] (col_name, ...)
REFERENCES tbl_name (col_name,...)
[ON DELETE reference_option]
[ON UPDATE reference_option]
reference_option:
RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT
```

> 13.1.20.5 FOREIGN KEY Constraints 



**示例创建**一张父表（**parent**）和一张子表（**child**）：

```sql
CREATE TABLE parent (
id INT NOT NULL,
PRIMARY KEY (id)
) ENGINE=INNODB;

CREATE TABLE child (
id INT,
parent_id INT,
INDEX par_ind (parent_id),  -- 给parent_id添加索引
FOREIGN KEY (parent_id)   -- parent_id设置为外键引用主表主键id
REFERENCES parent(id)   -- 引用主表（parent）主键id
) ENGINE=INNODB;
```



**演示插入数据外键冲突**：主表插入1条数据，在子表插入一条数据，违反外键约束，主表没有id=2的行。**此时无法级联更新**。

```sql
mysql> INSERT INTO parent (id) VALUES (1); -- 主表插入1条数据
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO child (id,parent_id) VALUES(2,2); -- 在子表插入一条数据，违反外键约束，主表没有id=2的行
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`test`.`child`, CONSTRAINT `child_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `parent` (`id`))
```



**演示删除数据外键冲突**：有外键约束和索引，此时无法级联删除。

```sql
mysql> DELETE FROM parent WHERE id=1;
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`test`.`child`, CONSTRAINT `child_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `parent` (`id`))
```



**如果想级联更新和删除**，在创建子表（child）时加入CASCADE关键字。同样Oracle中也支持CASCADE，在Oracle中创建外键时注意给这个列加上索引，具体用法可能略有差异。删除原表，重新创建子表child，并加入给update与delete条件加入CASCADE属性。

```sql
DROP TABLE child;-- 删除原有创建子表child

-- 重新创建子表child，并加入给update与delete条件加入CASCADE
CREATE TABLE child (
id INT,
parent_id INT,
INDEX par_ind (parent_id),
FOREIGN KEY (parent_id)
REFERENCES parent(id)
ON UPDATE CASCADE
ON DELETE CASCADE
) ENGINE=INNODB;
```



子表（**child**）插入测试数据：

```sql
mysql> INSERT INTO child (id,parent_id) VALUES(1,1),(2,1),(3,1);
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0
```



更新主表（**parent**）id值为2：

```sql
mysql> UPDATE parent SET id = 2 WHERE id = 1;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```



**查询验证主表**（**parent**）：

```sql
mysql> select * from parent;
+----+
| id |
+----+
|  2 |
+----+
1 row in set (0.00 sec)
```



**查询验证子表**（**child**）的**parent_id**值：此时已经全部更新（update）成 2

```sql
mysql> SELECT * FROM child;
+------+-----------+
| id   | parent_id |
+------+-----------+
|    1 |         2 |
|    2 |         2 |
|    3 |         2 |
+------+-----------+
3 rows in set (0.00 sec)
```



**演示级联删除效果**：此时可以删除数据内容

```sql
mysql> delete from parent where id=2;
Query OK, 1 row affected (0.01 sec)
```



**再次查看子表**（**child**）：此时子表中的数据内容一并删除掉

```sql
mysql> SELECT * FROM child;
Empty set (0.00 sec)
```



补充一点，如果想查看表约束，可以通过命令去验证`show create table table_name`：

查到子表（child）已经自动在外键列加入了索引。

```sql
mysql> show create table child\G
*************************** 1. row ***************************
       Table: child
Create Table: CREATE TABLE `child` (
  `id` int DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  KEY `par_ind` (`parent_id`),
  CONSTRAINT `child_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `parent` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
1 row in set (0.00 sec)
```



**注意**：MySQL数据库外键是即时检查的，对每一行都会运行外键检查。导入数据，在检查外键约束上往往消耗大量时间。有时候，可以灵活处理，在导入过程中忽略外键检查：`set foreign_key_checks=0`，默认值是1，开启了外键约束检查。

前面列举示例进行外键功能说明，接下来配合锁进行描述。



# 02	外键与锁

在InnoDB存储引擎中，对于一个外键列，如果没有显示地（人为手动添加）对这个列添加索引，在InnoDB存储引擎会自动对其加一个索引，因此可以避免表锁。这一点比Oracle数据库做得更好，Oracle数据库使用外键时，需要人为手动给该列添加索引。

对于外键值插入和更新，首先需要查询父表（parent）中的记录，即select父表。但对于父表进行select操作，不是使用一致性非锁定读方式，这样会发生数据不一致问题。因此这时使用的是`select ... lock in share mode`方式（共享锁），主动给父表加一个S锁。如果父表已经加了X锁，子表操作会被阻塞。（可以在两个会话窗口进行测试）

**示例阻塞**：

分别在session1会话和session2会话窗口执行事务。session1会话进行删除父表（parent）id为1的内容，session2会话执行插入内容到子表（child），发现session2此时发生阻塞，阻塞等待超时发出警告（默认50秒）。

```sql
-- session1
mysql> begin;
Query OK, 0 rows affected (0.00 sec)

mysql> delete from parent where id=1;
Query OK, 1 row affected (0.01 sec)

-- session2，阻塞等待超时发出警告（默认50秒）
mysql> begin;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into child select 4,1;
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/8018eeede19d432597ef6e5e49318029.png?x-oss-process=,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA6b6Z6IW-5LiH6YeMc2t5,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)



此时子表（child）处于锁定等待中，在**MySQL8.0**中可以使用`data_locks`参数进行分析：

```sql
mysql> select * from performance_schema.data_locks order by event_id desc limit 0,1\G
*************************** 1. row ***************************
               ENGINE: INNODB
       ENGINE_LOCK_ID: 2079935859840:93:5:1:2079912818080
ENGINE_TRANSACTION_ID: 16653
            THREAD_ID: 48
             EVENT_ID: 12
        OBJECT_SCHEMA: test
          OBJECT_NAME: child
       PARTITION_NAME: NULL
    SUBPARTITION_NAME: NULL
           INDEX_NAME: par_ind
OBJECT_INSTANCE_BEGIN: 2079912818080
            LOCK_TYPE: RECORD
            LOCK_MODE: S
          LOCK_STATUS: GRANTED
            LOCK_DATA: supremum pseudo-record
1 row in set (0.00 sec)
```

锁等待，在**MySQL8.0**中可以使用`data_lock_waits`参数进行分析：

```sql
mysql> select * from performance_schema.data_lock_waits  limit 0,1\G
*************************** 1. row ***************************
                          ENGINE: INNODB
       REQUESTING_ENGINE_LOCK_ID: 2079935860616:91:4:2:2079912823744
REQUESTING_ENGINE_TRANSACTION_ID: 16658
            REQUESTING_THREAD_ID: 49
             REQUESTING_EVENT_ID: 10
REQUESTING_OBJECT_INSTANCE_BEGIN: 2079912823744
         BLOCKING_ENGINE_LOCK_ID: 2079935859840:91:4:2:2079912817048
  BLOCKING_ENGINE_TRANSACTION_ID: 16653
              BLOCKING_THREAD_ID: 48
               BLOCKING_EVENT_ID: 12
  BLOCKING_OBJECT_INSTANCE_BEGIN: 2079912817048
1 row in set (0.00 sec)
```

前面介绍锁类型也提到过`data_locks`和`data_lock_waits`这两个参数，MySQL8.0之前在information_schema架构下有`INNODB_LOCKS`、`INNODB_LOCK_WAITS`两个系统参数可以进行参考。此处进行示例，也算补足在锁类型章节没有进行示例演示。



**下面是官方对外键锁定介绍**：MySQL在必要时扩展元数据锁，通过外键约束关联表。扩展元数据锁可以防止DML和DDL操作在相关表上并发执行引起的冲突。该特性还支持在父表被修改时，更新外键元数据。MySQL早期版本中，外键元数据(由子表拥有)不能安全更新。如果一个表被LOCK TABLES显式锁定，那么任何与外键约束相关的表都会被隐式打开和锁定。对于外键检查，在相关表上获取一个共享只读锁(LOCK TABLES READ)。对于级联更新，在操作涉及的相关表上获取一个无共享的写锁(LOCK TABLES WRITE)。

外键定义和元数据（Foreign Key Definitions and Metadata）。查看外键定义，可以使用`SHOW CREATE TABLE child\G`，之前也提到过，这里不再赘述。

如下是查看到数据库中哪些表使用到的外键信息，显示数据库名（**TABLE_SCHEMA**）、表名（**TABLE_NAME**）、字段列名（**COLUMN_NAME**）以及外键约束名（**CONSTRAINT_NAME**）。

```sql
mysql> SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME
    -> FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
    -> WHERE REFERENCED_TABLE_SCHEMA IS NOT NULL;
+--------------+-----------------+----------------------+---------------------------+
| TABLE_SCHEMA | TABLE_NAME      | COLUMN_NAME          | CONSTRAINT_NAME           |
+--------------+-----------------+----------------------+---------------------------+
| world        | city            | CountryCode          | city_ibfk_1               |
| world        | countrylanguage | CountryCode          | countryLanguage_ibfk_1    |
| test         | child           | parent_id            | child_ibfk_1              |
...
+--------------+-----------------+----------------------+---------------------------+
25 rows in set (0.02 sec)
```

**查询INFORMATION_SCHEMA架构下的INNODB_FOREIGN**，使用limit查询2条记录进行演示。world数据库与sakila数据库均为MySQL官方示例，前面有官方链接，可自行获取。

```sql
mysql> SELECT * FROM INFORMATION_SCHEMA.INNODB_FOREIGN limit 0,2 \G
*************************** 1. row ***************************
      ID: world/city_ibfk_1
FOR_NAME: world/city
REF_NAME: world/country
  N_COLS: 1
    TYPE: 48
*************************** 2. row ***************************
      ID: sakila/fk_address_city
FOR_NAME: sakila/address
REF_NAME: sakila/city
  N_COLS: 1
    TYPE: 4
2 rows in set (0.00 sec)
```

