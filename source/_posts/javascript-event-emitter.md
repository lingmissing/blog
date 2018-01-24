title: JS实现自定义事件
date: 2016-8-2 22:30:00
categories: JavaScript
tags: [JavaScript]
---
## 要求
> 请实现下面的自定义事件Event对象的接口，功能见注释（测试1）  
该Event对象的接口需要能被其他对象拓展复用（测试2）
<!-- more -->

```JavaScript
// 测试 1
Event.on("test", function(result) {
  console.log(result);
})
Event.on("test", function(result) {
  console.log("test");
})
Event.emit("test", "hello world"); // 输出“hello world”和”test”
//测试2
var person1 = {};
var person2 = {};

Object.assign(person1, Event);
Object.assign(person2, Event);

person1.on("call1", function() {
  console.log("person1");
});
person2.on("call2", function() {
  console.log("person2");
});

person1.emit("call1"); // 输出“person1”
person1.emit("call2"); // 没有输出
person2.emit("call1"); // 没有输出
person2.emit("call2"); // 输出”person2”
```

## 思路
这是个经典的自定义事件，实现"Pub/Sub"，Node.js中有个比较完善的实现`EventEmitter`。  

原理则是构造出一个集成队列的对象，每一个事件对应对象的一个队列，在自定义事件后将回调函数入队，触发事件后回调函数依次出队并执行。  

个人偏爱IIFE+构造器模式+原型模式，于是有了下面的一个简易实现：
```JavaScript
(function (exports) {

  function EventEmitter() {}

  EventEmitter.prototype.on = function (type, handler) {
    this._cbQueue = this._cbQueue || {};
    this._cbQueue[type] = this._cbQueue[type]|| [];
    this._cbQueue[type].push(handler);
    return this;
  };

  EventEmitter.prototype.emit = function (type, data) {
    if (this._cbQueue[type]) {
      this._cbQueue[type].forEach(function (cb) {
        cb(data);
      });
    }
  };

  exports.EventEmitter = EventEmitter;

}(global));

var Event = new EventEmitter();

// Test 1
Event.on("test", function(result) {
  console.log(result);
})
Event.on("test", function(result) {
  console.log("test");
})
Event.emit("test", "hello world"); // 输出“hello world”和”test”
```
这样便满足了测试1的要求，然而这样对于测试2是不行的，因为`Object.assign()`方法不能复制不可遍历的属性和继承属性，也就意味着`Event`对象上的`on`和`emit`不能被复制过去。那么复制`Event.prototype`对象呢？这样确实是可行的：
```JavaScript
//Test2
var person1 = {};
var person2 = {};

Object.assign(person1, EventEmitter.prototype);
Object.assign(person2, EventEmitter.prototype);

person1.on("call1", function() {
  console.log("person1");
});
person2.on("call2", function() {
  console.log("person2");
});

person1.emit("call1"); // 输出“person1”
person1.emit("call2"); // 没有输出
person2.emit("call1"); // 没有输出
person2.emit("call2"); // 输出”person2”
```
虽然差不多实现了题目中的要求，但是和题目中的要求依然有些偏差，于是我又想到了，如果放弃原型模式+构造器模式，单纯的把Event作为一个对象而不是一个函数呢？  
实现很简单：
```JavaScript
(function (exports) {

  var Event = {};

  Event.on = function (type, handler) {
    this._cbQueue = this._cbQueue || {};
    this._cbQueue[type] = this._cbQueue[type]|| [];
    this._cbQueue[type].push(handler);
    return this;
  };

  Event.emit = function (type, data) {
    if (this._cbQueue[type]) {
      this._cbQueue[type].forEach(function (cb) {
        cb(data);
      });
    }
  };

  exports.Event = Event;

}(global));


// Test 1
Event.on("test", function(result) {
  console.log(result);
})
Event.on("test", function(result) {
  console.log("test");
})
Event.emit("test", "hello world"); // 输出“hello world”和”test”


//Test2
var person1 = {};
var person2 = {};

Object.assign(person1, Event);
Object.assign(person2, Event);

person1.on("call1", function() {
  console.log("person1");
});
person2.on("call2", function() {
  console.log("person2");
});

person1.emit("call1"); // 输出“person1”
person1.emit("call2"); // 输出”person2”
person2.emit("call1"); // 输出”person1”
person2.emit("call2"); // 输出”person2”
```
测试1的结果如预期一样，然而测试2却出了问题，debug看了一下`Event`对象，`Event.on`执行后上面竟然有个可以遍历的属性`_cbQueue`，而且`_cbQueue`是一个对象而不是一个字面量，所以在`Object.assign()`拷贝的过程中，将`Event._cbQueue`对象引用赋值给了`person1._cbQueue`和`person2._cbQueue`，也就是说这三者指向了内存中的同一个对象，只要修改一个，其他几个都会跟着修改；当不执行`Event.on`时，`Event`上就不会有属性`_cbQueue`，那么接下来`person1`和`person2`执行`on`方法后，`this`指向了他们本身，会创造他们自己的互不影响的`_cbQueue`属性。  
但不执行`Event.on`这不是解决的完美办法，不过问题已经定位了，解决也很简单，修改`Event`对象的属性`_cbQueue`为不可遍历，让拷贝过程不拷贝属性`_cbQueue`即可：
```JavaScript
(function (exports) {

  var Event = {};

  Object.defineProperty(Event, "_cbQueue", {
	  value : {},
	  writable : true,
	  enumerable : false,
	  configurable : true
  });

  Event.on = function (type, handler) {
    this._cbQueue = this._cbQueue || {};
    this._cbQueue[type] = this._cbQueue[type]|| [];
    this._cbQueue[type].push(handler);
    return this;
  };

  Event.emit = function (type, data) {
    if (this._cbQueue[type]) {
      this._cbQueue[type].forEach(function (cb) {
        cb(data);
      });
    }
  };

  exports.Event = Event;

}(global));


// Test 1
Event.on("test", function(result) {
  console.log(result);
})
Event.on("test", function(result) {
  console.log("test");
})
Event.emit("test", "hello world"); // 输出“hello world”和”test”

//Test2
var person1 = {};
var person2 = {};

Object.assign(person1, Event);
Object.assign(person2, Event);

person1.on("call1", function() {
  console.log("person1");
});
person2.on("call2", function() {
  console.log("person2");
});

person1.emit("call1"); // 输出“person1”
person1.emit("call2"); // 没有输出
person2.emit("call1"); // 没有输出
person2.emit("call2"); // 输出”person2”
```
这样便算完美实现了题目的要求。

## 总结
其实原理很简单，没想到在周边的实现上浪费了一些debug的时间，有些惭愧。
