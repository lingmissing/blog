title: 前端函数式编程
date: 2017-08-16 22:19:15
categories: [FP]
tags: [FP, React, Redux]
---
前言：这个其实是我最近打算在在团队做的一个分享，这个分享将会聊聊函数式编程在前端的一些成熟的应用以及尝试。
<!-- more -->
## Something interesting
### 罗素悖论
在讲罗素悖论之前，先提一个小的需求，看看大家能不能实现：
> 设计出一个函数`f`，接受一个函数`g`作为参数，返回布尔值。
函数`f`判断`g`会不会导致死循环，会则返回`true`，不会则返回false。

如果学过离散数学的同学可能就会想起来了，这便是著名的**图灵机停机问题**。这个需求看似描述很完备，有输入输出的要求，也有函数功能的要求，但这个需求是不可实现的。  
证明很简单：假设存在满足上述要求的函数`f`，那么我们定义一个邪恶的函数`evil`，其伪代码定义如下：
``` JavaScript
function evil() {
	if (f(evil) == true) {
		return 0
	} else {
		while(true) {}
	}
}
```
于是这里便产生了悖论：如果`f`判定`evil`不会死循环，`evil`就会死循环；反之则不会死循环。所以假设不成立，即不存在符合要求的`f`。  

类似的悖论还有著名的理发师悖论：理发师给所有不给自己理发的人理发。  
不可解的`停机问题`其实便是**哥德尔不完备定理**的一种形式。

### Lambda (λ) 演算
> Lambda演算可以被称为最小的通用程序设计语言。它包括一条变换规则（变量替换）和一条函数定义方式，Lambda演算之通用在于，任何一个可计算函数都能用这种形式来表达和求值。因而，它是等价于图灵机的。尽管如此，Lambda演算强调的是变换规则的运用，而非实现它们的具体机器。可以认为这是一种更接近软件而非硬件的方式。 --from Wikipedia

这里我不会去讲太多关于Lambda演算的内容，一个原因是在没有一些相关的数理逻辑的前置知识的前提下很难三言两语之内将其描述清楚，另一个原因是我自己也不是很懂（笑。  

那么为什么会提到Lambda演算呢？在图灵机的停机问题之前，有一个更加有趣的问题：能否判断两个lambda演算表达式是否等价，这个问题和图灵机停机问题同属于判定性问题。邱奇运用λ演算在1936年给出判定性问题一个否定的答案。  
最重要的，Lambda演算对函数式编程语言有巨大的影响，比如Lisp语言、ML语言和Haskell语言。而通过这些，我们将引入今天的主要话题：函数式编程。但是注意的是，今天我讲的将会是偏前端方向的应用，而不会去过度的探讨演算、或者是范畴论等知识。

## 语言层面
首先放出我的观点：**JavaScriprt 适合也不适合函数式编程**。
### 适合函数式编程
JavaScript是一门多范式的语言，我们很难去说JS到底是面向过程还是面向对象的语言，甚至我们也可以说JS就是一门函数式语言。但是这一切并不是矛盾的，OOP与FP完全可以结合起来使用。  

对于函数式语言的定义其实没有明确的界限，没有说一定要有Monad，或者是Hindley-Milner类型系统等等。JS中函数是一等对象，所以完全可以认为JS是一门函数式编程语言，而且JS的灵活性允许我们去模拟常见函数式语言中的大多数操作。

- 纯函数 无副作用
> 此函数在相同的输入值时，需产生相同的输出。函数的输出和输入值以外的其他隐藏信息或状态无关，也和由I/O设备产生的外部输出无关。  
该函数不能有语义上可观察的函数副作用，诸如“触发事件”，使输出设备输出，或更改输出值以外物件的内容等。

- 不可变数据
> Immutable Data是指一旦被创造后，就不可以被改变的数据。

也许大家会产生疑惑，没有变量应用怎么跑起来？这里注意的是虽然没有变量，但是会有绑定的概念，数据虽然不可变，但是绑定可变。  

JS本身提供了一个`Object.freeze()`方法，但是类似浅拷贝，它只是一层浅`freeze`，所以如果真的要去`freeze`一个对象，必须一层层递归`freeze`处理。  

