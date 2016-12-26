title: vue使用总结
date: 2016-12-23 17:24:56
tags: [vue,javascript]
categories: 前端框架之vue
---
# 模板语法

- 插入文本

  ```javascript
  <div>{{text}}</div>
  ```
- 插入html

  ```javascript
  <div v-html="html"></div>
  ```

# 指令
<!-- more -->

> 指令是带有v-前缀的特殊属性。

- 常用指令
  - `v-if`
  - `v-else`
  - `v-else-if`
  - `v-show`
  - `v-bind`
  - `v-on`
  - `v-once`
  - `v-module`
  ~~

## 缩写

```html
<!-- 完整语法 -->
<a v-bind:href="url"></a>
<!-- 缩写 -->
<a :href="url"></a>
```

```html
<!-- 完整语法 -->
<a v-on:click="doSomething"></a>
<!-- 缩写 -->
<a @click="doSomething"></a>
```

## 注册方式

- 全局注册

  ```javascript
  // 注册一个全局自定义指令 v-focus
  Vue.directive('focus', {
    // 当绑定元素插入到 DOM 中。
    inserted: function (el) {
      // 聚焦元素
      el.focus()
    }
  })
  // 调用
  <input type="text" v-focus>
  ```

- 局部注册

  ```javascript
  directives: {
    focus: {
      // 指令的定义---
    }
  }
  // 调用
  <input type="text" v-focus>
  ```
- 函数简写

  ```javascript
  Vue.directive('color-swatch', function (el, binding) {
    el.style.backgroundColor = binding.value
  })
  ```

## 钩子函数

- `bind` 指令第一次绑定到元素时调用，只调用一次。
- `inserted` 被绑定元素插入父节点时调用。
- `update` 被绑定元素所在的模板更新时调用，而不论绑定值是否变化。
- `componentUpdated`  被绑定元素所在模板完成一次更新周期时调用。
- `unbind` 只调用一次，指令与元素解绑时调用。

参数说明:

- `el` 绑定元素DOM
- `binding`
  - `name`: 指令名，不包括 `v-` 前缀。
  - `value`: 指令的绑定值， 例如： `v-my-directive="1 + 1"`, `value` 的值是 2。
  - `oldValue`: 指令绑定的前一个值，仅在 `update` 和 `componentUpdated` 钩子中可用。无论值是否改变都可用。
  - `expression`: 绑定值的字符串形式。 例如 `v-my-directive="1 + 1"` ， `expression` 的值是 `"1 + 1"`。
  - `arg`: 传给指令的参数。例如 `v-my-directive:foo`， `arg` 的值是 `"foo"`。
  - `modifiers`: 一个包含修饰符的对象。 例如： `v-my-directive.foo.bar`, 修饰符对象 `modifiers` 的值是 `{ foo: true, bar: true }`。
- `vnode`: `Vue `编译生成的虚拟节点。
- `oldVnode`: 上一个虚拟节点，仅在 `update` 和 `componentUpdated` 钩子中可用。

案例

```html
<div id="hook-arguments-example" v-demo:hello.a.b="message"></div>
```

```javascript
Vue.directive('demo', {
  bind: function (el, binding, vnode) {
    var s = JSON.stringify
    el.innerHTML =
      'name: '       + s(binding.name) + '<br>' +
      'value: '      + s(binding.value) + '<br>' +
      'expression: ' + s(binding.expression) + '<br>' +
      'argument: '   + s(binding.arg) + '<br>' +
      'modifiers: '  + s(binding.modifiers) 
  }
})
```

```
name: "demo"
value: "hello!"
expression: "message"
argument: "hello"
modifiers: { "a": true, "b": true }
```


# 修饰符

> 修饰符是以半角句号.指明的特殊后缀

```html
<!-- 修饰符可以串联  -->
<a v-on:click.stop.prevent="doThat"></a>
<!-- 只当事件在该元素本身（而不是子元素）触发时触发回调 -->
<div v-on:click.self="doThat">...</div>
<!-- Alt + C -->
<input @keyup.alt.67="clear">
```

