title: 深入理解react高阶组件
date: 2017-03-10 15:08:17
tags: [react,hoc]
categories: 前端框架之react
---
> 高阶组件也是一个React组件，只是这个组件里面包裹着另一个React组件。

我们有意模糊了定义中“包裹”的概念，因为它可能会有以下两种不同的含义之一：

- Props Proxy： HOC 对传给 WrappedComponent W 的 porps 进行操作，
- Inheritance Inversion： HOC 继承 WrappedComponent W。

# HOC的作用

- 代码复用，抽象程序内部逻辑（logic and bootstrap abstraction）
- 渲染劫持（Render Highjacking）
- 提取和操作 state
- 操作 props

<!-- more -->
# HOC 工厂的实现方法

这一节我们将会研究 React 中两种 HOC 的实现方法：Props Proxy (PP) and Inheritance Inversion (II)。两种方法都可以操作 WrappedComponent。

## Props Proxy

Props Proxy (PP) 的最简实现：

```javascript
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    render() {
      return <WrappedComponent {...this.props}/>
    }
  }
}
```
注意：

```javascript
<WrappedComponent {...this.props}/>
// 等价于
React.createElement(WrappedComponent, this.props, null)
```

目的：

- 操作 props
- 通过 Refs 访问到组件实例
- 提取 state
- 用其他元素包裹 WrappedComponent

### 操作props

你可以读取、添加、编辑、删除传给 WrappedComponent 的 props。

当删除或者编辑重要的 props 时要小心，你可能应该通过命名空间确保高阶组件的 props 不会破坏 WrappedComponent。

```javascript
// WrappedComponent 中通过 this.props.user 访问到。
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
     render() {
       const newProps = {
         user: currentLoggedInUser
       }
       return <WrappedComponent {...this.props} {...newProps}/>
    }
  }
}
```

### 通过 Refs 访问到组件实例

你可以通过_引用_（ref）访问到 this （WrappedComponent 的实例），但为了得到引用，WrappedComponent 还需要一个初始渲染，意味着你需要在 HOC 的 render 方法中返回 WrappedComponent 元素，让 React 开始它的一致化处理，你就可以得到 WrappedComponent 的实例的引用。

```javascript
function refsHOC(WrappedComponent) {
  return class RefsHOC extends React.Component {
    proc(wrappedComponentInstance) {
      wrappedComponentInstance.method()
    }

    render() {
      const props = Object.assign({}, this.props, {ref: this.proc.bind(this)})
      return <WrappedComponent {...props}/>
    }
  }
}
```

Ref 的回调函数会在 WrappedComponent 渲染时执行，你就可以得到 WrappedComponent 的引用。这可以用来读取/添加实例的 props ，调用实例的方法。

### 提取 state

你可以通过传入 props 和回调函数把 state 提取出来。

```javascript
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    constructor(props) {
      super(props)
      this.state = {
        name: ''
      }

      this.onNameChange = this.onNameChange.bind(this)
    }
    onNameChange(event) {
      this.setState({
        name: event.target.value
      })
    }
    render() {
      const newProps = {
        name: {
          value: this.state.name,
          onChange: this.onNameChange
        }
      }
      return <WrappedComponent {...this.props} {...newProps}/>
    }
  }
}
```

你可以这样用

```javascript
@ppHOC
class Example extends React.Component {
  render() {
    return <input name="name" {...this.props.name}/>
  }
}
```

### 用其他元素包裹 WrappedComponent

为了封装样式、布局或别的目的，你可以用其它组件和元素包裹 WrappedComponent。基本方法是使用父组件（附录 B）实现，但通过 HOC 你可以得到更多灵活性。

```javascript
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    render() {
      return (
        <div style=>
          <WrappedComponent {...this.props}/>
        </div>
      )
    }
  }
}
```

## Inheritance Inversion

```javascript
function iiHOC(WrappedComponent) {
  return class Enhancer extends WrappedComponent {
    render() {
      return super.render()
    }
  }
}
```

返回的 HOC 类（Enhancer）继承了 WrappedComponent。之所以被称为 Inheritance Inversion 是因为 WrappedComponent 被 Enhancer 继承了，而不是 WrappedComponent 继承了 Enhancer。在这种方式中，它们的关系看上去被反转（inverse）了。

> Inheritance Inversion 允许 HOC 通过 this 访问到 WrappedComponent，意味着它可以访问到 state、props、组件生命周期方法和 render 方法。

注意通过II可以创建新的生命周期方法。为了不破坏 WrappedComponent，记得调用 super.[lifecycleHook]。

> Inheritance Inversion 的高阶组件不一定会解析完整子树.

目的：

- 渲染劫持（Render Highjacking）
- 操作 state

### 渲染劫持

之所以被称为渲染劫持是因为 HOC 控制着 WrappedComponent 的渲染输出，可以用它做各种各样的事。

通过渲染劫持你可以：

- 在由 render 输出的任何 React 元素中读取、添加、编辑、删除 props
- 读取和修改由 render 输出的 React 元素树
- 有条件地渲染元素树
- 把样式包裹进元素树（就像在 Props Proxy 中的那样）

*render 指 WrappedComponent.render 方法

