软件实施面试系列文章第二弹，MySQL和Oracle联合查询以及聚合函数的面试总结。放眼望去全是MySQL，就不能来点Oracle吗？之前面过不少公司，也做过不少笔试题，现在已经很少做笔试题了。你肚子有多少墨水，有经验的面试官一问基本上就知道个大概了。趁着还有点微薄的记忆，就彻底分享出来啦。

系列文章已收录至github仓库:

> [https://github.com/cnwangk/SQL-study](https://github.com/cnwangk/SQL-study)

# 前言

那个用心作题图，用脚写文档的就是我龙腾万里sky啦。

如果不想自己去新建示例，也想找一个完整的示例进行测试练习，MySQL官网有提供示例数据库。

**官方提供的sakila和world数据库**，官网下载地址已经提供，可以下载进行参考学习。

**sakila-db数据库包含三个文件**：

- sakila-schema.sql：数据库表结构
- sakila-data.sql：数据库示例模拟数据
- sakila.mwb：数据库物理模型，在MySQL workbench中可以打开查看。

> [https://downloads.mysql.com/docs/sakila-db.zip](https://downloads.mysql.com/docs/sakila-db.zip)

**world-db数据库**，表结构与data数据包含在一起：

> [https://downloads.mysql.com/docs/world-db.zip](https://downloads.mysql.com/docs/world-db.zip)

Oracle11g安装后自带有scott用户，可以用来练习。主要用到的是EMP和DEPT表，想起了当年用Java的ssh框架写的第一个CURD的demo示例就是Oracle的这两张表，因为这两表有关联关系。

- EMP：员工表；
- DEPT：部门表；

软件实施系列文章第二弹，本来在去年就想写出来的，一直鸽到现在，哈哈。

![](https://gitee.com/dywangk/img/raw/master/images/%E9%A2%98%E5%9B%BE01_proc.jpg)



# 正文

比摆烂，谁最强，自己一次比一次强。现在回顾自己以前写的那些博客，虽然也是自己真实实践和验证过才发出来的，但自己都感觉稀烂。虽然我写的文档很烂，但是比之前有进步就行了，一两年之后你会发现你的进步是可观的，知识宝库越来丰富。

多思考，多练习。不要只停留在想上面，而要立即动起来。亲自去实践，去求证。多问一个为什么，思考事情的本质。看一万遍，不如自己亲手实践一遍来的效果好。

**我的测试环境基于**：

- 操作系统：Windows10；
- 数据库：MySQL8.0.28和Oracle11g；
- 使用查询工具：MySQL8.0自带命令行以及Oracle自带的SQLplus；
- 第三方工具SQLyog和PLSQL Developer。

## 一、联合查询

**图解联合查询**

**内连接**：统计的内容是table1和table2的重合部分。

```sql
inner join on
```

![](https://gitee.com/dywangk/img/raw/master/images/%E5%B7%A6%E5%8F%B3%E8%A1%A8%E9%87%8D%E5%90%88%E9%83%A8%E5%88%86.jpg)

**左外连接**：可以省略掉`outer`，统计的内容是以table1为主的部分。

```sql
left outer join on
```
![](https://gitee.com/dywangk/img/raw/master/images/%E5%B7%A6%E8%A1%A8%E4%B8%BA%E4%B8%BB.jpg)

**右外连接**：同样可以省略掉`outer`，统计的内容是以table2为主的部分。

```sql
right outer join on
```
![](https://gitee.com/dywangk/img/raw/master/images/%E5%8F%B3%E8%A1%A8%E4%B8%BA%E4%B8%BB.jpg)

### 1、联合查询

#### 1.1、MySQL中的联合查询示例

- inner join on：内连接
- right join on：右外连接
- left join on：左外连接

MySQL中的内连接查询关键字：`inner join on`，只作为演示，就不执行explain执行计划去判断执行效率了。小小的建议，在测试这些个联合查询的时候，可以不用带太多的过滤条件看看三种联合查询的区别。

```sql
SELECT c.`ID`,c.`CountryCode`,cl.`CountryCode`,cl.`Language` 
FROM world.`city` c INNER JOIN world.`countrylanguage` cl 
ON c.`CountryCode`=cl.`CountryCode` WHERE c.`ID`>120 AND c.`ID` LIMIT 0,5; 
```

![](https://gitee.com/dywangk/img/raw/master/images/MySQL_inner_join_on_proc.jpg)

MySQL中的左外连接查询查询关键字：`LEFT OUTER JOIN`

```sql
SELECT c.`ID`,c.`Name`,c.`CountryCode`,cl.`IsOfficial`,cl.`CountryCode`,cl.`Language` 
FROM world.`city` c LEFT OUTER JOIN world.`countrylanguage` cl 
ON c.`CountryCode`=cl.`CountryCode` LIMIT 0,5;
```

![](https://gitee.com/dywangk/img/raw/master/images/MySQL_left_join_on_proc.jpg)

MySQL中的右外连接查询关键字：`RIGHT OUTER JOIN`

```sql
SELECT c.`ID`,c.`Name`,c.`CountryCode`,cl.`IsOfficial`,cl.`CountryCode`,cl.`Language` 
FROM world.`city` c RIGHT OUTER JOIN world.`countrylanguage` cl 
ON c.`CountryCode`=cl.`CountryCode` LIMIT 0,5;
```

![](https://gitee.com/dywangk/img/raw/master/images/MySQL_right_join_on_proc.jpg)



#### 1.2、Oracle中的联合查询示例

主要以SCOTT用户作为示例，查看SCOTT用户下有哪些表，这种方式需要以dba管理员身份运行SQL语句查询：

ower代表了用户名，所以直接查找SCOTT用户，TABLE_NAME：代表了表名。

```sql
select t.OWNER,t.TABLE_NAME,t.TABLESPACE_NAME from dba_tables t where t.OWNER='SCOTT'; 
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_dba_tables_proc.jpg)

Oracle中的联合查询，同样以员工表（emp）和部门表（dept）进行演示操作。

**Oracle中的内连接**：`inner join on`

根据部门编号进行关联查询，进行分页查询，每页显示5条数据：

```sql
select e.ename,e.empno,d.deptno,d.dname from scott.emp e 
inner join scott.dept d on e.deptno=d.deptno where rownum<=5; 
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_inner_join_on_proc.jpg)

**左外连接**：`left outer join on`

```sql
select e.ename,e.empno,d.deptno,d.dname from scott.emp e 
left outer join scott.dept d on e.deptno=d.deptno where rownum<=5; 
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_left_join_on_proc.jpg)

**右外连接**：`right outer join on`

```sql
select e.ename,e.empno,d.deptno,d.dname from scott.emp e 
right outer join scott.dept d on e.deptno=d.deptno where rownum<=5;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_right_join_on_proc.jpg)

**全连接**：`full join on`

```sql
select e.ename,e.empno,d.deptno,d.dname from scott.emp e 
full join scott.dept d on e.deptno=d.deptno where rownum<=5;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_full_join_proc.jpg)

**组合查询**：`union`

```sql
select e.ename,e.empno from scott.emp e where rownum<=5 union select e.ename,e.empno from scott.emp e  
where e.ename like '%ARC%'; 
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_union_proc.jpg)

**组合查询**：`union all`

```sql
select e.ename,e.empno from scott.emp e where rownum<=5 union all select e.ename,e.empno from scott.emp e  
where e.ename like '%ARC%'; 
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_union_all_proc.jpg)

**union和union all**是有区别的，我列举的例子进行了模糊匹配，没演示出来效果。使用`union all`后DBMS不会取消重复的行。

**去掉后面的like条件，使用union统计的数据为14行，使用union all统计的数据为19行**，其实不难理解，all就是全部。

### 2、分页查询

#### 2.1、MySQL的分页查询使用limit关键字

**tips**：Windows中CMD命令窗口使用`color a`即可调用出黑色背景绿色字体，`color f0`则是快速调出白色背景黑色字体哟！

护眼色：R：181    G：230    B：181

**示例**：使用world数据库中city表进行演示分页查询，**通过desc展示数据结构**，尤其是配合开发进行联调的时候很常用：

```sql
mysql> desc world.city;
```

![](https://gitee.com/dywangk/img/raw/master/images/world_city_proc.jpg)

**查询world数据库中的city表前5条数据**：

```sql
mysql> select * from city limit 0,5;
```

![](https://gitee.com/dywangk/img/raw/master/images/MySQL_limit_proc.jpg)

#### 2.2、Oracle的分页查询使用rownum伪列

同样使用`desc`关键字查询emp表结构：

```sql
SQL> desc scott.emp;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_emp_desc_proc.jpg)

**分页查询示例**：使用`rownum`关键字进行演示Oracle中的分页查询。

查询scott用户中emp（员工表）的员工empno：编号、ename：员工姓名以及伪列rowid，只查询前5条数据：

```sql
SQL> select t.rowid,t.empno,t.ename from scott.emp t where rownum <=5;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_emp_rownum_proc.jpg)

**Oracle进行分页查询常用方式一**，查询第6~11数据通过嵌套子查询，使用到关键字`rownum`和`where`：

```sql
-- 统计emp数据总条目数
select count(*) from scott.emp;  
-- 查询第6~11数据通过嵌套子查询，使用到关键字rownum和where
select * from (select scott.emp.empno,rownum r from scott.emp Where rownum<=11)where r>=6;
```
**Oracle进行分页查询常用方式二，先进行order by排序，再分页查询**，查询第6~11数据：

```sql
-- 先进行排序
select * from  emp e order by e.empno Desc;
-- 再进行分页
select * from (select e.*,rownum r_num from(select * from scott.emp e order by e.empno desc )e)b where b.r_num between 6 and 11;
```

## 二、聚合函数（Aggregate）

下面所讲的函数大多数标准SQL数据库是支持的，但也要依据实际情况做测试验证，个人主要验证的是MySQL和Oracle。

**重点**：count、sum函数在我们如果要迁移数据的时候，避免不了需要手动去统计求和对比迁移前后数据的一致性。

### 1、常见的聚合函数

**介绍几个聚合函数**：

- count函数用于统计条目数；
- sum函数用于求和；
- substr函数用于截取；
- avg函数用于取平均值；
- max函数用于取最大值；
- min函数用于取最小值。

如下则演示同时使用多个函数，查询Oracle数据库scott用户的emp表：

**查询出来的结果**：count统计员工总数，sum求和所有员工的薪水总额，avg统计所有员工平均薪水，substr则是截取到小数点后两位数。

```sql
-- count:统计条目数,sum:求和,substr:截取,avg:取平均值
select count(*), sum(t.sal), substr(avg(t.sal), 0, 7) from scott.emp t;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_agg_list_proc.jpg)

**返回平均值avg**，一般配合substr关键字去截取，通过计算保留小数点后两位。

统计某公司员工的平均薪资：

```sql
-- avg:取平均值
select avg(t.sal) from scott.emp t;
select substr(avg(t.sal), 0, 7) from scott.emp t;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_avg_proc.jpg)

**返回统计行数count**

统计某公司员工总数：

```sql
-- 统计函数count:统计emp表条目数量14
select count(*) from scott.emp;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_count_proc.jpg)

**返回总数（求和）sum**，sum函数一般会配合decode函数使用。上面的黑色背景看久了眼睛累，特意换了一种护眼色。字体颜色就没有特意更换，字体稍微点大了一丢丢，看的更舒服。

统计某公司所有员工薪资总和：

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

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_sum_proc.jpg)

**tips**：count函数在工作中使用的很频繁，你不清楚某张表中有多少条记录，需要统计一下再处理。

**返回最大值max**

查看员工中薪水最高的那一位：

```sql
-- max函数的使用
select max(t.sal) from scott.emp t;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_max_proc.jpg)

**返回最小值min**

查看员工中薪水最低的那一位：

```sql
select min(t.sal) from scott.emp t;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_min_proc.jpg)

**Oracle中的rownum伪列**

统计公司员工中的最后一条记录，通过`rownum`实现：

```sql
select t.sal from scott.emp t where rownum <=1;
select t.sal from scott.emp t where rownum <=1 order by t.sal desc;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_rownum_proc.jpg)

**MySQL中的分页limit关键字**

通过`limit`关键字实现，根据sakila数据库中的actor（演员表）为例子返回最后三条记录，使用actor_id进行排序。

**注意**：**limit属于MySQL扩展SQL92后的语法，在其它数据库中不能通用**。Oracle的分页可以通过rownum来实现，上面也介绍了。

```sql
SELECT t.`first_name`,t.`actor_id` FROM sakila.`actor` t ORDER BY t.`actor_id` DESC LIMIT 0,3;
```

![](https://gitee.com/dywangk/img/raw/master/images/MySQL_limit_01_proc60.jpg)

### 2、着重掌握的函数

- group by函数用于分组；
- having函数用于过滤，对分组后内容进行过滤。

**group by函数**

配合聚合函数`sum`使用，查询Oracle中scott用户下的emp表。使用`group by`进行分组，然后**统计公司各部门员工的薪资**：

```sql
SELECT t.deptno, SUM(t.sal) AS sals FROM scott.emp t GROUP BY t.deptno;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_group_by_proc.jpg)

**having函数**

**区别**：having和where的区别在于，having是对聚合后的结果进行条件的过滤，而where是在聚合前就对记录进行过滤。如果逻辑允许，应尽可能用where先过滤记录，由于结果集的减小，对聚合的效率明显提升。最后再依据逻辑判断是否用having再次过滤。

配合聚合函数使用，Oracle中的scott用户下emp与dept表。

先对部门名称进行分组，然后使用`having`过滤出薪水总和大于10000的部门：

```sql
SELECT d.dname, SUM(e.sal) AS sals FROM scott.emp e
INNER JOIN scott.dept d ON e.deptno=d.deptno
WHERE e.deptno < 30 GROUP BY d.dname  HAVING SUM(e.sal) > 10000;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_having_proc.jpg)

## 三、SQL核心知识

凡事应以实际工作场景而定。个人的以一些理解仅仅是建议，最终的应用还需结合实际应用场景。软件实施对SQL的函数、触发器和存储过程没有太高的要求，但也需要会基本的运用。在某些特殊的场景下，使用这些SQL的核心知识将有助于提高我们的工作效率。

### 1、函数

**函数关键字**：`FUNCTION`

使用第三方客户端工具新建函数，会自动生成一些模板：

```sql
DELIMITER $$  -- 声明关键字DELIMITER
CREATE -- 创建函数的关键字create
    /*[DEFINER = { user | CURRENT_USER }]*/
    FUNCTION `study`.`stu_num`() -- 设置函数名称
    RETURNS TYPE -- 返回值的类型
    /*LANGUAGE SQL
    | [NOT] DETERMINISTIC
    | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
    | SQL SECURITY { DEFINER | INVOKER }
    | COMMENT 'string'*/
    BEGIN -- 开始业务逻辑
    -- {业务逻辑区...}
    END$$ -- 结束标志
DELIMITER ;
```



### 2、触发器

**触发器关键字**：`TRIGGER`

使用第三方客户端工具新建触发器，会自动生成一些模板：

```sql
DELIMITER $$
CREATE	-- 创建触发器的关键字create
    /*[DEFINER = { user | CURRENT_USER }]*/
    TRIGGER `study`.`stu_insert` BEFORE/AFTER INSERT/UPDATE/DELETE
    ON `study`.`<Table Name>`
    FOR EACH ROW BEGIN -- 使用到for each循环
    -- {业务逻辑区...}
    END$$
DELIMITER ;
```



### 3、存储过程

**存储过程关键字**：`PROCEDURE`

支持完整事务的存储引擎，在保证数据的完整一致性情况下，尽可能多的使用commit事务提交。利用函数和存储过程一个好的示例，在MySQL中快速生成千万级别的数据大表进行测试就可以应用到，同时还能联想到测试性能。这是勾起我们学习的动力，一个比较好的方法。

**使用第三方客户端工具新建存储过程**，会自动生成一些模板：

```sql
DELIMITER $$
CREATE
    /*[DEFINER = { user | CURRENT_USER }]*/
    PROCEDURE `study`.`insert_study`()
    /*LANGUAGE SQL
    | [NOT] DETERMINISTIC
    | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
    | SQL SECURITY { DEFINER | INVOKER }
    | COMMENT 'string'*/
    BEGIN
	-- {业务逻辑区...}
	COMMIT; -- 支持完整事务的存储引擎,在保证数据的完整一致性情况下,尽可能多的使用commit事务提交
    END$$
DELIMITER ;
```



### 4、典型的示例sakila数据库

这是一个MySQL官方提供的拥有存储过程、触发器和函数示例的电影出租信息管理系统数据库。并且官方提供了EER模型，便于理解每张表之间的关联关系，可以使用MySQL workbench打开`sakila.mwb`进行参考学习。如果你能完整的看完这篇文档，你会发现在一开始我就提供了sakila数据库的官网下载地址。

**sakila数据库视图**：`actor_info`，演员信息视图

**使用DESC关键字进行查看视图结构**，这个关键字很实用哟。视图和表结构很像，以sakila中`actor_info`视图进行展示：

![](https://gitee.com/dywangk/img/raw/master/images/MySQL_desc_actor_info_proc.jpg)

**sakila数据库存储过程**：`film_in_stock`，电影库存

官方的一个示例：创建一个存储过程，声明了三个常量字段，然后分别赋值给演示字段，最后将找到的记录复制存到了p_film_count中。这里我为何说是复制呢？是因为使用到了`SELECT ... INTO`关键字。

函数、触发器和存储过程最主要的一块在BEGIN {业务逻辑区...} END这一块区域。

```sql
DELIMITER $$
USE `sakila`$$
DROP PROCEDURE IF EXISTS `film_in_stock`$$
CREATE DEFINER=`root`@`%` PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);
     SELECT FOUND_ROWS() INTO p_film_count;
