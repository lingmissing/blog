---
title: gulp-前端构建入门
date: 2016-04-10 11:33:08
tags: gulp
---

### 安装 gulp ###
在 cmd 中输入命令全局安装 gulp

    sudo npm install -g gulp 

安装完成后再输入检查是否安装成功

     gulp -v

接下来，将 gulp 安装到项目本地，作为项目的开发依赖（devDependencies）安装

     npm install --save-dev gulp

在项目根目录下创建一个名为 gulpfile.js 的文件     

```javascript
var gulp = require('gulp');

gulp.task('default', function() {
  // 将你的默认的任务代码放在这
});
```
<!--more-->
### 安装依赖 ###
现在，我们需要执行哪些任务，安装对应依赖的组件包。

1、编译 sass（或者 less）文件
2、压缩 js 文件
3、监听文件变更

    npm install --save-dev gulp-sass gulp-uglify

（ 注意： npm install --save-dev (依赖包名) 下载的是最新版本的 ）

    

### 修改 gulpfile.js 文件 ###
gulp 只有5个方法：task，run，watch，src，dest，粘贴下面的代码到 gulpfile.js 里

```javascript
// 引入 gulp
var gulp = require('gulp');

// 引入依赖的组件包
var sass = require('gulp-sass');
var uglify = require('gulp-uglify');

// 编译 sass
gulp.task('sass', function() {
    gulp.src('./scss/*.scss')
        .pipe(sass())
        .pipe(gulp.dest('./css'));
});

// 压缩 js
gulp.task('uglify', function () {
    gulp.src('./js-build/*.js')
        .pipe(uglify())
        .pipe(gulp.dest('./js'));
});

// 默认任务
gulp.task('default', function () {
    // 运行默认需要执行的任务
    gulp.run('sass', 'uglify');

    // 监听文件的变化
    gulp.watch(['./scss/*.scss', './js-build/*.js'], function () {
        // 执行文件变更后需要做的任务
        gulp.run('sass', 'uglify');
    })
});
```
![](http://orzhtml.github.io/img/temporary/QQ20160413-0.png)

1、任务的名字可以换成你想要的名字

    gulp.task('sass')

2、gulpfile.js中定义的任意任务可以单独运行，例如命令行输入 

    gulp sass

最后项目目录如下

![](http://orzhtml.github.io/img/temporary/QQ20160413-1.png)


