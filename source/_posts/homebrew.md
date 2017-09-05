title: Homebrew基础命令
date: 2017-09-05 16:06:08
tags: [homebrew,包管理]
---
> brew 又叫Homebrew，是Mac OSX上的软件包管理工具，能在Mac中方便的安装软件或者卸载软件。

# 安装brew
```bash
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
```
# 使用brew安装软件
```bash
brew install appName
```
# 使用brew卸载软件
```bash
brew uninstall appName
```
# 使用brew查询软件
> 有时候，你不知道你安装的软件的名字， 那么你需要先搜索下, 查到包的名字。

```bash
brew search /wge*/
```

`/wge*/`是个正则表达式， 需要包含在/中

# 其他brew命令

```js
// 列出已安装的软件
brew list           
//更新brew
brew update     
// 用浏览器打开brew的官方网站
brew home       
// 显示软件信息
brew info appName       
// 显示包依赖
brew deps appName
// 列出过时的软件包（已安装但不是最新版本）
brew outdated  
// 更新过时的软件包（全部或指定）
brew upgrade
brew upgrade wget     
```

# 定制自己的软件包

- 首先找到待安装软件的源码下载地址

```bash
http://foo.com/bar-1.0.tgz
```

- 建立自己的formula

```bash
brew create http://foo.com/bar-1.0.tgz
```
- 编辑formula，上一步建立成功后，Homebrew会自动打开新建的formula进行编辑，也可用如下命令打开formula进行编辑。

```bash
brew edit bar
```

Homebrew自动建立的formula已经包含了基本的configure和make install命令，对于大部分软件，不需要进行修改，退出编辑即可。

- 输入以下命令安装自定义的软件包

```bash
brew install bar
```