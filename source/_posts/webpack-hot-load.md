title: webpack热更新
date: 2017-03-08 16:55:31
tags: webpack
categories: 打包工具
---

# what

## 什么是 webpack dev server

`Webpack dev server` 是一个轻量的`node.js express`服务器，实现了 `webpack` 编译代码实时输出更新。在前后端分离的前端项目开发中经常用到。不过这篇文章应该不会讲到它。

## webpack dev middleware

`Webpack dev middleware` 是 `WebPack` 的一个中间件。它用于在 `Express` 中分发需要通过 `WebPack` 编译的文件。单独使用它就可以完成代码的热重载（hot reloading）功能。
<!--more-->

特性：

- 不会在硬盘中写入文件，完全基于内存实现。
- 如果使用 `watch` 模式监听代码修改，`Webpack` 会自动编译，如果在 `Webpack` 编译过程中请求文件，`Webpack dev middleware` 会延迟请求，直到编译完成之后再开始发送编译完成的文件。

## webpack hot middleware

`Webpack hot middleware` 它通过订阅 `Webpack` 的编译更新，之后通过执行 `webpack` 的 `HMR api` 将这些代码模块的更新推送给浏览器端。

## HMR

`HMR` 即 `Hot Module Replacement` 是 `Webpack` 一个重要的功能。它可以使我们不用通过手动地刷新浏览器页面实现将我们的更新代码实时应用到当前页面中。

HMR 的实现原理是在我们的开发中的应用代码中加入了 `HMR Runtime`，它是 HMR 的客户端（浏览器端 client）用于和开发服务器通信，接收更新的模块。服务端工作就是前面提到的 Webpack hot middleware 的，它会在代码更新编译完成之后通过以 json 格式输出给HMR Runtime 就会更具 json 中描述来动态更新相应的代码。

# WEBPACK DEV MIDDLEWARE

> `webpack-dev-middleware`为高级用户提供。需要即时可用的解决方案请查阅[webpack-dev-server](http://webpack.github.io/docs/webpack-dev-server.html)


` webpack-dev-middleware `是一个基于连接的中间件堆栈的小中间件。它使用webpack在内存中编译打包并提供服务。当编译正在运行时，对所提供的webpack的每个请求都被阻止，直到我们有一个稳定的bundle。

你可以使用两种模式：

- `watch`模式(default):  编译器根据文件更改重新编译。
- `lazy`模式: 编译器在每个对入口点的请求上编译。

## 基础API

```javascript
var webpackDevMiddleware = require("webpack-dev-middleware")
var webpack = require("webpack")

var compiler = webpack({
    // configuration
    output: { path: '/' }
});

app.use(webpackDevMiddleware(compiler, {
    // options
    noInfo: false,
    // display no info to console (only warnings and errors) 
 
    quiet: false,
    // display nothing to the console 
 
    lazy: true,
    // switch into lazy mode 
    // that means no watching, but recompilation on every request 
 
    watchOptions: {
        aggregateTimeout: 300,
        poll: true
    },
    // watch options (only lazy: false) 
 
    publicPath: "/assets/",
    // public path to bind the middleware to 
    // use the same as in webpack 
    
    index: "index.html",
    // the index path for web server


    headers: { "X-Custom-Header": "yes" },
    // custom headers 
 
    stats: {
        colors: true
    },
    // options for formating the statistics 
 
    reporter: null,
    // Provide a custom reporter to change the way how logs are shown. 
 
    serverSideRender: false
    // Turn off the server-side rendering mode. See Server-Side Rendering part for more info. 
}));
```

### options

- `noInfo` 控制台不显示任何信息（只有警告和错误）(default: false)
- `quiet` 不在控制台显示任何内容 (default: false)
- `lazy` 切换到延迟模式 (default: false)
- `filename` 大多数情况下，这个相当于webpack配置中的`output.filename`
- `watchOptions.aggregateTimeout` 在第一次更改后延迟重建,单位是毫秒。(default: 300)
- `watchOptions.poll` (default: undefined)
  - `true` 使用轮询
  - `number` 使用指定间隔的轮询
- `publicPath` 必填项，将中间件绑定到服务器的路径。大多数情况下相当于webpack配置中的`output.publicPath`
- `headers` 添加自定义`header`，例如`{ "X-Custom-Header": "yes" }`
- `stats` 统计信息的输出选项
- `middleware.fileSystem` 可以访问编译数据的可读（内存中）文件系统。

## 高级API

此部分显示了您在运行时如何与中间件进行交互：

- `close(callback)` 停止监视文件更改

```javascript
var devMiddleWare = webpackMiddleware(/* see example usage */);
app.use(devMiddleWare);
// After 10 seconds stop watching for file changes: 
setTimeout(function(){
  devMiddleWare.close();
}, 10000)
```

- `invalidate()` 重新编译包，比如你修改了配置

```javascript
var compiler = webpack(/* see example usage */);
var devMiddleWare = webpackMiddleware(compiler);
app.use(devMiddleWare);
setTimeout(function(){
  // After a short delay the configuration is changed 
  // in this example we will just add a banner plugin: 
  compiler.apply(new webpack.BannerPlugin('A new banner'));
  // Recompile the bundle with the banner plugin: 
  devMiddleWare.invalidate();
}, 1000);
```

- `waitUntilValid(callback)` 如果捆绑包有效或在其再次有效之后执行回调

```javascript
var devMiddleWare = webpackMiddleware(/* see example usage */);
app.use(devMiddleWare);
devMiddleWare.waitUntilValid(function(){
  console.log('Package is in a valid state');
});
```


# 启用热更新

## 将以下插件添加到plugins数组

```javascript
plugins: [
    // OccurenceOrderPlugin 只在webpack 1.x 需要
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
]
```
目的在于确保一致构建散列，热模块更换有点不言自明，NoErrorsPlugin使处理错误更加干净。

## 添加webpack-hot-middleware/client

在`entry`数组中添加`webpack-hot-middleware/client`,这个用于连接服务器，当bundle重建时相应的更新客户端bundle包来接收通知。

```javascript
webpackConfig.entry = [
  'webpack-hot-middleware/client',
  webpackConfig.entry
]
```

## 添加webpack-dev-middleware

```javascript
var webpack = require('webpack');
var webpackConfig = require('./webpack.config');
const compiler = webpack(webpackConfig)

const devMiddleWare = require('webpack-dev-middleware')(compiler, {
  publicPath: webpackConfig.output.publicPath,
  stats: {
    colors: true,
    modules: false,
    children: false,
    chunks: false,
    chunkModules: false
  }
})
app.use(devMiddleWare)
```
## 添加webpack-hot-middleware

将`webpack-hot-middleware`附加到同一个编译器实例

```javascript
app.use(require("webpack-hot-middleware")(compiler))
```

## 然后发送至浏览器

```javascript
app.get('*', (req, res) => {
  const fs = devMiddleWare.fileSystem
  devMiddleWare.waitUntilValid(() => {
    // 在确保包有效的情况下获取html
    const html = fs.readFileSync(path.join(webpackConfig.output.path, './index.html'))
    res.end(html)
  })
})

app.listen(config.port, () => {
  console.log(`Listening at http://localhost:${config.port}`)
})
```