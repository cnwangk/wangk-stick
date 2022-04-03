/**
1、dm8数据库创建用户users(个人感觉使用users容易混淆)或者test
2、创建表student
3、插入100w测试数据
4、commit提交
5、count统计数据
**/

/** 创建学生表begin  **/
CREATE TABLE users.student
(
    ID NUMBER not null primary key,
    STU_NAME VARCHAR2(60) not null,
    STU_AGE NUMBER(4,0) NOT NULL,
    STU_SEX VARCHAR2(2) not null
)

--学生表随机生成100w数据大约8s，测试插入1kw条数据花了90s左右
insert into users.student
select rownum,dbms_random.string('*',dbms_random.value(6,10)),dbms_random.value(14,16),
'女' from dual
connect by level<=1000000

select count(*) from users.student t where t.stu_age='16';

select t.*, t.rowid from users.student t where t.stu_age<16

update users.student set stuid=rownum where 1=1
--修改年龄随机14-16岁之间
update users.student set stu_age=dbms_random.value(14,16) where 1=1


--delete from test.student;
commit;
/** 创建学生表end  **/
/** DM8 for Windows10测试 **/




/** Oracle11g R2 for Windows10测试 **/
/** 测试插入1kw数据 ---begin **/
--创建表test
CREATE TABLE users.test
(
    id NUMBER not null primary key,
    stu_name NVARCHAR2(60) not null,
    score NUMBER(4,0) NOT NULL,
    createtime TIMESTAMP (6) not null
)


/** Oracle11g R2 测试 **/
--模拟插入200w级数据(36s),机器性能不够,插入1kw数据出现connect by内存不足
insert into users.test
select rownum,dbms_random.string('*',dbms_random.value(6,20)),dbms_random.value(0,100),
sysdate from dual
connect by level<=2000000

commit;

/** 统计 **/
select count(distinct id) from users.test;


--drop table test.test;
--drop table test.test01;

--提交
commit;

create table users.test01 as select * from users.test;

--(200w)
select count(*) from users.test;
--(1000w)
select count(*) from users.test01;

--(6s,8s,7s,7s),执行4次
insert into users.test01 select * from users.test
--统计
select count(distinct id) from users.test01

--优化id
update users.test01 set id=rownum where 1=1
--设置id为主键
ALTER TABLE users.test01 ADD CONSTRAINT constraint_test01 PRIMARY KEY (id);

/** 测试插入1kw数据 ---end **/
/** Oracle11g R2 for Windows10测试 **/

