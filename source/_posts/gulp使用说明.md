---
title: gulp-API文档
date: 2016-04-20 12:23:13
tags: gulp
---

## gulp.src(globs[, options])

#### globs

类型： String 或 Array

所要读取的 glob 或者包含 globs 的数组。

<!-- more -->

```javascript
gulp
  .src('client/templates/*.jade')
  .pipe(jade())
  .pipe(minify())
  .pipe(gulp.dest('build/minified_templates'))
```

<!--more-->

#### options.buffer

类型： Boolean 默认值： true

如果该项被设置为 false，那么将会以 stream 方式返回 file.contents 而不是文件 buffer 的形式。这在处理一些大文件的时候将会很有用。

**注意：**插件可能并不会实现对 stream 的支持。

#### options.read

类型： Boolean 默认值： true

如果该项被设置为 false， 那么 file.contents 会返回空值（null），也就是并不会去读取文件。

#### options.base

类型： String 默认值： 将会加在 glob 之前 (请看 glob2base)

如, 请想像一下在一个路径为 client/js/somedir 的目录中，有一个文件叫 somefile.js ：

```javascript
gulp
  .src('client/js/**/*.js') // 匹配 'client/js/somedir/somefile.js' 并且将 `base` 解析为 `client/js/`
  .pipe(minify())
  .pipe(gulp.dest('build')) // 写入 'build/somedir/somefile.js'

gulp
  .src('client/js/**/*.js', { base: 'client' })
  .pipe(minify())
  .pipe(gulp.dest('build')) // 写入 'build/js/somedir/somefile.js'
```

## gulp.dest(path[, options])

能被 pipe 进来，并且将会写文件。并且重新输出（emits）所有数据，因此你可以将它 pipe 到多个文件夹。如果某文件夹不存在，将会自动创建它。

```javascript
gulp
  .src('./client/templates/*.jade')
  .pipe(jade())
  .pipe(gulp.dest('./build/templates'))
  .pipe(minify())
  .pipe(gulp.dest('./build/minified_templates'))
```

#### path

类型： String or Function

文件将被写入的路径（输出目录）。也可以传入一个函数，在函数中返回相应路径，这个函数也可以由 vinyl 文件实例 来提供。

#### options.cwd

类型： String 默认值： process.cwd()

输出目录的 cwd 参数，只在所给的输出目录是相对路径时候有效。

#### options.mode

类型： String 默认值： 0777

八进制权限字符，用以定义所有在输出目录中所创建的目录的权限。

## gulp.task

```javascript
gulp.task(name[, deps], fn)
gulp.task('somename', function() {
  // 做一些事
});
```

#### name

任务的名字，如果你需要在命令行中运行你的某些任务，那么，请不要在名字中使用空格。

#### deps

类型： Array

一个包含任务列表的数组，这些任务会在你当前任务运行之前完成。

```javascript
gulp.task('mytask', ['array', 'of', 'task', 'names'], function() {
  // 做一些事
})
```

注意： 你的任务是否在这些前置依赖的任务完成之前运行了？请一定要确保你所依赖的任务列表中的任务都使用了正确的异步执行方式：使用一个 callback，或者返回一个 promise 或 stream。

#### fn

该函数定义任务所要执行的一些操作。通常来说，它会是这种形式：gulp.src().pipe(someplugin())。

异步任务支持

接受一个 callback

返回一个 stream

返回一个 promise

## gulp.watch(glob [, opts], tasks) 或 gulp.watch(glob [, opts, cb])

监视文件，并且可以在文件发生改动时候做一些事情。它总会返回一个 EventEmitter 来发射（emit） change 事件。

#### glob

类型： String or Array

一个 glob 字符串，或者一个包含多个 glob 字符串的数组，用来指定具体监控哪些文件的变动。

#### opts

类型： Object

传给 gaze 的参数。

#### tasks

类型： Array

需要在文件变动后执行的一个或者多个通过 gulp.task() 创建的 task 的名字，

```javascript
var watcher = gulp.watch('js/**/*.js', ['uglify', 'reload'])
watcher.on('change', function(event) {
  console.log(
    'File ' + event.path + ' was ' + event.type + ', running tasks...'
  )
})
```

## gulp.watch(glob[, opts, cb])

#### glob

类型： String or Array

一个 glob 字符串，或者一个包含多个 glob 字符串的数组，用来指定具体监控哪些文件的变动。

#### opts

类型： Object

传给 gaze 的参数。

#### cb(event)

类型： Function

每次变动需要执行的 callback。

```javascript
gulp.task('watch', function() {
  gulp.watch('js/*.js', function(event) {
    console.log(
      'File ' + event.path + ' was ' + event.type + ', running tasks...'
    )
  })
})
```

callback 会被传入一个名为 event 的对象。这个对象描述了所监控到的变动：

#### event.type

类型： String

发生的变动的类型：added, changed 或者 deleted。

#### event.path

类型： String

触发了该事件的文件的路径。
