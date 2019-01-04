---
title: webpack插件列表详解
date: 2016-09-28 14:39:17
tags: webpack
---

## 配置

### NormalModuleReplacementPlugin

```javascript
new webpack.NormalModuleReplacementPlugin(resourceRegExp, newResource)
```

<!-- more -->

Replace resources that matches resourceRegExp with newResource. If newResource is relative, it is resolve relative to the previous resource. If newResource is a function, it is expected to overwrite the ‘request’ attribute of the supplied object.

### ContextReplacementPlugin

```javascript
new webpack.ContextReplacementPlugin(
  resourceRegExp,
  [newContentResource],
  [newContentRecursive],
  [newContentRegExp]
)
```

### IgnorePlugin

```javascript
new webpack.IgnorePlugin(requestRegExp, [contextRegExp])
```

不要为匹配的正则生成模块。

- requestRegExp 正则用于测试需求
- contextRegExp(可选) 正则用于测试上下文（目录）

### PrefetchPlugin

```javascript
new webpack.PrefetchPlugin([context], request)
```

A request for a normal module, which is resolved and built even before a require to it occurs. This can boost performance. Try to profile the build first to determine clever prefetching points.

- context 目录的绝对路径
- request 普通模块的请求字符串

### ResolverPlugin

```javascript
new webpack.ResolverPlugin(plugins, [types])
```

应用一个插件（或插件数组），作用于一个或多个解析器。

- plugins 应用于解析器的插件或插件数组
- types 解析器类型或解析器类型数组（默认：["normal"]，解析器类型：normal, context, loader）
  例子：

```javascript
new webpack.ResolverPlugin(
  [
    new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin('bower.json', [
      'main'
    ])
  ],
  ['normal', 'loader']
)
```

### ResolverPlugin.FileAppendPlugin

This plugin will append a path to the module directory to find a match, which can be useful if you have a module which has an incorrect “main” entry in its package.json/bower.json etc (e.g. "main": "Gruntfile.js"). You can use this plugin as a special case to load the correct file for this module. Example:
举例：

```javascript
new webpack.ResolverPlugin([
  new webpack.ResolverPlugin.FileAppendPlugin(['/dist/compiled-moduled.js'])
])
```

### EnvironmentPlugin

这个插件允许你通过 process.env 参考环境变量。

```javascript
new webpack.EnvironmentPlugin(['NODE_ENV'])
```

代码中使用：

```javascript
var env = process.env.NODE_ENV
```

## 输出

### BannerPlugin

```javascript
new webpack.BannerPlugin(banner, options)
```

在每个生成的块中添加 banner

- banner 字符串，包裹在 comment 中
- options.raw 如果为 true，banner 不会包裹在 comment 中
- options.entryOnly 如果为 true，banner 只会添加在入口文件

## 优化

### DedupePlugin

```javascript
new webpack.optimize.DedupePlugin()
```

找出相同的依赖并在输出时删除重复依赖。这些文件来源于入口模块，但是可以有效地降低文件大小。
这不会改变模块的语义，不要指望能解决多个模块实例的问题，在删除后不会变成一个实例。
注意：不要再检测模式下使用。只能用于生产环境构建。

### LimitChunkCountPlugin

```javascript
new webpack.optimize.LimitChunkCountPlugin(options)
```

限制模块的数量。

- options.maxChunks (number) max number of chunks

- options.chunkOverhead (number) an additional overhead for each chunk in bytes (default 10000, to reflect request delay)

- options.entryChunkMultiplicator (number) a multiplicator for entry chunks (default 10, entry chunks are merged 10 times less likely)

### MinChunkSizePlugin

```javascript
new webpack.optimize.MinChunkSizePlugin(options)
```

- options.minChunkSize (number)

### OccurrenceOrderPlugin

```javascript
new webpack.optimize.OccurrenceOrderPlugin(preferEntry)
```

### UglifyJsPlugin

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

UglifyJS 配置项：

- compress (boolean|object) 压缩的配置项，默认启用。使用`compress: false`禁用压缩。
- mangle (boolean|object) 变量名称改编的配置项，默认启用。禁用方式如上。
- mangle.props (boolean|object):

### ngAnnotatePlugin

### CommonsChunkPlugin

### DllPlugin

### AppCachePlugin

### OfflinePlugin

### ImageminPlugin

## 模块风格

### LabeledModulesPlugin

### ComponentPlugin

### AngularPlugin

## 依赖注入

### DefinePlugin

```javascript
new webpack.DefinePlugin(definitions)
```

这个插件允许你在编译的时候创建全局的可配置的常量。对于在开发版本和发布版本中允许不同的行为是非常有用的。例如，你可以用一个全局的常量确定记录是否发生，或许你的执行记录是在开发版本而不是生成版本。
例如：

```javascript
new webpack.DefinePlugin({
  PRODUCTION: JSON.stringify(true),
  VERSION: JSON.stringify('5fa3b9'),
  BROWSER_SUPPORTS_HTML5: true,
  TWO: '1+1',
  'typeof window': JSON.stringify('object')
})
```

```javascript
console.log('Running App version ' + VERSION)
if (!BROWSER_SUPPORTS_HTML5) require('html5shiv')
```

- 如果该值是一个字符串，将被用作代码片段
- 如果该值不是字符串，那么会被字符串化（包括方法）
  这些值将会被内联到代码：

```javascript
if (!PRODUCTION) console.log('Debug info')
if (PRODUCTION) console.log('Production log')
```

通过 webpack 编译后没有缩小的结果：

```javascript
if (!true) console.log('Debug info')
if (true) console.log('Production log')
```

最后缩小后的结果：

```javascript
console.log('Production log')
```

### ProvidePlugin

```javascript
new webpack.ProvidePlugin(definitions)
```

自动加载模块。当关键字在模块中使用时将会被加载。
例子：

```javascript
new webpack.ProvidePlugin({
  $: 'jquery'
})
```

```javascript
// in a module
$('#item') // <= just works
// $ is automatically set to the exports of module "jquery"
```

### RewirePlugin

### NgRequirePlugin

## 本土化

### I18nPlugin

## 调试

### SourceMapDevToolPlugin

## 其他

### HotModuleReplacementPlugin

```javascript
new webpack.HotModuleReplacementPlugin()
```

启用热模块更换。

### ExtendedAPIPlugin

### NoErrorsPlugin

### ProgressPlugin

### WatchIgnorePlugin

### HtmlWebpackPlugin

```javascript
HtmlWebpackPlugin = require('html-webpack-plugin')
new HtmlWebpackPlugin({ title: 'Webpack App' })
```

### S3Plugin

### BellOnBundlerErrorPlugin

### WebpackShellPlugin

### WebpackAngularResourcePlugin

### WebpackBrowserPlugin

### FaviconsWebpackPlugin