END$$
DELIMITER ;
```

关于函数我就不列举MySQL官方提供的示例了。

**给出一点小小的建议，感觉对你没啥作用可以忽略掉**：首先快速熟悉语法使用，对官方的示例进行解读，然后运行验证。最后，书写一些简单的示例达到熟练运用目的。不要只停留在想要执行，而是立即执行并带着思考去看待问题。多问一个为什么，思考本质。

## 四、看文档也要护眼哟

### 1、常用护眼色

| 颜色           | RGB                      | 16进制  |
| -------------- | ------------------------ | ------- |
| **常用护眼色** | R：181   G：230   B：181 | #B5E6B5 |
| **黄**         | R：250   G：249   B：222 | #FAF9DE |
| **褐**         | R：250   G：242   B：226 | #FFF2E2 |
| 红             | R：253   G：230   B：224 | #FDE6E0 |
| 绿             | R：227   G：237   B：205 | #E3EDCD |
| **海天蓝**     | R：220   G：226   B：241 | #DCE2F1 |
| 紫             | R：233   G：235   B：154 | #E9EBFE |
| 灰             | R：234   G：234   B：239 | #EAEAEF |



# 总结

**能看到这里的，都是帅哥靓妹**。以上就是对SQL常用联合查询以及聚合函数的一个总结。希望能对你的工作与学习有所帮助。感觉写的还行，就反手一键三连吧。公众号上更新可能要快一点，目前还在完善中。如果感觉总结不到位，也希望能留下您宝贵的意见，我会定期在文章中进行调整优化。

![](https://gitee.com/dywangk/img/raw/master/images/Snipaste_2022-01-25_20-24-05.jpg)

