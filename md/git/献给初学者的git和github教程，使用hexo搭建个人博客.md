# 前言

首选展示一下闲来无事，突然再次逛到hexo，此时回想起5年前还是是看别人的博客教程搭建。今天直接在github上看了hexo的简单教程，亲自撸了一个很简陋的小破站出来，直接访问可以看到效果呦：[https://cnwangk.github.io/](https://cnwangk.github.io/)

![](https://gitee.com/dywangk/img/raw/master/images/github_pages_hexo_proc.jpg)

hexo配合github还是挺方便的，毕竟在Windows平台我可以利用node.js安装hexo插件，进而配合一键生成模板然后提交到github。直接在hexo生成的blob模板中的markdown文件中写入你的文章。抛开通用性，markdown确实很方便。这里提供一下**hexo的网址**：

- hexo的github仓库：[https://github.com/hexojs/hexo](https://github.com/hexojs/hexo)
- hexo的中文文档：[https://hexo.io/zh-cn/docs/](https://hexo.io/zh-cn/docs/)
- hexo中文github-pages教程：[https://hexo.io/zh-cn/docs/github-pages](https://hexo.io/zh-cn/docs/github-pages)
- hexo安装deploy实现一键发布：[https://github.com/hexojs/hexo-deployer-git](https://github.com/hexojs/hexo-deployer-git)


你真的了解git、gitee、github吗？本文主要围绕git、gitee、github的使用展开介绍，如何一步步通过实践去打造自己的git工作环境。当然你可以作为写作环境，熟悉一门技术的有效方式就是应用实践。顺带会讲一些gitee和github的pages服务，搭建自己的个人网站。

本文主要环境是在Windows下进行的，所以看到桌面或者在某一目录右键可以直接打开Git Bash。



# 正文

至于我为什么将git工具放在最前面，是因为通过这个工具可以将gitee与github串联起来。可能有人会说，我可以在虚拟机上或者云服务器上搭建git环境测试。但我想说的是，白嫖她不香吗？直呼真香，小伙子有点东西啊！

## 一、git

**背景**

现如今，难以想象有创意的人会在没有备份策略的情况启动一个项目。数据是短暂的，且容易丢失，例如通过一次错误的代码变更或者一次灾难性的磁盘崩溃。所以，在整个工作中持续性地备份和存档是非常明智的。

对于文本和代码项目，备份策略通常包括版本控制，或者叫“对变更进行追踪管理”。每个开发人员都会进行若干变更。这些持续增长的变更，加在一起可以构成一个版本库，用于项目描述，团队沟通和产品管理。版本控制有着举足轻重的作用。

一个可以管理和追踪软件代码或其他类似类容的不同版本工具。通常称为：版本控制系统（VCS），或者源代码管理器（SCM），或者修订控制系统（RCS）。或者其他各种“修订、代码、内容、版本、控制、管理以及系统”等相关叫法。但其实每二个工具都是出于同样的目的，开发以及维护开发出来的代码，方便管理控制历史记录和修改。

**诞生**

一句话简单概括：BitKeeper的所有方对免费版做了限制，Linus本人开始寻找替代品，在工作中开发出了有助于分布式开发的git版本控制管理工具。

### 1、git客户端工具下载地址

[https://git-scm.com/downloads](https://git-scm.com/downloads)

git下载地址：支持Linux/Unix、macOS、Windows

![](https://gitee.com/dywangk/img/raw/master/images/git%E4%B8%8B%E8%BD%BD_proc.jpg)



### 2、生成ssh公钥

使用`git status`时遇到如下问题：

```bash
You don’t exist Go away！
you parents must have hated you!
you sysadmin must hate you! 
```

不要慌，此时git在告诉你，我无法确定您的真实姓名，咱交个好朋友吧，请告诉我你的芳名。

通过设置name和email地址可以修复此问题。



2.1、配置提交作者

安装好了git工具，此时可以在桌面右键（Git Bash），输入以下命令进行设置用户以及email。

```bash
$ git config --global user.name "dywangk"
$ git config --global user.email "dywangk@example.com"
```

2.2、生成ssh公钥，Windows下默认在**系统盘的当前用的.ssh目录**下

```bash
$ ssh -keygen -t ed25519 -C "test@example.com" 
```

2.3、**gitee提供的方案配置多个key**

生成rsa文件时，以指定不同的文件命令作为区分gitee以及github生成的key文件。

```bash
$ ssh-keygen -t rsa -C 'dywangk@company.com' -f ~/.ssh/gitee_id_rsa
$ ssh-keygen -t rsa -C 'dywangk@163.com' -f ~/.ssh/github_id_rsa
```

生成key后，然后在 ~/.ssh 目录下新建一个config文件，添加如下内容（其中Host和HostName填写git服务器的域名，IdentityFile指定私钥的路径）。看完后我大致明白了，是将gitee和github区分开来，分别读取不同的id_rsa文件的参数值。

```bash
# gitee
Host gitee.com
HostName gitee.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/gitee_id_rsa
# github
Host github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/github_id_rsa
```

配置好进行验证

```bash
#验证gitee
$ ssh -T git@gitee.com
#验证github
$ ssh -T git@github.com
```



配置好git之后，利用ssh -keygen命令生成ssh公钥，生成公钥所在的存储目录（以Windows环境为例）。生成完key后，可以通过VSCode、sublime text或者其她的辅助工具打开这个文件，复制到github的ssh公钥并保存。在下面的github介绍过程中，我有提到如何将生成的key保存到github并验证。同理gitee也是一样的操作过程，只是操作界面不一样而已。

![](https://gitee.com/dywangk/img/raw/master/images/git%E7%94%9F%E6%88%90%E7%9A%84id_rsa%E5%AD%98%E5%82%A8%E7%9D%80ssh%E5%85%AC%E9%92%A5_proc.jpg)





## 二、gitee

>引用官方的一个介绍
>
>*Gitee*.com(码云) 是 OSCHINA.NET 推出的代码托管平台,支持 Git 和 SVN,提供免费的私有仓库托管。目前已有超过 600 万的开发者选择 *Gitee*。

中文模式，使用起来比较方便。没有github那么难上手，毕竟看到纯英文，读起来着实头疼。在gitee的教程上，我没有过多介绍。

提一点，如果不想使用命令提交，gitee也支持拖拉拽形式上传文件，但是每天上传的文件有限制。

### 1、gitee配置ssh公钥教程

gitee官网有很详细的中文说明文档，至于如何配置，我这里给出链接参考。

[https://gitee.com/help/articles/4181#article-header0](https://gitee.com/help/articles/4181#article-header0)



### 2、配置GPG keys工具

当你访问gitee配置的GPG keys的时候，截至目前为止依旧是测试中（beta）。

[https://gpg4win.org/thanks-for-download.html](https://gpg4win.org/thanks-for-download.html)



## 三、github

### 1、github官网

[https://github.com](https://github.com)

一句话精简概括，一款活跃在互联网中有着庞大的开发团队或者个人并维护者众多的开源项目的开源项目托管平台。

**下面是来自于维基百科最新的介绍**

>**GitHub**是通过[Git](https://zh.wikipedia.org/wiki/Git)进行[版本控制](https://zh.wikipedia.org/wiki/版本控制)的软件[源代码](https://zh.wikipedia.org/wiki/源代码)托管服务平台，由GitHub公司（曾称Logical Awesome）的开发者[Chris Wanstrath](https://zh.wikipedia.org/w/index.php?title=Chris_Wanstrath&action=edit&redlink=1)、[P. J. Hyett](https://zh.wikipedia.org/w/index.php?title=P._J._Hyett&action=edit&redlink=1)和[汤姆·普雷斯顿·沃纳](https://zh.wikipedia.org/wiki/汤姆·普雷斯顿·沃纳)使用[Ruby on Rails](https://zh.wikipedia.org/wiki/Ruby_on_Rails)编写而成。
>
>GitHub同时提供付费账户和免费账户。这两种账户都可以创建公开或私有的[代码仓库](https://zh.wikipedia.org/wiki/代码库)，但付费用户拥有更多功能。根据在2009年的Git用户调查，GitHub是最流行的[Git](https://zh.wikipedia.org/wiki/Git)访问站点。除了允许个人和组织创建和访问保管中的代码以外，它也提供了一些方便社会化共同软件开发的功能，即一般人口中的社群功能，包括允许用户追踪其他用户、组织、软件库的动态，对软件代码的改动和[bug](https://zh.wikipedia.org/wiki/程序错误)提出评论等。GitHub也提供了图表功能，用于概观显示开发者们怎样在代码库上工作以及软件的开发活跃程度。
>
>截止到2020年1月，GitHub已经有超过4000万注册用户和1.9亿代码库（包括至少2800万开源代码库），事实上已经成为了世界上最大的代码存放网站和[开源](https://zh.wikipedia.org/wiki/开放源代码)社区。
>
>2018年6月4日晚，[美国](https://zh.wikipedia.org/wiki/美国)科技公司[微软](https://zh.wikipedia.org/wiki/微軟)宣布以75亿美元的股票收购GitHub。

就算被微软收购后，依旧没改变github那极不稳定的访问速度。



### 2、github使用配置简介

由于github是纯英文的，所以我会多配置一些截图并辅以说明，望理解。

**2.1、github配置ssh公钥**

这里不仅仅是支持配置SSH keys，并且还支持配置GPG keys，需要下载支持的工具进行生成GPG公钥然后添加到github。当然，如果你要移除某一个key，点击Delete删除即可。

![](https://gitee.com/dywangk/img/raw/master/images/github%E9%85%8D%E7%BD%AEsshkeys_gpgkeys_proc.jpg)

[https://github.com/settings/ssh/new](https://github.com/settings/ssh/new)



**2.2、账号设置**

账号设置，可以修改用户名、以及删除你的账号（谨慎操作）。

![](https://gitee.com/dywangk/img/raw/master/images/github%E8%B4%A6%E5%8F%B7%E8%AE%BE%E7%BD%AE_proc.jpg)

[https://github.com/settings/admin](https://github.com/settings/admin)



**2.3、个人简介设置**

此处是个人简介设置，比如公共邮箱设置、对自己的介绍、URL地址、Twitter用户名以及公司等等介绍。

![](https://gitee.com/dywangk/img/raw/master/images/github%E4%B8%AA%E4%BA%BA%E8%B5%84%E6%96%99%E8%AE%BE%E7%BD%AE_proc.jpg)

[https://github.com/settings/profile](https://github.com/settings/profile)



**2.4、辅助邮箱设置**

设置邮箱后，可以使用设置好的邮箱进行登录操作，接收一些比如修改密码时可能需要邮箱验证。

![](https://gitee.com/dywangk/img/raw/master/images/github%E9%82%AE%E7%AE%B1%E8%AE%BE%E7%BD%AE_proc.jpg)

[https://github.com/settings/emails](https://github.com/settings/emails)



### 3、配置验证

Windows下右键打开`Git Bash`，使用`ssh -T`命令测试验证。当前配置了gitee的ssh公钥，验证返回结果成功。未配置github的ssh公钥，测试验证返回的结果是权限（permission denied）拒绝。

使用命令测试验证

```bash
#验证gitee
ssh -T git@gitee.com
#验证github
ssh -T git@github.com
```



![](https://gitee.com/dywangk/img/raw/master/images/git%E4%BD%BF%E7%94%A8ssh-T%E6%B5%8B%E8%AF%95%E8%BF%9E%E6%8E%A5.png)



下面是配置好了github的ssh公钥或者是GPG keys，进行测试验证，返回结果是成功。

![](https://gitee.com/dywangk/img/raw/master/images/github%E9%85%8D%E7%BD%AEssh%E5%85%AC%E9%92%A5%E8%AE%BF%E9%97%AE%E9%AA%8C%E8%AF%81.png)



### 4、导入远程仓库到github

导入远程仓库选择**import repositories**，比如导入gitee的远程仓库。好吧，我一般是将github仓库同步至gitee作为镜像仓库使用。大家都懂得，长城网络的墙太殷实了，就算github被微软收购后这个访问速度依旧感人。

![](https://gitee.com/dywangk/img/raw/master/images/github_%E6%96%B0%E5%BB%BA%E5%AF%BC%E5%85%A5%E4%BB%93%E5%BA%93_proc.jpg)

例如，我**同步自己的写作工作空间**：

![](https://gitee.com/dywangk/img/raw/master/images/github%E5%AF%BC%E5%85%A5%E8%BF%9C%E7%A8%8B%E4%BB%93%E5%BA%93_proc.jpg)

**github一些使用介绍**，你的个人仓库（your repositories）、个人收藏的仓库（your stars）、个人设置（settings）

![](https://gitee.com/dywangk/img/raw/master/images/github%E6%93%8D%E4%BD%9C%E7%AE%80%E4%BB%8B_proc.jpg)


### 5、获取github私人令牌（token）
**登录到github**，在个人设置（点右上角头像）找到**settings**（设置），左侧一栏滑到最下面找到**Developer settings**，然后选中**Personal access tokens**。每张截图下面都有附上设置的地址哟！

![](https://gitee.com/dywangk/img/raw/master/images/github%E7%94%9F%E6%88%90%E4%B8%AA%E4%BA%BAtoken_proc.jpg)

[https://github.com/settings/tokens](https://github.com/settings/tokens)

**新建token**，需要勾选自己需要的设置，然后填上标题。

![](https://gitee.com/dywangk/img/raw/master/images/github_gen_token_proc.jpg)

[https://github.com/settings/tokens/new](https://github.com/settings/tokens/new)

## 四、git基本命令介绍（实用型）

### 1、基本命令

#### 1.1、git init初始化一个仓库

git初始化一个仓库时，会生成.git目录，是一个隐藏文件。linux下可以使用`ls -a`查看所有文件，Windows下打开资源管理器的显示隐藏项目才能看到该文件。下面给出Windows下的初始化后的git仓库示例：

![](https://gitee.com/dywangk/img/raw/master/images/%E5%88%9D%E5%A7%8B%E5%8C%96git%E5%90%8E%E7%94%9F%E6%88%90%E7%9A%84%E9%9A%90%E8%97%8Fgit%E6%96%87%E4%BB%B6.png)

隐藏目录文件列表如下，具体作用不做讲解。有兴趣的可以去逛逛官方文档，或者参考git相关的实体书。

![](https://gitee.com/dywangk/img/raw/master/images/git%E9%9A%90%E8%97%8F%E7%9B%AE%E5%BD%95%E6%96%87%E4%BB%B6.png)

Windows下直接切换到test目录，并**初始化test这个目录**

```bash
#Windows下直接切换到test目录，并初始化这个目录
$ git init
```

![](https://gitee.com/dywangk/img/raw/master/images/git_init%E5%88%9D%E5%A7%8B%E5%8C%96test%E7%9B%AE%E5%BD%95.png)

#### 1.2、git add将数据暂存

这里提醒一下，TAB快捷键可以自动补全，使用时输入开头直接按TAB快捷键自动补全。

```bash
#添加README.md文件，此时加入到暂存区域
$ git add README.md
```

#### 1.3、git commit提交数据

提交创建好的README.md文件，显示如下图所示。这里只是示例，不代表最终推送到仓库。

![](https://gitee.com/dywangk/img/raw/master/images/git%E6%8F%90%E4%BA%A4%E6%96%87%E4%BB%B6.png)

```bash
#提交数据到仓库,提交全部
$ git commit -m "新增README.md文件"
#提交单个指定文件README.md
$ git commit README.md -m "新增README.md文件"
```

**查看提交**

```bash
$ git log
```

![](https://gitee.com/dywangk/img/raw/master/images/git_log_proc.jpg)

#### 1.4、git push推送提交的数据到远程仓库

推送之前需要连上自己的远程仓库SQL-study

```bash
$ git remote add origin git@gitee.com:dywangk/SQL-study.git
```

**推送提交的数据到远程仓库master**

```bash
#推送提交的数据到远程仓库master
$ git push git@gitee.com:dywangk/SQL-study.git
```

之前看到某呼上有提问，如何记住那么多的linux命令。我当时就在思考，经常使用，自然而然的就记住了。一遍记不住，我操作五遍该有印象了吧。很多命令不用刻意记住，善用系统提供的帮助命令`--help`或者linux下的`man`辅助你快速上手。**使用时尽量手敲，不要去复制粘贴**，否则效果不大。熟悉后可以使用上下键快速调出历史命令，使用`history`命令查看使用的记录。

以上就是我日常书写文章后，进行提交经常使用到的git命令。当你需要优化删除一些不需要的文件，此时可以通过 `git rm`命令实现操作。当你需要移动某个文件时，可以使用git rm或者`git mv`命令进行移动文件操作。熟悉linux基本命令的同学，更容易上手，很多命令都类似。

#### 1.5、克隆仓库到本地

比如，将阿里的开源消息中间件rocketmq-spring克隆到本地，**前提是配置好了ssh公钥**

```bash
#将阿里的开源消息中间件rocketmq-spring克隆到本地，前提是配置好了ssh公钥
$ git clone git@github.com:apache/rocketmq-spring.git
```



### 2、进阶

#### 2.1、以分支为例简单介绍

```bash
#查看分支
$ git branch
#新增分支
$ git branch bchtest
#删除分支
$ git branch -d bchtest
#检出分支
$ git checkout master
#合并分支命令
$ git merge other_branch
```



关于进阶知识，需要了解更多的git命令使用，比如分支、合并、删除、修改或者移动以及冲突处理。

**在你做删除操作时，切记事先做好备份**。

如果想再进一步，那就推荐系统的看实体书《Git版本控制管理》，我最近也在阅读这本书籍。很多以前一知半解的，现在突然**念头通达**了。深入了解Git的工作原理，辅助你更好地学习与理解。



## 五、Gitee Pages与Github Pages

关于gitee pages与github pages只做简单的介绍。至于新建仓库这些比较简单了，就不一一截图介绍了。要不然显得篇幅很长，有点在灌水的感觉。

### 1、gitee pages服务

[https://gitee.com/dywangk/sky/pages](https://gitee.com/dywangk/sky/pages)

gitee的gitee pages，新建仓库，在服务这一栏会有显示。强调的是，开启gitee pages服务需要实名认证。

![](https://gitee.com/dywangk/img/raw/master/images/gitee_pages_proc.jpg)

gitee pages配置页面，这已经是配置好的界面，可以强制使用https安全协议。当你提交数据到仓库时，没有及时生效，就进入此页面进行更新操作，然后测试访问你的git pages仓库即可。

比如访问我之前上传比较的感受一下。

[https://dywangk.gitee.io/sky](https://dywangk.gitee.io/sky)

![](https://gitee.com/dywangk/img/raw/master/images/gitee_pages%E6%9C%8D%E5%8A%A1_proc.jpg)

gitee官网有很详细的入门介绍，我这里只提一下，感兴趣的可以测试使用。

[https://gitee.com/help/articles/4136#article-header0](https://gitee.com/help/articles/4136#article-header0)



### 2、github pages服务

github pages的配置页面

[https://github.com/cnwangk/test/settings/pages](https://github.com/cnwangk/test/settings/pages)

配置教程，纯英文的，可以用Google翻译一下哈

[https://pages.github.com/](https://pages.github.com/)

**我测试配置了一个仓库**

**注意**：仓库必须是公开的（public）、然后仓库命令可以命令为用户名加github.io

![](https://gitee.com/dywangk/img/raw/master/images/github%E9%85%8D%E7%BD%AEpages%E6%9C%8D%E5%8A%A1_proc.jpg)

简单的github pages 服务搭建示例，可以测试访问。

[https://cnwangk.github.io/](https://cnwangk.github.io/)



<H5 align=center><a href="https://blog.csdn.net/Tolove_dream">by 龙腾万里sky  转载请标明出处！</a></H5>