title: learn-rxjs
date: 2016-12-19 16:22:47
tags: [RxJS,javascript]
categories: 代码如诗，前端如画
---


RxJS中解决异步事件的基本概念如下：
- 可观察对象(Observable)：表示一个可调用的未来值或者事件的集合。
- 观察者(observer)：是一个知道如何监听被可观察对象传递的值的回调函数集合。
- 订阅(Subscription)： 表示一个可观察对象的执行，主要用于取消执行。
- 操作符(Operators)： 一些单纯的函数，支持使用map,filter,contact,flatmap等操作符以函数式编程的方式处理处理集合。
- Subject(主题?)：等同于一个事件驱动器，是将一个值或者事件广播到多个观察者的唯一途径。
- Schedulers(调度者?)： 用来控制并发，当计算发生的时候允许我们协调，比如setTimeout,requestAnimationFrame。



next()
Observer 提供一个 next 方法来接收 Observable 流，是一种 push 形式；而 Iterator 是通过调用 iterator.next() 来拿到值，是一种 pull 的形式。

complete()
当不再有新的值发出时，将触发 Observer 的 complete 方法；而在 Iterator 中，则需要在 next 的返回结果中，当返回元素 done 为 true 时，则表示 complete。

error()
当在处理事件中出现异常报错时，Observer 提供 error 方法来接收错误进行统一处理；Iterator 则需要进行 try catch 包裹来处理可能出现的错误。


# 可观察对象(Observable)
## 创建Observable的方式

很多不同的方法都可以创建可观察序列对象。这里是一些普通使用的例子：

|方法|说明|
|-----|----|
|of(arg)	|把参数转换成可观察序列对象|
|from(iterable)	|把可迭代的队列参数转换成可观察序列对象|
|fromPromise(promise)	|把promise对象参数转换成可观察序列对象|
|fromEvent(element, eventName)|	通过增加一个事件监听器用于监听匹配的Dom元素，jQuery元素，Zepto元素，Angular元素，Ember.js元素或者EventEmitter等，来创建可观察序列对象|

流式编程的另一个不同点是触发机制。可观察序列类型对象是后触发的(lazy data types)，就是说当有订阅者订阅的时候什么也不执行（这种方式不会有事件发出来）。它的订阅机制是被观察者(Observer)触发的。

### create

```javascript
var observable = Rx.Observable.create(function(observer) {
observer.onNext('Simon');
observer.onNext('Jen');
observer.onNext('Sergi');
observer.onCompleted(); // 成功完成
})
```

* 与observer的关联

  * observers监听observable，不论何时在Observable中发生了什么事件，它会调用它的observers中相应的方法。
  * observers有三个方法：onNext，onCompleted，onError。
  * onNext：相当于在（1）中observer模式中的Update方法，当observable发射了一个新值它就会被调用。注意到那个名称是如何反应到我们订阅的序列中的，而不是仅仅分离的值。
  * onCompleted：再没有任何有效数据的信号，在onCompleted被调用后，之后的onNext调用将会无效。
  * onError：当observable中发生了错误后将会被调用，在onError被调用后，之后的onNext调用将会无效。 


# 操作符（operator）

> 改变或者查询序列（sequence）的方法叫做操作符

### 根据Arrays创建Observable

```javascript
Rx.Observable
.from(['Adrià', 'Jen', 'Sergi'])
.subscribe(
function(x) { console.log('Next: ' + x); },
function(err) { console.log('Error:', err); }
function() { console.log('Completed'); }
);
```
> from操作符伴随着fromEvent，在RxJS中这是最方便和使用频率最高的操作符。

### 通过js的Event创建Observable

```javascript
var allMoves = Rx.Observable.fromEvent(document, 'mousemove');
allMoves.subscribe(function(e) {
console.log(e.clientX, e.clientY);
});
```

> 把event转化为Observable解开了event本身的强制约束。更重要的是，我们可以基于原始的Observable创建一个新的Observable，并且这些新的Observable是独立的，可以别用于其他的任务：

