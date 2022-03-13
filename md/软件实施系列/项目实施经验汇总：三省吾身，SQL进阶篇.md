﻿﻿﻿软件（项目）实施面试题（经验），空余时间会总结一些SQL常用的知识并持续更新。

﻿﻿关于软件实施工程师的面试题，我个人也总结了一些，仅供参考。需要对主流的数据库Oracle、MySQL、SQLserver以及国产数据库DM有所了解，并能够熟练部署使用。最好还能具备一些服务器方面的知识，windous和linux都应该具备，能玩转linux那绝对是加分项。

说实话，软件实施这个行业，目前不仅资料欠缺，人才缺口更大。之前从事Javaweb后端开发，后来转向了软件实施行业，深知这个行业很缺人。目前也有几个项目的现场实施经验，也与许多人打过交道。

面试这方面，出的题也差不多。如果是医疗行业，也许使用微软的那一套比较多。更注重的是临时应变能力和SQL的运用能力，以及对项目实施布控的周期预估和控制。

![](https://gitee.com/dywangk/img/raw/master/images/%E4%B8%89%E7%9C%81%E5%90%BE%E8%BA%AB%EF%BC%8CSQL%E8%BF%9B%E9%98%B6_proc.jpg)

[toc]

# 第一部分《软件实施面试实际方案篇》

## 一	软件实施面试专业技能试题

### 01	理论思考题

**1、作为一个软件实施工程师你的职责是什么？该岗位需要具备什么样的能力？**

**解答**：

1. 推广公司的产品，现场为客户实施安装。
2. 熟悉公司的产品，现场对客户进行培训。



**2、你熟悉的远程有哪些方法？各种方法应该怎么配置？**

**解答**：

1. Windows：常见的QQ远程桌面，或者用QQ办公版TIM。
2. 或者采取有远程桌面功能的软件，或者其它OA办公系统。
2. 最终达到预期目标，采用远程协助达成客户需求。

**win10还有自带的远程桌面**
![](https://gitee.com/dywangk/img/raw/master/images/Windows设置远程桌面.jpg)

<br/>

**开启远程桌面协助**
![](https://gitee.com/dywangk/img/raw/master/images/开启远程桌面协助_proc80.jpg)

<br/>

快捷键**win + r**打开任务输入**mstsc**命令打开远程桌面。

![](https://gitee.com/dywangk/img/raw/master/images/远程桌面连接.jpg)

**linux使用ssh远程连接**：

1. **Xshell**（个人版免费使用）；
2. SecureCRT；
3. **Putty**（免费）；
4. **tabby**（开源的多终端集合）等等，只要能实现ssh连接的终端工具。
    ![](https://gitee.com/dywangk/img/raw/master/images/ssh工具.png)

**文件传输工具：WinSCP-5.11.2-Setup。**
![](https://gitee.com/dywangk/img/raw/master/images/winSCP.png)



**3、在你进行实施的过程中，公司制作的一款软件系统缺少某一项功能，而且公司也明确表示不会再为系统做任何的修改或添加任何的功能，而客户也坚决要求需要这一项功能！对于实施人员来说，应该怎么去合理妥善处理这个问题？**

**解答**：

1. 首先看用户要求合不合理，不合理就坚决退还需求，如果需求合理，可以申请二次开发，需要考虑公司的利益。
2. 然后综合考虑客户的重量级，对客户强调合同成本，外加某一项功能需要耗费的人力物力是需要付出额外的成本的。
3. 最后考虑第三方软件补助。



**4、如销售签有一外地客户，要求实施人员在客户现场一周内完成所有项目实施，而标准实施一般为期一个月，针对以上情况实施人员应该如何应对？**

**解答**：

1. 标准实施为一个月，那就按签订的合同行事。
2. 然后考虑这个项目一周完成，在当前的人力和时间成本下是否可行。
3. 如果想加快进度可以与公司沟通，额外派人，与客户客户协商额外的劳动成本。



**5、在项目实施过程中，使用者对产品提出了适合自己习惯的修改意见，但多个使用者相互矛盾，应该如何去处理？**

**解答**：

采用求同存异法。

1. 对于客户的意见，我们实施人员应该有自己的实施方案。
2. 当使用者意见出现不一致时候，引导客户内部意见达到统一和用户经过沟通确认后，找到切实可行的方案，双方认可并达成共识。



**6、系统启动后，不能连接数据库，可能是哪些方面的原因？**

**解答**：

1. 检查网络原因；
2. 检查数据库服务是否启动；
3. 数据库文件是否被破坏；
4. 数据库端口号问题（防火墙是否放通）。



**7、如果有一个不太懂电脑的客户，你应该采取什么样的方法去教他用公司的软件产品？**

**解答**：首先教客户熟悉基本的电脑操作，然后参考相关文档操作，实际根据软件的复杂程度去教会客户熟悉使用公司产品。遵循由易到难，简单的可以直接教会客户熟悉运用。复杂情况，一步一步稳扎稳打。

**也可以做其它的补足**：

1. 制作ppt；
2. 图文操作文档；
3. 录制视频。



**8、针对于已有5年以上的客户，其产生的历史数据可以怎么处理？**
**解答**：

1. 综合考虑客户的重量级。
2. 重量级客户，提前计划，定期做好用户数据的备份。一切从公司的利益考虑。



**9、一般数据库若出现日志满了，会出现什么情况，是否还能使用？**
**解答**：

1. 只能执行查询等读取操作。不能执行修改，备份等写操作，原因是任何写操作都要记录日志。
2. 数据库本就是需要承载读写操作的，也就是说基本上处于不能使用的状态。



### 02	SQL实际操作题



**10、已知A、B两表A.ID=B.ID请分别写出内外链接的sql语句，并说明区别？**
**解答**：

1. 内连接关键字`inner join on`；内连接取A和B的交集公共部分。
2. 外连接关键字：`left join on`，`right join on`。外连接分左外连接和右外连接，左外连接以左表为主，右外连接以右表为主。
3. 参考下图SQL联结查询图解，以数学集合的思想来思考更加清晰明了。

**注意**：外连接是可以省略`outer`关键字的，例如：左外连接`left outer join` 简写为`left join`，右外连接同理，后面配合`on`关键字。



## 二	SQL联结查询图解

### 1	内连接
内连接：
```sql
inner join on
```
![](https://gitee.com/dywangk/img/raw/master/images/左右表重合部分.jpg)
### 2	左外连接
左外连接：省略掉了`outer`，下同。
```sql
left join on
```
![](https://gitee.com/dywangk/img/raw/master/images/左表为主.jpg)
### 3	右外连接
右外连接：
```sql
right join on
```
![](https://gitee.com/dywangk/img/raw/master/images/右表为主.jpg)


关联查询，个人常用的两种，内连接和外连接。实际工作中内连接使用更多，具体视工作情况而定。

### 4	可参考资料

提供参考文档：

1. 菜鸟教程文档
2. 个人依据实际工作经验总结的文档

菜鸟教程直通车：

> [https://www.runoob.com/mysql/mysql-join.html](https://www.runoob.com/mysql/mysql-join.html)

个人总结文档：

> [https://blog.csdn.net/Tolove_dream/article/details/123005339](https://blog.csdn.net/Tolove_dream/article/details/123005339)

软件实施面试系列文章第二弹，MySQL和Oracle联合查询以及聚合函数的面试总结。思考来想去，方便阅读，将两篇文档整合到一起。上面的个人总结文档链接可提供单篇阅读。





# 第二部分《面试进阶，实际工作篇》

![](https://gitee.com/dywangk/img/raw/master/images/%E8%BD%AF%E4%BB%B6%E5%AE%9E%E6%96%BD%E9%A2%98%E5%9B%BE_proc.jpg)

**官方提供的sakila和world数据库**，官网下载地址已经提供，可以下载进行参考学习。

给出**sakila-db数据库**包含三个文件，便于大家获取与使用：

1. sakila-schema.sql：数据库表结构；
2. sakila-data.sql：数据库示例模拟数据；
3. sakila.mwb：数据库物理模型，在MySQL workbench中可以打开查看。

> [https://downloads.mysql.com/docs/sakila-db.zip](https://downloads.mysql.com/docs/sakila-db.zip)

**world-db数据库**，包含三张表：city、country、countrylanguage。

**只是用于用于简单测试学习，建议使用world-db**：

> [https://downloads.mysql.com/docs/world-db.zip](https://downloads.mysql.com/docs/world-db.zip)

Oracle11g安装后自带有scott用户，可以用来练习。主要用到的是EMP和DEPT表，想起了当年用Java的ssh框架写的第一个CURD的demo示例就是Oracle的这两张表，因为这两表有关联关系。

- EMP：员工表；
- DEPT：部门表；

**我的测试环境基于**：

- 操作系统：Windows10；
- 数据库：MySQL8.0.28和Oracle11g；
- 使用查询工具：MySQL8.0自带命令行以及Oracle自带的SQLplus；
- 第三方工具SQLyog和PLSQL Developer。



## 一	高级查询

**图解联合查询**

**内连接**：统计的内容是table1和table2的重合部分。

```sql
inner join on
```

![](https://gitee.com/dywangk/img/raw/master/images/左右表重合部分.jpg)

**左外连接**：可以省略掉`outer`，统计的内容是以table1为主的部分。

```sql
left outer join on
```
![](https://gitee.com/dywangk/img/raw/master/images/左表为主.jpg)

**右外连接**：同样可以省略掉`outer`，统计的内容是以table2为主的部分。

```sql
right outer join on
```
![](https://gitee.com/dywangk/img/raw/master/images/右表为主.jpg)

### 1	联结查询

#### 1.1	MySQL中联结查询示例

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



#### 1.2	Oracle中联结查询示例

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



### 2	分页查询

**tips**：Windows中CMD命令窗口使用`color a`即可调用出黑色背景绿色字体，`color f0`则是快速调出白色背景黑色字体哟！

护眼色：R：181    G：230    B：181

#### 2.1	MySQL分页查询

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



#### 2.2	Oracle分页查询

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



## 二	汇总数据

下面所讲的函数大多数标准SQL数据库是支持的，但也要依据实际情况做测试验证，个人主要验证的是MySQL和Oracle。

**重点**：count、sum函数在我们如果要迁移数据的时候，避免不了需要手动去统计求和对比迁移前后数据的一致性。

### 1	常见聚合函数

**01	聚合函数**（Aggregate）

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

#### 01	avg求平均值函数

**返回平均值avg**，一般配合substr关键字去截取，通过计算保留小数点后两位。

统计某公司员工的平均薪资：

```sql
-- avg:取平均值
select avg(t.sal) from scott.emp t;
select substr(avg(t.sal), 0, 7) from scott.emp t;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_avg_proc.jpg)

#### 02	count统计函数

**返回统计行数count**

统计某公司员工总数：

```sql
-- 统计函数count:统计emp表条目数量14
select count(*) from scott.emp;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_count_proc.jpg)



#### 03	sum求和函数

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



#### 04	max返回最大值函数

**返回最大值max**

查看员工中薪水最高的那一位：

```sql
-- max函数的使用
select max(t.sal) from scott.emp t;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_max_proc.jpg)



#### 05	min返回最小值函数

**返回最小值min**

查看员工中薪水最低的那一位：

```sql
select min(t.sal) from scott.emp t;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_min_proc.jpg)





### 2	着重掌握的函数

- group by函数用于分组；
- having函数用于过滤，对分组后内容进行过滤。

#### 01	group by分组函数

配合聚合函数`sum`使用，查询Oracle中scott用户下的emp表。使用`group by`进行分组，然后**统计公司各部门员工的薪资**：

```sql
SELECT t.deptno, SUM(t.sal) AS sals FROM scott.emp t GROUP BY t.deptno;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_group_by_proc.jpg)

#### 02	having过滤函数

**区别**：having和where的区别在于，having是对聚合后的结果进行条件的过滤，而where是在聚合前就对记录进行过滤。如果逻辑允许，应尽可能用where先过滤记录，由于结果集的减小，对聚合的效率明显提升。最后再依据逻辑判断是否用having再次过滤。

配合聚合函数使用，Oracle中的scott用户下emp与dept表。

先对部门名称进行分组，然后使用`having`过滤出薪水总和大于10000的部门：

```sql
SELECT d.dname, SUM(e.sal) AS sals FROM scott.emp e
INNER JOIN scott.dept d ON e.deptno=d.deptno
WHERE e.deptno < 30 GROUP BY d.dname  HAVING SUM(e.sal) > 10000;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_having_proc.jpg)





## 三	Oracle与MySQL各自特色

#### 01	Oracle中rownum伪列

统计公司员工中的最后一条记录，通过`rownum`实现：

```sql
select t.sal from scott.emp t where rownum <=1;
select t.sal from scott.emp t where rownum <=1 order by t.sal desc;
```

![](https://gitee.com/dywangk/img/raw/master/images/Oracle_rownum_proc.jpg)



#### 02	MySQL中分页limit关键字

通过`limit`关键字实现，根据sakila数据库中的actor（演员表）为例子返回最后三条记录，使用actor_id进行排序。

**注意**：**limit属于MySQL扩展SQL92后的语法，在其它数据库中不能通用**。Oracle的分页可以通过rownum来实现，上面也介绍了。

```sql
SELECT t.`first_name`,t.`actor_id` FROM sakila.`actor` t ORDER BY t.`actor_id` DESC LIMIT 0,3;
```

![](https://gitee.com/dywangk/img/raw/master/images/MySQL_limit_01_proc60.jpg)





## 四	SQL核心知识

凡事应以实际工作场景而定。个人的以一些理解仅仅是建议，最终的应用还需结合实际应用场景。软件实施对SQL的函数、触发器和存储过程没有太高的要求，但也需要会基本的运用。在某些特殊的场景下，使用这些SQL的核心知识将有助于提高我们的工作效率。

### 1	函数

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



### 2	触发器

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



### 3	存储过程

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



### 4	示例sakila数据库

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





## 五	SQL查漏补缺

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

![](https://gitee.com/dywangk/img/raw/master/images/show_status%E7%94%A8%E6%B3%95_proc.jpg)

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

![](https://gitee.com/dywangk/img/raw/master/images/c_u_s%E4%BA%86%E8%A7%A3%E6%95%B0%E6%8D%AE%E5%BA%93%E5%9F%BA%E6%9C%AC%E6%83%85%E5%86%B5_proc.jpg)

- Connections：试图连接MySQL服务器次数。
- Uptime：服务器工作时间。
- Slow_queries：慢查询次数。



#### 1.2	下划线（_）通配符

**作用**：这同样是一个比较有用的通配符。下划线用途和%一样，但有限制，只匹配单个字符。

**示例**：

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

**例如**：我想匹配含有b和o的老师姓名，在SQL Server2012中演示。

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





## 六	看文档也要护眼哟

### 1	常用护眼色

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



**面试过几家招软件实施，大体上前几道笔试题是考量你的现场应变能力，后几道笔试题是考量你对SQL的运用，关联查询这方面的试题居多**。软件实施一般是需要去固定的场所驻场，需要有自己的一套方案。也需要结合现场实际情况，灵活变通运用。软件实施行业是需要靠长期的累积行业经验的，不是一蹴而就的。



**参考文献**：

- 菜鸟教程
- 《SQL必知必会第五版》



# 莫问收获，但问耕耘

**养得胸中一种恬静，方得始终**。

学无止境，向阳而生。好啦！到此为止就是此篇文章的全部内容了！**能看到这里的都是帅哥靓妹啊**！！！善于总结，其乐不穷。**好记性不如烂笔头**，多收集自己第一次尝试的成果，收获也颇丰。**你会发现，自己的知识宝库越来越丰富**。

