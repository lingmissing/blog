---
title: react&redux基础
date: 2016-08-18 10:36:45
tags: [react, redux]
---

`Redux` 主要分为三个部分 `Action`、`Reducer`、及 `Store`

原理：

- `view`直接触发`dispatch`；
- 将`action`发送到`reducer`中后，根节点上会更新 `state`，改变全局`view`。

<!-- more -->

本案例以一个提到 TODOLIST 为案例。

## Action

在 `Redux` 中，`action` 主要用来传递操作 `State` 的信息，只是一种命令，并没有实际改变`state`。

我们约定，`action` 内必须使用一个字符串类型的 `type` 字段来表示将要执行的动作。`type` 属性是必要的，除了 `type` 字段外，`action` 对象的结构完全取决于你，建议尽可能简单。`type` 一般用来表达处理 `state` 数据的方式。

比如添加`todo`的`action`：

```javascript
const ADD_TODO = 'ADD_TODO'
{
  type: ADD_TODO,
  text: 'Build my first Redux app'
}
```

这个动作需要改变哪些属性就传递这些属性。

##### 创建函数

如果有多个数据是同样的动作，那么我们就需要一个通用的函数来传递数据。在 `Redux` 中的 `action` 创建函数只是简单的返回一个 `action`:

```javascript
//actions
export const ADD_TODO = 'ADD_TODO'
export function addTodo(text) {
  return {
    type: ADD_TODO,
    text
  }
}
```

或者

```javascript
//actions
export const ADD_TODO = 'ADD_TODO'
export const addTodo = text => {
  return {
    type: ADD_TODO,
    text
  }
}
```

在组件的事件中，`Redux` 中只需把 `action` 创建函数的结果传给 `dispatch()` 方法即可发起一次 `dispatch` 过程。

```javascript
dispatch(addTodo(text))
```

或者

```javascript
const boundAddTodo = text => dispatch(addTodo(text))
boundAddTodo(text)
```

##### bindActionCreators

如上所示，我们每次都需要调用时 dispatch 这个 action。

在 React 组件中，如果你希望让组件通过调用函数来更新 state，可以通过使用 const actions = bindActionCreators(FilmActions, dispatch); 将 actions 和 dispatch 揉在一起，成为具备操作 store.state 的 actions。

## Reducer

Action 只是描述了有事情发生了这一事实，并没有指明应用如何更新 state。而这正是 reducer 要做的事情。

当明确 action 的任务，就可以开始编写 reducer，并让它来处理之前定义过的 action。

```javascript
//reducers
import { addTodo, ADD_TODO } from './actions'

function todoApp(state = initialState, action) {
  switch (action.type) {
    case ADD_TODO:
      return Object.assign({}, state, {
        text: action.text
      })
    default:
      return state
  }
}
```

注意：

- 不要修改 state。 使用 Object.assign() 新建了一个副本。为了对 ES7 提案对象展开运算符的支持, 也可以使用 { ...state, ...newState } 达到相同的目的。
- 在 default 情况下返回旧的 state。遇到未知的 action 时，一定要返回旧的 state。
- reducer 中的一个 fun 在 store 里作为一个对象存储。

##### combineReducers

combineReducers() 所做的只是生成一个函数，这个函数来调用你的一系列 reducer，每个 reducer 根据它们的 key 来筛选出 state 中的一部分数据并处理，然后这个生成的函数再将所有 reducer 的结果合并成一个大的对象。

```javascript
import { combineReducers } from 'redux'

const todoApp = combineReducers({
  todoApp
})

export default todoApp
```

## Store

`Store` 就是把`action`和`reducer`联系到一起的对象。`Store` 有以下职责：

- 维持应用的 `state`；
- 提供 `getState()` 方法获取 `state`；
- 提供 `dispatch(action)` 方法更新 `state`；
- 通过 `subscribe(listener)` 注册监听器;
- 通过 `subscribe(listener)` 返回的函数注销监听器。

> `Redux` 应用只有一个单一的 `store`。当需要拆分数据处理逻辑时，你应该使用 `reducer`组合 而不是创建多个 `store`。

我们使用 `combineReducers()` 将多个 `reducer` 合并成为一个。现在我们将其导入，并传递 `createStore()`。

```javascript
import { createStore } from 'redux'
import todoApp from './reducers'
let store = createStore(todoApp)
```

##### Middleware

`redux`中的`middleware`还是比较简单的，它只是针对于`dispatch`方法做了`middleware`处理；也就是说，只接受一个`action`对象；

```javascript
import createLogger from 'redux-logger'
import { createStore, applyMiddleware } from 'redux'
import thunk from 'redux-thunk'
import reducers from './reducers'
const logger = createLogger()
let thunkStore = applyMiddleware(thunk, logger)(createStore)
let store = thunkStore(reducers)
```

## connect

```javascript
connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeToProps
)(App)
```

第一个函数接收 store 中 state 和 props，使页面可以根据当前的 store 中 state 和 props 返回新的`stateProps`;
第二个函数接收 store 中的 dispatch 和 props，使页面可以复写 dispatch 方法，返回新的`dispatchProps`；
第三个函数接收前 2 个函数生成的`stateProps`和`dispatchProps`，在加上原始的`props`，合并成新的`props`，并传给原始根节点的`props`。

```javascript
const mapStateToProps = (state, ownProps) => {
  return {
    active: ownProps.filter === state.visibilityFilter
  }
}

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    onClick: () => {
      dispatch(setVisibilityFilter(ownProps.filter))
    }
  }
}

const FilterLink = connect(
  mapStateToProps,
  mapDispatchToProps
)(Link)
```

## Provider

<Provider store> 使组件层级中的 connect() 方法都能够获得 Redux store。正常情况下，你的根组件应该嵌套在 <Provider> 中才能使用 connect() 方法。

`react-redux`首先提供了一个`Provider`，可以将从`createStore`返回的`store`放入`context`中，使子集可以获取到`store`并进行操作；

Connect 组件需要 store。这个需求由 Redux 提供的另一个组件 Provider 来提供。源码中，Provider 继承了 React.Component，所以可以以 React 组件的形式来为 Provider 注入 store，从而使得其子组件能够在上下文中得到 store 对象。

```javascript
<Provider store={store}>
  <App />
</Provider>
```
