# 前言
最近接触到了国产数据库达梦，因此想着写一个合集方便查阅连接驱动，以及配置连接。
创建用户、表以及表空间默认大家都会，因此就省略掉。
这里以Oracle为例子创建用户，表，赋予表空间。
1、达梦数据库（DM8）
2、Oracle11gR2
3、SqlServer2012
4、MySQL5.6


# 正文

主流数据库以及国产数据库驱动配置参考（端口默认没改动）
系统环境：Windows10
数据库：
1、达梦数据库（DM8）
2、Oracle11gR2
3、SqlServer2012
4、MySQL5.6


## DM8数据库
注意：最终安装目录是你自己设置的，与我设置的有区别。

DM8数据库jar驱动
D:\software\dmdbms\drivers\jdbc

配置连接
```java
jdbc.url=jdbc:dm://localhost:5236/test
```

```sql
--DM驱动:dm.jdbc.driver.DmDriver
jdbc.url=jdbc:dm://localhost（IP）:5236（端口）/test(数据库名称)
--jar驱动：DmJdbcDriver17.jar
```


## MySQL数据库
mysql驱动
com.mysql.jdbc.Driver

配置连接
jdbc.url=jdbc:mysql://localhost（IP）:3306（端口）/test?useUnicode=true&characterEncoding=utf-8


## SQLserver数据库
sqlserver2012驱动
com.microsoft.sqlserver.jdbc.SQLServerDriver

配置连接
jdbc.url=jdbc:sqlserver://localhost（IP）:1433（端口）;instanceName=sqlserver2012;DatabaseName=test;integratedSecurity=true;

jar包驱动：
sqljdbc41.jar



## Oracle数据库
oracle驱动
oracle.jdbc.driver.OracleDriver

jar驱动
ojdbc6.jar

配置连接：
```java
jdbc.url=jdbc:oracle:thin:@localhost（IP）:1521（端口）:orcl（实例名）
jdbc.url=jdbc:oracle:thin:@localhost:1521:orcl
```

### 创建用户、表、生成数据
```sql
--使用plsql developer工具创建
--Oracle11g创建数据库用户:TEST,PASSWORD:123456
--创建用户
create USER TEST;

--赋予权限
grant resource,connect to TEST;

--执行以下语句创建表
--建议：创建表以及字段要么统一小写，要么统一大写，最好还是大写的
create table TEST.GIRL
(
  ID        VARCHAR2(64),
  GIRL_NAME VARCHAR2(64),
  CUP_SIZE  VARCHAR2(2),
  GIRL_AGE  VARCHAR2(2),
  STU_NUM   VARCHAR2(64)
)

--设置默认表空间
alter user test default tablespace USERS;
--设置ID为主键
alter table TEST.GIRL add primary key(ID); 

--插入测试数据
insert into TEST.GIRL values('1001','梦梦','C','16','TOLOVE16C');

--查询数据
select * from TEST.GIRL;
```


## 示例代码