- 事件修饰符
  - .`stop` 阻止单击事件冒泡
  - .`prevent`  提交事件不再重载页面
  - .`capture` 添加事件侦听器时使用事件捕获模式
  - .`self` 只当事件在该元素本身（而不是子元素）触发时触发回调
  - .`once` 只触发一次
- 按键修饰符
  - `.enter` 回车
  - `.tab` tab键
  - `.delete`(捕获 “删除” 和 “退格” 键)
  - `.esc`
  - `.space`
  - `.up`
  - `.down`
  - `.left`
  - `.right`
  - `.ctrl`
  - `.alt`
  - `.shift`
  - `.meta`
- 表单修饰符
  - `.lazy` 在 "change" 而不是 "input" 事件中更新
  - `.number` 只能为数字
  - `.trim` 过滤输入的首尾空格
- `.native` 监听原生事件

# prop

```html
<!-- 传递了一个字符串"1" -->
<comp some-prop="1"></comp>
<!-- 传递实际的数字 -->
<comp v-bind:some-prop="1"></comp>
```

```javascript
// 子元素引用
props: ['size'],
// or 
props: {
  // 基础类型检测 （`null` 意思是任何类型都可以）
  propA: Number,
  // 多种类型
  propB: [String, Number],
  // 必传且是字符串
  propC: {
    type: String,
    required: true
  },
  // 数字，有默认值
  propD: {
    type: Number,
    default: 100
  },
  // 数组／对象的默认值应当由一个工厂函数返回
  propE: {
    type: Object,
    default: function () {
      return { message: 'hello' }
    }
  },
  // 自定义验证函数
  propF: {
    validator: function (value) {
      return value > 10
    }
  }
}
```
- 验证
  - `String`
  - `Number`
  - `Boolean`
  - `Function`
  - `Object`
  - `Array`
 
# 过滤器

# 计算属性

## vs Methord

不经过计算属性，我们可以在 method 中定义一个相同的函数来替代它。对于最终的结果，两种方式确实是相同的。然而，不同的是计算属性是基于它的依赖缓存。计算属性只有在它的相关依赖发生改变时才会重新取值。这就意味着只要 message 没有发生改变，多次访问 reversedMessage 计算属性会立即返回之前的计算结果，而不必再次执行函数。如果你不希望有缓存，请用 method 替代。

## vs watch

如果需要不停监听数据才需要用到watch。

## 计算setter

```javascript
// ...
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
// ...
```

现在在运行 `vm.fullName = 'John Doe'` 时， `setter` 会被调用， `vm.firstName` 和 `vm.lastName` 也会被对应更新。


# 绑定class和style

## 绑定class

```javascript
// 如果isActive为true则显示active属性，控制显示隐藏class
<div v-bind:class="{ active: isActive }"></div>
<div class="static"
     v-bind:class="{ active: isActive, 'text-danger': hasError }">
</div>
```

```javascript
// 直接绑定数据里的对象
<div v-bind:class="classObject"></div>
data: {
  classObject: {
    active: true,
    'text-danger': false
  }
}
```

```javascript
//控制class的名称的变化
<div v-bind:class="[activeClass, errorClass]">
data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}
```

```javascript
// 结合两者
<div v-bind:class="[{ active: isActive }, errorClass]">
```

## 绑定style

```javascript
// 绑定样式
<div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
data: {
  activeColor: 'red',
  fontSize: 30
}
```

```javascript
// 绑定样式对象
<div v-bind:style="styleObject"></div>
data: {
  styleObject: {
    color: 'red',
    fontSize: '13px'
  }
}
```

```javascript
// 应用多个样式
<div v-bind:style="[baseStyles, overridingStyles]">
```

# 条件渲染

> v-if 控制是否渲染元素

