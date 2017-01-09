title: weex用法基础整理
date: 2017-01-09 14:22:47
tags: [weex,vue,javascript]
categories: 关于制作原生app
---


# 内建组件

- `<div>` 组件是用于包装其它组件的最基本容器。(弃用)
- `<scroller>` 是一个**竖直**的，可以容纳多个排成一列的子组件的滚动器。
- `<list>`组件是提供垂直列表功能的核心组件，非常适合用于长列表的展示。
  - `<cell>`用于定义列表中的子列表项，必须作为`<list>`组件的子组件, 这是为了优化滚动时的性能。
- `<refresh>` 为 `<scroller>` 和 `<list>` 提供下拉加载功能。
- `<loading>` 为 `<scroller>` 和 `<list>` 提供上拉加载功能。
- `<text>`用来将文本按照指定的样式渲染出来，只能包含文本值。
- `<image>` 组件用于渲染图片，并且它不能包含任何子组件。可以用 `<img>` 作简写。
- `<input>` 组件用来创建接收用户输入字符的输入组件。
- `<textarea>` 用于用户交互，接受用户输入数据。
- `<switch>`用来创建与 iOS 一致样式的按钮。
- `<slider>` 组件用于在一个页面中展示多个图片，在前端，这种效果被称为 轮播图。
  - `<indicator>` 组件用于显示轮播图指示器效果，必须充当 `<slider>` 组件的子组件使用。
- `<video>` 组件可以让我们在 Weex 页面中嵌入视频内容。
- `<a>` 组件定义了指向某个页面的一个超链接,不能直接添加文本。
- `<web>` 组件在 Weex 页面中嵌入一张网页内容。
- `weex-components` 依赖库
  - `<wxc-tabbar>`能在窗口的底部显示 tab 页面。
  - `<wxc-navpage>` 组件是一个包含 navbar 的容器组件。

# 内建模块

<!-- more -->

```javascript
var moduleName = require('@weex-module/${moduleName}')
```

- `dom` —— dom节点的API
  - `scrollToElement(node, options)` 让页面滚动到那个对应的节点。
  - `getComponentRect(ref, callback)` 通过标签的 ref 获得其布局信息，返回的信息在 callBack 中。
- `stream` —— 网络请求
  - fetch(options, callback[,progressCallback])
- `modal`展示消息框
  - `toast(options)` 一个小浮层里展示关于某个操作的简单反馈。
  - `alert(options, callback)` 警告框经常用于确保用户可以得到某些信息。
  - `confirm(options, callback)` 确认框用于使用户可以验证或者接受某些信息。
  - `prompt(options, callback)` 提示框经常用于提示用户在进入页面前输入某个值。
- `animation` —— 动画相关
  - `transition(el, options, callback)`
- `webview` —— 页面操作相关API
  - `goBack(webElement)` 加载历史记录里的前一个资源地址。
  - `goForward(webElement)` 前进。
  - `reload(webElement)` 刷新页面。
- `navigator` —— 导航控制
  - `push(options, callback)` 把一个weex页面URL压入导航堆栈中。
  - `pop(options, callback)` 把一个 Weex 页面 URL 弹出导航堆栈中。
- `storage` —— 本地存储
  - `setItem(key, value, callback)` 将数据存储到本地。
  - `getItem(key, callback)` 传入键名返回对应的键值。
  - `removeItem(key, callback)` 传入一个键名将会删除本地存储中对应的键值。
  - `length(callback)` 返回本地存储的数据中所有存储项数量的整数。
  - `getAllKeys(callback)` 返回一个包含全部已存储项键名的数组。
- `clipboard` —— 剪切板
  - `getString(callback)` 从系统粘贴板读取内容。
  - `setString(text)` 将一段文本复制到剪切板，相当于手动复制文本。
- `picker` —— 数据选择，日期选择，时间选择
  - `pick(options, callback[options])` 调用单选 picker
  - `pickDate(options, callback[options])` 调用 date picker
  - `pickTime(options, callback[options])` 调用 time picker
- `globalEvent` —— 监听持久性事件
  - `addEventListener(String eventName, String callback)`
  - `removeEventListener(String eventName)`

# 事件

## 通用事件

- `click`
- `longpress` 长按事件。
- `Appear` 如果一个位于某个可滚动区域内的组件被绑定了 appear 事件，那么当这个组件的状态变为在屏幕上可见时，该事件将被触发。
- `Disappear` 如果一个位于某个可滚动区域内的组件被绑定了 disappear 事件，那么当这个组件被滑出屏幕变为不可见状态时，该事件将被触发。
- `Page`

## 特殊事件

- `loadmore` 列表滚动到底部将会立即触发这个事件
- `refresh` 当 `<scroller>`/`<list>` 被下拉时触发。
- `load` 图片加载完成
- `change`,`focus`,`blur` 输入框相关事件
- `start`,`pause`,`finish`,`fail` video相关事件

# 语法介绍

## if

通过设置 if 特性值，你可以控制当前组件是否显示。如果值为真，则当前组件会被渲染出来，如果值为假则会被移除。

## repeat
repeat 特性用于重复渲染一组相同的组件。它绑定的数据类型必须为数组，数组里的每一项数据可以体现在不同的组件特性、样式、事件绑定等。

## append

- 以一整棵树的方式一次性添加到视图中 (append="tree")
- 每个子组件都产生一次单独的添加到视图的指令 (append="node")
