---
title: Action构建工具（redux-act）
date: 2016-09-29 10:58:40
tags: [react,redux]
categories: 前端框架之react
---
github路径：https://github.com/pauldijou/redux-act

这是一个自用的工具用于创建`actions`和`reducers`用于`redux`。主要的目标是使用`action`本身作为`reducer`的引用而不是变量。
## 安装
    npm install redux-act --save
## 用法
这里有一个名叫`createAction`的函数，它用于创建一个`action`，和名叫`createActionCreator`的方法有点接近。如果你不能确定是否是`action`或`action`创造者，那么记住当`action`创造者是方法时，`action`是对象。
<!-- more -->

```javascript
// Import functions
import { createStore } from 'redux';
import { createAction, createReducer } from 'redux-act';

// Create an action creator (description is optional)
const add = createAction('add some stuff');
const increment = createAction('increment the state');
const decrement = createAction('decrement the state');

// Create a reducer
// (ES6 syntax, see Advanced usage below for an alternative for ES5)
const counterReducer = createReducer({
  [increment]: (state) => state + 1,
  [decrement]: (state) => state - 1,
  [add]: (state, payload) => state + payload,
}, 0); // <-- This is the default state

// Create the store
const counterStore = createStore(counterReducer);

// Dispatch actions
counterStore.dispatch(increment()); // counterStore.getState() === 1
counterStore.dispatch(increment()); // counterStore.getState() === 2
counterStore.dispatch(decrement()); // counterStore.getState() === 1
counterStore.dispatch(add(5)); // counterStore.getState() === 6
```
## 高级用法
```javascript
import { createStore } from 'redux';
import { createAction, createReducer } from 'redux-act';

// You can create several action creators at once
// (but that's probably not the best way to do it)
const [increment, decrement] = ['inc', 'dec'].map(createAction);

// When creating action creators, the description is optional
// it will only be used for devtools and logging stuff.
// It's better to put something but feel free to leave it empty if you want to.
const replace = createAction();

// By default, the payload of the action is the first argument
// when you call the action. If you need to support several arguments,
// you can specify a function on how to merge all arguments into
// an unique payload.
let append = createAction('optional description', (...args) => args.join(''));

// There is another pattern to create reducers
// and it works fine with ES5! (maybe even ES3 \o/)
const stringReducer = createReducer(function (on) {
  on(replace, (state, payload) => payload);
  on(append, (state, payload) => state += payload);
  // Warning! If you use the same action twice,
  // the second one will override the previous one.
}, 'missing a lette'); // <-- Default state

// Rather than binding the action creators each time you want to use them,
// you can do it once and for all as soon as you have the targeted store
// assignTo: mutates the action creator itself
// bindTo: returns a new action creator assigned to the store
const stringStore = createStore(stringReducer);
replace.assignTo(stringStore);
append = append.bindTo(stringStore);

// Now, when calling actions, they will be automatically dispatched
append('r'); // stringStore.getState() === 'missing a letter'
replace('a'); // stringStore.getState() === 'a'
append('b', 'c', 'd'); // stringStore.getState() === 'abcd'

// If you really need serializable actions, using string constant rather
// than runtime generated id, just use a uppercase description (with eventually some underscores)
// and it will be use as the id of the action
const doSomething = createAction('STRING_CONSTANT');
doSomething(1); // { type: 'STRING_CONSTANT', payload: 1}

// Little bonus, if you need to support metadata around your action,
// like needed data but not really part of the payload, you add a second function
const metaAction = createAction('desc', arg => arg, arg => ({meta: 'so meta!'}));

// Metadata will be the third argument of the reduce function
createReducer({
  [metaAction]: (state, payload, meta) => payload
});
```
## API说明
### createAction([description], [payloadReducer], [metaReducer])
#### 参数
- description（字符串，可选） 当显示的时候用于注册action名称和在开发者工具中使用。如果这个参数只是大写，它可以在不用生成任何id的情况下被用作`action`类型。你可以使用这个特性在服务端和客户端中有序整理`action`。
- payloadReducer（方法，可选） 转变多个参数作为唯一的`payload`。
- metaReducer（方法，可选） 转变多个参数作为唯一的元数据对象。
#### 用法
返回一个新的`action`构造器。如果你指定了`description`,它将被开发者工具使用。默认情况下，`createAction`返回一个方法，并且触发它的时候第一个参数被作为`payload`。如果你想支持多个参数，你需要指定一个`payloadReducer`来把所有的参数合并到`payload`中。
```javascript
// Super simple action
const simpleAction = createAction();
// Better to add a description
const betterAction = createAction('This is better!');
// Support multiple arguments by merging them
const multipleAction = createAction((text, checked) => ({text, checked}))
// Again, better to add a description
const bestAction = createAction('Best. Action. Ever.', (text, checked) => ({text, checked}))
// Serializable action (the description will be used as the unique identifier)
const serializableAction = createAction('SERIALIZABLE_ACTION');
```
### action creator
`action`创造器基本上是一个携带参数并且返回`action`的方法，它具有以下格式：
- type：通过参数`description`生成id
- payload：当调用`action creator`时进行数据传递，传递的是第一个参数除非在创建`action`时指定了`payloadReducer`.
- meta：如果你提供了`metaReducer`，它将创建一个`metadata`对象分配给这个`key`，否则它是`undefined`
```javascript
const addTodo = createAction('Add todo');
addTodo('content');
// return { type: '[1] Add todo', payload: 'content' }

const editTodo = createAction('Edit todo', (id, content) => ({id, content}));
editTodo(42, 'the answer');
// return { type: '[2] Edit todo', payload: {id: 42, content: 'the answer'} }

const serializeTodo = createAction('SERIALIZE_TODO');
serializeTodo(1);
// return { type: 'SERIALIZE_TODO', payload: 1 }
```
`action creator`有以下方法：
##### getType() 
返回生成的类型并被用于这个`action creator`的所有`action`。
##### assignTo(store | dispatch) 
记住你要触发这些`actions`，如果你有一个或多个`stores`，可以通过`assignTo`分配这些`action`。这会改变`action creator`本身，你可以传递一个`store`或者`dispatch`方法或者数组。
```javascript
let action = createAction();
let action2 = createAction();
const reducer = createReducer({
  [action]: (state) => state * 2,
  [action2]: (state) => state / 2,
});
const store = createStore(reducer, 1);
const store2 = createStore(reducer, -1);

// Automatically dispatch the action to the store when called
action.assignTo(store);
action(); // store.getState() === 2
action(); // store.getState() === 4
action(); // store.getState() === 8

// You can assign the action to several stores using an array
action.assignTo([store, store2]);
action();
// store.getState() === 16
// store2.getState() === -2
```
##### bindTo(store | dispatch) 
如果你需要不可变，你可以使用该方法。它将生成一个新的`action creator`并且能够自动触发`action`。
```javascript
// If you need more immutability, you can bind them, creating a new action creator
const boundAction = action2.bindTo(store);
action2(); // Not doing anything since not assigned nor bound
// store.getState() === 16
// store2.getState() === -2
boundAction(); // store.getState() === 8
```
##### assigned() / bound() / dispatched() 
测试`action creator`的当前状态。

