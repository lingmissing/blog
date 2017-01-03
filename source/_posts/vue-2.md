---
title: 【译】 Vue 2.0 的变化（二）
date: 2016-12-09 17:19:21
tags: [vue,javascript]
categories: 前端框架之vue
---
 

### `v-for`迭代语法变化 ###

- 丢弃~~`$index`~~和~~`$key`~~
- 新数组语法
    - value in arr
    - (value, index) in arr
- 新对象语法
    - value in obj
    - (value, key) in obj 
    - (value, key, index) in obj

### 指令接口的改变 ###
<!-- more -->
大体来说，2.0版本中指令大范围的降低功能，它们仅用于低层次的直接dom操作。在多数情况下，你更应该使用组件作为主要的代码重构抽象。

指令不再有实例，这意味着指令中将不存在`this`，并且`bind`, `update`和`unbind`目前将接受任何数据作为参数。

请注意，绑定对象是不可变的。设置`binding.value`没有任何效果。并且在它上面添加属性不会持久，如果你真的非常需要可以在`el`配置上添加指令状态。

```html
<div v-example:arg.modifier="a.b"></div>
```

```javascript
// example directive
export default {
  bind (el, binding, vnode) {
    // the binding object exposes value, oldValue, expression, arg and modifiers.
    binding.expression // "a.b"
    binding.arg // "arg"
    binding.modifiers // { modifier: true }
    // the context Vue instance can be accessed as vnode.context.
  },

  // update has a few changes, see below
  update (el, binding, vnode, oldVnode) { ... },

  // componentUpdated is a new hook that is called AFTER the entire component
  // has completed the current update cycle. This means all the DOM would
  // be in updated state when this hook is called. Also, this hook is always
  // called regardless of whether this directive's value has changed or not.
  componentUpdated (el, binding, vnode, oldVNode) { ... },

  unbind (el, binding, vnode) { ... }
}
```

如果你只关心值可以使用解构：

```javascript
export default {
  bind (el, { value }) {
    // ...
  }
}
```

除此之外，`update`钩子有一些变化：

- 在`bind`之后将不再自动调用
- 当组件重新渲染时总能响应，无论被绑定的值是否发生改变。你可以通过`binding.value === binding.oldValue`比较跳过不必要的更新，但也会有情况下，你希望应用始终更新。例如，当指令绑定到对象那可能希望是变化而不是替代。

`elementDirective`, 指令参数和指令配置，例如`acceptStatement`, `deep`等等
均被删除。

### 过滤器用法和语法变化 ###

在vue 2.0，filter有了一系列的变化：

- filter现在只能用于文本插入（双花括号标签）。在之前我们在指令中使用filter，例如`v-model`，`v-on`等等，导致使用的复杂性，并且在`v-for`上的列表过滤，它更适合迁移到计算性能的js中。
- vue 2.0不提供任何内置过滤器。建议使用独立的方法解决特定域的问题，例如[moment.js][1]用于格式化时间，[accounting.js][2]用于格式化金融货币。也欢迎你来创建自己的过滤器，并与社区分享吧！
- filter语法更改为内嵌的js函数调用，而不是采取空格分割的参数。

    ```javascript
    {{ date | formatDate('YY-MM-DD') }}
    ```
### 过渡组件 ###

#### 过渡CSS的变化 ####

- `v-enter`：在元素插入前应用，1秒后删除。（开始于进入状态）
- `v-enter-active`：在元素插入前应用，当`transition`/`animation`结束时移除。
- `v-leave`：当离开的`transition`触发时正确应用，一秒后删除。（开始于离开状态）
- `v-leave-active`：当离开的`transition`触发时正确应用，当`transition`/`animation`结束时移除。

`v-enter-active`和`v-leave-active`帮助你指定不同的曲线用于进入/离开动画。在多数情况下，升级只需将当前的`v-leave`替换为`v-leave-active`。（对于css动画，使用`v-enter-active`和`v-leave-active`）

#### 过渡API的变化 ####

- `<transition>`组件

所有单元素的过度效果通过使用`<transition>`这个内置组件包装目标元素或组件得到相应的效果。这是一个抽象组件，意味着它不会渲染额外的DOM元素，也不会在组件层次结构中展示。它仅仅用于过渡行为里面的包裹内容。

