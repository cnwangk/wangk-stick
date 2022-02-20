# 前言

看到这篇文章的大佬，我默认大家都会配置git，已经配置好ssh公钥。

此时你看到的这篇文章就是基于markdown工具（VSCode，Typora）编写的。

PicGo作为图床转换工具，并配合gitee作为图片服务器（仓库）。



个人设置找到私人令牌（配置图床时需要）
https://gitee.com/profile/personal_access_tokens



# 正文



此时你看到的这篇文章就是基于markdown工具（VSCode，Typora）编写的。

PicGo作为图床转换工具，并配合gitee作为图片服务器（仓库）。

## 一、设置gitee私人令牌

1、设置gitee私人令牌，**后续配置gitee图床是需要填写token**。

2、私人令牌描述：配置图床仓库，方便自己阅读查找

3、令牌权限，根据个人需求勾选

4、**提交设置，生成令牌**。如果忘记也没事，重新生成即可。

![](https://gitee.com/dywangk/img/raw/master/images/gitee%E8%AE%BE%E7%BD%AE%E7%A7%81%E4%BA%BA%E4%BB%A4%E7%89%8C.png)



## 二、PicGo图床

### 1、下载

下载地址：[https://github.com/Molunerfinn/PicGo](https://github.com/Molunerfinn/PicGo)

![](https://gitee.com/dywangk/img/raw/master/images/PicGo%E7%89%88%E6%9C%AC.png)



### 2、安装

2.1、安装就不细讲，基本上下一步下一步。友情提示：不要点太快，需要自己选择路径。

### 3、设置图床

以下展示gitee图床以及github图床配置界面。

#### 3.1、PicGo配置gitee图床仓库 

**注意：*号代表必填项，配置repo对应仓库名，token为之前配置的gitee私人令牌**。

默认也会有提示如何配置。

![](https://gitee.com/dywangk/img/raw/master/images/PicGo%E9%85%8D%E7%BD%AEgitee%E5%9B%BE%E5%BA%8A%E4%BB%93%E5%BA%93.png)



#### 3.2、github图床

**注意**：输入框中的灰色字体就是提示，根据提示配置参数。

![](https://gitee.com/dywangk/img/raw/master/images/PicGo%E9%85%8D%E7%BD%AEGitHub%E5%9B%BE%E5%BA%8A.png)



#### 3.3、插件设置

![](https://gitee.com/dywangk/img/raw/master/images/PicGo%E6%8F%92%E4%BB%B6%E8%AE%BE%E7%BD%AE.png)



#### 3.4、上传图片

![](https://gitee.com/dywangk/img/raw/master/images/PicGo%E4%B8%8A%E4%BC%A0%E5%8C%BA.png)



#### 3.5、PicGo相册

查看到上传的图片

![](https://gitee.com/dywangk/img/raw/master/images/PicGo%E7%9B%B8%E5%86%8C.png)



生成链接，可以直接访问（**前提：是配置好了gitee仓库（公开的呦，不然无法访问）**）

![](https://gitee.com/dywangk/img/raw/master/images/PicGo%E7%94%9F%E6%88%90%E5%9B%BE%E7%89%87%E9%93%BE%E6%8E%A5%E6%8C%87%E5%90%91%E5%9B%BE%E5%BA%8A%E4%BB%93%E5%BA%93%E5%9C%B0%E5%9D%80.png)









## 三、Typora配置PicGo

### 1、typora配置图床工具，验证上传

![](https://gitee.com/dywangk/img/raw/master/images/typora%E9%85%8D%E7%BD%AE%E5%9B%BE%E5%BA%8A.png)



## 四、VSCode配置gitee插件

### 1、VSCode配置gitee插件

![](https://gitee.com/dywangk/img/raw/master/images/VSCode%E9%85%8D%E7%BD%AEgitee%E6%8F%92%E4%BB%B6.png)



## 五、白嫖gitee pages服务（题外话）

### 1、gitee pages服务

注意：使用git提交过后，在你配置的仓库需要更新服务才会生效呦！

![](https://gitee.com/dywangk/img/raw/master/images/%E7%99%BD%E5%AB%96gitee_pages%E6%9C%8D%E5%8A%A1.png)



### 2、示例

个人配置的简单静态页面：https://dywangk.gitee.io/sky/影视神曲.html



![](https://gitee.com/dywangk/img/raw/master/images/%E4%BD%BF%E7%94%A8gitee_pages%E4%BF%9D%E7%95%99%E4%B9%8B%E5%89%8D%E8%99%BE%E7%B1%B3%E9%9F%B3%E4%B9%90%E7%9A%84%E6%AD%8C%E5%8D%95.png)





<H3 align=center><a href="https://blog.csdn.net/Tolove_dream">by 龙腾万里sky 原创不易，白嫖有瘾</a></H3>