```javascript
const action = createAction();
action.assigned(); // false, not assigned
action.bound(); // false, not bound
action.dispatched(); // false, test if either assigned or bound

const boundAction = action.bindTo(store);
boundAction.assigned(); // false
boundAction.bound(); // true
boundAction.dispatched(); // true

action.assignTo(store);
action.assigned(); // true
action.bound(); // false
action.dispatched(); // true
```
##### raw(...args) 
当`action creator`无论是分配还是绑定，将不再返回`action`对象而是触发它。有些情况下，你需要没有触发的`action`。为了达到这个目的，你可以使用`raw`方法返回纯粹的`action`。
```javascript
const action = createAction().bindTo(store);
action(1); // store has been updated
action.raw(1); // return the action, store hasn't been updated
```
### createReducer(handlers, [defaultState])
#### 参数
- handlers（对象或方法）：如果是方法则携带两个属性，一是注册`action`，二是取消注册，如下。
- defaultState（任意，可选）：`reducer`的初始状态，如果要在`combineReducers`使用千万不能为空。
#### 用法
返回一个新的`reducer`。和`Array.prototype.reduce`的语法类似，你可以指定如何累加，比如第一个参数并累加，或者默认的状态。默认的状态是可选的，因为创建时可以在`store`中获取，但你需要注意`reducer`中始终存在默认状态，尤其是你要结合`combineReducers`使用时。
有两种创建`reducer`的方式，一种是通过对象集合，所有方法必须遵循`previousState, payload) => newState`。另一种是使用工厂模式，话不多说，看下面的例子。
```javascript
const increment = createAction();
const add = createAction();

// First pattern
const reducerMap = createReducer({
  [increment]: (state) => state + 1,
  [add]: (state, payload) => state + payload
}, 0);

// Second pattern
const reducerFactory = createReducer(function (on, off) {
  on(increment, (state) => state + 1);
  on(add, (state, payload) => state + payload);
  // 'off' remove support for a specific action
  // See 'Adding and removing actions' section
}, 0);
```
### reducer
`reducer`就是一个方法。它当前的状态和行为并返回新的状态，有以下方法：
#### options(object)
因为`action`是带有`type`、`payload`甚至还有`metadata`的对象。所有的`reduce`方法默认将`payload`作为它们的第二个参数，`metadata`作为第三个参数，而不是所有的`action`。因为所有其他属性由lib处理不用关心。如果你要使用全部的`action`，你可以改变`reducer`的行为。
```javascript
const add = createAction();
const sub = createAction();
const reducer = createReducer({
  [add]: (state, action) => state + action.payload,
  [sub]: (state, action) => state - action.payload
}, 0);

reducer.options({
  payload: false
});
```
#### has(action creator)
检测`reducer`是否含有`reduce`方法对于特定的`action`或者字符串类型。
```javascript
const add = createAction();
const sub = createAction();
const reducer = createReducer({
  [add]: (state, action) => state + action.payload
}, 0);

reducer.has(add); // true
reducer.has(sub); // false
reducer.has(add.getType()); // true
```
#### on(action creator, reduce function) / off(action creator)
可以动态添加或删除action。
### assignAll(actionCreators, stores)
#### 参数
- actionCreators（对象或数组）
- stores（对象或数组）
#### 用法
普遍的方式是导出一系列的action作为对象，如果你需要将所有绑定到store，这里有一个超级小帮手。也可以使用action数组。
```javascript
// actions.js
export const add = createAction('Add');
export const sub = createAction('Sub');

// reducer.js
import * as actions from './actions';
export default createReducer({
  [actions.add]: (state, payload) => state + payload,
  [actions.sub]: (state, payload) => state - payload
}, 0);

// store.js
import * as actions from './actions';
import reducer from './reducer';

const store = createStore(reducer);
assignAll(actions, store);

export default store;
```
### bindAll(actionCreators, stores)
#### 参数
- actionCreators（对象或数组）
- stores（对象或数组）
#### 用法
类似于`assignAll`,可以立刻绑定`action`。
```javascript
import { bindAll } from 'redux-act';
import store from './store';
import * as actions from './actions';

export bindAll(actions, store);
```
### disbatch(store | dispatch, [actions])
#### 参数
- store | dispatch （对象，store或diaptch方法），在`store`上添加`disbatch`方法，类似于`diaptch`，但这个是触发多个`action`。
- actions（数组，可选） 需要触发的一些`action`
#### 用法
```javascript
// All samples will display both syntax with and without an array
// They are exactly the same
import { disbatch } from 'redux-act';
import { inc, dec } from './actions';

// Add 'disbatch' directly to the store
disbatch(store);
store.disbatch(inc(), dec(), inc());
store.disbatch([inc(), dec(), inc()]);

// Disbatch immediately from store
disbatch(store, inc(), dec(), inc());
disbatch(store, [inc(), dec(), inc()]);

// Disbatch immediately from dispatch
disbatch(store.dispatch, inc(), dec(), inc());
disbatch(store.dispatch, [inc(), dec(), inc()]);
```