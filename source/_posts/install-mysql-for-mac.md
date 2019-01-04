---
title: 如何在mac上使用homebrew安装mysql
date: 2016-10-09 11:43:49
tags: mysql
---

- 安装命令

```
brew install mysql
```

<!-- more -->

- 安装完成之后，本地命令行输入 mysql 命令，发现无此命令

```
command not found
```

- 首先，检查是否是安装了

重新执行一遍

```
brew install mysql
```

命令行提示：

```
Warning: mysql-5.7.10 already installed, it's just not linked
```

- 然后网上查找解决方法，最后解决方法是执行：

```
brew link --overwrite mysql
```

- 但是执行，却报错

```
Linking /usr/local/Cellar/mysql/5.7.10...
Error: Could not symlink share/man/man8/mysqld.8
/usr/local/share/man/man8 is not writable.
```

- 又在网上各种查找解决方法，最后本地实验以下语句执行成功

```
sudo chown -R 'yin' /usr/local
注意： yin是你电脑的用户名
```

- 解决了问题后，重新执行：

```
brew link --overwrite mysql
```

提示：

```
Linking /usr/local/Cellar/mysql/5.7.10... 92 symlinks created
```

心想着，这下算是成功了吧。重新执行:

```
mysql -u root -p
```

但是又报错：

```
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
```

依次执行：

```
unset TMPDIR
bash mysql_install_db --verbose --user=root --basedir="$(brew --prefix mysql)"--datadir=/usr/local/var/mysql --tmpdir=/tmp
```

接下来启动 mysql：

```
bash mysql.server start
```

到这里，mysql 的安装就结束了~
