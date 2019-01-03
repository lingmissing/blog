---
title: gulp-高手装X进阶篇
date: 2016-04-15 12:23:13
tags: gulp
---

### gulp 的【常用】各种插件包介绍 - 不分前后 ###

|  插件包名                |     说明                      |
|-------------------------|------------------------------|
| fs                      | 读取一个 jsons 文件            |
| gulp-less               | less 编译                     |
| gulp-sass               | scss 编译                     |
| gulp-postcss            | css 插件处理器                 |
| autoprefixer            | 解析 css 添加前缀 css 规则      |
| cssnano                 | css 优化                      |
| gulp-uglify             | 压缩文件                      |
| gulp-sourcemaps         | 生成 source map 文件          |
| gulp-handlebars         | 编译模板成 js                  |
| gulp-define-module      | 编译 handlebars 模板的类型     |
| gulp-clean              | 删除文件                      |
| gulp-notify             | 消息提示                      |
| minimist                | 命令行参数解析                 |
| gulp-requirejs-optimize | AMD 模块 打包                 |
| gulp-sequence           | gulp 任务合并                 |
| gulp-ftp                | 上传文件                      |

<!--more-->

### fs 使用方法 ###
```javascript
var fs = require('fs');

// 基础配置信息获取
var pkg = JSON.parse(fs.readFileSync('./package.json', 'utf8'));

gulp.task('default', function () {
	console.log(pkg);
	console.log(pkg.name);
});

// cmd 命令行输入：gulp
```

### gulp-less 使用方法 ###
```javascript
var less = require('gulp-less');

gulp.task('less', function () {
	return gulp.src('./src/less/**/*.less', {
            base: './src/'
        })
        .pipe(less())
        .pipe(gulp.dest('./dist/'))
});

// cmd 命令行输入：gulp less
```

### gulp-sass 使用方法 ###
```javascript
var sass = require('gulp-sass');

gulp.task('sass', function () {
	return gulp.src('./src/scss/**/*.scss', {
            base: './src/'
        })
        .pipe(sass())
        .pipe(gulp.dest('./dist/'))
});

// cmd 命令行输入：gulp less
```

### gulp-postcss 、autoprefixer、cssnano 使用方法 ###
```javascript
var postcss      = require('gulp-postcss');
var autoprefixer = require('autoprefixer');
var cssnano      = require('cssnano');
var processors   = [
   autoprefixer({
       browsers: ['last 2 versions', 'Android >= 4.0'] // 指定浏览器需要兼容的版本
   }),
   cssnano()
];

gulp.task('css', function () {
    return gulp.src('./dist/**/*.css')
        .pipe(postcss(processors))
        .pipe(gulp.dest('./dist/'));
});

// cmd 命令行输入：gulp css
```

### gulp-uglify 使用方法 ###
```javascript
var uglify = require('gulp-uglify');

gulp.task('js', function() {
    return gulp.src('./src/**/*.js')
        .pipe(uglify())
        .pipe(gulp.dest('./dist/'));
});

// cmd 命令行输入：gulp js
```

### gulp-sourcemaps 使用方法 ###
```javascript
var uglify     = require('gulp-uglify');
var sourcemaps = require('gulp-sourcemaps');

gulp.task('js-map', function() {
    return gulp.src('./src/**/*.js')
        .pipe(sourcemaps.init())
        .pipe(uglify())
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest('./dist/'));
});

// cmd 命令行输入：gulp js-map
```

### gulp-handlebars、gulp-define-module 使用方法 ###
```javascript
var handlebars   = require('gulp-handlebars');
var defineModule = require('gulp-define-module');

gulp.task('tpl', function() {
    return gulp.src('./src/**/*.js')
        .pipe(handlebars())
        .pipe(defineModule('amd'))
        .pipe(gulp.dest('./src/'));
});

// cmd 命令行输入：gulp tpl
```

### gulp-clean、gulp-notify 使用方法 ###
```javascript
var clean  = require('gulp-clean');
var notify = require('gulp-notify');

gulp.task('clean-css', function() {
    return gulp.src('./dist/**/*.css')
        .pipe(clean())
        .pipe(notify({
        	    message: 'clean-css task complete'
        }));
});

// cmd 命令行输入：gulp clean-css
```

### minimist 使用方法 ###
```javascript
var minimist     = require('minimist');
var knownOptions = {
    string: 'nav',
    default: {
        nav: process.env.NODE_ENV || '',
        env: process.env.NODE_ENV || ''
    }
};

var nav_string = minimist(process.argv.slice(2), knownOptions);
gulp.task('minimist', function() {
    console.log(nav)
    console.log(nav.nav);
    console.log(nav.env);
});

// cmd 命令行输入：gulp minimist --nav aaaaaaa
// 结果：{ _: [], nav: 'aaaaaaa' }

// cmd 命令行输入：gulp minimist --env bbbbbbb
// 结果：{ _: [], env: 'bbbbbbb' }

// cmd 命令行输入：gulp minimist --nav aaaaaaa --env bbbbbbb
// 结果：{ _: [], nav: 'aaaaaaa', env: 'bbbbbbb' }
```

### 待续! 待续! 待续! ###


