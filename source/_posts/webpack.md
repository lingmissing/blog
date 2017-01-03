---
title: webpack
date: 2016-07-08 13:44:12
tags: webpack
categories: 打包工具
---

## webpack是什么 ##

`webpack`是近期最火的一款模块加载器兼打包工具，它能把各种资源，例如`JS`（含`JSX`）、`coffee`、样式（含`less`/`sass`）、图片等都作为模块来使用和处理。

可以直接使用 `require(XXX)` 的形式来引入各模块，即使它们可能需要经过编译（比如`JSX`和`sass`）
<!-- more -->
## webpack 的优势 ##

- webpack 是以 `commonJS` 的形式来书写脚本滴，但对 `AMD`/`CMD` 的支持也很全面，方便旧项目进行代码迁移。
- 能被模块化的不仅仅是 JS 了。
- 开发便捷，能替代部分 `grunt`/`gulp` 的工作，比如打包、压缩混淆、图片转base64等。
- 扩展性强，插件机制完善，特别是支持 React 热插拔（见 `react-hot-loader` ）。

## 安装和配置 ##
### 创建一个文件夹，安装`webpack`依赖

	$ npm init
	$ npm install webpack --save-dev

### 配置 `webpack.config.js` 
```javascript
var webpack = require('webpack');
//提取多个入口文件的公共脚本部分，然后生成一个 common.js
var commonsPlugin = new webpack.optimize.CommonsChunkPlugin('common.js');
module.exports = {
    //插件项
    plugins: [commonsPlugin],
    //页面入口文件配置
    entry: {
        index : './src/js/page/index.js'
    },
    //入口文件输出配置
    output: {
        path: 'dist/js/page',
        filename: '[name].js'
    },
    module: {
        //加载器配置
        loaders: [
            { test: /\.css$/, loader: 'style-loader!css-loader' },
            { test: /\.js$/, loader: 'jsx-loader?harmony' },
            { test: /\.scss$/, loader: 'style!css!sass?sourceMap'},
            { test: /\.(png|jpg)$/, loader: 'url-loader?limit=8192'}
        ]
    },
    //其它解决方案配置
    resolve: {
        root: 'E:/github/flux-example/src', //绝对路径
        extensions: ['', '.js', '.json', '.scss'],
        alias: {
            AppStore : 'js/stores/AppStores.js',
            ActionType : 'js/actions/ActionType.js',
            AppAction : 'js/actions/AppAction.js'
        }
    }
};
```
- plugins 是插件项
- entry 是页面入口文件配置，output 是对应输出项配置（即入口文件最终要生成什么名字的文件、存放到哪里），其语法大致为：
```javascript
{
    entry: {
        page1: "./page1",
        //支持数组形式，将加载数组中的所有模块，但以最后一个模块作为输出
        page2: ["./entry1", "./entry2"]
    },
    output: {
        path: "dist/js/page",
        filename: "[name].bundle.js"
    }
}
```
 - 该段代码最终会生成一个 page1.bundle.js 和 page2.bundle.js，并存放到 ./dist/js/page 文件夹下。

- module.loaders 是最关键的一块配置。它告知 webpack 每一种文件都需要使用什么加载器来处理：
```javascript
module: {
    //加载器配置
    loaders: [
        //.css 文件使用 style-loader 和 css-loader 来处理
        { test: /\.css$/, loader: 'style-loader!css-loader' },
        //.js 文件使用 jsx-loader 来编译处理
        { test: /\.js$/, loader: 'jsx-loader?harmony' },
        //.scss 文件使用 style-loader、css-loader 和 sass-loader 来编译处理
        { test: /\.scss$/, loader: 'style!css!sass?sourceMap'},
        //图片文件使用 url-loader 来处理，小于8kb的直接转为base64
		//超过8kb的才使用 url-loader 来映射到文件，否则转为data url形式
        { test: /\.(png|jpg)$/, loader: 'url-loader?limit=8192'}
    ]
}
```
  - "-loader"其实是可以省略不写的，多个loader之间用“!”连接起来。
  - 所有的加载器都需要通过 npm 来加载
