---
title: gulp-常用插件列表
date: 2016-06-15 12:23:13
tags: gulp
---

## 安装说明

    $ npm install --save-dev gulp-autoprefixer（插件名称，可以接多个，空格）

<!-- more -->

## gulp-autoprefixer(自动补 hack)

```javascript
var gulp = require('gulp')
var autoprefixer = require('gulp-autoprefixer')

gulp.task('default', function() {
  return gulp
    .src('src/app.css')
    .pipe(
      autoprefixer({
        browsers: ['last 2 versions'], //兼容浏览器的最低版本
        cascade: false //
      })
    )
    .pipe(gulp.dest('dist'))
})
```

<!--more-->

## gulp-uglify（压缩）

```javascript
var uglify = require('gulp-uglify')

gulp.task('compress', function() {
  return gulp
    .src('lib/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('dist'))
})
```

参数说明：

- output 输出格式
- compress 是否压缩（boolean）
- mangle 设为 false 则不压缩名称
- preserveComments 输出的注释 默认无

      	- all 输出所有注释
      	- license
      	- function
      	- some (deprecated)

## gulp-sourcemaps（生成 source map）

```javascript
var gulp = require('gulp')
var sourcemaps = require('gulp-sourcemaps')
var autoprefixer = require('gulp-autoprefixer')
var concat = require('gulp-concat')

gulp.task('default', function() {
  return gulp
    .src('src/**/*.css')
    .pipe(sourcemaps.init())
    .pipe(autoprefixer())
    .pipe(concat('all.css'))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('dist'))
})
```

所有在 sourcemaps.init()和 sourcemaps.write() 之间的插件必须支持 gulp-sourcemaps。

Init 参数：

- loadMaps（设为 true 加载存在的 map）

```javascript
var gulp = require('gulp')
var plugin1 = require('gulp-plugin1')
var plugin2 = require('gulp-plugin2')
var sourcemaps = require('gulp-sourcemaps')

gulp.task('javascript', function() {
  gulp
    .src('src/**/*.js')
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(plugin1())
    .pipe(plugin2())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('dist'))
})
```

- identityMap（boolean）

debug（设为 true 输出 debug 信息）

## gulp-sass(编译 sass)

```javascript
'use strict'

var gulp = require('gulp')
var sass = require('gulp-sass')

gulp.task('sass', function() {
  return gulp
    .src('./sass/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./css'))
})

gulp.task('sass:watch', function() {
  gulp.watch('./sass/**/*.scss', ['sass'])
})
```

参数配置：

```javascript
gulp.task('sass', function() {
  return gulp
    .src('./sass/**/*.scss')
    .pipe(sass({ outputStyle: 'compressed' }).on('error', sass.logError))
    .pipe(gulp.dest('./css'))
})
```

outputStyle 可设置输出形式。

## gulp-less(编译 less)

```javascript
var less = require('gulp-less')

gulp.task('less', function() {
  return gulp
    .src('./src/less/**/*.less', {
      base: './src/'
    })
    .pipe(less())
    .pipe(gulp.dest('./dist/'))
})
```

less 参数说明：

- paths: 用于@ import 指令的路径数组集

```javascript
var less = require('gulp-less')
var path = require('path')

gulp.task('less', function() {
  return gulp
    .src('./less/**/*.less')
    .pipe(
      less({
        paths: [path.join(__dirname, 'less', 'includes')]
      })
    )
    .pipe(gulp.dest('./public/css'))
})
```

- plugins: less 插件的数组

```javascript
var LessAutoprefix = require('less-plugin-autoprefix')
var autoprefix = new LessAutoprefix({ browsers: ['last 2 versions'] })

return gulp
  .src('./less/**/*.less')
  .pipe(
    less({
      plugins: [autoprefix]
    })
  )
  .pipe(gulp.dest('./public/css'))
```

## gulp-cssnano（css 压缩）

```javascript
var gulp = require('gulp')
var cssnano = require('gulp-cssnano')

gulp.task('default', function() {
  return gulp
    .src('./main.css')
    .pipe(cssnano())
    .pipe(gulp.dest('./out'))
})
```

## gulp-postcss（多个插件串起来的接口）

```javascript
var postcss = require('gulp-postcss')
var gulp = require('gulp')
var autoprefixer = require('autoprefixer')
var cssnano = require('cssnano')

gulp.task('css', function() {
  var processors = [autoprefixer({ browsers: ['last 1 version'] }), cssnano()]
  return gulp
    .src('./src/*.css')
    .pipe(postcss(processors))
    .pipe(gulp.dest('./dest'))
})
```

