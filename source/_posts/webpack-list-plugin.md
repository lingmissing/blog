---
title: webpack插件列表详解
date: 2017-01-05 14:39:17
tags: webpack
categories: 打包工具
---
## 配置

### NormalModuleReplacementPlugin(匹配resourceRegExp，替换为newResource)

```javascript
new webpack.NormalModuleReplacementPlugin(resourceRegExp, newResource)
```
<!-- more -->
将与`resourceRegExp`匹配的代码替换为`newResource`。
如果`newResource`是相对的，那么它是相对于上一个资源的解析。

### ContextReplacementPlugin(替换上下文的插件)

```javascript
new webpack.ContextReplacementPlugin(
                resourceRegExp, 
                [newContentResource],
                [newContentRecursive],
                [newContentRegExp])
```
如果资源（目录）匹配`resourceRegExp`，插件会替换默认资源，

### IgnorePlugin(不打包匹配文件)

```javascript
new webpack.IgnorePlugin(requestRegExp, [contextRegExp])
```
不要为匹配的正则生成模块。

- `requestRegExp` 正则用于测试需求
- `contextRegExp`(可选) 正则用于测试上下文（目录）

### PrefetchPlugin

```javascript
new webpack.PrefetchPlugin([context], request)
```
- `context` 目录的绝对路径
- `request` 普通模块的请求字符串

### ResolverPlugin(替换上下文的插件)

```javascript
new webpack.ResolverPlugin(plugins, [types])
```
应用一个插件（或插件数组），作用于一个或多个解析器。

- `plugins` 应用于解析器的插件或插件数组
- `types` 解析器类型或解析器类型数组（默认：["normal"]，解析器类型：normal, context, loader）

例子：

```javascript
new webpack.ResolverPlugin([
    new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
], ["normal", "loader"])
```

### ResolverPlugin.FileAppendPlugin

举例：

```javascript
new webpack.ResolverPlugin([
  new webpack.ResolverPlugin.FileAppendPlugin(['/dist/compiled-moduled.js'])
])
```

### EnvironmentPlugin

这个插件允许你通过process.env参考环境变量。

```javascript
new webpack.EnvironmentPlugin([
  "NODE_ENV"
])
```
代码中使用：

```javascript
var env = process.env.NODE_ENV;
```

## 输出

### BannerPlugin

```javascript
new webpack.BannerPlugin(banner, options)
```
在每个生成的块中添加头注释

- `banner` 字符串，包裹在comment中
- `options.raw` 如果为true，banner不会包裹在comment中
- `options.entryOnly` 如果为true，banner只会添加在入口文件

### ExtractTextPlugin(独立打包样式文件)

当项目的样式能不要被打包到脚本中，而是独立出来作为css时，这时候我们需要 `extract-text-webpack-plugin `来帮忙.