最简单的用法示例:

```html
<transition>
  <div v-if="ok">toggled content</div>
</transition>
```
该组件定义了一些属性和事件，直接映射到旧版的过渡定义选项。

##### 属性 #####

- name: String
    - 用于自动生成过渡CSS类名。例如，`name: 'fade'`将会自动生成 `.fade-enter`、`.fade-enter-active`等等。默认是`v`。
- appear: Boolean
    - 是否在最初的渲染应用的过渡。（默认值`false`）
- css: Boolean
    - 是否应用css过度类，默认值`true`。如果设置为`false`，只能通过触发组件事件注册的JavaScript钩子。
- type: String
    - 指定等待确定过渡结束时转变的事件类型。可用的值是`transition`和`animation`。默认情况下，它会自动检测一个持续时间较长的类型。
- mode: String
    - 控制离开/进入转换的时序。可用的模式是`in-out`和`out-in`，默认为同步。
- enterClass, leaveClass, enterActiveClass, leaveActiveClass, appearClass, appearActiveClass: String
    - 单独配置的过渡css类

过渡到动态组件的示例：
```html
<transition name="fade" mode="out-in" appear>
  <component :is="view"></component>
</transition>
```

##### 事件 #####

对应的在1.x API中可用的js钩子：
- before-enter
- enter
- after-enter
- before-leave
- leave
- after-leave
- before-appear
- appear
- after-appear

例子：

```html
<transition @after-enter="transitionComplete">
  <div v-show="ok">toggled content</div>
</transition>
```
当进入的过渡效果完成时，组件的`transitionComplete`方法将会在过渡DOM元素作为参数被调用。

一些注意事项：
- `leave-cancelled`在插入删除中不可用。一旦离开的过渡效果开始，将不能被取消。但是仍然可用于`v-show`。
- 和1.0类似，对于`enter`和`leave`钩子，在`cb`作为第二个参数的存在下表示使用者想要过渡结束时间的明确控制。

##### `<transition-group>`组件 #####
所有的多元素过渡效果通过使用`<transition-group>`内置组件包装元素应用。它暴露了和`<transition>`一样的属性和事件。不同之处在于：

 1. 不同于`<transition>`,`<transition-group>`渲染一个真实的DOM元素。默认是渲染一个`<span>`标签，并且你可以配置哪些元素应该通过标记的属性呈现。你也可以使用`is`特性，例如`<ul is="transition-group">`。
 2. `<transition-group>`不支持`mode`属性。
 3. `<transition-group>`下的子组件必须有唯一的key。

例子：
```html
<transition-group tag="ul" name="slide">
  <li v-for="item in items" :key="item.id">
    {{ item.text }}
  </li>
</transition-group>
```

#### 创建可重用的转换 ####

现在`transitions`能够通过组件应用，它们补在被视为一种单独类型，因此全局的`Vue.transition()`方法和`transition`配置都被丢弃。你可以通过组件的属性和方法配置内嵌的过渡。但是，我们现在怎么创建可重复使用的过渡效果，尤其是那些自定义的js钩子？答案是创建自己的过渡组件（它们特别适合作为功能组件）：
```javascript
Vue.component('fade', {
  functional: true,
  render (createElement, { children }) {
    const data = {
      props: {
        name: 'fade'
      },
      on: {
        beforeEnter () { /* ... */ }, // <-- Note hooks use camelCase in JavaScript (same as 1.x)
        afterEnter () { /* ... */ }
      }
    }
    return createElement('transition', data, children)
  }
})
```
你可以这么使用：

```html
<fade>
  <div v-if="ok">toggled content</div>
</fade>
```

### `v-model`的变化 ###
- `lazy`和`number`参数现在是修饰符。
    ```html
    <input v-model.lazy="text">
    ```
- 新的修饰符：`.trim`-修整输入，顾名思义
- `debounce`参数被丢弃
- `v-model`不再关心初始值。它始终将data的数据作为资源。这意味着数据将是以1呈现而不是2.

    ```javascript
data: {
    val: 1
}
    ```

    ```html
    <input v-model="val" value="2">
    ```
- 当使用`v-for`时，`v-model`不再生效。
    ```html
    <input v-for="str in strings" v-model="str">
    ```
