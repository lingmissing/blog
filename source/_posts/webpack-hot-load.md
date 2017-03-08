title: webpack-hot-load
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

## API

```javascript
var webpackDevMiddleware = require("webpack-dev-middleware")
var webpack = require("webpack")

var compiler = webpack({
    // configuration
    output: { path: '/' }
});

app.use(webpackDevMiddleware(compiler, {
    // options
}));
```

### options

- `noInfo` 控制台不显示任何信息（只有警告和错误）
  默认值： false
- `quiet` 不在控制台显示任何内容
  默认值： false
- `lazy` 切换到延迟模式
  默认值： false
- `filename` 大多数情况下，这个相当于webpack配置中的`output.filename`
- `watchOptions.aggregateTimeout` 在第一次更改后延迟重建,单位是毫秒。
  默认值：300
- `watchOptions.poll` (default: undefined)
  - `true` 使用轮询
  - `number` 使用指定间隔的轮询
- `publicPath` 必填项，将中间件绑定到服务器的路径。大多数情况下相当于webpack配置中的`output.publicPath`
- `headers` 添加自定义`header`，例如`{ "X-Custom-Header": "yes" }`
- `stats` 统计信息的输出选项
- `middleware.invalidate()` 手动使编译无效。前提是如果编译器的东西已经改变。
- `middleware.fileSystem` 可以访问编译数据的可读（内存中）文件系统。

# 启用热更新

1.将以下插件添加到plugins数组

```javascript
plugins: [
    // OccurenceOrderPlugin 只在webpack 1.x 需要
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
]
```
目的在于确保一致构建散列，热模块更换有点不言自明，NoErrorsPlugin使处理错误更加干净。

2.在`entry`数组中添加`webpack-hot-middleware/client`,这个用于连接服务器，当bundle重建时相应的更新客户端bundle包来接收通知。

```javascript
webpackConfig.entry = [
  'webpack-hot-middleware/client',
  webpackConfig.entry
]
```

3.添加`webpack-dev-middleware`

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
4.将`webpack-hot-middleware`附加到同一个编译器实例

```javascript
app.use(require("webpack-hot-middleware")(compiler))
```

5.然后发送至浏览器

```javascript
app.get('*', (req, res) => {
  const fs = devMiddleWare.fileSystem
  devMiddleWare.waitUntilValid(() => {
    const html = fs.readFileSync(path.join(webpackConfig.output.path, './index.html'))
    res.end(html)
  })
})

app.listen(config.port, () => {
  console.log(`Listening at http://localhost:${config.port}`)
})
```