Windows中使用hexo搭建个人博客。

既学了git和github的用法，也熟悉了nodejs。

又多了一项打发业余时间的软技能。慢慢地变成硬技能，何乐而不为？

@[toc]
# Windows中使用hexo搭建私人博客

**必备环境（Windows）**：

- Nodejs：[https://nodejs.org/en/](https://nodejs.org/en/)（hexo官方建议：Node.js 版本需不低于 10.13，建议使用 Node.js 12.0 及以上版本。）

- **提醒**：Node.js 14.0版本在运行hexo服务时会出现警告，**但不影响使用**。

  ```bash
  INFO  Start processing 		# 使用nodejs 14.0出现警告，搜索后发现基本是让降版本至nodejs 12.0
  INFO  Hexo is running at http://localhost:4000 . Press Ctrl+C to stop.
  (node:4464) Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
  (Use `node --trace-warnings ...` to show where the warning was created)
  (node:4464) Warning: Accessing non-existent property 'column' of module exports inside circular dependency
  (node:4464) Warning: Accessing non-existent property 'filename' of module exports inside circular dependency
  (node:4464) Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
  (node:4464) Warning: Accessing non-existent property 'column' of module exports inside circular dependency
  (node:4464) Warning: Accessing non-existent property 'filename' of module exports inside circular dependency
  ```

- Git：[https://git-scm.com/downloads](https://git-scm.com/downloads)（个人使用版本：git version 2.31.1.windows.1）

- Hexo：[https://hexo.io/zh-cn/docs/github-pages](https://hexo.io/zh-cn/docs/github-pages)（个人使用版本：5.4.1）



**建议**：如果只是想简单发点私人博客，使用landscape主题完全可以满足。

**如果想弄点花里胡哨的功能，那就使用Next主题**。



## 一	安装hexo

### 01	使用npm安装hexo环境

```bash
npm install -g hexo-cli		#使用npm安装Hexo-cli
npm install hexo			#使用npm安装Hexo，熟悉的用户可以仅局部安装Hexo包
```

做完上面操作，恭喜你可以进行初始化安装blog文件了。

### 02	初始化博客（blog）目录

1. 进入d盘（Windows下打开cmd命令）

   ```bash
   d:
   ```

   

2. 创建hexo目录，方便自管理，知道这是使用hexo搭建的博客
   
   ```bash
   mkdir hexo
   ```
   
   
   
3. 切换到hexo目录
   
   ```bash
   cd hexo
   ```
   
   
   
4. 初始化blog目录，如果速度很慢，建议看第二大步骤第9小步骤替换为国内镜像源地址
   
   ```bash
   hexo init blog
   ```
   
   
   
5. 建议启动debug模式
   
   ```bash
   hexo --debug
   ```
   
   
   
6. 新增md文件
   
   ```bash
   hexo new "hello my blog"
   ```
   
   生成md（markdown）文件所在目录：source
   
   
   
7. 生成静态文件
   
   ```bash
   hexo g
   ```
   
   生成静态文件所在目录：public
   
   
   
8. 启动服务
   
   ```bash
   hexo s
   ```
   
   



## 二	切换nodejs镜像源

9. nodejs临时配置国内taobao镜像源：

​	npm镜像源地址，国内镜像站：
>  [https://npmmirror.com/](https://npmmirror.com/)

​	nodejs临时配置国内taobao镜像源：
> npm config set registry http://registry.npm.taobao.org/



## 三	安装插件（进阶）

如果你会一丢丢前端（nodejs）知识，对这些插件使用会很顺手。

10. 安装hexo插件（Next主题）

    ```bash
    npm install hexo-xxx-xxx --save
    ```

安装插件目录：node_modules

**比较实用的几个插件**：部分对landscape适用，主要是对Next主题适用。

- hexo-auto-excerpt：配置阅读全文功能，主页实现折叠效果（如果不想自己写代码，这是一个好的选择）。
- hexo-generator-sitemap：Next主题配置站点。
- hexo-leancloud-counter-security：配置博客阅读次数，需要在leancloud注册并配置应用凭证、结构化数据。
- hexo-generator-searchdb：Next主题配置本地搜索，注意在hexo中也需要配置。
- hexo-generator-search：这个插件使用浏览器进行在线搜索（个人不推荐配置这种）。

**这里只详细介绍主题配置自动阅读**（landscape和Next都适用）：

```yaml
#	1. 在主题（Next或者landscape）中设置_yaml.config配置文件，添加如下配置文件
#https://github.com/ashisherc/hexo-auto-excerpt
auto_excerpt: 
  enable: true
  length: 100
```

**cmd命令执行以下命令**：

```bash
#	2. 测试效果（Windows下使用cmd命令）
hexo g 		#	生成静态文件
hexo s		#	启动服务
```

**测试访问**：

> http://localhost:4000



11. 主题目录

    **主题所在目录**：themes

    **获取Next主题**：使用git clone或者直接下载

    > git clone git@github.com:next-theme/hexo-theme-next.git
    >
    > [https://github.com/next-theme/hexo-theme-next/archive/refs/heads/master.zip](https://github.com/next-theme/hexo-theme-next/archive/refs/heads/master.zip)

    下载后复制到themes目录，然后**修改hexo配置文件**_config.yml：

    ```bash
    # Extensions
    ## Plugins: https://hexo.io/plugins/
    ## Themes: https://hexo.io/themes/
    theme: hexo-theme-next
    #theme: landscape
    ```

   

12. hexo配置文件

​	blog目录下配置文件：_config.yml

**介绍一些使用比较多的参数**：更多请参考hexo或者Next主题文档

```yaml
# Site 		#站点配置
title: 		#网站标题：养得胸中一种恬静
subtitle: 	#子标题
description: 	#描述（个人简介）：莫问收获，但问耕耘
author: 		#作者
language: zh-CN #配置语言（中文）

# search	#搜索
search:
  path: search.xml
  field: post
  content: true
  format: html
  
leancloud_counter_security: 	#注册配置leancloud：配置阅读次数需要
  enable_sync: true
  app_id: #<app_id>
  app_key: #<app_key>
  #server_url: <your server url> # Required for apps from CN region, e.g. https://leancloud.cn
  #username: <your username> # Will be asked while deploying if is left blank
  #password: <your password> # Recommmended to be left blank. Will be asked while deploying if is left blank  
# Deployment	#配置一键发布，需要获取github的私人令牌（token）
## Docs: https://hexo.io/docs/one-command-deployment
#deploy:
#  type: git
#  repo: https://github.com/cnwangk/username.github.io
#  example, https://github.com/hexojs/hexojs.github.io
#  branch: gh-pages
```





13. 主题配置文件

​	themes目录landscape主题（hexo默认主题）：_config.yml

​	themes目录next主题hexo-theme-next：_config.yml

**Next主题仓库**：

> [https://github.com/next-theme/hexo-theme-next](https://github.com/next-theme/hexo-theme-next)

**主要介绍一些个人配置Next主题重要部分**：根据使用经验加了注释

```yaml
menu:		#菜单配置
  home: / || fa fa-home						#主页
  about: /about/ || fa fa-user				#关于页面（个人简介），默认需要手动创建
  #search: /search							#配置搜索（在线搜索）
  tags: /tags/ || fa fa-tags				#配置标签页目录，默认需要手动创建
  categories: /categories/ || fa fa-th		#配置类别目录，默认需要手动创建
  archives: /archives/ || fa fa-archive		#配置归档目录
  schedule: /schedule/ || fa fa-calendar	#日程表
  sitemap: /sitemap.xml || fa fa-sitemap	#站点地图（xml文件，相当于一个导航）
  commonweal: /404/ || fa fa-heartbeat		#公益404界面，在source目录配置404.html即可

# Local Search	#配置本地搜索
#下载插件：npm install hexo-generator-searchdb --save
# Dependencies: https://github.com/next-theme/hexo-generator-searchdb	
local_search:
  enable: true
  # If auto, trigger search by changing input.
  # If manual, trigger search by pressing enter key or search button.
  trigger: auto
  # Show top n results per article, show all results by setting to -1
  top_n_per_article: 1
  # Unescape html strings to the readable one.
  unescape: false
  # Preload the search data when the page loads.
  preload: false


#安装sitemap插件
#npm install hexo-generator-sitemap --save
#npm install hexo-generator-baidu-sitemap --save
# 自动生成sitemap
sitemap:
  path: sitemap.xml
  
#导航栏在左侧、中间或者右侧
sidebar:
  # Sidebar Position.
  position: left  

#配置社交信息
social:
  GitHub: https://github.com/cnwangk || fab fa-github
  E-Mail: dywangk@gmail.com || fa fa-envelope

#配置阅读全文效果
#https://github.com/ashisherc/hexo-auto-excerpt
auto_excerpt: 
  enable: true
  length: 100  

#你主打的写作平台（比如公众号）
follow_me:
  WeChat: /images/wechat_channel.jpg || fab fa-weixin	#设置公众号二维码，后台下载自己的二维码
  #RSS: /atom.xml || fa fa-rss							#订阅，需要下载插件（个人感觉很鸡肋）

#配置代码高亮显示（默认是github浅色）
codeblock:
  # Code Highlight theme
  # Available value: 
  # https://github.com/chriskempson/tomorrow-theme
  #highlight_theme: night eighties
  # All available themes: https://theme-next.js.org/highlight/
  theme:
    #light: default
    light: atom-one-dark
    dark: stackoverflow-dark  
    
# Baidu Analytics  #百度站点分析
# See: https://tongji.baidu.com
baidu_analytics: #注册账号建立分析站点生成的ID（一串字符串）

#在Next主题配置leancloud的应用凭证，注意在hexo中也要配置leancloud
leancloud_visitors:
  enable: true
  app_id: #<app_id>
  app_key: #<app_key>
  security: false
```

更多配置说明，请参考Next主题文档介绍：

> [https://theme-next.iissnan.com/theme-settings.html](https://theme-next.iissnan.com/theme-settings.html)
>
> [https://theme-next.js.org/](https://theme-next.js.org/)



## 四	发布至github pages

14. 发布至github pages

    **前提**：已经配置`git`环境（本地生成ssh公钥，然后配置到github）

    如果你还没自己的github账号，也没配置git环境，可以参考我的历史博客：**git推送项目到github并使用gitee做镜像仓库**
    
    > [https://cnwangk.github.io/2022/02/16/github%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B%E4%BD%BF%E7%94%A8gitee%E5%81%9A%E9%95%9C%E5%83%8F%E4%BB%93%E5%BA%93/](https://cnwangk.github.io/2022/02/16/github%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B%E4%BD%BF%E7%94%A8gitee%E5%81%9A%E9%95%9C%E5%83%8F%E4%BB%93%E5%BA%93/)
    
    也可以配置deploy一键发布，需要配置github私人令牌token。
    
    个人推荐使用`cp`命令将public目录下生成的静态文件复制到你的repo（仓库），然后提交到远程仓库，这样操作更灵活一点。
    
    **如下为提交至远程仓库详细步骤**：

```bash
mkdir github # 1. 创建github目录，用于存放（检出）自己的远程仓库
git clone git@github.com:yourUserName/yourUserName.github.io.git # 2. 克隆远程仓库
cd yourUserName.github.io		# 3. 切换到仓库
git branch gh-pages 			# 4. 创建分支gh-pages
git remote add origin git@github.com:yourUserName/userName.github.io.git # 5. 连接远程仓库，已连接会提示exists
git add --all					# 6. 暂存所有有文件
git commit -am "初始化提交"		# 7. 初始化提交所有文件	
git push git@github.com:yourUserName/yourUserName.github.io.git # 8. 推送至远程仓库
```

做完上面提交操作，还需要给github仓库配置github pages服务。

**github pages的配置页面**：

> [https://github.com/cnwangk/test/settings/pages](https://github.com/cnwangk/test/settings/pages)

**我测试配置了一个仓库**：2022最新版github pages配置界面

**注意**：仓库必须是公开的（public）、然后仓库命令可以命令为用户名加github.io。

默认进入一个设置好的**gh-pages**分支的仓库这样显示内容的：将gh-pages设置为默认仓库。

**Custom domain**：配置域名，比如userName.github.io之外的域名。

![](https://img-blog.csdnimg.cn/img_convert/5869739fcaf91e45e689fafd53ee9b65.png)

15.访问验证博客

```bash
https://yourUserName.github.io
```

可以访问我搭建好的示例：

> [https://cnwangk.github.io/](https://cnwangk.github.io/)



## 五	hexo帮助命令

16. 进入blog目录（cmd命令窗口）

```bash
cd blog
```

17. 执行帮助命令

​	对使用比较有帮助的命令，根据个人实际使用经验，做了中文注释。

```bash
D:\hexo\blog>hexo --h							#查看帮助命令，使用Next主题
INFO  Validating config
INFO  ==================================
  ███╗   ██╗███████╗██╗  ██╗████████╗
  ████╗  ██║██╔════╝╚██╗██╔╝╚══██╔══╝
  ██╔██╗ ██║█████╗   ╚███╔╝    ██║
  ██║╚██╗██║██╔══╝   ██╔██╗    ██║
  ██║ ╚████║███████╗██╔╝ ██╗   ██║
  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝
========================================
NexT version 8.10.1 							#使用Next主题版本
Documentation: https://theme-next.js.org
========================================
Usage: hexo <command>

Commands:  # 命令
  clean       Remove generated files and cache. # 移除文件和缓存
  config      Get or set configurations. 		# 获取和设置配置
  deploy      Deploy your website. 				# 发布到你的网站
  generate    Generate static files.			# 生成静态文件
  help        Get help on a command. 			# 获取帮助命令
  init        Create a new Hexo folder.			# 初始化，创建一个新的hexo目录
  lc-counter  hexo-leancloud-counter-security	# 配置阅读数需要下载插件
  list        List the information of the site	#站点列表信息
  migrate     Migrate your site from other system to Hexo.	
  new         Create a new post.				#新建一个md（markdown）文件
  publish     Moves a draft post from _drafts to _posts folder.
  render      Render files with renderer plugins.
  server      Start the server.					#启动hexo服务
  version     Display version information.		#查看hexo版本

Global Options:
  --config  Specify config file instead of using _config.yml	#配置全局_config.yml文件
  --cwd     Specify the CWD
  --debug   Display all verbose messages in the terminal		#开启debug模式
  --draft   Display draft posts									
  --safe    Disable all plugins and scripts						#禁用所有插件
  --silent  Hide output on console

For more help, you can use 'hexo help [command]' for the detailed information
or you can check the docs: http://hexo.io/docs/					#hexo官方文档
https://hexo.io/zh-cn/docs/										#hexo中文文档
```



## 六	个人配置示例效果

### 01	首页

![](https://img-blog.csdnimg.cn/img_convert/992e8b5de0023ff946655392f9176e62.png)

### 02 	标签页

![](https://img-blog.csdnimg.cn/img_convert/7f17c4fe9186828b8239a911d72021bf.png)

### 03	文章分类

![](https://img-blog.csdnimg.cn/img_convert/df9c83cdc16e7c427653c3ca2a084294.png)

### 04	本地搜索

![](https://img-blog.csdnimg.cn/img_convert/bde813e135985e959d1828ff40e1c108.png)

# 莫问收获，但问耕耘

> 养得胸中一种恬静，方得始终。

以上就是本文的全部内容，希望能对你的工作与学习有所帮助。感觉写的好，就拿出你的一键三连。在公众号上更新的可能要快一点，目前还在完善中。**能看到这里的，都是帅哥靓妹**。如果感觉总结的不到位，也希望能留下您宝贵的意见，我会在文章中进行调整优化。

![](https://img-blog.csdnimg.cn/img_convert/9274af9e14216005237b8c9698286908.png)

原创不易，转载也请标明出处和作者，尊重原创。不定期上传到github。

**tips**：使用hexo搭建的静态博客也会定期更新维护。