### Refs ###
- `v-ref`现在不再是一个指令，而是一个类似于`key`的属性

    ```html
<!-- before -->
<comp v-ref:foo></comp>

<!-- after -->
<comp ref="foo"></comp>
     ```
依然支持动态绑定：

    ```html
<comp :ref="dynamicRef"></comp>
    ```
- `vm.$els`和`vm.$refs`合并了。在正常元素上使用是DOM元素，在组件上使用是组件实例。

### 杂项 ###
- `track-by`已经被`key`替代。对于绑定属性它遵守相同的规则，没有`v-bind:`或者`:`字头，它被视为普通字符串。大多数情况下需要动态绑定，如下：
    ```html
<!-- 1.x -->
<div v-for="item in items" track-by="id">

<!-- 2.0 -->
<div v-for="item in items" :key="item.id">
    ```
- 内插值属性已被弃用。
    ```html
<!-- 1.x -->
<div id="{{ id }}">

<!-- 2.0 -->
<div :id="id">
    ```

- 属性绑定行为变化：当绑定属性时，只有`null`、`undefine`和`false`被认为是`false`。这意味着0和空字符串依旧呈现出原来的样子。对于枚举属性，`:draggable="''"`将被渲染为`draggable="true"`。
另外，对于枚举属性，除了上述`false`的值，`false`字符串也会被渲染为`attr="false"`。
- 当使用一个自定义组件，`v-on`只听自定义事件`$emitted`挂载在组件上。（不再监听DOM事件）
- `v-else`不再适用于`v-show`，请使用其他的否定表达式。
- 单次绑定只能使用`v-once`。
- `Array.prototype.$set`/`$remove`被丢弃（使用`Vue.set`或者`Array.prototype.splice`）。
- `:style`不再支持`!import`。
- `root`实例不能使用`props`（请使用`propsData`）
- 在`Vue.extend`中`el`配置项不能被使用,它现在只能被用作一个实例创建选项。
- 在vue的实例中不能使用`Vue.set`和`Vue.delete`
### 升级小提示
#### 如何处理丢弃的`$dispatch`和`$broadcast`？
我们弃用`$dispatch`和`$broadcast`的原因在于依赖组件树结构的事件流，当组件树变得很大时很难推理（简单地说：它不能在大型应用很好地扩展，我们不希望以后给你设置痛点）。`$dispatch`和`$broadcast`不能解决同级组件之间的通信。从而，你可以使用和node中的`EventEmitter`类似的模式：一个允许组件通信的集中事件枢纽，无论他们在组件树的任何地方。因为vue的实例实现了事件发射接口，你可以使用空的vue实例达到目的：
```javascript
var bus = new Vue()
```
```javascript
// in component A's method
bus.$emit('id-selected', 1)
```
```javascript
// in component B's created hook
bus.$on('id-selected', this.someMethod)
```
并且不要忘记使用`$off`解绑事件：
```javascript
// in component B's destroyed hook
bus.$off('id-selected', this.someMethod)
```
这种模式在简单的场景中可以作为`$dispatch`和`$broadcast`的替代。但是在复杂的场景中，建议使用`vuex`建立一个专门的状态管理层。
#### 如何处理数组中filter的弃用？
对于使用`v-for`进行列表过滤-过滤器常见用法之一-现在建议使用`computed`属性返回原始数组的一个副本（查阅[更新数据例子][3]）。好处在于你不再受到`filter`语法的限制，现在它只是普通的javascript，并且你可以正常访问过滤结果，因为它只是一个计算的属性。
#### 如何处理在`v-model`中`debounce`的丢弃？
`debounce`用于我们多久执行异步请求和其他操作，在`v-model`中使用十分容易，但这样也延迟了状态更新带来了限制。
当在设计一个搜索功能时这个限制变得很明显，看看这个[例子][4]，使用`debounce`属性，在搜索之前没法检测脏数据，因为我们不能访问输入的实时状态。
> 未完待续....
---


> 翻译自[2.0 Changes][5]


  [1]: http://momentjs.com/
  [2]: http://openexchangerates.github.io/accounting.js/
  [3]: https://github.com/vuejs/vue/blob/next/examples/grid/grid.js#L21-L41
  [4]: https://jsbin.com/zefawu/3/edit?html,output
  [5]: https://github.com/vuejs/vue/issues/2873