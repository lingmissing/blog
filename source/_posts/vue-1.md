---
title: 【译】Vue 2.0的变化（一）之基本API变化
date: 2016-09-27 14:23:20
tags: vue
---

### 高层级的变化

- 模板解析器不再依赖于 DOM（除非你使用真正的 DOM 作为模板），因此只要你使用字符串模板，你将不再受到任何 1.0 版本中的解析限制。但是，如果你依赖在存在的内容中挂载一个元素作为模板（使用`el`元素），你将依然受到这些限制。
- 编译器（将字符串模板转换为渲染方法的部分）和运行时间现在能够被分开。这里有两种不同的构建：
  - 独立构建：包括编译并且运行。这种方式和`vue 1.0`几乎完全一样。
  - 运行时编译：由于它不包括编译器，在编译步骤时要么预编译模板，要么手动编写渲染功能。npm 包默认导出这个版本，那么你需要有一个编译的过程（使用`Browserify`或`Webpack`）,从中`vueify`或`vue-loader`将可以进行模板预编译。

<!-- more -->

### 全局配置

- `Vue.config.silent`
- `Vue.config.optionMergeStrategies`
- `Vue.config.devtools`
- **`Vue.config.errorHandler`**（新 API，全局的挂钩用于在组件渲染和监控的时候处理未捕获的错误）
- `Vue.config.keyCodes`（新 API，为`v-on`配置自定义的`key`的别名）
- ~~`Vue.config.debug`~~（已丢弃）
- ~~`Vue.config.async`~~（已丢弃）
- ~~`Vue.config.delimiters`~~(已丢弃)
- ~~`Vue.config.unsafeDelimiters`~~（已丢弃，使用`v-html`）

### 全局 API

- `Vue.extend`
- `Vue.nextTick`
- `Vue.set`
- `Vue.delete`
- `Vue.directive`
- `Vue.component`
- `Vue.use`
- `Vue.mixin`
- **`Vue.compile`**（新 API，只能用于独立版本构建）
- `Vue.transition`
  - ~~`stagger`~~（已丢弃，在`el`上设置
- `Vue.filter`
- ~~`Vue.elementDirective`~~（已丢弃，使用组件）
- ~~`Vue.partial`~~ （已丢弃，使用功能组件）

### 选项

#### data

- `data`
- `props`
  - `prop`
  - `default`
  - ~~`coerce`~~（已丢弃，如果你需要转换`prop`,请使用`compute`属性）
  - ~~`prop binding modes`~~（已丢弃，`v-model`在组件上可以工作
- **`propsData`**（新 API）只能用于实例
- `computed`
- `methods`
- `watch`

#### DOM

- `el`
- `template`
- **`render`**（新 API）
- ~~`replace`~~（已丢弃，组件现在必须有一个根元素）

#### 生命周期钩子

- ~~`init`~~（已丢弃，请使用`beforeCreate`）
- `created`
- `beforeDestroy`
- `destroyed`
- **`beforeMount`**(新 API)
- **`mounted`**（新 API）
- **`beforeUpdate`**（新 API）
- **`updated`**（新 API）
- **`activated`**(新 API，用于`keep-alive`)
- **`deactivated`**（新 API 用于`keep-alive`）
- ~~`ready`~~（已丢弃，使用`mounted`）
- ~~`activate`~~（已丢弃，迁移到`vue-router`）
- ~~`beforeCompile`~~（已丢弃，使用`created`）
- ~~`compiled`~~（已丢弃，使用`mounted`）
- ~~`attached`~~（已丢弃）
- ~~`detached`~~（已丢弃，同上）

#### Assets

- `directives`
- `components`
- `transitions`
- `filters`
- ~~`partials`~~（已丢弃）
- ~~`elementDirectives`~~（已丢弃）

#### 杂项

- `parent`
- `mixins`
- `name`
- `extends`
- **`delimiters`**（新 API，替代原版的全局配置选项，只在独立构建中可用）
- **`functional`**（新 API）
- ~~`events`~~（已丢弃）

### 实例方法

#### data

- `vm.$watch`
- ~~`vm.$get`~~（已丢弃，直接检索值）
- ~~`vm.$set`~~（已丢弃，使用`Vue.set`）
- ~~`vm.$delete`~~（已丢弃，使用`Vue.delete`）
- ~~`vm.$eval`~~（已丢弃，没有真正的使用）
- ~~`vm.$interpolate`~~（已丢弃，同上）
- ~~`vm.$log`~~（已丢弃，使用`devtools`）

#### events

- `vm.$on`
- `vm.$once`
- `vm.$off`
- `vm.$emit`
- ~~`vm.$dispatch`~~（已丢弃，使用全局的事件或使用`vuex`，见下面）
- ~~`vm.$broadcast`~~（已丢弃，同上）

#### DOM

- `vm.$nextTick`
- ~~`vm.$appendTo`~~（已丢弃，在`vm.$el`上使用本地 API）
- ~~`vm.$before`~~（已丢弃）
- ~~`vm.$after`~~（已丢弃）
- ~~`vm.$remove`~~（已丢弃）

#### 生命周期

- `vm.$mount`
- `vm.$destroy`

### 指令

- `v-text`
- `v-html`（注意三次括号被丢弃）
- `v-if`
- `v-show`
- `v-else`
- `v-for`
  - **`key`** (替代 `track-by`)
  - `object v-for`
  - `range v-for`
  - 参数顺序更新：数组中使用`(value, index) in arr`，对象中使用`(value, key, index) in obj`
  - ~~`$index`~~和~~`$key`~~被丢弃
- `v-on`
  - `modifiers`
  - on child component
  - 自定义键码，目前版本`Vue.config.keyCodes`代替原来的`Vue.directive('on').keyCodes`
- `v-bind`
  - 作为`prop`
  - `xlink`
  - 绑定对象
- `v-bind:style`
  - `prefix sniffing`
- `v-bind:class`
- `v-model`
  - `lazy` (as modifier)
  - `number` (as modifier)
  - `ignoring composition events
  - ~~`debounce`~~（已丢弃，使用`v-on:input`）
- `v-cloak`
- `v-pre`
- **`v-once`**（新 API）
- ~~`v-ref`~~（已丢弃，现在只是一个特殊的属性`ref`）
- ~~`v-el`~~（和`ref`合并）

### 特殊组件

- `<component>`
  - `:is`
  - `async组件`
  - `inline-template`
- `<transition>`
- `<transition-group>`
- `<keep-alive>`
- `<slot>`
- ~~`partial`~~（已丢弃）

### 特殊属性

- `key`
- `ref`
- `slot`

### 服务器端渲染

- `renderToString`
- `renderToStream`
- `client-side hydration`

> 翻译自[2.0 Changes][3]

[1]: http://momentjs.com/
[2]: http://openexchangerates.github.io/accounting.js/
[3]: https://github.com/vuejs/vue/issues/2873
