参考gitee官方文档：https://gitee.com/help/articles/4114#article-header0

参考廖雪峰git教程：https://www.liaoxuefeng.com/wiki/896043488029600

推荐一本书籍：Git版本控制管理（第2版）

此处只是复制了一些个人认为为常用的命令。

# 大纲

以前的使用经验
git的部署：Git-2.31.1-64-bit.exe
git bash：命令窗口的使用

生成ssh并在github或者gitee上验证：
```powershell
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```
```powershell
git init #初始化仓库
git clone  #获取仓库，克隆仓库
git add "file"  #添加文件到指定仓库
git commit -m "1.0.1" #提交
git push 仓库地址  #推送至服务器
```



测试



<img src="https://gitee.com/dywangk/img/raw/master/images/IMG_20211215_001451.jpg" style="zoom:20%;" />



<img src="https://gitee.com/dywangk/img/raw/master/images/MySQL.png" style="zoom:50%;" />

## 一、初次运行 Git 前的配置

Git 配置 git config git 命令
在新的系统上，我们一般都需要先配置下自己的 Git 工作环境。配置工作只需一次，以后升级时还会沿用现在的配置。当然，如果需要，你随时可以用相同的命令修改已有的配置。

Git 提供了一个叫做 git config 的工具（译注：实际是 git-config 命令，只不过可以通过 git 加一个名字来呼叫此命令。），专门用来配置或读取相应的工作环境变量。而正是由这些环境变量，决定了 Git 在各个环节的具体工作方式和行为。这些变量可以存放在以下三个不同的地方：

/etc/gitconfig 文件：系统中对所有用户都普遍适用的配置。
若使用 git config 时用 --system 选项，读写的就是这个文件。
~/.gitconfig 文件：用户目录下的配置文件只适用于该用户。
若使用 git config 时用 --global 选项，读写的就是这个文件。
当前仓库的 Git 目录中的配置文件（也就是工作目录中的 .git/config 文件）：这里的配置仅仅针对当前仓库有效。每一个级别的配置都会覆盖上层的相同配置，所以 .git/config 里的配置会覆盖 /etc/gitconfig 中的同名变量。
在 Windows 系统上，Git 会找寻用户主目录下的 .gitconfig 文件。主目录即 $HOME 变量指定的目录，一般都是 C:\Documents and Settings\$USER。此外，Git 还会尝试找寻 /etc/gitconfig 文件，只不过看当初 Git 装在什么目录，就以此作为根目录来定位。
用户信息配置
第一个要配置的是你个人的用户名称和电子邮件地址。这两条配置很重要，每次 Git 提交时都会引用这两条信息，说明是谁提交了更新，所以会随更新内容一起被永久纳入历史记录：
```powershell
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```
如果用了 --global 选项，那么更改的配置文件就是位于你用户主目录下的那个，以后你所有的仓库都会默认使用这里配置的用户信息。如果要在某个特定的仓库中使用其他名字或者电邮，只要去掉 --global 选项重新配置即可，新的设定保存在当前仓库的
 .git/config 文件里。如果你是使用 https 进行仓库的推拉，你可能需要配置客户端记住密码，避免每次都输入密码
```powershell
$ git config --global credential.helper store
```
文本编辑器配置
接下来要设置的是默认使用的文本编辑器。Git 需要你输入一些额外消息的时候，会自动调用一个外部文本编辑器给你用。默认会使用操作系统指定的默认编辑器，一般可能会是 Vi 或者 Vim。如果你有其他偏好，比如 Emacs 的话，可以重新设置：
```powershell
$ git config --global core.editor emacs
```
差异分析工具
还有一个比较常用的是，在解决合并冲突时使用哪种差异分析工具。比如要改用 vimdiff 的话：
```powershell
$ git config --global merge.tool vimdiff
```
Git 可以理解 kdiff3，tkdiff，meld，xxdiff，emerge，vimdiff，gvimdiff，ecmerge，和 opendiff 等合并工具的输出信息。当然，你也可以指定使用自己开发的工具。
查看配置信息
```powershell
#要检查已有的配置信息，可以使用 
git config --list 
```


```powershell
$ git config --list
user.name=Scott Chacon
user.email=schacon@gmail.com
color.status=auto
color.branch=auto
color.interactive=auto
color.diff=auto
```

有时候会看到重复的变量名，那就说明它们来自不同的配置文件（比如 /etc/gitconfig 和 ~/.gitconfig），不过最终 Git 实际采用的是最后一个。也可以直接查阅某个环境变量的设定，只要把特定的名字跟在后面即可，像这样：
```powershell
$ git config user.name
Scott Chacon
```



## 二、Git 仓库基础操作
git 命令
仓库基本管理
初始化一个Git仓库(以/home/gitee/test文件夹为例)

```powershell
$ cd /home/gitee/test    #进入git文件夹
$ git init               #初始化一个Git仓库
```

将文件添加到Git的暂存区
```powershell
$ git add "readme.txt"
```
注：使用git add -A或git add . 可以提交当前仓库的所有改动。