Vue 尝试尽可能高效的渲染元素，通常会复用已有元素而不是从头开始渲染。这么做除了使 Vue 更快之外还可以得到一些好处。如下例，当允许用户在不同的登录方式之间切换:

```javascript
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address">
</template>
```
在代码中切换 `loginType` 不会删除用户已经输入的内容，两个模版由于使用了相同的元素，<input> 会被复用，仅仅是替换了他们的 placeholder。

=》 添加`key`

```javascript
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username" key="username-input">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address" key="email-input">
</template>
```
这样`input`切换时会重新渲染， <label> 元素仍然会被复用，因为没有被添加了 `key `属性。

> `v-show`的元素会始终在DOM中，只是切换`display`

# 列表渲染

> `template`中亦可使用`v-for`

> 循环组件时不会自动将值注入组件，需要手动绑定。

```javascript
// 循环数组
<li v-for="item in arr"><li>
<li v-for="(item, index) in arr"><li>
```

```javascript
// 循环obj依次显示的是对象的value
<li v-for="value in object">
  {{ value }}
</li>
```

```javascript
<div v-for="(value, key) in object">
  {{ key }} : {{ value }}
</div>
```

```javascript
// 依次是值，key以及索引
<div v-for="(value, key, index) in object">
  {{ index }}. {{ key }} : {{ value }}
</div>
```

```javascript
// 遍历整数
<div>
  <span v-for="n in 10">{{ n }}</span>
</div>
```

# vue实例暴露的实例属性和方法

> 所有的都带有前缀`$`

- $data vm的data属性
- $el vm的el属性所指向的dom结点
- $watch


# vue生命周期说明

- `beforeCreate`

  在实例初始化之后，数据观测(data observer) 和 event/watcher 事件配置之前被调用。
- `created`

  实例已经创建完成之后被调用。在这一步，实例已完成以下的配置：数据观测(data observer)，属性和方法的运算， watch/event 事件回调。然而，挂载阶段还没开始，$el 属性目前不可见。
- `beforeMount`

  在挂载开始之前被调用：相关的 render 函数首次被调用。
- `mounted`

  el 被新创建的 vm.$el 替换，并挂载到实例上去之后调用该钩子。如果 root 实例挂载了一个文档内元素，当 mounted 被调用时 vm.$el 也在文档内。
- `beforeUpdate`

  数据更新时调用，发生在虚拟 DOM 重新渲染和打补丁之前。
- `updated`

  由于数据更改导致的虚拟 DOM 重新渲染和打补丁，在这之后会调用该钩子。
- `activated`

  `keep-alive` 组件激活时调用。
- `deactivated`

  keep-alive 组件停用时调用。
- `beforeDestroy`

  实例销毁之前调用。在这一步，实例仍然完全可用。
- `destroyed`

  Vue 实例销毁后调用。

# slot分发内容

> 子组件模板至少含有一个slot接口，否则父组件内容将被丢弃。

```html
<!-- myComponent -->
<div>
  <h2>我是子组件的标题</h2>
</div>
```

```html
<div>
  <h1>我是父组件的标题</h1>
  <my-component>
    <p>这是slot内容</p>
  </my-component>
</div>
```

渲染为

```html
<div>
  <h1>我是父组件的标题</h1>
  <div>
    <h2>我是子组件的标题</h2>
  </div>
</div>
```
> 当子组件模板只有一个没有属性的 slot 时，父组件整个内容片段将插入到 slot 所在的 DOM 位置，并替换掉 slot 标签本身。

```html
<!-- myComponent -->
<div>
  <h2>我是子组件的标题</h2>
  <slot>
    只有在没有要分发的内容时才会显示。
  </slot>
</div>
```

```html
<div>
  <h1>我是父组件的标题</h1>
  <my-component>
    <p>这是slot内容</p>
  </my-component>
</div>
```
渲染为

```html
<div>
  <h1>我是父组件的标题</h1>
  <div>
    <h2>我是子组件的标题</h2>
    <p>这是slot内容</p>
  </div>
</div>
```

