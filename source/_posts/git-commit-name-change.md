title: git用户名莫名其妙变化及挽救措施
date: 2016-04-22 09:59:00
categories: git
tags: [git]
---
昨晚提交了一次commit并推到github的远程仓库后，突然发现最近的commit提交都没有记录到contributions里，而且commit记录中我的头像无法正常显示。  
<!-- more -->
查了一下查到了github的帮助文档：
* [Why are my contributions not showing up on my profile?](https://help.github.com/articles/why-are-my-contributions-not-showing-up-on-my-profile/)
* [Changing author info](https://help.github.com/articles/changing-author-info/)

英语不好的还可以看看这篇博客：[为什么Github没有记录你的Contributions](https://segmentfault.com/a/1190000004318632)  

在本地仓库目录下`git log`查看了历史记录，发现出问题的那几次的用户名变成了windows的用户名，邮箱也是用户名。  
按照帮助文档修复了commit作者信息，并提交了github的远程仓库后，终于正常了。  

最后，在git bash中设定好git配置文件的用户信息：
```shell
git config --global user.name "CodeDaraW"
git config --global user.email "CodeDaraW@gmail.com"
```
一切就正常了。