```javascript
var movesOnTheRight = allMoves.filter(function(e) {
return e.clientX > window.innerWidth / 2;
});
var movesOnTheLeft = allMoves.filter(function(e) {
return e.clientX < window.innerWidth / 2;
});
movesOnTheRight.subscribe(function(e) {
console.log('Mouse is on the right:', e.clientX);
});
movesOnTheLeft.subscribe(function(e) {
console.log('Mouse is on the left:', e.clientX);
});
```

### 根据Callback函数创建Observable

```javascript
var Rx = require('rx'); // Load RxJS
var fs = require('fs'); // Load Node.js Filesystem module
// Create an Observable from the readdir method
var readdir = Rx.Observable.fromNodeCallback(fs.readdir);
// Send a delayed message
var source = readdir('/Users/sergi');
var subscription = source.subscribe(
function(res) { console.log('List of directories: ' + res); },
function(err) { console.log('Error: ' + err); },
function() { console.log('Done!'); });
```

# 序列（sequence）

#### 流式序列化

|方法 |说明|
|--------|---------|
|map(fn)	 |               重新构建observable序列对象为新的形式|
|filter(predicate)	|                通过给定的predicate函数，过滤掉匹配的observable序列对象|
|reduce(accumulator, [seed])	 |               通过收集器函数accumulator返回一个单一结果。seed是收集器的初始化数据。|

#### 处理时间

|名称	|描述|
|-----|-----|
|Rx.Observable.interval(period)	|在每一个时期返回一个可观测序列产生值|
|Rx.Observable.timer(dueTime)	|在dueTime运行后产生一个值,然后在每一个时期返回一个可观测序列|



```javascript
var a = Rx.Observable.interval(200).map(function(i) {
return 'A' + i;
});
var b = Rx.Observable.interval(100).map(function(i) {
return 'B' + i;
});
Rx.Observable.merge(a, b).subscribe(function(x) {
console.log(x);
});
```
》B0, A0, B1, B2, A1, B3, B4…


- map
> map是用的最多的序列转化操作符。

```javascript
const arr = [1,2,3,4,5]
const upper = arr.map(name => name * 2)
upper.forEach((val) => console.log(val))
```

转换为

```javascript
const arr = Rx.Observable.range(1,5)
const upper = arr.map(name => name * 2)
upper.subscribe((val) => console.log(val))
```
> 在某些状况下，map可能不会如期盼的那样工作，对于这些状况，更好的办法是使用flatMap操作符。

- filter

```javascript
const isEven = (val) => val % 2 !== 0
const arr = [1,2,3,4,5]
const even = arr.filter(isEven)
even.forEach((val) => console.log(val))
```
转换为

```javascript
const isEven = (val) => val % 2 !== 0
const arr = Rx.Observable.range(1,5)
const even = arr.filter(isEven)
even.subscribe((val) => console.log(val))
```


- reduce

```javascript
var avg = Rx.Observable.range(0, 5)
.reduce(function(prev, cur) {
return {
sum: prev.sum + cur,
count: prev.count + 1
};
}, { sum: 0, count: 0 })
.map(function(o) {
return o.sum / o.count;
});
var subscription = avg.subscribe(function(x) {
console.log('Average is: ', x);
});
```

-scan

```javascript
var avg = Rx.Observable.interval(1000)
.scan(function (prev, cur) {
return {
sum: prev.sum + cur,
count: prev.count + 1
};
}, { sum: 0, count: 0 })
.map(function(o) {
return o.sum / o.count;
});
var subscription = avg.subscribe( function (x) {
console.log(x);
});
```

- flatMap
- debounceTime

> debounceTime 操作可以操作一个时间戳 TIMES，表示经过 TIMES 毫秒后，没有流入新值，那么才将值转入下一个操作。

- mergeMap

 将请求搜索结果输出回给 Observer 上进行渲染。

- switchMap

 使用 switchMap 替换 mergeMap，将能取消上一个已无用的请求，只保留最后的请求结果流，这样就确保处理展示的是最后的搜索的结果。