```java
/** 测试连接Oralce、DM、MySQL、SqlServer **/

package com.example.demo.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TestConnJdbc {

		/**mysql驱动:com.mysql.jdbc.Driver**/

		/**sqlserver驱动：com.microsoft.sqlserver.jdbc.SQLServerDriver**/

		/**oracle驱动:oracle.jdbc.driver.OracleDriver**/

		/**DM驱动:dm.jdbc.driver.DmDriver**/
			

	private static final Logger log = LoggerFactory.getLogger(TestConnJdbc.class);

	//初始化参数
	static Connection conn = null;
	static PreparedStatement ps = null;
	static ResultSet rs = null;


	/** 测试连接各个数据库 **/
	public static void main(String[] args) throws Exception {
		//TestSQLConnOralce();
		//TestSQLConnSqlServer();
		//TestSQLConnMySQL();
		TestSQLConnDM();
	}
	
	
	/**
	 * @Description
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 * 
	 */
	private static void TestSQLConnOralce() throws SQLException, ClassNotFoundException {

		try {
			
			//1.加载驱动 
			Class.forName("oracle.jdbc.driver.OracleDriver");
		
			//2.获取连接参数url,username,password
			/** oracle拼接url **/
			String url = "jdbc:oracle:thin:@127.0.0.1:1521:orcl";
			String username = "TEST";
			String password = "123456";

			//获取连接
			conn = DriverManager.getConnection(url, username, password);
			if(null != conn) {
				log.info("connect database success...");
				System.out.println("连接成功！！！");
			}else {
				log.error("connect database failed...");
				System.out.println("连接失败！！！");
			}
			
			
			//查询数据库
			String sql = "select * from girl";
			// 3.通过preparedStatement执行SQL
			ps = conn.prepareStatement(sql);
			
			// 4.执行查询,获取结果集
			rs = ps.executeQuery();
			// 5.遍历结果集，前提是你的数据库创建了表以及有数据
			while (rs.next()) {
				//对应表中字段类型
				System.out.println("ID:" + rs.getString("ID"));
				System.out.println("姓名：" + rs.getString("girl_name"));
				System.out.println("年龄：" + rs.getString("girl_age"));
				System.out.println("尺寸：" + rs.getString("cup_size"));
				System.out.println("学号：" + rs.getString("stu_num"));
			}
		} finally {
			// 6.关闭连接 释放资源
			rs.close();
			ps.close();
			conn.close();
		}
	}
	
	//使用JDBC连接DM数据库
	private static void TestSQLConnDM() throws SQLException, ClassNotFoundException {

		try {
			
			//1.加载驱动 
			Class.forName("dm.jdbc.driver.DmDriver");
			
			//2.获取连接参数url,username,password

			/** DM拼接url **/
			String url = "jdbc:dm://localhost:5236/test";
			String username = "USERS";
			String password = "123456789";
			if(username!="USERS") {
				System.err.println("用户名错误或者不存在！！！");
			}else if(password != "123456789" && password != null) {
				System.err.println("密码错误！！！");
			}

			//获取连接
			conn = DriverManager.getConnection(url, username, password);
			if(null != conn) {
				log.info("connect database success...");
				System.out.println("连接成功！！！");
			}else {
				log.error("connect database failed...");
				System.out.println("连接失败！！！");
			}
			
			
			//查询数据库
			String sql = "select * from girl";
			// 3.通过preparedStatement执行SQL
			ps = conn.prepareStatement(sql);
			
			// 4.执行查询,获取结果集
			rs = ps.executeQuery();
			// 5.遍历结果集，前提是你的数据库创建了表以及有数据
			while (rs.next()) {
				//对应表中字段类型
				System.out.println("ID:" + rs.getString("ID"));
				System.out.println("姓名：" + rs.getString("girl_name"));
				System.out.println("年龄：" + rs.getString("girl_age"));
				System.out.println("尺寸：" + rs.getString("cup_size"));
				System.out.println("学号：" + rs.getString("stu_num"));
			}
		} finally {
			// 6.关闭连接 释放资源
			rs.close();
			ps.close();
			conn.close();
		}
	}
	

	/** 
	 * 1.SQLserver2012需要下载jar包sqljdbc41.jar
	 * 2.将auth下x64下的sqljdbc_auth.dll导入到Windows的system32中
	 */
	private static void TestSQLConnSqlServer() throws SQLException, ClassNotFoundException {

		try {
		
			//1.加载驱动 
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			//2.获取连接参数url,username,password
			/** SqlServer拼接url **/
			String url = "jdbc:sqlserver://localhost:1433;" + 
			"database=girl;integratedSecurity=true;";
			String username = "sa";
			String password = "123456";

			//获取连接
			conn = DriverManager.getConnection(url, username, password);
			if(null != conn) {
				log.info("connect database success...");
				System.out.println("连接成功！！！");
			}else {
				log.error("connect database failed...");
				System.out.println("连接失败！！！");
			}
			
			//查询数据库
			String sql = "select * from girl";
			// 3.通过preparedStatement执行SQL
			ps = conn.prepareStatement(sql);
			
			// 4.执行查询,获取结果集
			rs = ps.executeQuery();
			// 5.遍历结果集，前提是你的数据库创建了表以及有数据
			while (rs.next()) {
				//对应表中字段类型
				System.out.println("ID:" + rs.getString("ID"));
				System.out.println("姓名：" + rs.getString("girl_name"));
				System.out.println("年龄：" + rs.getString("girl_age"));
				System.out.println("尺寸：" + rs.getString("cup_size"));
				System.out.println("学号：" + rs.getString("stu_num"));
			}
		} finally {
			// 6.关闭连接 释放资源
			rs.close();
			ps.close();
			conn.close();
		}
	}
	
	private static void TestSQLConnMySQL() throws SQLException, ClassNotFoundException {

		try {

			//1.加载驱动 
			Class.forName("com.mysql.jdbc.Driver");
		
			// 2.获取连接参数url,username,password

			/** MySQL拼接url **/
			String url = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf-8";
			String username = "root";
			String password = "123456";
			if(username!="root") {
				System.err.println("用户名错误或者不存在！！！");
			}else if(password != "123456" && password != null) {
				System.err.println("密码错误！！！");
			}

			//获取连接
			conn = DriverManager.getConnection(url, username, password);
			if(null != conn) {
				log.info("connect database success...");
				System.out.println("连接成功！！！");
			}else {
				log.error("connect database failed...");
				System.out.println("连接失败！！！");
			}
			
			//查询数据库
			String sql = "select * from girl";
			// 3.通过preparedStatement执行SQL
			ps = conn.prepareStatement(sql);
			
			// 4.执行查询,获取结果集
			rs = ps.executeQuery();
			// 5.遍历结果集，前提是你的数据库创建了表以及有数据
			while (rs.next()) {
				//对应表中字段类型
				System.out.println("ID:" + rs.getString("ID"));
				System.out.println("姓名：" + rs.getString("girl_name"));
				System.out.println("年龄：" + rs.getString("girl_age"));
				System.out.println("尺寸：" + rs.getString("cup_size"));
				System.out.println("学号：" + rs.getString("stu_num"));
			}
		} finally {
			// 6.关闭连接 释放资源
			rs.close();
			ps.close();
			conn.close();
		}
	}

}
```