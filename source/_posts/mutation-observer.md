title: MutationObserver 监听 DOM 树变化
date: 2019-01-08 10:32:07
tags: [javascript]

---

`MutationObserver` 是用于代替 `MutationEvents` 作为观察 `DOM` 树结构发生变化时，做出相应处理的 `API` 。为什么要使用 `MutationObserver` 去代替 `MutationEvents` 呢，我们先了解一下 `MutationEvents`

<!-- more -->

## MutationEvents

它简单的用法如下：

```js
document.getElementById('list').addEventListener(
  'DOMSubtreeModified',
  () => {
    console.log('列表中子元素被修改')
  },
  false
)
```

```js
// Mutation 事件列表
DOMAttrModified // 监听元素的修改
DOMAttributeNameChanged
DOMCharacterDataModified
DOMElementNameChanged
DOMNodeInserted // 监听新增
DOMNodeRemoved // 监听删除
DOMNodeInsertedIntoDocument
DOMSubtreeModified // 监听子元素的修改
```

其中 `DOMNodeRemoved` ，`DOMNodeInserted` 和 `DOMSubtreeModified`分别用于监听元素子项的删除，新增，修改(包括删除和新增），`DOMAttrModified` 是监听元素属性的修改，并且能够提供具体的修改动作。

**Mutation Events 遇到的问题**

- IE9 不支持 `MutationEvents`。Webkit 内核不支持 `DOMAttrModified` 特性，`DOMElementNameChanged` 和 `DOMAttributeNameChanged` 在 Firefox 上不被支持。
- 性能问题 1. `MutationEvents` 是同步执行的，它的每次调用，都需要从事件队列中取出事件，执行，然后事件队列中移除，期间需要移动队列元素。如果事件触发的较为频繁的话，每一次都需要执行上面的这些步骤，那么浏览器会被拖慢。 2. `MutationEvents` 本身是事件，所以捕获是采用的是事件冒泡的形式，如果冒泡捕获期间又触发了其他的 `MutationEvents` 的话，很有可能就会导致阻塞 Javascript 线程，甚至导致浏览器崩溃。

## Mutation Observer

`MutationObserver` 是在 `DOM4` 中定义的，用于替代 `MutationEvents` 的新 API，它的不同于 events 的是，所有监听操作以及相应处理都是在其他脚本执行完成之后异步执行的，并且是所以变动触发之后，将变得记录在数组中，统一进行回调的，也就是说，当你使用 `observer` 监听多个 DOM 变化时，并且这若干个 DOM 发生了变化，那么 `observer` 会将变化记录到变化数组中，等待一起都结束了，然后一次性的从变化数组中执行其对应的回调函数。

**特点**

- 所有脚本任务完成后，才会运行，即采用异步方式
- DOM 变动记录封装成一个数组进行处理，而不是一条条地个别处理 DOM 变动。
- 可以观察发生在 DOM 节点的所有变动，也可以观察某一类变动

目前，Firefox(14+)、Chrome(26+)、Opera(15+)、IE(11+) 和 Safari(6.1+) 支持这个 API。 Safari 6.0 和 Chrome 18-25 使用这个 API 的时候，需要加上 WebKit 前缀（WebKitMutationObserver）。可以使用下面的表达式检查浏览器是否支持这个 API。

```js
var MutationObserver =
  window.MutationObserver ||
  window.WebKitMutationObserver ||
  window.MozMutationObserver
// 监测浏览器是否支持
var observeMutationSupport = !!MutationObserver
```

## 如何使用 MutationObserver

在应用中集成 `MutationObserver` 是相当简单的。通过往构造函数 `MutationObserver` 中传入一个函数作为参数来初始化一个 `MutationObserver` 实例，该函数会在每次发生 DOM 发生变化的时候调用。`MutationObserver` 的函数的第一个参数即为单个批处理中的 DOM 变化集。每个变化包含了变化的类型和所发生的更改。

```js
var mutationObserver = new MutationObserver(function(mutations) {
  mutations.forEach(function(mutation) {
    console.log(mutation)
  })
})
```

创建的实例对象拥有三个方法：

- `observe` －开始进行监听。接收两个参数－要观察的 DOM 节点以及一个配置对象。
- `disconnect` －停止监听变化。
- `takeRecords` －触发回调前返回最新的批量 DOM 变化。

### observer 方法

observer 方法指定所要观察的 DOM 元素，以及要观察的特定变动。

```js
var article = document.querySelector('article')
observer.observer(article, {
  childList: true,
  arrtibutes: true
})
```

上面代码分析：

1. 指定所要观察的 DOM 元素 article
2. 指定所要观察的变动是子元素的变动和属性变动。
3. 将这两个限定条件作为参数，传入`observer` 对象 `observer`方法。

### disconnect 方法

- disconnect 方法用来停止观察。发生相应变动时，不再调用回调函数。

```js
var MutationObserver =
  window.MutationObserver ||
  window.WebKitMutationObserver ||
  window.MozMutationObserver
// 选择目标节点
var target = document.querySelector('#some-id')
// 创建观察者对象
var observer = new MutationObserver(function(mutations) {
  mutations.forEach(function(mutation) {
    console.log(mutation.type)
  })
})
// 配置观察选项:
var config = { attributes: true, childList: true, characterData: true }
// 传入目标节点和观察选项
observer.observe(target, config)
// 随后,你还可以停止观察
observer.disconnect()
```

### takeRecord 方法

takeRecord 方法用来清除变动记录，即不再处理未处理的变动。

在观察者对象上调用 `takeRecords` 会返回 其观察节点上的变化记录(MutationRecord)数组。其中 `MutationRecord` 数组也会作为，观察者初始化时的回调函数的第一个参数。

其包含的属性如下：

- type 如果是属性发生变化,则返回 `attributes`.如果是一个`CharacterData` 节点发生变化,则返回 `characterData` ,如果是目标节点的某个子节点发生了变化,则返回 `childList` .
- target 返回此次变化影响到的节点,具体返回那种节点类型是根据 type 值的不同而不同的,如果 type 为 `attributes` ,则返回发生变化的属性节点所在的元素节点,如果 type 值为 `characterData` ,则返回发生变化的这个 characterData 节点.如果 type 为 `childList` ,则返回发生变化的子节点的父节点.
- addedNodes 返回被添加的节点
- removedNodes 返回被删除的节点
- previousSibling 返回被添加或被删除的节点的前一个兄弟节点
- nextSibling 返回被添加或被删除的节点的后一个兄弟节点
- attributeName 返回变更属性的本地名称
- oldValue 根据 type 值的不同,返回的值也会不同.如果 type 为 attributes,则返回该属性变化之前的属性值.如果 type 为 characterData,则返回该节点变化之前的文本数据.如果 type 为 childList,则返回 null

```js
observer.takeRecord()
```

## MutationObserver 类型

`MutationObserver` 所观察的 DOM 变动（即上面代码的 option 对象），包含以下类型：

- childList：子元素的变动
- attributes：属性的变动
- characterData：节点内容或节点文本的变动
- subtree：所有下属节点（包括子节点和子节点的子节点）的变动

> 想要观察哪一种变动类型，就在 option 对象中指定它的值为 true。
> 需要注意的是，不能单独观察 subtree 变动，必须同时指定 childList、attributes 和 characterData 中的一种或多种。

除了变动类型，option 对象还可以设定以下属性：

- attributeOldValue：值为 true 或者为 false。如果为 true，则表示需要记录变动前的属性值。
- characterDataOldValue：值为 true 或者为 false。如果为 true，则表示需要记录变动前的数据值。
- attributesFilter：值为一个数组，表示需要观察的特定属性（比如['class', 'str']）。

创建 `MutationObserver` 并 获取 dom 元素，定义回调数据。

```js
// 获取MutationObserver，兼容低版本的浏览器
var MutationObserver =
  window.MutationObserver ||
  window.WebKitMutationObserver ||
  window.MozMutationObserver
// 获取dom元素
var list = document.querySelector('ol')
// 创建Observer
var Observer = new MutationObserver(function(mutations, instance) {
  console.log(mutations)
  console.log(instance)
  mutations.forEach(function(mutation) {
    console.log(mutation)
  })
})
```

- 子元素的变动

```js
Observer.observe(list, {
  childList: true,
  subtree: true
})
// 追加div标签
list.appendChild(document.createElement('div'))
// 追加文本
list.appendChild(document.createTextNode('foo'))
// 移除第一个节点
list.removeChild(list.childNodes[0])
// 子节点移除创建的div
list.childNodes[0].appendChild(document.createElement('div'))
```

- 监测 characterData 的变动

```js
Observer.observe(list, {
  childList: true,
  characterData: true,
  subtree: true
})
// 将第一个子节点的数据改为cha
list.childNodes[0].data = 'cha'
```

- 监测属性的变动

```js
Observer.observe(list, {
  attributes: true
})
// 设置节点的属性  会触发回调函数
list.setAttribute('data-value', '111')
// 重新设置属性 会触发回调
list.setAttribute('data-value', '2222')
// 删除属性 也会触发回调
list.removeAttribute('data-value')
```

- 属性变动前，记录变动之前的值

```js
Observer.observe(list, {
  attributes: true,
  attributeOldValue: true
})
// 设置节点的属性  会触发回调函数
list.setAttribute('data-value', '111')
// 删除属性
list.setAttribute('data-value', '2222')
```

- characterData 变动时，记录变动前的值。

```js
Observer.observe(list, {
  childList: true,
  characterData: true,
  subtree: true,
  characterDataOldValue: true
})
// 设置数据 触发回调
list.childNodes[0].data = 'aaa'
// 重新设置数据 重新触发回调
list.childNodes[0].data = 'bbbb'
```

- attributeFilter {Array} 表示需要观察的特定属性 比如 ['class', 'src']；

```js
Observer.observe(list, {
  attributes: true,
  attributeFilter: ['data-value']
})
// 第一次设置属性 data-key 不会触发的，因为data-value 不存在
list.setAttribute('data-key', 1)
// 第二次会触发
list.setAttribute('data-value', 1)
```

## 案例分析—demo 编辑器

下面我们做一个简单的 demo 编辑器：

1. 首先给父级元素 `ol` 设置 `contenteditable` 让容器可编辑；
2. 然后构造一个 `observer` 监听子元素的变化；
3. 每次回车的时候，控制台输出它的内容；

```html
<div id="demo">
  <ol contenteditable style="border: 1px solid red">
    <li>111111</li>
  </ol>
</div>
```

```js
const MutationObserver =
  window.MutationObserver ||
  window.WebKitMutationObserver ||
  window.MozMutationObserver
const list = document.querySelector('ol')
const Observer = new MutationObserver((mutations, instance) => {
  mutations.forEach(mutation => {
    if (mutation.type === 'childList') {
      const list_values = [].slice
        .call(list.children)
        .map(node => node.innerHTML)
        .filter(s => s !== '<br>')
      console.log(list_values)
    }
  })
})
Observer.observe(list, {
  childList: true
})
```

现在我们继续可以做一个类似于 input 和 textarea 中的 `valueChange` 的事件一样的，监听值变化，之前的值和之后的值，如下代码：

```js
const MutationObserver =
  window.MutationObserver ||
  window.WebKitMutationObserver ||
  window.MozMutationObserver
const list = document.querySelector('ol')
const Observer = new MutationObserver((mutations, instance) => {
  mutations.forEach(mutation => {
    const enter = {
      mutation: mutation,
      el: mutation.target,
      newValue: mutation.target.textContent,
      oldValue: mutation.oldValue
    }
    console.log(enter)
  })
})

Observer.observe(list, {
  childList: true,
  attributes: true,
  characterData: true,
  subtree: true,
  characterDataOldValue: true
})
```

> 注意： 对 input 和 textarea 不起作用的。

## 案例分析—编辑器统计字数

```html
<div
  id="editor"
  contenteditable
  style="width: 240px; height: 80px; border: 1px solid red;"
></div>
<p id="textInput">还可以输入100字</p>
```

```js
const MutationObserver =
  window.MutationObserver ||
  window.WebKitMutationObserver ||
  window.MozMutationObserver
const editor = document.querySelector('#editor')
const textInput = document.querySelector('#textInput')
const observer = new MutationObserver(mutations => {
  mutations.forEach(function(mutation) {
    if (mutation.type === 'characterData') {
      const newValue = mutation.target.textContent
      textInput.innerHTML = `还可以输入${1000 - newValue.length}字`
    }
  })
})
observer.observe(editor, {
  childList: true,
  attributes: true,
  characterData: true,
  subtree: true,
  characterDataOldValue: true
})
```