> 你不能编辑或添加 WrappedComponent 实例的 props，因为 React 组件不能编辑它接收到的 props，但你可以修改由 render 方法返回的组件的 props。

II 类型的 HOC 不一定会解析完整子树，意味着渲染劫持有一些限制。根据经验，使用渲染劫持你可以完全操作 WrappedComponent 的 render 方法返回的元素树。但是如果元素树包括一个函数类型的 React 组件，你就不能操作它的子组件了。（被 React 的一致化处理推迟到了真正渲染到屏幕时）

例1：条件渲染。当 this.props.loggedIn 为 true 时，这个 HOC 会完全渲染 WrappedComponent 的渲染结果。（假设 HOC 接收到了 loggedIn 这个 prop）

```javascript
function iiHOC(WrappedComponent) {
  return class Enhancer extends WrappedComponent {
    render() {
      if (this.props.loggedIn) {
        return super.render()
      } else {
        return null
      }
    }
  }
}
```

例2：修改由 render 方法输出的 React 组件树。

```javascript
function iiHOC(WrappedComponent) {
  return class Enhancer extends WrappedComponent {
    render() {
      // 获取WrappedComponent的reactElement
      const elementsTree = super.render()
      let newProps = {}
      if (elementsTree && elementsTree.type === 'input') {
        // 如果element存在并且是个input元素
        newProps = {value: 'may the force be with you'}
      }
      const props = Object.assign({}, elementsTree.props, newProps)
      const newElementsTree = React.cloneElement(elementsTree, props, elementsTree.props.children)
      return newElementsTree
    }
  }
}
```

在这个例子中，如果 WrappedComponent 的输出在最顶层有一个 input，那么就把它的 value 设为 “may the force be with you”。

### 操作 state

HOC 可以读取、编辑和删除 WrappedComponent 实例的 state，如果你需要，你也可以给它添加更多的 state。记住，这会搞乱 WrappedComponent 的 state，导致你可能会破坏某些东西。要限制 HOC 读取或添加 state，添加 state 时应该放在单独的命名空间里，而不是和 WrappedComponent 的 state 混在一起。

例子：通过访问 WrappedComponent 的 props 和 state 来做调试。

```javascript
export function IIHOCDEBUGGER(WrappedComponent) {
  return class II extends WrappedComponent {
    render() {
      return (
        <div>
          <h2>HOC Debugger Component</h2>
          <p>Props</p> <pre>{JSON.stringify(this.props, null, 2)}</pre>
          <p>State</p><pre>{JSON.stringify(this.state, null, 2)}</pre>
          {super.render()}
        </div>
      )
    }
  }
}
```

### 命名

用 HOC 包裹了一个组件会使它失去原本 WrappedComponent 的名字，可能会影响开发和调试。

通常会用 WrappedComponent 的名字加上一些 前缀作为 HOC 的名字。下面的代码来自 React-Redux：

```javascript
HOC.displayName = `HOC(${getDisplayName(WrappedComponent)})`

//或

class HOC extends ... {
  static displayName = `HOC(${getDisplayName(WrappedComponent)})`
  ...
}
```

getDisplayName 函数：

```javascript
function getDisplayName(WrappedComponent) {
  return WrappedComponent.displayName
         WrappedComponent.name
         ‘Component’
}
```

# 附录 A: HOC 和参数

```javascript
function HOCFactoryFactory(...params){
  // do something with params
  return function HOCFactory(WrappedComponent) {
    return class HOC extends React.Component {
      render() {
        return <WrappedComponent {...this.props}/>
      }
    }
  }
}
```
你可以这样用：

```javascript
HOCFactoryFactory(params)(WrappedComponent)
//或
@HOCFatoryFactory(params)
class WrappedComponent extends React.Component{}
```

# 附录 B: 与父组件的不同

父组件就是有一些子组件的 React 组件。React 有访问和操作子组件的 API。

```javascript
class Parent extends React.Component {
    render() {
      return (
        <div>
          {this.props.children}
        </div>
      )
    }
}

render((
  <Parent>
    {children}
  </Parent>
  ), mountNode)
```

相对 HOC 来说，父组件可以做什么，不可以做什么？我们详细地总结一下：

- 渲染劫持 (在 Inheritance Inversion 一节讲到)；
- 操作内部 props (在 Inheritance Inversion 一节讲到)；
- 提取 state。但也有它的不足。只有在显式地为它创建钩子函数后，你才能从父组件外面访问到它的 props。这给它增添了一些不必要的限制；
- 用新的 React 组件包裹。这可能是唯一一种父组件比 HOC 好用的情况。HOC 也可以做到；
- 操作子组件会有一些陷阱。例如，当子组件没有单一的根节点时，你得添加一个额外的元素包裹所有的子组件，这让你的代码有些繁琐。在 HOC 中单一的根节点会由 React/JSX语法来确保；
- 父组件可以自由应用到组件树中，不像 HOC 那样需要给每个组件创建一个类。

一般来讲，可以用父组件的时候就用父组件，它不像 HOC 那么 hacky，但也失去了 HOC 可以提供的灵活性

> 转载自 [前端外刊评论](http://qianduan.guru/2017/01/11/react-higher-order-components-in-depth/)