这样做虽然可以实现不可变，但是无论做不做`freeze`处理，每次都产生一个新的对象会带来大量的中间变量，这一点后面我讲到Redux的时候也会提到，如果使用过Redux，相信应该知道这个问题，`Object.assign`会带来大量的中间对象，影响性能，而解决方案就是Immutable.js。  
Immutable.js是一个不可变数据结构的JS库，它的原理其实也很简单，借助字典树，共享了不变的部分。有兴趣的同学可以读一读一篇著名的文章《Understanding Clojure's Persistent Vectors》，Immutable.js的实现原理与Clojure的数据结构底层实现非常相似。下面的Redux环节我还会提到这个问题。

- 递归  
循环和循环是常见的流程控制方式，在绝大多数场景下两者是可以等价互换的。  
递归的优点在于代码简洁、清晰，并且容易验证正确性。在一些函数式语言中，即使存在流程控制语句`if` `else`等等，他们也只是函数的语法糖。  

- curry / compose / ...  
这些虽然JS没有直接提供，但是已经有足够多的第三方库可以来做这个工作，例如 Underscore / Lodash / Ramda。这些函数的实现也可以阅读上述库的源码来学习。

- 惰性求值  
惰性求值可以最小化计算机要做的工作。JS中有着一小部分表达式是属于惰性求值的，例如`||`和`&&`，这也是所谓的“短路原理”：
``` JavaScript
let i = 1
true || i++
false && i++
console.log(i) // 1
```
但是语言直接提供的这点惰性实在是太可怜了，JS中也基本都是立即求值。  
这里拿Haskell举个例子：
``` Haskell
Prelude> import Data.List
Prelude Data.List> take 10 $ sort [100, 99..0] :: [Int]
-- [0,1,2,3,4,5,6,7,8,9]
```
简单介绍下，`[Int]`是类型标注，表示返回的是一个整型列表；`[100, 99..0] `代表生成一个等差的列表；`sort`是排序；`$`是一个中缀函数，可以理解为把右边部分括起来。  
这段代码的意思是生成一个100到0的等差数列，把这个等差列表从小到大排序并取出前十个。如果在JavaScript中的等价的代码应该类似如下：
``` JavaScript
const arr = []
for (let i = 100; i >= 0; i--) {
	arr.push(i)
}
arr.sort((a, b) => a - b)
console.log(arr.splice(0, 10))
// [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
```
无论是什么JS引擎，这段JS代码在执行的时候都会把这个数组的所有元素都遍历一遍；相反的是上面的Haskell代码在执行的时候，Haskell的编译器GHC只会尝试去计算刚好足够取出需要的10个元素为止。所以，在Haskell中，我们完全可以定义出无限长度的数组，然后设法取出其中的一部分，GHC也会在底层通过一些黑魔法来帮助实现。  

让我们回到JS：在ES6之前，模拟惰性求值的方式一般是thunk函数，或者借助Stream抽象。所幸ES6使得JS拥有了强大的`generator`函数，我们现在还可以借助它模拟惰性求值。  

具体的实现可以阅读参考文献中的文章，也有现成的库例如Lazy.js可以使用，这里不再赘述。  

但是注意的是，惰性求值可以为我们带来较好的性能，也可以导致性能下降。大量的延迟求值，可能会带来内存的消耗积压。Haskell中这个现象称为任务堆积，所以即便是默认惰性求值的Haskell，也为使用者提供了强制立即求值的方法，有兴趣的同学可以自行学习一些Haskell的知识。

### 不适合函数式编程
- 递归  
在JS中，递归容易导致一个致命的问题：**爆栈**。  
尾递归优化可以使得尾递归在编译时被优化为循环从而避免爆栈，但是到目前为止，JS是没有什么正儿八经的尾递归优化的，当然我们有着`Trampolining`这样的奇技淫巧可以巧妙的避免爆栈，但是每一层的转换消耗的匿名函数开销也是不可小觑：
``` JavaScript
function trampoline(f) {
  return function() {
    var result = f.apply(this, arguments);
    while (result instanceof Function) {
      result = result();
    }
    return result;
  };
}
var reduce = trampoline(function myself(f, list, sum) {
  if (list.length < 1) {
    return sum;
  } else {
    return function() {
      var val = list.shift();
      return myself(f, list, f(val, list));
    };
  }
});
```
上面这段代码来自贺老在今年的FP China会议上的分享STC VS PTC。
ES6早已规定了JS应该有尾递归的优化，但是大家迟迟不去实现，主要是尾递归优化的STC与PTC之争：
PTC:
``` JavaScript
function sum(n, total = 0) {
	if (n === 0) return total
	else return sum(n - 1, total + n)
}
```
PTC目前只有Safari支持，V8可以通过flag开启。STC的问题在于不知道写对了没有，开发时不爆栈不代表生产环境不爆栈，以及很难以调试。
STC:
``` JavaScript
function factorial(n, acc = 1) {
  if (n === 1) {
    return acc;
  }
  return continue factorial(n - 1, acc * n)
}
```
STC通过新的语法，保证不写对就会报错，但是新的语法会引入维护等一些问题。  
所以因为STC与PTC之争，至今JS仍没有一个可靠的尾递归优化。