> <slot> 元素可以用一个特殊的属性 name 来配置如何分发内容

```html
<!-- app-layout-->
<div class="container">
  <header>
    <!--插入slot="header"-->
    <slot name="header"></slot>
  </header>
  <main>
    <!--
      匿名 slot ，
      它是默认 slot ，
      作为找不到匹配的内容片段的备用插槽。如果没有默认的 slot ，
      这些找不到匹配的内容片段将被抛弃。
    -->
    <slot></slot>
  </main>
  <footer>
    <!--插入slot="footer"-->
    <slot name="footer"></slot>
  </footer>
</div>
```

```html
<app-layout>
  <h1 slot="header">这里可能是一个页面标题</h1>
  <p>主要内容的一个段落。</p>
  <p>另一个主要段落。</p>
  <p slot="footer">这里有一些联系信息</p>
</app-layout>
```

渲染为

```html
<div class="container">
  <header>
    <h1>这里可能是一个页面标题</h1>
  </header>
  <main>
    <p>主要内容的一个段落。</p>
    <p>另一个主要段落。</p>
  </main>
  <footer>
    <p>这里有一些联系信息</p>
  </footer>
</div>
```
> slot 传递props

```html
<!--my-awesome-list-->
<ul>
  <slot name="item"
    v-for="item in items"
    :text="item.text">
    <!-- fallback content here -->
  </slot>
</ul>
```

```html
<my-awesome-list :items="items">
  <!-- 作用域插槽也可以在这里命名 -->
  <template slot="item" scope="props">
    <li class="my-fancy-item">{{ props.text }}</li>
  </template>
</my-awesome-list>
```

# 过渡效果

```html
  <transition name="v"></transition>
```
## 过渡的css类名

- `v-enter`: 定义进入过渡的开始状态。在元素被插入时生效，在下一个帧移除。
- `v-enter-active`: 定义进入过渡的结束状态。在元素被插入时生效，在 `transition/animation` 完成之后移除。
- `v-leave`: 定义离开过渡的开始状态。在离开过渡被触发时生效，在下一个帧移除。
- `v-leave-active`: 定义离开过渡的结束状态。在离开过渡被触发时生效，在 `transition/animation` 完成之后移除。

## 自定义过渡类名


- `enter-class`
- `enter-active-class`
- `leave-class`
- `leave-active-class`

```html
<transition
  name="custom-classes-transition"
  enter-active-class="animated tada"
  leave-active-class="animated bounceOutRight"
>
  <p v-if="show">hello</p>
</transition>
```

## 过渡模式

- `in-out`: 新元素先进行过渡，完成之后当前元素过渡离开。
- `out-in`: 当前元素先进行过渡，完成之后新元素过渡进入。

```html
<transition name="fade" mode="out-in">
  <!-- ... the buttons ... -->
</transition>
```

## javascript钩子

```html
<transition
  @before-enter="beforeEnter"
  @enter="enter"
  @after-enter="afterEnter"
  @enter-cancelled="enterCancelled"
  @before-leave="beforeLeave"
  @leave="leave"
  @after-leave="afterLeave"
  @leave-cancelled="leaveCancelled"
>
  <!-- ... -->
</transition>
```

```javascript

methods: {
  // --------
  // 进入中
  // --------
  beforeEnter: function (el) {
    // ...
  },
  // 此回调函数是可选项的设置
  // 与 CSS 结合时使用
  enter: function (el, done) {
    // ...
    done()
  },
  afterEnter: function (el) {
    // ...
  },
  enterCancelled: function (el) {
    // ...
  },
  // --------
  // 离开时
  // --------
  beforeLeave: function (el) {
    // ...
  },
  // 此回调函数是可选项的设置
  // 与 CSS 结合时使用
  leave: function (el, done) {
    // ...
    done()
  },
  afterLeave: function (el) {
    // ...
  },
  // leaveCancelled 只用于 v-show 中
  leaveCancelled: function (el) {
    // ...
  }
}
```