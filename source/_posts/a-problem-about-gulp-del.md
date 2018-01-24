title: gulp构建中del的一个小坑
date: 2016-02-12 12:55:15
categories: 前端
tags: [gulp]
---
## 前言
grunt，gulp以及webpack三个常见构建工具的对比和介绍已经很多了，这里就不再赘述。手上这个项目用了gulp进行构建，同时也是我刚刚入门学习使用gulp构建。
<!-- more -->
## 问题
在写`gulpfile.js`的task时，一开始我是这么写的：
```javascript
    gulp.task('clean', function(cb) {

        del(['typing.min.js'], cb);

    });

    gulp.task('build', ['clean'], function() {

        gulp.src('typing.js')
            .pipe(uglify())
            .pipe(rename('typing.min.js'))
            .pipe(gulp.dest(''));

    });

    gulp.task('default', ['clean', 'build']);
```
在`shell`里执行
```shell
    gulp
```
或者是
```shell
    gulp build
```
始终只进行了`clean`任务而不`build`，对着API和一些介绍gulp的文章，怎么都找不到问题所在。  

## 解决
接着搜到了一句话：
> Make sure to return the stream so that gulp knows the clean task is asynchronous and waits for it to terminate before starting the dependent one.


由于del是异步执行的，尝试在`clean`任务中返回流后就正常了：
```javascript
    gulp.task('clean', function(cb) {

        return del(['typing.min.js'], cb);

    });

```
另外在github的del项目的[issues](https://github.com/sindresorhus/del/issues/50)中看到一个哥们提供的解决方案，其中一个是返回流，另一个则是常见的解决方案：回调。

## 构建的其他方案
在学长ChiChou的技术群里，学长告诉我在这种无需大量文件操作的项目中，可以用`package.json`+`Makefile`进行构建，甚至可以连这都不用，直接在`package.json`中的scripts中写入指令，然后`npm run xxxx`执行。