- 纯函数难以保证
在Haskell、Clojure等语言中，会有语言或者是编译的层面去做纯度的保障，但是在JS中，这一切只能靠我们自己来做约束，在多人合作的时候很难保证不会有坑。

- 弱类型，难以模拟类型系统
- 没有 monadic io
- 。。。

## 架构层面
事实上，随着RxJS、React全家桶等受函数式影响的库的崛起，前端可以说是工程里应用函数式最为成熟的领域之一了。目前应用函数式比较广泛的领域还有金融（Haskell、Erlang等等），大数据（Scala）。
### React全家桶
首先，**这不是一个React全家桶相关的入门介绍文章**，理解接下来的内容期望你至少有一些React的相关开发经验，有一些Redux的开发经验就更棒了！

- React
先说说React，提及React，大家想到的往往是V-DOM，以至于Vue2在引入V-DOM后，两者已经极其相似了，事实上两者在设计思想上有一个很大的区别，在于React更加追求纯度，Vue的作者尤雨溪也曾明确表示Vue并不像React那样追求纯度。

相信大家都知道语法糖，这是指简化的语法，鼓励大家使用，例如ES6的Class、Arrow Function等等都是语法糖。那么不知道你有没有思考过，为什么React的生命周期函数的名字那么长？为什么React直接输出HTML的API名字`dangerouslySetInnerHTML`那么长？  
这其实是一个很古老的API设计，叫做**语法盐**，与语法糖相反，它设计出让人感觉难用的API，让使用者在使用前多加思考是不是真的需要使用这些API，从而避免写出低质量的代码设计。

既然React不鼓励使用生命周期函数，那么React鼓励的是什么呢？答案是**Pure Component**。
React鼓励你去从一个不变的角度思考组件，如果你的组件无须设定生命周期钩子函数，那么你的组件类可以继承`PureComponent`而非普通的`Component`，`PureComponent`会自动去做`shouldComponentUpdate()`的判断优化。
但是`PureComponent`并非万能的灵药，先抛去其浅对比（shallowly compare）`state / prop`的缺陷不谈，一个应用怎么可能避免不了状态呢？React并不管，它只管给定状态就能做到幂等渲染，虽然保证了自身的纯度，却把状态的问题抛回给了用户。

- Redux
这是社区对React应用的数据层解决方案。这里我也不会去讲Flux架构入门基础，更不会去讲其被讲烂了的Pub/Sub设计模式。

接触过Redux的一定会对Redux中反复提及`reducer`纯函数、`state`不可变等函数式的概念印象深刻；如果读过Redux的源码，你会发现Redux内部通过`compose`以极低的代码成本实现了洋葱模型的中间件。

除去这些函数式风格的API，和函数式的实现，更重要的是Redux实现了一套CQRS + ES软件架构。
CQRS全称Command Query Responsibility Segregation，即命令查询职责分离；ES全称Event Sourcing，即事件溯源。为什么会提CQRS + ES架构呢？因为目前为止，可以看到的基于函数式的大型项目至少一半都是基于这套架构，

下面我简单的讲一下这一套架构，CQRS其实就是读写分离，相信了解过数据库的同学不会对这个概念陌生，在分布式数据库中，通常借助读写分离来保证性能，这也是CQRS最常见的应用场景之一；ES则是不保存对象的最新状态，而是保存对象产生的所有事件，通过事件溯源（Event Sourcing，ES）得到对象最新状态。在Redux中，C端采用Event Sourcing的技术，在EventStore中存储事件；Q端存储对象的最新状态，用于提供查询支持。

ES近年来在并发编程领域应用的也非常多，例如Scala异步编程库Akka，基于Actor异步编程模型结合了ES。这种架构可以避免状态的竞争和锁，以少量的实时性损耗换取了可靠性，不会出现同时更新一个数据的问题。但是现在前端的复杂度还没有达到分布式场景下后端及数据库的程度，所以现在可能还不能去感受到这套架构带来的好处。