- resolve 配置
```javascript
resolve: {
    //查找module的话从这里开始查找
    root: 'E:/github/flux-example/src', //绝对路径
    //自动扩展文件后缀名，意味着我们require模块可以省略不写后缀名
    extensions: ['', '.js', '.json', '.scss'],
    //模块别名定义，方便后续直接引用别名，无须多写长长的地址
    alias: {
        AppStore : 'js/stores/AppStores.js',//后续直接 require('AppStore') 即可
        ActionType : 'js/actions/ActionType.js',
        AppAction : 'js/actions/AppAction.js'
    }
}
```
## webpack的运行 ##
### 模块引入
直接在页面中引入打包好的脚本，样式不用引入，脚本执行时会动态生成`<style>`并标签打到`head`里。
入口entryjs：
```javascript
// entry.js
require('./style.css')
document.write('It works.')
document.write(require('./module.js')) // 添加模块
```
其他被引入文件：
```javascript
// module.js
module.exports = 'It works from module.js.'

//style.css
body {
	background: #f9f9f9;
}
```
### 编译
直接运行webpack即可编译文件。
	$ webpack --display-error-details
后面的参数`--display-error-details`是推荐加上的，方便出错时能查阅更详尽的信息。亦可省略。
其他部分参数：

	$ webpack --config XXX.js   //使用另一份配置文件（比如webpack.config2.js）来打包
	 
	$ webpack --watch   //监听变动并自动打包
	 
	$ webpack -p    //压缩混淆脚本，这个非常非常重要！
	 
	$ webpack -d    //生成map映射文件，告知哪些模块被最终打包到哪里了

### 开发环境
当项目逐渐变大，webpack 的编译时间会变长，可以通过参数让编译的输出内容带有进度和颜色。
	$ webpack --progress --colors
如果不想每次修改模块后都重新编译，那么可以启动监听模式。开启监听模式后，没有变化的模块会在编译后缓存到内存中，而不会每次都被重新编译，所以监听模式的整体速度是很快的。
	$ webpack --progress --colors --watch
使用 webpack-dev-server 开发服务是一个更好的选择。它将在 localhost:8080 启动一个 express 静态资源 web 服务器，并且会以监听模式自动运行 webpack，在浏览器打开 http://localhost:8080/ 或 http://localhost:8080/webpack-dev-server/ 可以浏览项目中的页面和编译后的资源输出，并且通过一个 socket.io 服务实时监听它们的变化并自动刷新页面。
	# 安装
	$ npm install webpack-dev-server -g
	
	# 运行
	$ webpack-dev-server --progress --colors
## 其他技巧 ##
### 自定义公共模块提取
```javascript
var CommonsChunkPlugin = require("webpack/lib/optimize/CommonsChunkPlugin");
module.exports = {
    entry: {
        p1: "./page1",
        p2: "./page2",
        p3: "./page3",
        ap1: "./admin/page1",
        ap2: "./admin/page2"
    },
    output: {
        filename: "[name].js"
    },
    plugins: [
        new CommonsChunkPlugin("admin-commons.js", ["ap1", "ap2"]),
        new CommonsChunkPlugin("commons.js", ["p1", "p2", "admin-commons.js"])
    ]
};
// <script> required:
// page1.html: commons.js, p1.js
// page2.html: commons.js, p2.js
// page3.html: p3.js
// admin-page1.html: commons.js, admin-commons.js, ap1.js
// admin-page2.html: commons.js, admin-commons.js, ap2.js
```
### 独立打包样式文件
当项目的样式能不要被打包到脚本中，而是独立出来作为css时，这时候我们需要 `extract-text-webpack-plugin `来帮忙.
```javascript
var webpack = require('webpack');
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  plugins: [new ExtractTextPlugin("[name].css")],
  entry: './entry.js',
  output: {
    path: 'dist/',
    filename: '[name].js'
  },
  module: {
    loaders: [
      {test: /\.css$/, loader: 'style!css'},
      {
        test: /\.less$/,
        loader:  ExtractTextPlugin.extract("style-loader", "css-loader!less-loader")
      }
    ]
  }
}
```
> 转载自[http://www.w2bc.com/Article/50764](http://www.w2bc.com/Article/50764 "webpack入门指南")


