title: react 高级用法
date: 2018-03-20 14:16:09
tags: [react,javascript]

---

## 上下文(Context)

> 如果你希望使用应用程序更加稳定，就不要使用上下文(context)。

通过将 `childContextTypes` 和 `getChildContext` 添加到组件( context 提供者)，React 自动地向下传递信息，并且子树中的任何组件都可以通过定义`contextTypes`去访问它。如果`contextTypes`没有定义， context 将是一个空对象。

```js
const PropTypes = require('prop-types');

class Button extends React.Component {
  render() {
    return (
    )
  }
}
// 调用时候定义
Button.contextTypes = {
  color: PropTypes.string
}

class MessageList extends React.Component {
  getChildContext() {
    return {color: "purple"}
  }
}
// 父组件定义
MessageList.childContextTypes = {
  color: PropTypes.string
}
```

## 片段(fragments)

> 片段(fragments) 可以让你将子元素列表添加到一个分组中，并且不会在DOM中增加额外节点。

```js
<tr>
  <React.Fragment>
    <td>Hello</td>
    <td>World</td>
  </React.Fragment>
</tr>
```

## 插槽(Portals)

> 将dom插入任意位置

```js
ReactDOM.createPortal(child, container)
```

第一个参数（child）是任何可渲染的 React 子元素，例如一个元素，字符串或 片段(fragment)。第二个参数（container）则是一个 DOM 元素。