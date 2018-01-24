title: 将setTimeout函数队列
date: 2016-02-12 14:36:41
categories: JavaScript
tags: [JavaScript]
---
## 问题
先来看一段代码：
```javascript
    setTimeout(function() {
        console.log('3000ms');
    }, 3000);

    console.log('first');

    setTimeout(function() {
        console.log('1000ms');
    }, 1000);

    console.log('second');
```
控制台输出为：
```
first
second
1000ms
3000ms
```

如果我们想让第一个定时器的回调函数执行完再执行第二个定时器的回调函数该怎么做呢？
<!-- more -->
## 分析
JavaScript一开始作为浏览器脚本语言出现，为了避免多线程带来的管理问题，被设计成了单线程，即使是Node.js中的`cluster`以及Web Worker也并没有改变JS单线程的本质。  
单线程意味着阻塞，所有的任务要排队执行，前一个任务未执行完下一个任务是不会执行的。如果有一个任务耗时很长，那么后面的任务也只有干等着。为了解决这个问题，JS内部还有一个消息队列，并采用EventLoop来处理消息队列中的消息。  
在上述栗子中，`setTimeout`会在指定的时间向消息队列中添加一条消息，在消息得到处理的时候也就是回调函数执行的时候，而主线程中的`console.log`不会等待，所以上述栗子中先按顺序执行了两个`console.log`，然后才按照定时分别执行1000ms和3000ms时的回调函数。  
关于JS的单线程的问题这里不做更多解释，想了解更多的话可以看看下面参考中的阮一峰老师的[浏览器的JavaScript引擎](http://javascript.ruanyifeng.com/bom/engine.html)，讲的非常易懂。  

那么上述问题中的需求就是说，如何做到在第一个定时器的回调函数执行后，第二个定时器才开始定时并等待执行回调函数。  
最容易想到了方法就是回调函数。封装定时器，在回调中执行下一个封装函数，但这会导致一个问题，在稍微复杂的情况下，出现“回调地狱”，相信Node.js党应该对回调有着别样的感情。  
So，回调函数并不是一个cool的解决方案。  

这里的另一个思路就是再构造一个函数队列，封装定时器，给定时器加锁，将其锁在一个函数里，只有确认执行结束才会执行队列中的下一个封装的定时器。  

## 方案
在StackOverflow上有个哥们提了个和我一样的问题，其中一个答案给了一个demo，我这里简化了一下：
```javascript
    function recursiveOne(arg1){
        if(arg1){
            arg1 = false;
            setTimeout(function(){recursiveOne(arg1);}, 3000);
        }else{
            console.log("func1 complete");
            coreFunction();
        }
    }

    function recursiveTwo(arg1){
    if(arg1){
            arg1 = false;
            setTimeout(function(){recursiveTwo(arg1);}, 2000);
        }else{
            console.log("func2 complete");
            coreFunction();
        }
    }

    function recursiveThree(arg1){
            if(arg1){
            arg1 = false;
            setTimeout(function(){recursiveThree(arg1);}, 1000);
        }else{
            console.log("func3 complete");
            coreFunction();
        }
    }

    var funcSet = [recursiveOne, recursiveTwo, recursiveThree];
    var funcArgs = [[true], [true], [true]];

    function coreFunction(){
        if(funcSet.length){
            var func = funcSet.shift();
            func.apply(global, funcArgs.shift())
        }
    }
    coreFunction();
```
免去了层层回调，优雅的解决的问题：
```
fun1 complete
fun2 complete
fun3 complete
```

那么在实际开发环境如何可控的操作执行队列和锁呢？  
构造一个入队函数，和出队执行函数：
```javascript
    var funcSet = [],
        funcArgs = [],
        funcCont = [],
        isRunning = false;

    function enQueue(fn, context, args) {
        funcSet.push(fn);
        funcCont.push(context);
        funcArgs.push(args);

        if (!isRunning) {
            isRunning = true;
            coreFunction();
        }
    }

    function coreFunction(){
        if(funcSet.length){
            funcSet.shift().apply(funcCont.shift(), [].concat(funcArgs.shift()));
        }
    }
```

完整的代码实现如下：

```javascript
    function recursiveOne(arg1){
        if(arg1){
            arg1 = false;
            setTimeout(function(){recursiveOne(arg1);}, 3000);
        }else{
            console.log("func1 complete");
            coreFunction();
        }
    }

    function recursiveTwo(arg1){
        if(arg1){
            arg1 = false;
            setTimeout(function(){recursiveTwo(arg1);}, 2000);
        }else{
            console.log("func2 complete");
            coreFunction();
        }
    }

    function recursiveThree(arg1){
            if(arg1){
            arg1 = false;
            setTimeout(function(){recursiveThree(arg1);}, 1000);
        }else{
            console.log("func3 complete");
            coreFunction();
        }
    }

    var funcSet = [],
        funcArgs = [],
        funcCont = [],
        isRunning = false;

    function enQueue(fn, context, args) {
        funcSet.push(fn);
        funcCont.push(context);
        funcArgs.push(args);

        if (!isRunning) {
            isRunning = true;
            coreFunction();
        }
    }

    function coreFunction(){
    if(funcSet.length){
            funcSet.shift().apply(funcCont.shift(), [].concat(funcArgs.shift()));
        }
    }

    enQueue(recursiveOne, this, true);
    enQueue(recursiveTwo, this, true);
    enQueue(recursiveThree, this, true);
```


## 参考
* [浏览器的JavaScript引擎](http://javascript.ruanyifeng.com/bom/engine.html)  
* [How to queue several functions set by setTimeout with JS/jQuery](http://stackoverflow.com/questions/12839488/how-to-queue-several-functions-set-by-settimeout-with-js-jquery)
