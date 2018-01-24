title: node-thunkify源码阅读笔记
date: 2016-11-11 16:00:15
categories: JavaScript
tags: [thunkify]
---
Node7发布后已经可以通过添加`--harmony-async-await`的参数调用来直接支持`async/await`语法了，据说Node8还会进一步推进其发展，于是研究了一下JS的异步流程控制和下一代Node Web框架`Koa2`。  

关于`generator` `async/await`的发展史已有一大堆文章讲过了，这里不再赘述。  
tj的`co`是`Koa2`上个大版本`Koa1`的核心，在没有`async/await`的时候一般会借助`co`来做自动流程控制。关于`co`的源码分析文章也有很多，代码不长值得一读，参考了一些分析文章也算是了解了其逻辑和思路。

在`co`中出现了一个`thunkToPromise`的函数，一些文章都跳过了这个并表示`thunk`函数已经没什么意义了，但本着好奇心读了阮一峰的[Thunk 函数的含义和用法](http://www.ruanyifeng.com/blog/2015/05/thunk.html)，文中一个地方一时没有搞懂，故写此文记录一下。
<!-- more -->

`thunkify`的[代码](https://github.com/tj/node-thunkify/blob/master/index.js)很少，就是一个函数：
```JavaScript
function thunkify(fn){
  assert('function' == typeof fn, 'function required');

  return function(){
    var args = new Array(arguments.length);
    var ctx = this;

    for(var i = 0; i < args.length; ++i) {
      args[i] = arguments[i];
    }

    return function(done){
      var called;

      args.push(function(){
        if (called) return;
        called = true;
        done.apply(null, arguments);
      });

      try {
        fn.apply(ctx, args);
      } catch (err) {
        done(err);
      }
    }
  }
};
```

Demo：
```JavaScript
function f(a, b, callback){
  var sum = a + b;
  callback(sum);
  callback(sum);
}

var ft = thunkify(f);
ft(1, 2)(console.log);
// 3
```
让我一时没有搞懂的是为什么借助`called`标记能够确保回调函数只执行一次，借助VS Code的断点调试把文中示例的代码跑了一遍总算搞懂了：  

Demo中首先真正执行的是`thunkify(f)`，`f`函数传入`thunkify`后直接返回了一个闭包，这里称之为闭包1，闭包1被赋值给了ft，ft即为闭包1的一个引用。  
接着执行的是`ft(1, 2)`，`ft`中传入了`(1, 2)`来执行，`ft`中将`duck type`的伪数组`arguments`保存为一个真实数组`args`，所以此时`args`数组中有两个成员即`1`和`2`，`ft`最后又返回了一个闭包，这里称之为闭包2。  
接着执行的是`ft(1, 2)(console.log)`，也就是将`console.log`传入闭包2来执行，传入的`console.log`即形参`done`其实就是一开始`f`的回调函数，这时候重点来了，在闭包2中增加了一个标记`called`来记录回调是否执行过一次了，而`push`进`args`数组的函数则已经不是单纯的回调，而是被包裹了原回调、保证只会执行一次的函数
```JavaScript
function(){
  if (called) return;
  called = true;
  done.apply(null, arguments);
}
```
最后执行的就是`fn.apply(ctx, args)`，而`thunkify`函数的形参`fn`对应的就是一开始传入的`f`函数，所以总的看来，真正执行的还是最初的`f`函数，而被改变的是传入的回调，回调被包裹了一层，借助`called`标记来保证只会被执行一次，执行过后`called`标记被改变，不再会被执行。
