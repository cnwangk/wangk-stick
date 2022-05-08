主要介绍：MySQL锁、MyISAM表锁、查询表锁互掐、MySQL表锁模式、如何加（显示）表锁、模拟并发插入以及MyISAM锁调度的介绍。

只停留在看上面，提升效果甚微。应该带着思考去测试佐证，或者使用（同类书籍）新版本进行对比，这样带来的效果更好。最重要的一环，**养成阅读官方文档**，是一个良好的习惯。能编写官方文档，至少证明他们在这个领域是有很高的造诣，对用法足够熟练。

接着上一篇MySQL数据库SQL优化流程。在对MySQL进行举例并使用到示例数据库：大多数情况使用MySQL官方提供的sakila（模拟电影出租信息管理系统）和world数据库，类似于Oracle的scott用户。

如果没有进行特别说明，一般是基于MySQL8.0.28进行测试验证。官方文档非常具有参考意义。你可以将这篇博文，当成过度到MySQL8.0的参考资料。**友情提示:经验是用来参考，但不是拿来即用**。如果你能看到并分享这篇文章，我很荣幸。如果有误导你的地方，我表示抱歉。




![](https://img-blog.csdnimg.cn/img_convert/9897445be9ccea40278b7827713ecfa6.png)

[toc]


# MySQL锁问题——MyISAM表锁

**注意**：在某些情况，你自己测试的结果可能与我演示有所不同，我省略了查询结果的部分参数。

**本文侧重点在SQL优化流程以及MySQL锁问题**（MyISAM和InnoDB存储引擎）。图片可能会挂，演示时尽量使用SQL查询语句返回结果进行示例。篇幅很长，因此使用markdown语法加了目录。

如果你是从MySQL5.6或者5.7版本过渡到MySQL8.0。学习之前，建议线看官方文档这一章节：1.3 What Is New MySQL8.0 。在做对比的时候，**文档中带有Note标识是你应该注意的地方**。比如下面这张截图：

![在这里插入图片描述](https://img-blog.csdnimg.cn/7439166f7c74468e8ecb3f25391795ec.png#pic_center)


## MyISAM锁问题

**简单概括锁**：锁是计算机协调多个进程或线程并发访问某一资源的机制。

MySQL中的锁看上去用法和表面实现（对比其它DBMS），貌似很简单，但真正深入理解其实也不是那么容易。

### 01 MySQL锁介绍

#### 1.1	什么是锁

**为何要使用锁**？开发多用户、数据库驱动的应用时，难点（痛点）：一方面要最大程度地利用数据库的并发访问，另一方面还要**确保每个用户能以一致的方式读取和修改数据**。因此有了锁（locking）的机制，同时也是数据库系统区别于文件系统的一个关键特性。

在数据库中，除传统的计算资源（如CPU、RAM、I/O等）的消耗外，数据也是一种供许多用户共享的资源。

如何保证数据并发访问的**一致性**、**有效性**是所有数据库必须解决的一个问题，**锁冲突**也是影响数据库并发访问性能的重要因素。从描述来看，锁对数据库显得尤为重要，也更加复杂。接下来，会对锁机制特点进行介绍、**常见的锁问题**，以及解决MySQL锁问题的方法。

#### 1.2	MySQL锁

相比其它数据库来说，MySQL的锁机制相对好理解一点，其最显著的特点是不同的存储引擎支持不同锁机制。比如MyISAM和MEMORY存储引擎采用表级锁（table-level locking）；BDB存储引擎（MySQL8.0文档没看到介绍）采用页面锁（page-level locking），但也支持表级锁（table-level locking）；InnoDB存储引擎既支持行级锁（row-level locking），也支持表级锁，默认采用行级锁。

**MySQL中3种锁特性**：

- 表级锁：开销小，加锁块。不会出现死锁，锁粒度大，发生锁冲突概率最高，并发度最低。
- 行级锁：开销大，加锁慢。会出现死锁，锁粒度最小，发生锁冲突概率最低，并发度最高。
- 页面锁：开销和加锁时间介于表锁与行锁之间。会出现死锁，锁粒度介于表锁与行锁之间，并发度一般。

从上述各种锁特点来看，不能一概而论哪种锁更好，但可以**从具体应用特点来判断哪种锁更合适**。

单从锁角度出发：表锁较为适合以查询为主，少量按索引条件更新数据的应用。行级锁更适合有大量按索引条件、并发更新少量不同数据，同时有并发查询的应用。



### 02 MyISAM 表锁

MyISAM（存储引擎限制256TB）存储引擎只支持表锁，是MySQL开始几个版本中唯一支持的锁类型。

随着应用对事务完整性和并发性要求的不断提高，MySQL开发了基于事务存储引擎，后来出现了支持页面锁的BDB（逐渐被InnoDB替代，MySQL8.0文档已看不到介绍）存储引擎和支持行锁的InnoDB存储引擎。MyISAM表锁依旧是使用比较广泛的锁类型。

#### 2.1	查询表锁互掐	

通过检查Table_locks_waited和Table_locks_immediate状态变量来分析系统上表锁争抢：

```sql
mysql> show status like 'table%';
+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| Table_locks_immediate      | 164   |
| Table_locks_waited         | 0     |
+----------------------------+-------+
...
5 rows in set (0.00 sec)
```



如果`Table_locks_waited`值比较大，则说明存在严重的表锁争抢情况。



#### 2.2	MySQL表锁模式

MySQL表锁有两种模式：

1. Table Read Lock：**表共享读锁**；
2. Table Write Lock：**表独占写锁**。

MyISAM表读操作，不会阻塞其他用户对同一表的读请求，但会阻塞对同一表的写请求；对MyISAM表的写操作，则会阻塞其他用户对同一表的读和写操作。MyISAM表的读操作和写操作之间，以及与写操作之间是串行的。

当一个线程获得对一个表的写锁后，只有持有锁的线程可以对表进行更新操作。其它线程的读、写操作都会等待，直到被释放。



#### 2.3	如何加表锁

MyISAM在执行查询（select）前，会自动给涉及的所有表加读锁；在执行更新（update、insert、delete等）操作前，会自动给涉及的表加写锁，这一过程并不需要用户干预。所以，一般情况不需要用户执行lock table命令给MyISAM显式加锁。

**下面只是演示一下加锁和解锁**，阻塞示例。如果想测试，可以在创表时指定存储引擎为MyISAM，或者使用alter table命令修改存储引擎。例如修改city表存储引擎为MyISAM，使用`show create table`命令查看：

```sql
mysql> alter table world.city engine=MyISAM;
mysql> show create table city;
```



**city表测试添加写锁**（lock table write）

```sql
mysql> lock table city write;
Query OK, 0 rows affected (0.00 sec)
```

当前session窗口，测试查询（select）、插入（insert）、修改（update）、删除（delete）均不受影响。

打开其它session窗口，测试增删改查均在等待中。分别给出查询上锁与解锁示例。

上了写锁（当前session），其它窗口查询显示等待中...

![](https://img-blog.csdnimg.cn/img_convert/1d116b9eb4b82e61683414957d7f939b.png)



**解锁**（当前session），其它session窗口查询正常并显示查询等待时间：

```sql
mysql> unlock tables;
Query OK, 0 rows affected (0.00 sec)
mysql> select * from city limit 0,1;
1 row in set (1 min 33.43 sec)
```

![](https://img-blog.csdnimg.cn/img_convert/263bb98960880361660f708cd3dfaf6a.png)



**city表测试添加读锁**（lock table read）

```sql
mysql> lock table city read;
Query OK, 0 rows affected (0.00 sec)
```



**演示更新操作**插入（insert）、修改（update）、删除（delete）：**均提示有读锁**（当前session）

```sql
mysql> insert into city values(9527,'ts','ts','ts',9527000);
ERROR 1099 (HY000): Table 'city' was locked with a READ lock and can't be updated

mysql> update city set name='Kabuls' where id=1;
ERROR 1099 (HY000): Table 'city' was locked with a READ lock and can't be updated

mysql> delete from city where id=1;
ERROR 1099 (HY000): Table 'city' was locked with a READ lock and can't be updated
```



**解锁**（unlock）：

```sql
mysql> unlock tables;
Query OK, 0 rows affected (0.00 sec)
```

**tips**：添加读锁，当前session的新增、修改删除均会提示已经上了锁，查询其它未上锁表也会提示报错。

其它session窗口依旧可以查询、更新未上锁的表。锁住表不会提示，但是会在等待中。

使用lock table时，可能需要一次性锁定用到的所有表，同一个表出现多次，需要对别名锁定。



#### 2.4	并发插入

整体上看，MyISAM表读和写是串行。在一定条件下，MyISAM表也支持查询和插入操作并发进行。

MyISAM存储引擎有一个系统变量concurrent_insert，用于控制其并发插入行为，值可以为0、1或2，默认为AUTO。

如下所示，使用select @@参数形式查询系统变量值：

```sql
mysql> select @@concurrent_insert;
+---------------------+
| @@concurrent_insert |
+---------------------+
| AUTO                |
+---------------------+
```



1. 当concurrent_insert设置为0：不允许并发插入。
2. 当concurrent_insert设置为AUTO（or 1）：如果MyISAM表中间没有被删除的行，允许在一个进程读表的同时，另一个进程从表尾插入记录。也是MySQL默认设置AUTO（or 1）。
3. 当concurrent_insert设置为2：无论MyISAM有无空洞（表中间没有被删除的行），都允许在表尾并发插入记录。

**示例**：其中一个session获得一张表read local锁，该线程可以对当前表进行查询，但不能进行更新操作。其它线程（session），虽然不能进行删除和更新操作，但可以进行插入（insert）操作。假定条件：表中间没有空洞。

其中一个线程（**session1**）获取锁：查询不受影响，不能做更新操作

```sql
mysql> lock table xxls read local;						-- session1获取read local锁
Query OK, 0 rows affected (0.00 sec)
mysql> select * from xxls limit 0,1;					 -- 查询一条数据（可行）
mysql> insert into xxls values(1015,'xxls','女','B');	-- 演示更新操作是拒绝的
ERROR 1099 (HY000): Table 'xxls' was locked with a READ lock and can't be updated
```

另外一个线程（**session2**）演示：插入数据完成，不受影响

```sql
mysql> insert into xxls values(1015,'xxls','女','B');
Query OK, 1 row affected (0.01 sec)
```

**总结**：可以利用MyISAM存储引擎并发插入特性解决应用中对同一表查询和插入锁争用。设置concurrent_insert值为2，总是允许并发插入。与此同时，通过定期在系统空闲时段（不活跃时段）执行optimize table整理空间碎片，回收删除记录产生的空洞。

**optimize用法如下**：注意如果有读锁情况下，是不能进行操作的。

```sql
mysql> optimize table tolove;	-- 优化tolove表
+-------------+----------+----------+----------+
| Table       | Op       | Msg_type | Msg_text |
+-------------+----------+----------+----------+
| test.tolove | optimize | status   | OK       |
+-------------+----------+----------+----------+
1 row in set (1.24 sec)
```



更多详细描述（MySQL8.0）可以参考：

> 第5章节：5.1.8	Server System Variables（服务系统变量）
>
> 摘自：refman-8.0-en.pdf



#### 2.5	MyISAM锁调度

MyISAM存储引擎读锁与写锁互斥，读写操作串行。

一个进程请求某MyISAM表读锁，另一个进程请求同一表写锁，MySQL能友好的处理么？

答案是**写进程先获得锁**。即使读请求先等等待（排队时，读在前），写在后等的不耐烦了。读你给我挪挪位，写优先插队进入队列中。个人认为写锁优先是合理的，毕竟写（更新操作：insert、update、delete）比较重要，如何在最大限度保证数据完整性、一致性。

**写锁优先，MySQL认为写请求一般比读请求重要**。这也是为什么MyISAM表不适合同时有大量更新操作和查询操作的原因。大量更新操作会造成查询操作很难获得读锁，导致永远阻塞。好在可以通过一些系统参数来调节MyISAM调度行为。通过指定参数`low_priority_updates`，让MyISAM存储引擎默认给予读请求优先权利。

**给出官方文档设置示范**：

```sql
mysql> select @@low_priority_updates;	-- 查询出默认值是0

--low-priority-updates[={OFF|ON}] 		-- 命令行格式，也可以在配置文件中进行设置

set low_priority_updates=1				-- 在字符界面临时设置值，设置为1，降低连接发出更新请求
```



另外MySQL提供了折中方法调节锁冲突，给系统参数`max_write_lock_count`设置合适值。当一张表读锁达到这个值后，MySQL暂时将写请求优先级降低，给读进程（session）获得锁的机会。

也不能太依赖一条SQL查询语句解决问题，适当进行拆分成中间表进行合理控制查询时间。有些复杂查询（统计）操作是无法避免的，但可以人为定时操作，在夜深人静之时（凌晨），悄无声息执行。如果你是一名Java开发人员，或许在配置文件（xml、yml）中应该做过这种操作。



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

> 《深入浅出MySQL 第2版 数据库开发、优化与管理维护》，个人参考优化篇部分。
>
> 《MySQL技术内幕InnoDB存储引擎 第2版》，个人参考索引与锁章节描述。
>
> MySQL8.0官网文档：refman-8.0-en.pdf，要学习新版本，官方文档是非常不错的选择。

虽然书籍年份比较久远（停留在MySQL5.6.x版本），但仍然具有借鉴意义。

最后，对以上书籍和官方文档所有作者表示衷心感谢。让我充分体会到：前人栽树，后人乘凉。



# 莫问收获，但问耕耘

**能看到这里的，都是帅哥靓妹**。以上是本次MySQL优化篇（上部分）全部内容，希望能对你的工作与学习有所帮助。感觉写的好，就拿出你的一键三连。如果感觉总结的不到位，也希望能留下您宝贵的意见，我会在文章中定期进行调整优化。**好记性不如烂笔头，多实践多积累**。**你会发现，自己的知识宝库越来越丰富**。原创不易，转载也请标明出处和作者，尊重原创。

一般情况下，会优先在公众号发布：龙腾万里sky。

不定期上传到github仓库：

> [https://github.com/cnwangk/SQL-study](https://github.com/cnwangk/SQL-study)