查看仓库当前文件提交状态（A：提交成功；AM：文件在添加到缓存之后又有改动）
```powershell
$ git status -s
```
从Git的暂存区提交版本到仓库，参数-m后为当次提交的备注信息
```powershell
$ git commit -m "1.0.0"
```
将本地的Git仓库信息推送上传到服务器
```powershell
$ git push https://gitee.com/***/test.git
```
查看git提交的日志
```powershell
$ git log
```
远程仓库管理
修改仓库名
一般来讲，默认情况下，在执行clone或者其他操作时，仓库名都是 origin 如果说我们想给他改改名字，比如我不喜欢origin这个名字，想改为 oschina 那么就要在仓库目录下执行命令:
```powershell
git remote rename origin oschina
```

这样 你的远程仓库名字就改成了oschina，同样，以后推送时执行的命令就不再是 git push origin master 而是 git push oschina master 拉取也是一样的

添加一个仓库
在不执行克隆操作时，如果想将一个远程仓库添加到本地的仓库中，可以执行
```powershell
git remote add origin  #仓库地址
```
注意: 1.origin是你的仓库的别名 可以随便改，但请务必不要与已有的仓库别名冲突 2. 仓库地址一般来讲支持 http/https/ssh/git协议，其他协议地址请勿添加

查看当前仓库对应的远程仓库地址
```powershell
git remote -v
```
这条命令能显示你当前仓库中已经添加了的仓库名和对应的仓库地址，通常来讲，会有两条一模一样的记录，分别是fetch和push，其中fetch是用来从远程同步 push是用来推送到远程

修改仓库对应的远程仓库地址
```powershell
git remote set-url origin 仓库地址
```



## 三、取得项目的 Git 仓库
git 命令
有两种取得 Git 项目仓库的方法。第一种是在现存的目录下，通过导入所有文件来创建新的 Git 仓库。第二种是从已有的 Git 仓库克隆出一个新的镜像仓库来。

在工作目录中初始化新仓库
要对现有的某个项目开始用 Git 管理，只需到此项目所在的目录，执行：
```powershell
$ git init
```
初始化后，在当前目录下会出现一个名为 .git 的目录，所有 Git 需要的数据和资源都存放在这个目录中。不过目前，仅仅是按照既有的结构框架初始化好了里边所有的文件和目录，但我们还没有开始跟踪管理项目中的任何一个文件。（在第九章我们会详细说明刚才创建的 .git 目录中究竟有哪些文件，以及都起些什么作用。）

如果当前目录下有几个文件想要纳入版本控制，需要先用 git add 命令告诉 Git 开始对这些文件进行跟踪，然后提交：
```powershell
$ git add *.c
$ git add README
$ git commit -m 'initial project version'
```
稍后我们再逐一解释每条命令的意思。不过现在，你已经得到了一个实际维护着若干文件的 Git 仓库。

从现有仓库克隆
如果想对某个开源项目出一份力，可以先把该项目的 Git 仓库复制一份出来，这就需要用到 git clone 命令。如果你熟悉其他的 VCS 比如 Subversion，你可能已经注意到这里使用的是 clone 而不是 checkout。这是个非常重要的差别，Git 收取的是项目历史的所有数据（每一个文件的每一个版本），服务器上有的数据克隆之后本地也都有了。实际上，即便服务器的磁盘发生故障，用任何一个克隆出来的客户端都可以重建服务器上的仓库，回到当初克隆时的状态（虽然可能会丢失某些服务器端的挂钩设置，但所有版本的数据仍旧还在）。

克隆仓库的命令格式为 git clone [url] 。比如，要克隆 Ruby 语言的 Git 代码仓库 Grit，可以用下面的命令：
```powershell
$ git clone git@gitee.com:oschina/git-osc.git
```
这会在当前目录下创建一个名为grit的目录，其中包含一个 .git 的目录，用于保存下载下来的所有版本记录，然后从中取出最新版本的文件拷贝。如果进入这个新建的 grit 目录，你会看到仓库中的所有文件已经在里边了，准备好后续的开发和使用。如果希望在克隆的时候，自己定义要新建的仓库目录名称，可以在上面的命令末尾指定新的名字：
```powershell
$ git clone git@gitee.com:oschina/git-osc.git mygrit
```
唯一的差别就是，现在新建的目录成了 mygrit，其他的都和上边的一样。

Git 支持许多数据传输协议。之前的例子使用的是 git:// 协议，不过你也可以用 http(s):// 或者 user@server:/path.git 表示的 SSH 传输协议。





## 四、如何通过 git clone 克隆仓库/项目
仓库克隆
在前面我们介绍了Git支持多种数据传输协议，有 git:// 协议、http(s):// 和 user@server:/path.git表示的 SSH 传输协议。我们可以通过这三种协议，对项目/仓库进行克隆操作。

下面，我们将以仓库 git@git.oschina.net:zxzllyj/sample-project.git 为例，对项目/仓库进行克隆。

通过HTTPS协议克隆
```powershell
git clone https://gitee.com/zxzllyj/sample-project.git
```
通过SSH协议克隆
```powershell
git clone git@gitee.com:zxzllyj/sample-project.git
```
以克隆仓库git@gitee.com:zxzllyj/sample-project.git为例(注:本处使用的是ssh地址，因为演示机已经配置好ssh公钥，故可以使用ssh地址，如果您没有配置公钥，请使用https地址)


注：虽然将仓库完整的拉取了下来，但是仅仅只会是显示默认分支，如果需要直接到指定的分支，可以在仓库地址后面加上分支名



## 五、获取git帮助
会获取本地的隐藏文件，并且在浏览器打开

```powershell
git help config
```