但是Redux借助CQRS+ES，带来的一个直观的好处就是调试工具的使用，相信使用过的同学一定对时光旅行这个功能印象深刻，可以随意的调节得到每个时刻的应用状态。其实现依赖于在Redux中`Action`就是`Event`，`Reducer`就是状态转换，根据初始`State`和`Event`记录，可以推算出每一个时刻的状态。

说了这么多，Redux带来的坏处是什么呢？主要有两点：
第一点，在实际的开发中，我们的操作并非都是同步的，几乎是到处充斥着异步操作，而Redux为了保证自身的纯度，把不可靠的异步问题再一次抛给了用户；第二点，JS的数据结构并非天生的不可变，`reducer`函数为了追求不可变，大量使用`Object.assign()`来创建新的状态对象（例如下面这段代码，来自Redux文档），所以会产生很多的中间状态变量，带来性能问题：
``` JavaScript
function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return Object.assign({}, state, {
        visibilityFilter: action.filter
      })
    case ADD_TODO:
      return Object.assign({}, state, {
        todos: [
          ...state.todos,
          {
            text: action.text,
            completed: false
          }
        ]
      })
    default:
      return state
  }
}
```

对于上面两点，第一点社区的解决方案是redux-thunk、redux-saga、redux-observable，第二点则是Immutable.js。
- redux-thunk，redux-saga，redux-observable  
这一块其实我不是很熟悉，也没有真正在业务中尝试使用过这些方案，就不献丑了，推荐阅读参考资料里的《Redux Thunk vs Saga vs Observable》，当然也期待有同学能够积极分享自己的经验。

- Immutable.js  
Immutable.js事实上是和React一起出来的，只是React的光芒掩盖了Immutable.js，直到Redux引入了性能问题，大家才想到了Immutable.js。其实关于Immutable.js也没啥好介绍的，API看官网即可，其实现则可以参考阅读Clojure的数据结构实现。

### Reactive Programming 响应式编程
讲FP牵扯到RP很大的原因是因为大多数场景下RP和FP息息相关着。
这一块我还欠缺很多，所以暂时不讲太多。

- FRP vs F&RP  
两者区别在于：FRP是基于时间连续的，RP是基于时间离散的。

- Rx.js  
Rx不是FRP，而是F&RP，因为Rx并不强调时间的作用，只是借助了函数式编程的一些思想让API变得更加优雅。
为什么我们会需要Rx.js呢？推荐阅读《单页应用的数据流方案探索》

- Cycle.js  
循环依赖问题  
函数不动点模型

- Elm  
受Haskell影响  
影响了Redux

# 参考资料

## 递归
- [STC vs PTC](http://johnhax.net/2017/stc-vs-ptc/#0)
- [[译]All About Recursion, PTC, TCO and STC in JavaScript](https://zhuanlan.zhihu.com/p/26941235)

## 惰性求值
- [如何用 JavaScript 实现一个数组惰性求值库](https://zhuanlan.zhihu.com/p/26535479)
- [js中的Stream实现](https://zhuanlan.zhihu.com/p/26587745)

## CQRS
- [CQRS](https://martinfowler.com/bliki/CQRS.html)
- [Redux and it's relation to CQRS (and other things)](https://github.com/reactjs/redux/issues/351)
- [Akka persistence == event sourcing in 30 minutes](https://www.slideshare.net/ktoso/akka-persistence-event-sourcing-in-30-minutes)

## Redux异步解决方案
- [Redux Thunk vs Saga vs Observable](http://slides.com/dabit3/deck-11-12#/)

## 不可变数据
- [函数式编程所倡导使用的「不可变数据结构」如何保证性能？](https://www.zhihu.com/question/53804334)
- [Understanding Clojure's Persistent Vectors, pt. 1](http://hypirion.com/musings/understanding-persistent-vector-pt-1)
- [Understanding Clojure's Persistent Vectors, pt. 2](http://hypirion.com/musings/understanding-persistent-vector-pt-2)
- [Understanding Clojure's Persistent Vectors, pt. 3](http://hypirion.com/musings/understanding-persistent-vector-pt-3)

## Rx
- [Clarify the differences between Functional Reactive Programming and Reactive Extensions](https://github.com/ReactiveX/reactivex.github.io/issues/130)
- [Hello RxJS](https://zhuanlan.zhihu.com/p/23331432)

## 综合
- [前端开发js函数式编程真实用途体现在哪里？](https://www.zhihu.com/question/59871249/answer/170400954)
- [为什么说 JavaScript 不擅长函数式编程](https://zhuanlan.zhihu.com/p/24076438)
- [单页应用的数据流方案探索](https://zhuanlan.zhihu.com/p/26426054)
