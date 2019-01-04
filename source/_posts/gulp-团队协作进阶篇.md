---
title: gulp-团队协作进阶篇
date: 2016-04-13 17:27:02
tags: gulp
---

### 第一步

当前项目根目录新建文件 package.json 复制粘贴下面的代码

<!-- more -->

```
{
  "name": "application-name",
  "version": "0.0.1",
  "devDependencies": {
    "gulp": "^3.9.1",
    "gulp-sass": "^2.2.0",
    "gulp-uglify": "^1.5.3"
  }
}
```

命令行输入

<!--more-->

    npm install

会自动下载依赖的组件包（ gulp ）

解释这个 json：
1、name 是指你的项目名
2、version 当前项目的版本号
3、devDependencies 依赖的组件包

可以考虑在 json 中加入对应项目的仓库地址，方便其他伙伴查看下载

```
"repository": {
  "type": "git",
  "url": "git@github.com:orzhtml/orzhtml.github.com.git"
},
```

### 第二步

在项目的根目录新建一个说明文档 README.md 复制粘贴下面的代码

```
## TODO
//这里写接下来需要做的事情

## gulp 命令说明
gulp sass    -编译sass
gulp uglify  -压缩js
gulp default -默认任务并监听文件的变化自动执行任务

## 项目目录说明：
|   git 过滤  |  gulp 配置  |    包 配置    |
| ---------- | ----------- | ------------ |
| .gitingore | gulpfile.js | package.json |

|  js源文件目录  | scss源文件目录 | 编译后的js目录 | 编译后的scss目录|
| ------------ | ------------ | ------------ | ------------  |
|  js-build    |     scss     |      js      |    css         |
```

就这样吧，去跟小伙伴愉快的合作开发吧
