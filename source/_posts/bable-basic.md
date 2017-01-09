title: Babel 入门教程
date: 2017-01-09 17:00:05
tags: [babel]
categories: 编译工具
---

```javascript
// 转码前
input.map(item => item + 1);

// 转码后
input.map(function (item) {
  return item + 1;
});
```
<!--more -->

# 配置文件.babelrc

Babel的配置文件是`.babelrc`，存放在项目的根目录下。使用Babel的第一步，就是配置这个文件。
该文件用来设置转码规则和插件，基本格式如下。

```javascript
{
  "presets": [],
  "plugins": []
}
```
`presets`字段设定转码规则，官方提供以下的规则集，你可以根据需要安装。

```bash
# ES2015转码规则
$ npm install --save-dev babel-preset-es2015

# react转码规则
$ npm install --save-dev babel-preset-react

# ES7不同阶段语法提案的转码规则（共有4个阶段），选装一个
$ npm install --save-dev babel-preset-stage-0
$ npm install --save-dev babel-preset-stage-1
$ npm install --save-dev babel-preset-stage-2
$ npm install --save-dev babel-preset-stage-3
```

然后，将这些规则加入`.babelrc`。

```javascript
{
  "presets": [
    "es2015",
    "react",
    "stage-2"
  ],
  "plugins": []
}
```

# 命令行转码babel-cli

```bash
$ npm install --global babel-cli
```

基本用法：

```bash
# 转码结果输出到标准输出
$ babel example.js

# 转码结果写入一个文件
# --out-file 或 -o 参数指定输出文件
$ babel example.js --out-file compiled.js
# 或者
$ babel example.js -o compiled.js

# 整个目录转码
# --out-dir 或 -d 参数指定输出目录
$ babel src --out-dir lib
# 或者
$ babel src -d lib

# -s 参数生成source map文件
$ babel src -d lib -s
```
以上是全局转码，那如何在项目内编写呢？

```bash
# 安装
$ npm install --save-dev babel-cli
```

然后，改写`package.json`。

```javascript
{
  // ...
  "devDependencies": {
    "babel-cli": "^6.0.0"
  },
  "scripts": {
    "build": "babel src -d lib"
  },
}
```

执行

```bash
npm run build
```

# babel-node

`babel-cli`工具自带一个`babel-node`命令，提供一个支持ES6的REPL环境。

它支持Node的REPL环境的所有功能，而且可以直接运行ES6代码。

它不用单独安装，而是随`babel-cli`一起安装。然后，执行`babel-node`就进入PEPL环境。

```javascript
$ babel-node
> (x => x * 2)(1)
2
```

# babel-register


`babel-register`模块改写`require`命令，为它加上一个钩子。此后，每当使用`require`加载`.js`、`.jsx`、`.es`和`.es6`后缀名的文件，就会先用Babel进行转码。

```bash
$ npm install --save-dev babel-register
```

```javascript
require("babel-register");
require("./index.js");
```
然后就不需要手动转码了

# babel-core

如果某些代码需要调用Babel的API进行转码，就要使用`babel-core`模块。

```bash
$ npm install babel-core --save
```

然后，在项目中就可以调用babel-core。

```javascript
var babel = require('babel-core');

// 字符串转码
babel.transform('code();', options);
// => { code, map, ast }

// 文件转码（异步）
babel.transformFile('filename.js', options, function(err, result) {
  result; // => { code, map, ast }
});

// 文件转码（同步）
babel.transformFileSync('filename.js', options);
// => { code, map, ast }

// Babel AST转码
babel.transformFromAst(ast, code, options);
// => { code, map, ast }
```

下面是个例子，

```javascript
var es6Code = 'let x = n => n + 1';
var es5Code = require('babel-core')
  .transform(es6Code, {
    presets: ['es2015']
  })
  .code;
// '"use strict";\n\nvar x = function x(n) {\n  return n + 1;\n};'
```

# babel-polyfill

abel默认只转换新的JavaScript句法（syntax），而不转换新的API，比如`Iterator`、`Generator`、`Set`、`Maps`、`Proxy`、`Reflect`、`Symbol`、`Promise`等全局对象，以及一些定义在全局对象上的方法（比如`Object.assign`）都不会转码。

举例来说，ES6在`Array`对象上新增了`Array.from`方法。Babel就不会转码这个方法。如果想让这个方法运行，必须使用`babel-polyfill`，为当前环境提供一个垫片。

```bash
$ npm install --save babel-polyfill
```

然后，在脚本头部，加入如下一行代码。

```javascript
import 'babel-polyfill';
// 或者
require('babel-polyfill');
```

Babel默认不转码的API非常多，详细清单可以查看`babel-plugin-transform-runtime`模块的`definitions.js`文件。

# 与其他工具配合

许多工具需要Babel进行前置转码，这里举两个例子：ESLint和Mocha。

```javascript
// .eslint
{
  "parser": "babel-eslint",
  "rules": {
    ...
  }
}
```

> 转载自 [阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/01/babel.html)