备注：只有适用于 postcss 的插件才能组合，详细参照官网说明。
[https://github.com/postcss/postcss](https://github.com/postcss/postcss '可用插件说明')

## gulp-requirejs-optimize（打包插件）

```javascript
var gulp = require('gulp')
var requirejsOptimize = require('gulp-requirejs-optimize')

gulp.task('scripts', function() {
  return gulp
    .src('src/main.js')
    .pipe(requirejsOptimize())
    .pipe(gulp.dest('dist'))
})
```

参数说明：

```javascript
var gulp = require('gulp')
var requirejsOptimize = require('gulp-requirejs-optimize')

gulp.task('scripts', function() {
  return gulp
    .src('src/main.js')
    .pipe(
      requirejsOptimize({
        optimize: 'none',
        insertRequire: ['foo/bar/bop']
      })
    )
    .pipe(gulp.dest('dist'))
})
```

多个参数传 fun：

```javascript
var gulp = require('gulp')
var requirejsOptimize = require('gulp-requirejs-optimize')

gulp.task('scripts', function() {
  return gulp
    .src('src/modules/*.js')
    .pipe(
      requirejsOptimize(function(file) {
        return {
          name: '../vendor/bower/almond/almond',
          optimize: 'none',
          useStrict: true,
          baseUrl: 'path/to/base',
          include: 'subdir/' + file.relative
        }
      })
    )
    .pipe(gulp.dest('dist'))
})
```

## gulp-handlebars（handlebars 模板编译）

可以通过 package.json 定义使用的版本。

```javascript
//package.json
{
  "devDependencies": {
    "handlebars": "^1.3.0"
  }
}

var handlebars = require('gulp-handlebars');
var defineModule = require('gulp-define-module');

gulp.task('templates', function(){
  gulp.src(['templates/*.hbs'])
    .pipe(handlebars())
    .pipe(defineModule('cmd'))
    .pipe(gulp.dest('build/templates/'));
});
```

## gulp-define-module（模块类型）

创建一个模块：

    {
      start: function() {},
      end: function() {},
      version: "1.0"
    }

`defineModule(type, [options])`参数说明：

Type: String 类型

默认: bare

- CommonJS/Node (defineModule('commonjs') or defineModule('node'))

- cmd (defineModule('amd'))

- Hybrid (defineModule('hybrid'))

- plain defineModule('plain')

其他参数举例：

```javascript
defineModule('amd', {
  require: {
    Hogan: 'hogan'
  },
  name: function(filePath) {
    return filePath.split(process.cwd() + '/')[1].replace('.js', '')
  }
})
```

## gulp-sequence（任务合并排序）

假设存在 a、b、c、d、d、e、f 六个任务：

```javascript
//先运行ab，在运行c，在运行de，在运行f
gulp.task('sequence-1', gulpSequence(['a', 'b'], 'c', ['d', 'e'], 'f'))

// usage 2
gulp.task('sequence-2', function(cb) {
  gulpSequence(['a', 'b'], 'c', ['d', 'e'], 'f', cb)
})

// usage 3
gulp.task('sequence-3', function(cb) {
  gulpSequence(['a', 'b'], 'c', ['d', 'e'], 'f')(cb)
})

gulp.task(
  'gulp-sequence',
  gulpSequence('sequence-1', 'sequence-2', 'sequence-3')
)
```

API 参数：

gulpSequence('subtask1', 'subtask2',...[, callback])

gulpSequence.use(gulp) 返回一个存在 gulp 的 gulpSequence 方法，如果有一些任务不存在的错误，这个将会解决它。

## gulp-clean（删除地址）

```javascript
var gulp = require('gulp')
var clean = require('gulp-clean')

gulp.task('default', function() {
  return gulp.src('app/tmp', { read: false }).pipe(clean())
})
```

参数 read:false 防止 gulp 从文件中读取内容并且让任务更快。如果你在 cleaning 后需要使用这个文件，那么不能设置此属性。

```javascript
var gulp = require('gulp')
var clean = require('gulp-clean')

gulp.task('default', function() {
  return gulp
    .src('app/tmp/index.js')
    .pipe(clean({ force: true }))
    .pipe(gulp.dest('dist'))
})
```

当前工作目录以外的安全文件和文件夹可以删除只有将 force 选项设置为 true。

## gulp-ftp （上传文件）

```javascript
var gulp = require('gulp')
var gutil = require('gulp-util')
var ftp = require('gulp-ftp')

gulp.task('default', function() {
  return gulp
    .src('src/*')
    .pipe(
      ftp({
        host: 'website.com',
        user: 'johndoe',
        pass: '1234'
      })
    )
    .pipe(gutil.noop())
})
```

参数说明：

- host 主机 ip 地址（必填项）
- port 端口号
- user 默认'anonymous'
- pass 默认 '@anonymous'
- remotePath 默认'/'
