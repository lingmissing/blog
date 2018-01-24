title: 《你不知道的JS上卷》阅读小记之setTimeout的this指向问题
date: 2017-02-19 10:10:05
categories: JavaScript
tags: [JavaScript]
---
这几天翻看了下被传的神乎其神的《你不知道的JS》这本书，其实以前就看过一次，不过当时的level并不高，而且感觉这本书讲的有点绕，所以看了一点就没坚持下去。  
这次翻看感觉还是比较轻松的，有些地方写的很好，有的地方还是感觉讲的有点绕（可能是翻译的问题），但总的来说这本书还是很不错的，基本都是JS中有坑、新手难以理解的点，简直就是《JS：The Bad Parts》（哈，开个玩笑~）。  
这个小记不是打算记录书中内容的笔记，而是想补充纠正书中的讲的不完善的地方。
<!-- more -->

## this的问题
在第二部分`2.2.2隐式绑定`一节中，提到了`setTimeout`的传入函数this的问题，书里说传入回调函数在执行的时候`context`为全局对象，所以`this`指向了全局对象：
```JavaScript
setTimeout(function() {
	console.log(this)
}, 200)
```
在Chrome56中测试上面的一段代码确实输出为`window`全局对象，符合书中的描述，然而如果你在Node.js中测试这段代码你会发现输出是这样的：
```
➜  Desktop  node -v
v6.8.1
➜  Desktop  node test.js
Timeout {
  _called: true,
  _idleTimeout: 200,
  _idlePrev: null,
  _idleNext: null,
  _idleStart: 94,
  _onTimeout: [Function],
  _timerArgs: undefined,
  _repeat: null }
```
What? 输出的是一个Timeout实例对象！  
打开node的源码，在`node\timers.js`中有着`setTimeout`的实现，这里大概的讲一下，有兴趣的可以自己再去看看代码：  
有一个`Timeout`构造函数，用来构造定时器对象，用一个链表存着所有的`Timeout`的实例对象，也就是每次执行暴露出来的`setTimeout`都会在链表中插入一个`Timeout`实例`timer`。下面是`Timeout`构造函数的代码：
```JavaScript
function Timeout(after, callback, args) {
  this._called = false;
  this._idleTimeout = after;
  this._idlePrev = this;
  this._idleNext = this;
  this._idleStart = null;
  this._onTimeout = callback;
  this._timerArgs = args;
  this._repeat = null;
}
```
定时的部分`TimerWrap`则由C++来做处理，这里不是现在我们关注的关键点也脱离了JS的范畴暂且不细谈，在定时结束后，通过`ontimeout`函数来处理`timer`对象：
```JavaScript
function ontimeout(timer) {
  var args = timer._timerArgs;
  var callback = timer._onTimeout;
  if (!args)
    callback.call(timer);
  else {
    switch (args.length) {
      case 1:
        callback.call(timer, args[0]);
        break;
      case 2:
        callback.call(timer, args[0], args[1]);
        break;
      case 3:
        callback.call(timer, args[0], args[1], args[2]);
        break;
      default:
        callback.apply(timer, args);
    }
  }
  if (timer._repeat)
    rearm(timer);
}
```
`ontimeout`函数中正藏着`this`指向问题的真相：`callback.call(timer, ...)`。  

在JS中，`setTimeout`应该是属于`Event Loop`的`Macro Tasks`，与`I/O`等`Tasks`同等级，在浏览器中有`Web APIs`规范来定义这部分的实现，node没有（或者是我没找到，还请告知）。但我大概翻了下`Web APIs`的规范，也没有找到对`this` `context` 的规定。虽然不理解为什么node这样做，但是好歹也找出了与Chrome浏览器不同的原因。  

所以，关于`setTimeout`传入函数的`this`，我的建议是即使你写的代码只会在浏览器里运行，也最好不要依赖`this`会自动绑定到全局对象上去，而是应该手动借助`bind`绑定。当然使用ES6的箭头函数是没什么问题的，因为没有创建新的`context`，`this`都会毫无疑问的绑定在当前的`context`上：
```JavaScript
let that = this

setTimeout(() => {
	console.log(this == that) // true
}, 200)
```
