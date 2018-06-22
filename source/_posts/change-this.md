title: apply,call,bind 的区别及实现
date: 2018-06-22 13:40:16
tags: [javascript]
---

> 用来改变函数的 this 对象的指向

- 都是用来改变函数的 this 对象的指向的。
- **第一个参数都是 this 要指向的对象**。
- 后面的参数是调用方法的参数。
- 都可以利用**后续参数传参**。
  <!-- more -->

```js
var xw = {
  name: '小王',
  gender: '男',
  age: 24,
  say: function() {
    alert(this.name + ' , ' + this.gender + ' ,今年' + this.age)
  }
}
var xh = {
  name: '小红',
  gender: '女',
  age: 18
}
xw.say()
```

调用：

```js
xw.say.call(xh)
xw.say.apply(xh)
// call和apply都是对函数的直接调用，而bind方法返回的仍然是一个函数
xw.say.bind(xh)()
```

**在有参数的情况下 call 和 apply 产生区别：**

```js
var xw = {
  name: '小王',
  gender: '男',
  age: 24,
  say: function(school, grade) {
    alert(
      this.name +
        ' , ' +
        this.gender +
        ' ,今年' +
        this.age +
        ' ,在' +
        school +
        '上' +
        grade
    )
  }
}
var xh = {
  name: '小红',
  gender: '女',
  age: 18
}
```

调用形式：

- call 以及 bind 后面的参数与 say 方法中是一一对应的
- apply 的第二个参数是一个数组，数组中的元素是和 say 方法中一一对应的

```js
xw.say.call(xh, '实验小学', '六年级')
xw.say.apply(xh, ['实验小学', '六年级'])
xw.say.bind(xh, '实验小学', '六年级')()
```

# bind 实现

> 一个绑定函数也能使用 new 操作符创建对象：这种行为就像把原函数当成构造器。提供的 this 值被忽略，同时调用时的参数被提供给模拟函数。

```js
var value = 2
var foo = {
  value: 1
}
function bar(name, age) {
  this.habit = 'shopping'
  console.log(this.value)
  console.log(name)
  console.log(age)
}
bar.prototype.friend = 'kevin'

// 指定bar的this，传入name
var bindFoo = bar.bind(foo, 'daisy')
// 实例化，传入age
var obj = new bindFoo('18')
// 此时this指向的是obj，this.value不存在； 说明new的this优先级大于bind
// undefined
// daisy
// 18
console.log(obj.habit)
console.log(obj.friend)
// shopping
// kevin
```

```js
Function.prototype.bind = function(context) {
  if (typeof this !== 'function') {
    // 如果不是function抛出异常
    throw new Error(
      'Function.prototype.bind - what is trying to be bound is not callable'
    )
  }

  var self = this // 当前函数
  // bind里面的参数
  var args = Array.prototype.slice.call(arguments, 1)
  // 中转函数
  var fNOP = function() {}
  var fBound = function() {
    // bing后的函数执行对应的参数
    var bindArgs = Array.prototype.slice.call(arguments)
    // 当作为构造函数时，this 指向实例，此时结果为 true，将绑定函数的 this 指向该实例，可以让实例获得来自绑定函数的值
    // 以上面的是 demo 为例，如果改成 `this instanceof fBound ? null : context`，实例只是一个空对象，将 null 改成 this ，实例会具有 habit 属性
    // 当作为普通函数时，this 指向 window，此时结果为 false，将绑定函数的 this 指向 context
    return self.apply(
      this instanceof fNOP ? this : context,
      args.concat(bindArgs)
    )
  }
  // 直接将 fBound.prototype = this.prototype，我们直接修改 fBound.prototype 的时候，也会直接修改绑定函数的 prototype。这个时候，我们可以通过一个空函数来进行中转：
  fNOP.prototype = this.prototype
  fBound.prototype = new fNOP()
  return fBound
}
```

# call 实现

```js
// ES6实现
Function.prototype.call = function(context) {
  // context为null的时候，context为window
  var context = context || window
  // 获取调用call的函数
  context.fn = this
  // 获取call方法的不定长参数
  var args = []
  for (var i = 1, len = arguments.length; i < len; i++) {
    args.push(arguments[i])
  }
  // 使用ES6扩展运算符（...）执行函数，返回结果
  var result = context.fn(...args)
  // var result = eval('context.fn(' + args +')');
  // 删除fn属性
  delete context.fn
  // 返回结果
  return result
}
```

# apply 实现

apply 传的参数是数组为数组，绑定字符串后会转换为字符串

```js
Function.prototype.apply = function(context, arr) {
  var context = context || window
  context.fn = this
  var result

  if (!arr) {
    // 参数不存在，立即执行
    result = context.fn()
  } else {
    var args = []
    for (var i = 0, len = arr.length; i < len; i++) {
      args.push('arr[' + i + ']')
    }
    result = eval('context.fn(' + args + ')')
    // ES6写法 result = context.fn(...args)
  }

  delete context.fn
  return result
}
```
