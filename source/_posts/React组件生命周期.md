---
title: React组件生命周期
date: 2016-08-16 14:14:55
tags: react
---

组件的生命周期包含三个主要部分：

- 挂载： 组件被插入到 DOM 中。
- 更新： 组件被重新渲染，查明 DOM 是否应该刷新。
- 移除： 组件从 DOM 中移除。

<!-- more -->

> React 提供生命周期方法，你可以在这些方法中放入自己的代码。我们提供 will 方法，会在某些行为发生之前调用，和 did 方法，会在某些行为发生之后调用。

<img src="/myBlog/artical_imgs/component-lifecycle.jpg"/>

### 装载组件触发

##### getInitialState

`object`在组件被挂载之前调用。状态化的组件应该实现这个方法，返回初始的`state`数据。

初始化 `this.state` 的值，只在组件装载之前调用一次。

如果是使用 ES6 的语法，你也可以在构造函数中初始化状态，比如：

```javascript
class Counter extends Component {
  constructor(props) {
    super(props)
    this.state = { count: props.initialCount }
  }

  render() {
    // ...
  }
}
```

##### getDefaultProps

只在组件创建时调用一次并缓存返回的对象（即在 `React.createClass` 之后就会调用）。

因为这个方法在实例初始化之前调用，所以在这个方法里面不能依赖 `this` 获取到这个组件的实例。
在组件装载之后，这个方法缓存的结果会用来保证访问 `this.props` 的属性时，当这个属性没有在父组件中传入（在这个组件的 JSX 属性里设置），也总是有值的。

如果是使用 ES6 语法，可以直接定义 `defaultProps` 这个类属性来替代，这样能更直观的知道 `default props` 是预先定义好的对象值：

```javascript
Counter.defaultProps = { initialCount: 0 }
```

##### componentWillMount()

`componentWillMount()`只会在装载之前调用一次，在 `render` 之前调用，你可以在这个方法里面调用 `setState` 改变状态，并且不会导致额外调用一次 `render`。

##### render()

组装生成这个组件的 `HTML` 结构（使用原生 `HTML` 标签或者子组件），也可以返回 `null`或者 `false`，这时候 `ReactDOM.findDOMNode(this)` 会返回 `null`。

##### componentDidMount()

`componentDidMount()`在挂载结束之后马上被调用。只会在装载完成之后调用一次，在 render 之后调用，从这里开始可以通过 `ReactDOM.findDOMNode(this)` 获取到组件的 DOM 节点。

### 更新组件触发

##### componentWillReceiveProps(object nextProps)

当一个挂载的组件接收到新的 props 的时候被调用。该方法应该用于比较`this.props`和`nextProps`，然后使用`this.setState()`来改变`state`。

在初始化渲染的时候，该方法不会调用。

```javascript
componentWillReceiveProps: function(nextProps) {
  this.setState({
    likesIncreasing: nextProps.likeCount > this.props.likeCount
  });
}
```

##### shouldComponentUpdate(object nextProps, object nextState): boolean

当组件做出是否要更新 DOM 的决定的时候被调用。

在接收到新的 `props`或者 `state`，将要渲染之前调用。该方法在初始化渲染的时候不会调用，在使用 forceUpdate 方法的时候也不会。

如果确定新的 `props` 和 `state` 不会导致组件更新，则此处应该返回 `false`。

```javascript
shouldComponentUpdate: function(nextProps, nextState) {
  return nextProps.id !== this.props.id;
}
```

如果 `shouldComponentUpdate` 返回 `false`，则 `render()` 将不会执行，直到下一次 `state` 改变。

##### componentWillUpdate(object nextProps, object nextState)

在更新发生之前被调用。你可以在这里调用`this.setState()`。

##### componentDidUpdate(object prevProps, object prevState)

在更新发生之后调用。

### 卸载组件触发

##### componentWillUnmount()

在组件移除和销毁之前被调用。清理工作应该放在这里。比如无效的定时器，或者清除在 componentDidMount 中创建的 DOM 元素。

### 装载的方法

##### getDOMNode()

DOMElement 可以在任何挂载的组件上面调用，用于获取一个指向它的渲染 DOM 节点的引用。

##### forceUpdate()

当你知道一些很深的组件 state 已经改变了的时候，可以在该组件上面调用，而不是使用`this.setState()`。

> 完整实例展示

```javascript
var Button = React.createClass({
  getInitialState: function() {
    return {
      data: 0
    }
  },
  setNewNumber: function() {
    this.setState({ data: this.state.data + 1 })
  },
  render: function() {
    return (
      <div>
        <button onClick={this.setNewNumber}>INCREMENT</button>
        <Content myNumber={this.state.data} />
      </div>
    )
  }
})

var Content = React.createClass({
  componentWillMount: function() {
    console.log('Component WILL MOUNT!')
  },
  componentDidMount: function() {
    console.log('Component DID MOUNT!')
  },
  componentWillReceiveProps: function(newProps) {
    console.log('Component WILL RECIEVE PROPS!')
  },
  shouldComponentUpdate: function(newProps, newState) {
    return true
  },
  componentWillUpdate: function(nextProps, nextState) {
    console.log('Component WILL UPDATE!')
  },
  componentDidUpdate: function(prevProps, prevState) {
    console.log('Component DID UPDATE!')
  },
  componentWillUnmount: function() {
    console.log('Component WILL UNMOUNT!')
  },
  render: function() {
    return (
      <div>
        <h3>{this.props.myNumber}</h3>
      </div>
    )
  }
})

ReactDOM.render(
  <div>
    <Button />
  </div>,
  document.getElementById('example')
)
```

### 总结

| 生命周期                  | 调用次数        | 能否使用 setSate() |
| ------------------------- | --------------- | ------------------ |
| getDefaultProps           | 1(全局调用一次) | 否                 |
| getInitialState           | 1               | 否                 |
| componentWillMount        | 1               | 是                 |
| render                    | >=1             | 否                 |
| componentDidMount         | 1               | 是                 |
| componentWillReceiveProps | >=0             | 是                 |
| shouldComponentUpdate     | >=0             | 否                 |
| componentWillUpdate       | >=0             | 否                 |
| componentDidUpdate        | >=0             | 否                 |
| componentWillUnmount      | 1               | 否                 |
