---
title: webpack按需加载
date: 2016-12-12 16:48:45
categories: 打包工具真难搞
tags: webpack
---
> 加载项目时,不管那些代码有没有执行到，都会下载下来。如果说，我们只下载我们需要执行的代码话，那么可以节省相当大的流量。也就是我们所说的按需加载,这对于大型项目是相当有用的。

# 基本使用

[webpack官网](http://webpack.github.io/docs/code-splitting.html)有详细的介绍，这里简单阐述下：

加载函数：

```
require.ensure(dependencies, callback, chunkName)
```

这个方法可以实现js的按需加载，分开打包，`webpack`管包叫`chunk`，为了打包能正常输出，我们先给`webpack`配置文件配置一下chunk文件输出路径:

<!--more-->

```
// webpack.config.js
module.exports = {
  ...
  output: {
    ...
    chunkFilename: '[name].[chunkhash:5].chunk.js',
    publicPath: '/dist/'
  }
  ...
}
```


每个chunk都会有一个ID，会在webpack内部生成，当然我们也可以给`chunk`指定一个名字，就是`require.ensure`的第三个参数。

注意： 如果这里不配置`chunkFilename`，那么打包出来的名称是id加name。

配置文件中

- [name] 默认是 ID，如果指定了chunkName则为指定的名字。
- [chunkhash] 是对当前chunk 经过hash后得到的值，可以保证在chunk没有变化的时候hash不变，文件不需要更新，chunk变了后，可保证hash唯一，由于hash太长，这里截取了hash的5个字符。

# demo展示

```javascript
// a.js
console.log('a');

// b.js
console.log('b');

// c.js
console.log('c');

// entry.js
require.ensure([], () => {
  require('./a')
  require('./b')
}, 'chunk1')

if(false){
  require.ensure([], () => {
    require('./c')
  }, 'chunk2')
}
```

将会打包出3个文件，基础包、chunk1 和 chunk2，但是chunk2在if判断中，而且永远为false，所以 chunk2 虽然打包了但永远不会被加载。

# 结合 react-router 按需加载

react-router本身有一套[动态加载方案](https://react-guide.github.io/react-router-cn/docs/guides/advanced/DynamicRouting.html)。


```javascript
const CourseRoute = {
  path: 'course/:courseId',

  getChildRoutes(location, callback) {
    require.ensure([], function (require) {
      callback(null, [
        require('./routes/Announcements'),
        require('./routes/Assignments'),
        require('./routes/Grades'),
      ])
    })
  },

  getIndexRoute(location, callback) {
    require.ensure([], function (require) {
      callback(null, require('./components/Index'))
    })
  },

  getComponents(location, callback) {
    require.ensure([], function (require) {
      callback(null, require('./components/Course'))
    })
  }
}
```

- `getChildRoutes`
- `getIndexRoute`
- `getComponents`

# 实际操作

```javascript
const home = (location, callback) => {
  require.ensure([], require => {
    callback(null, require('modules/home'))
  }, 'home')  
}

const blog = (location, callback) => {
  require.ensure([], require => {
    callback(null, require('modules/blog'))
  }, 'blog')  
}

<Router history={history}>
  <Route path="/" component={App}>
    <Route path="home" getComponent={home}></Route>
    <Route path="blog" getComponent={blog}></Route>
  </Route>
</Router>
```

# 能否将按需加载抽成公共函数？

答案：不可以。

因为`require`函数太特别了，他是`webpack`底层用于加载模块，所以必须明确的声明模块名，`require`函数在这里只能接受字符串，不能接受变量 。


> [react-router官网案例](https://github.com/ReactTraining/react-router/tree/master/examples/huge-apps/routes/Grades)