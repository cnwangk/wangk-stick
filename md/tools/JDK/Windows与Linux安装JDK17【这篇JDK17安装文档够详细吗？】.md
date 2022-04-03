JDK最新版JDK17下载与安装；Windows版本与Linux（Redhat7系列安装配置JDK17），在Windows平台下Eclipse IDE配置JDK17。历史版本需要注册账号登录才能下载，真的太骚了，看着那个锁标志是锁住的。

![](https://gitee.com/dywangk/img/raw/master/images/JDK17%E9%A2%98%E5%9B%BE_proc.jpg)

前段时间，在某平台看到有人吐槽CSDN下载JDK17还需要付费。官方免费提供下载，CSDN欺负萌新不懂吗？

顺带一提目前使用比较广泛的两个JDK版本JDK8和JDK11最新版，需要登录账号才能下载哟：

1. JDK8最新版本：JDK8u321。
2. JDK11最新版本：JDK11.0.14。

[toc]


# BEGIN JDK17下载与安装

## 一、JDK17下载地址

JDK官网提供三大平台下载地址：

1. Linux版本JDK下载地址（ARM64和x64）。
2. macOS版本JDK下载地址（ARM64和x64）。
3. Windows版本JDK下载地址（x64）。

### 01 Windows版本JDK17

> [https://www.oracle.com/java/technologies/downloads/#jdk17-windows](https://www.oracle.com/java/technologies/downloads/#jdk17-windows)

1. Compressed Archive：被压缩的归档包文件，其实是JDK归档压缩包，需要手动安装JRE。
2. x64 installer：x64架构exe安装包文件。
3. x64 msi installer：x64架构msi安装包文件。

![](https://gitee.com/dywangk/img/raw/master/images/Windows_jdk17_proc.jpg)

**Windows版本zip压缩包JDK17.0.2下载地址**：

> [https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.zip](https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.zip)

Windows版本x64安装包exe文件安装包文件JDK17下载地址：

> [https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe](https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe)

Windows版本x64安装包msi安装包文件JDK17下载地址：

> [https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.msi](https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.msi)

### 02 Linux版本JDK17

Linux版JDK17.0.2下载：分为ARM64和x64架构

1. ARM64 Compressed Archive：被压缩的归档包文件，其实是JDK归档压缩包。
2. ARM64 RPM Packages：ARM64架构rpm包。
3. **x64 Compressed Archive**：被压缩的归档包文件，其实是JDK归档压缩包，编译后的二进制包。
4. x64 Debian Packages：x64架构deb包，在某版本之后同样适用于Ubuntu系列、中标麒麟以及银河麒麟。
5. x64 RPM Packages：x64架构rpm包。

> [https://www.oracle.com/java/technologies/downloads/#jdk17-linux](https://www.oracle.com/java/technologies/downloads/#jdk17-linux)

![](https://gitee.com/dywangk/img/raw/master/images/Linux_jdk17_proc.jpg)

JDK源码包下载地址：

> [https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz](https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz)

### 03 MacOS版本JDK17

MAC版本JDK17下载地址：

> [https://www.oracle.com/java/technologies/downloads/#jdk17-mac](https://www.oracle.com/java/technologies/downloads/#jdk17-mac)

![](https://gitee.com/dywangk/img/raw/master/images/MAC_jdk17_proc.jpg)

## 二、Windows安装JDK17（Archive）

介绍zip包的使用，不用点那个烦人的下一步下一步，比较自由，得自己控制。

**注意**：有可能存在配置环境变量后没有及时生效，重启就好了。

### 01 zip包JDK手动安装JRE 

当然我自己也做了测试，对于`jdk12`、`jdk14`、`jdk17`都适用。其它版本，没测试过。

1. 切换至jdk解压目录：D:\work\JavaEE\jdk17.0.2
2. 查看当前JDK版本，切换至jdk17.0.2\bin目录执行：`java -version`，看下面代码示例就很清晰。
3. 执行命令：bin\jlink.exe --module-path jmods --add-modules java.desktop --output jre，**注意我执行命令的目录**。

```bash
cd D:\work\JavaEE\jdk17.0.2\bin
#1.查看jdk版本
java -version
java version "17.0.2" 2022-01-18 LTS
Java(TM) SE Runtime Environment (build 17.0.2+8-LTS-86)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.2+8-LTS-86, mixed mode, sharing)
#2.生成jre,注意我执行命令的目录
D:\work\JavaEE\jdk17.0.2>bin\jlink.exe --module-path jmods --add-modules java.desktop --output jre
```



### 02 Eclipse IDE添加JDK17

1. 找到Eclipse IDE状态栏的Windows选项。
2. 点击Windows然后打开Preferences。
3. 搜索`jres`，选中`Installed JREs`，点击右侧add添加JDK17。
4. 添加完JDK选apply and close：应用并退出。

Eclipse IDE添加JDK17第一步：**选择Add添加**

![](https://gitee.com/dywangk/img/raw/master/images/eclipse_add_jdk_01_proc.jpg)



Eclipse IDE添加JDK17第二步：**选择VM点击next进行下一步**

![](https://gitee.com/dywangk/img/raw/master/images/eclipse_add_jdk_02_proc.jpg)



Eclipse IDE添加JDK17第三步：**选择Directory添加JDK安装目录，然后点击finish完成**。

 ![](https://gitee.com/dywangk/img/raw/master/images/eclipse_add_jdk_03_proc.jpg)



**完成添加JDK17，点击apply and close应用并提出当前窗口**：

![](https://gitee.com/dywangk/img/raw/master/images/eclipse_add_jdk_04_proc.jpg)

### 03 Windows下配置JDK环境变量

根据自己需求来，为了方便，建议配置一个经常使用的版本作为当前用户或者全局环境变量。

在实际工作中，我可以有多种方式去给自己测试的web应用配置JDK，一般情况是**startup.bat或者catalina.bat**文件中指定，**比如tomcat中指定JDK目录**，或者在rocketmq中也可以指定JDK目录：

```bash
JAVA_HOME=D:\work\JavaEE\jdk17.0.2
```

**开始配置环境变量**：

1. 编辑当前用户或者系统环境变量加入如下配置：D:\work\JavaEE\jdk17.0.2
2. 编辑当前用户或者系统PATH环境变量加入如下配置：D:\work\JavaEE\jdk17.0.2\bin
3. 编辑当前用户或者系统CLASS_PATH环境变量加入如下配置：.;%JAVA_HOME%\bin;%JAVA_HOME%\lib\dt.jar;%Java_Home%\lib\tools.jar;%SystemRoot%/system32;%SystemRoot%;，**注意结尾英文分号隔开**，在JDK5以后是可以不用配置这一选项。

编辑当前用户或者系统环境变量：**添加JAVA_HOME**

![](https://gitee.com/dywangk/img/raw/master/images/win10_add_java_home01_proc.jpg)

```bash
变量名:JAVA_HOME
变量值:D:\work\JavaEE\jdk17.0.2
```

配置JAVA_HOME后的效果：

![](https://gitee.com/dywangk/img/raw/master/images/win10_add_java_home02_proc.jpg)

编辑当前用户或者系统环境变量：**添加PATH**

![](https://gitee.com/dywangk/img/raw/master/images/win10_%E6%96%B0%E5%BB%BA_path_proc.jpg)

```bash
变量名:PATH
变量值:D:\work\JavaEE\jdk17.0.2\bin
```

**添加后的path环境变量**，个人测试配置了很多，其实大部分是系统自动生成的：

![](https://gitee.com/dywangk/img/raw/master/images/win10_add_path_proc.jpg)

编辑当前用户或者系统环境变量：**添加CLASS_PATH**

```bash
变量名:CLASS_PATH
变量值:.;%JAVA_HOME%\bin;%JAVA_HOME%\lib\dt.jar;%Java_Home%\lib\tools.jar;%SystemRoot%/system32;%SystemRoot%;
```

## 三、Linux（Redhat7系列）安装JDK17

安利一款实用多终端管理工具tabby，其实也不用我安利，在github上已经快30K的star（星标）。最新版可以设置中文模式。

![](https://gitee.com/dywangk/img/raw/master/images/tabby_proc.jpg)

如同Windows下配置环境变量一样，Linux下也有当前用户和全局用户（root）环境变量两种配置方式。

以下均作为演示，仅供参考，不喜勿喷。

### 01 Linux（Redhat7系列）安装JDK17

1. 解压jdk17安装包

```bash
[root@cnwangk work]# tar -zxvf jdk-17_linux-x64_bin.tar.gz
```

2. 修改名称为jdk17，为后面配置环境变量JAVA_HOM做准备

```bash
[root@cnwangk work]# mv jdk-17.0.2 jdk17 
```

3. 剪切jdk17到其它目录方便自己管理

```bash
[root@cnwangk work]# mv jdk17/ /usr/local/
```

4. 查看JDK版本，在没配置JAVA_HOME环境变量之前一样可以查看版本

```bash
[root@cnwangk bin]# ls
jar        javac    jcmd      jdeprscan  jhsdb   jlink  jpackage    jshell  jstatd       serialver
jarsigner  javadoc  jconsole  jdeps      jimage  jmap   jps         jstack  keytool
java       javap    jdb       jfr        jinfo   jmod   jrunscript  jstat   rmiregistry
[root@cnwangk bin]# ./java -version
java version "17.0.2" 2022-01-18 LTS
Java(TM) SE Runtime Environment (build 17.0.2+8-LTS-86)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.2+8-LTS-86, mixed mode, sharing)
```

5. 安装JRE，主要是利用`jlink`去生成，在解压后jdk17的bin目录下

```bash
[root@cnwangk jdk17]# ./bin/jlink --module-path jmods --add-modules java.desktop --output jre
[root@cnwangk jdk17]# ls
bin  conf  include  jmods  jre  legal  lib  LICENSE  man  README  release
```

能贴代码做演示的，我一般不愿意贴图，因为图片可能会因为各种原因挂掉。

### 02 Linux（Redhat7系列）配置JDK环境变量

1. 全局环境变量，**需要root用户权限**
2. 编辑`profile`文件：`vim /etc/profile`，加入如下配置：

![](https://gitee.com/dywangk/img/raw/master/images/Linux_add_jdk17_env_proc.jpg)

```bash
#JAVA environment
JAVA_HOME=/usr/local/jdk17
PATH=$PATH:$JAVA_HOME/bin
```

3. 配置jdk环境变量在当前用户test生效
4. 编辑`.bash_profile`文件：`vim /home/test/.bash_profile`
5. 在`.bashrc`和`.bash_profile`都有可以看到环境变量，个人一般编辑.bash_profile

![](https://gitee.com/dywangk/img/raw/master/images/Linux_vim_bashprofile.png)

```bash
#JAVA environment
JAVA_HOME=/usr/local/jdk17
PATH=$PATH:$JAVA_HOME/bin
```

6. **因为上面配置了全局的**，所以我在test用户下一样可以查看jdk版本

```bash
[test@cnwangk jdk17]$ java -version
java version "17.0.2" 2022-01-18 LTS
Java(TM) SE Runtime Environment (build 17.0.2+8-LTS-86)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.2+8-LTS-86, mixed mode, sharing)
```



关于JDK17的下载与安装就介绍到这里，**能看到这里的都是帅哥靓妹**。

# END 向阳而生

向阳而生，生而向阳。

静下来心才好做事，思路更清晰。每天进步一点，进步一小点那也是进步。

引用晚清中兴第一名臣，曾国藩家训中的一句名言，颇为受用：

> 养得胸中一种恬静。
