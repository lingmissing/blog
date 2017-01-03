---
title: es6箭头函数
date: 2016-09-27 16:58:41
tags: [javascript,es6]
categories:  代码如诗，前端如画
---
## 语法

### 基础语法
```javascript
(param1, param2, …, paramN) => { statements }
(param1, param2, …, paramN) => expression
         // equivalent to:  => { return expression; }

// 如果只有一个参数，圆括号是可选的:
(singleParam) => { statements }
singleParam => { statements }

// 无参数的函数需要使用圆括号:
() => { statements }
```

<!-- more -->

### 高级语法
```javascript
// 返回对象字面量时应当用圆括号将其包起来:
params => ({foo: bar})

// 支持重置参数和默认参数:
(param1, param2, ...rest) => { statements }
(param1 = defaultValue1, param2, …, paramN = defaultValueN) => { statements }

// 支持解构参数
var f = ([a, b] = [1, 2], {x: c} = {x: a + b}) => a + b + c;
f();  // 6
```
## 简短函数书写
```javascript
// a is array
var a2 = a.map(function(s){ return s.length });
var a3 = a.map( s => s.length );
```
## this词法解析
在箭头函数出现之前，每个新定义的函数都有其自己的this值。

```javascript
// ES5
function Person() {
  var self = this; // 也有人选择使用 `that` 而非 `self`. 
                   // 只要保证一致就好.
  self.age = 0;

  setInterval(function growUp() {
    // 回调里面的 `self` 变量就指向了期望的那个对象了
    self.age++;
  }, 1000);
}
```

```javascript
// ES6
function Person(){
  this.age = 0;

  setInterval(() => {
    this.age++; // |this| 正确地指向了 person 对象
  }, 1000);
}

var p = new Person();
```