```javascript
var webpack = require('webpack')
var ExtractTextPlugin = require("extract-text-webpack-plugin")

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

### HtmlWebpackPlugin 

自动生成html文件, 模板生成的相关配置。

```javascript
new HtmlWebpackPlugin({                 //根据模板插入css/js等生成最终HTML
    favicon: './src/img/favicon.ico',     //favicon路径, 通过webpack引入同时可以生成hash值
    filename: './view/index.html',         //生成的html存放路径, 相对于path
    template: './src/view/index.html',     //html模板路径
    inject: 'body',                     //js插入的位置, true/'head'/'body'/false
    hash: true,                         //为静态资源生成hash值
    chunks: ['vendors', 'index'],        //需要引入的chunk, 不配置就会引入所有页面的资源
    minify: {                             //压缩HTML文件
        removeComments: true,             //移除HTML中的注释
        collapseWhitespace: false         //删除空白符与换行符
    }
});
```

```html
//注意：这里的htmlWebpackPlugin对象标识符是固定的，必须是这个，必须这样写，必须！
<title><%= htmlWebpackPlugin.options.title %></title>
```

## 优化

### LoaderOptionsPlugin

UglifyJsPlugin 将不再把所有 loader 都切到代码压缩模式。debug 选项已经被移除。Loader 不应该再从 Webpack 的配置那里读取自己选项了。取而代之的是，你需要通过 LoaderOptionsPlugin 来提供这些选项。

```javascript
new webpack.LoaderOptionsPlugin({
	test: /\.css$/, // optionally pass test, include and exclude, default affects all loaders
	                // 可以传入 test、include 和 exclude，默认会影响所有的 loader
	minimize: true,
	debug: false,
	options: {
		// pass stuff to the loader
		// 这里的选项会传给 loader
	}
})
```

### DedupePlugin(打包的时候删除重复或者相似的文件)

```javascript
new webpack.optimize.DedupePlugin()
```
找出相同的依赖并在输出时删除重复依赖。这些文件来源于入口模块，但是可以有效地降低文件大小。
这不会改变模块的语义，不要指望能解决多个模块实例的问题，在删除后不会变成一个实例。
注意：不要再检测模式下使用。只能用于生产环境构建。

### LimitChunkCountPlugin( 限制打包文件的个数)

```javascript
new webpack.optimize.LimitChunkCountPlugin(options)
```
限制模块的数量。

- `options.maxChunks (number)` 最大数量

- `options.chunkOverhead (number)` 

- `options.entryChunkMultiplicator`

### MinChunkSizePlugin(把多个小模块进行合并，以减少文件的大小)

```javascript
new webpack.optimize.MinChunkSizePlugin(options)
```
- `options.minChunkSize(number)` 

### OccurrenceOrderPlugin(根据模块调用次数，给模块分配ids，常被调用的ids分配更短的id，使得ids可预测，降低文件大小，该模块推荐使用)

```javascript
new webpack.optimize.OccurrenceOrderPlugin(preferEntry)
```

### UglifyJsPlugin(压缩js)

```javascript
new webpack.optimize.UglifyJsPlugin([options])
```

例子：

```javascript
new webpack.optimize.UglifyJsPlugin({
    compress: {
        warnings: false
    }
})
```

UglifyJS配置项：

- `compress (boolean|object)` 压缩的配置项，默认启用。使用`compress: false`禁用压缩。
- `mangle (boolean|object)` 变量名称改编的配置项，默认启用。禁用方式如上。
- `mangle.props (boolean|object)`:
- `output` 对象提供项，表示输出处理
    - `comments` 是否需要注释
    - `sourceMap (boolean)`：使用SourceMaps将错误消息位置映射到模块。（默认true）

### CommonsChunkPlugin(多个 html共用一个js文件(chunk))

```javascript
new webpack.optimize.CommonsChunkPlugin({
    name: 'vendors',                     // 将公共模块提取, 生成名为`vendors`的chunk
    chunks: ['index','list','about'],     //提取哪些模块共有的部分
    minChunks: 3,                         // 提取至少3个模块共有的部分
    minSize: 10 ,                      // 创建公共块之前所有公共模块的最小大小
    chunks: ['a','b']             //按块名称选择源块。块必须是公共块的子节点。如果省略，则选择所有条目块。
});
```

### DllPlugin

### AppCachePlugin

### OfflinePlugin

### ImageminPlugin

## 模块风格

### LabeledModulesPlugin

### ComponentPlugin 

### AngularPlugin

## 依赖注入

### DefinePlugin(定义变量，一般用于开发环境log或者全局变量)

```javascript
new webpack.DefinePlugin(definitions)
```

这个插件允许你在编译的时候创建全局的可配置的常量。对于在开发版本和发布版本中允许不同的行为是非常有用的。例如，你可以用一个全局的常量确定记录是否发生，或许你的执行记录是在开发版本而不是生成版本。

例如：

```javascript
new webpack.DefinePlugin({
    PRODUCTION: JSON.stringify(true),
    VERSION: JSON.stringify("5fa3b9"),
    BROWSER_SUPPORTS_HTML5: true,
    TWO: "1+1",
    "typeof window": JSON.stringify("object")
})
```

```javascript
console.log("Running App version " + VERSION);
if(!BROWSER_SUPPORTS_HTML5) require("html5shiv");
```

- 如果该值是一个字符串，将被用作代码片段
- 如果该值不是字符串，那么会被字符串化（包括方法）

这些值将会被内联到代码：

```javascript
if (!PRODUCTION)
    console.log('Debug info')
if (PRODUCTION)
    console.log('Production log')
```

通过webpack编译后没有缩小的结果：

```javascript
if (!true)
    console.log('Debug info')
if (true)
    console.log('Production log')
```

最后缩小后的结果：

```javascript
console.log('Production log')
```

### ProvidePlugin(自动加载模块，当配置（$:'jquery'）例如当使用$时，自动加载jquery)

```javascript
new webpack.ProvidePlugin(definitions)
```
自动加载模块。当关键字在模块中使用时将会被加载。

例子：

```javascript
new webpack.ProvidePlugin({
    $: "jquery"
})
```

```javascript
// in a module
$("#item") // <= just works
// $ is automatically set to the exports of module "jquery"
```

### RewirePlugin 

### NgRequirePlugin 

## 本土化

### I18nPlugin

## 调试

### SourceMapDevToolPlugin（对source map做更多的控制）

```javascript
new webpack.SourceMapDevToolPlugin({
    // Match assets just like for loaders.
    test: string | RegExp | Array,
    include: string | RegExp | Array,

    // `exclude` matches file names, not package names!
    exclude: string | RegExp | Array,

    // If filename is set, output to this file.
    // See `sourceMapFileName`.
    filename: string,

    // This line is appended to the original asset processed. For
    // instance '[url]' would get replaced with an url to the
    // sourcemap.
    append: false | string,

    // See `devtoolModuleFilenameTemplate` for specifics.
    moduleFilenameTemplate: string,
    fallbackModuleFilenameTemplate: string,

    module: bool, // If false, separate sourcemaps aren't generated.
    columns: bool, // If false, column mappings are ignored.

    // Use simpler line to line mappings for the matched modules.
    lineToLine: bool | {test, include, exclude}
})
```

## 其他

### progress-bar-webpack-plugin

代码打包输出进度条

```javascript
const ProgressBarPlugin = require('progress-bar-webpack-plugin')
//调用
new ProgressBarPlugin()
```

### HotModuleReplacementPlugin

```javascript
new webpack.HotModuleReplacementPlugin()
```
启用热模块更换。

### ExtendedAPIPlugin

### NoErrorsPlugin(报错但不退出webpack进程)

跳过编译时出错的代码并记录，使编译后运行时的包不会发生错误

```javascript
new webpack.NoErrorsPlugin()
```

### ProgressPlugin
### WatchIgnorePlugin
### OpenBrowserPlugin(自动打开浏览器)
### S3Plugin 
### BellOnBundlerErrorPlugin 
### WebpackShellPlugin 
### WebpackAngularResourcePlugin
### WebpackBrowserPlugin 
### FaviconsWebpackPlugin 