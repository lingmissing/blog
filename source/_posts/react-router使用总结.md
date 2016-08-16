---
title: react-router使用总结
date: 2016-08-16 11:40:19
tags: [react,react-router]
---


> [react-router API](https://github.com/reactjs/react-router/blob/master/docs/API.md)

## 基本用法
安装命令：

	$ npm install -S react-router
	
使用展示：

```javascript
import { Router } from 'react-router';
render(<Router/>, document.getElementById('app'));
```

Router组件本身只是一个容器，真正的路由要通过Route组件定义。

```javascript
import { Router, Route, hashHistory } from 'react-router';

render((
  <Router history={hashHistory}>
    <Route path="/" component={App}/>
  </Router>
), document.getElementById('app'));
```

代码解释：

- 用户访问根路由`/`（比如`http://www.example.com/`），组件`APP`就会加载到document.getElementById('app')。
- `Router`组件有一个参数`history`，它的值`hashHistory`表示，路由的切换由URL的`hash`变化决定，即URL的#部分发生变化。举例来说，用户访问`http://www.example.com/`，实际会看到的是`http://www.example.com/#/`。

## 嵌套路由

`Route`组件定义了URL路径与组件的对应关系。你可以同时使用多个Route组件。

```javascript
<Router history={hashHistory}>
  <Route path="/" component={App}/>
  <Route path="/repos" component={Repos}/>
  <Route path="/about" component={About}/>
</Router>
```

上面代码中，用户访问`/repos`时，会先加载`App`组件，然后在它的内部再加载`Repos`组件。

```javascript
<App>
  <Repos/>
</App>
```
App组件要写成下面的样子。

```javascript
export default React.createClass({
  render() {
    return <div>
      {this.props.children}
    </div>
  }
})
```

上面代码中，App组件的`this.props.children`属性就是子组件。

子路由也可以不写在`Router`组件里面，单独传入`Router`组件的`routes`属性。

```javascript
let routes = <Route path="/" component={App}>
  <Route path="/repos" component={Repos}/>
  <Route path="/about" component={About}/>
</Route>;

<Router routes={routes} history={browserHistory}/>
```

## path属性

`Route`组件的`path`属性指定路由的匹配规则。这个属性是可以省略的，这样的话，不管路径是否匹配，总是会加载指定组件。

```javascript
<Route path="inbox" component={Inbox}>
   <Route path="messages/:id" component={Message} />
</Route>
```

上面代码中，当用户访问`/inbox/messages/:id`时，会加载下面的组件。

如果省略外层`Route`的`path`参数，写成下面的样子。

```javascript
<Route component={Inbox}>
  <Route path="inbox/messages/:id" component={Message} />
</Route>
```

## 通配符


```javascript
<Route path="/hello/:name">
// 匹配 /hello/michael
// 匹配 /hello/ryan
```

```javascript
<Route path="/hello(/:name)">
// 匹配 /hello
// 匹配 /hello/michael
// 匹配 /hello/ryan
```

```javascript
<Route path="/files/*.*">
// 匹配 /files/hello.jpg
// 匹配 /files/hello.html
```

```javascript
<Route path="/files/*">
// 匹配 /files/ 
// 匹配 /files/a
// 匹配 /files/a/b
```


通配符规则：

- `:paramName`匹配URL的一个部分，直到遇到下一个/、?、#为止。这个路径参数可以通过this.props.params.paramName取出。
- `()`表示URL的这个部分是可选的。
- `*`匹配任意字符，直到模式里面的下一个字符为止。匹配方式是非贪婪模式。
- `**`匹配任意字符，直到下一个/、?、#为止。匹配方式是贪婪模式。



## 常用组件


#### IndexRoute

上面的代码会发现访问根路径会加载不到子组件。`IndexRoute`就是解决这个问题，显式指定`Home`是根路由的子组件，即指定默认情况下加载的子组件。你可以把`IndexRoute`想象成某个路径的index.html。

```javascript
<Router>
  <Route path="/" component={App}>
    <IndexRoute component={Home}/>
    <Route path="accounts" component={Accounts}/>
    <Route path="statements" component={Statements}/>
  </Route>
</Router>
```

> `IndexRoute`组件没有路径参数`path`。

#### Redirect

`<Redirect>`组件用于路由的跳转，即用户访问一个路由，会自动跳转到另一个路由。

```javascript
<Route path="inbox" component={Inbox}>
  {/* 从 /inbox/messages/:id 跳转到 /messages/:id */}
  ＜Redirect from="messages/:id" to="/messages/:id" />
</Route>
```

#### IndexRedirect

`IndexRedirect`组件用于访问根路由的时候，将用户重定向到某个子组件。

```javascript
<Route path="/" component={App}>
  ＜IndexRedirect to="/welcome" />
  <Route path="welcome" component={Welcome} />
  <Route path="about" component={About} />
</Route>
```

#### RouterContext

- push(pathOrLoc)

	```javascript
	router.push('/users/12')
	
	// or with a location descriptor object
	router.push({
	 pathname: '/users/12',
	 query: { modal: true },
	 state: { fromDashboard: true }
	})
	```
- replace(pathOrLoc)
- go(n)
- goBack()
- goForward()
- setRouteLeaveHook(route, hook)

## Link

`Link`组件用于取代`<a>`元素，生成一个链接，允许用户点击后跳转到另一个路由。它基本上就是`<a>`元素的`React 版本，可以接收Router`的状态。

```javascript
render() {
  return <div>
    <ul role="nav">
      <li><Link to="/about">About</Link></li>
      <li><Link to="/repos">Repos</Link></li>
    </ul>
  </div>
}
```
如果希望当前的路由与其他路由有不同样式，这时可以使用`Link`组件的`activeStyle`属性

```javascript
<Link to="/about" activeStyle={{color: 'red'}}>About</Link>
<Link to="/repos" activeStyle={{color: 'red'}}>Repos</Link>
```

另一种做法是，使用`activeClassName`指定当前路由的`Class`。


```javascript
<Link to="/about" activeClassName="active">About</Link>
<Link to="/repos" activeClassName="active">Repos</Link>
```

## IndexLink

如果链接到根路由`/`，不要使用`Link`组件，而要使用`IndexLink`组件。

这是因为对于根路由来说，`activeStyle`和`activeClassName`会失效，或者说总是生效，因为`/`会匹配任何子路由。而IndexLink组件会使用路径的精确匹配。

```javascript
<IndexLink to="/" activeClassName="active">
  Home
</IndexLink>
```

另一种方法是使用`Link`组件的`onlyActiveOnIndex`属性，也能达到同样效果。

```javascript
<Link to="/" activeClassName="active" onlyActiveOnIndex={true}>
  Home
</Link>
```

实际上，`IndexLink`就是对`Link`组件的`onlyActiveOnIndex`属性的包装。

## history

`Router`组件的`history`属性，用来监听浏览器地址栏的变化，并将URL解析成一个地址对象，供 React Router 匹配。

- `hashHistory`
	- 如果设为`hashHistory`，路由将通过URL的hash部分（#）切换，URL的形式类似example.com/#/some/path。
- `browserHistory`
	- 如果设为`browserHistory`，浏览器的路由就不再通过Hash完成了，而显示正常的路径example.com/some/path，背后调用的是浏览器的History API
	- 种情况需要对服务器改造。否则用户直接向服务器请求某个子路由，会显示网页找不到的404错误。
- `createMemoryHistory`
	- `createMemoryHistory`主要用于服务器渲染。它创建一个内存中的history对象，不与浏览器URL互动。
	```javascript
	const history = createMemoryHistory(location)
	```
- `useRouterHistory(createHistory)`
```javascript
import createHashHistory from 'history/lib/createHashHistory'
const history = useRouterHistory(createHashHistory)({ queryKey: false })
```


## 表单处理

`Link`组件用于正常的用户点击跳转，但是有时还需要表单跳转、点击按钮跳转等操作。这些情况怎么跟React Router对接呢？

```javascript
<form onSubmit={this.handleSubmit}>
  <input type="text" placeholder="userName"/>
  <input type="text" placeholder="repo"/>
  <button type="submit">Go</button>
</form>
```

第一种方法是使用`browserHistory.push`

```javascript
import { browserHistory } from 'react-router'

// ...
  handleSubmit(event) {
    event.preventDefault()
    const userName = event.target.elements[0].value
    const repo = event.target.elements[1].value
    const path = `/repos/${userName}/${repo}`
    browserHistory.push(path)
  }
```

第二种方法是使用`context`对象。

```javascript
export default React.createClass({

  // ask for `router` from context
  contextTypes: {
    router: React.PropTypes.object
  },

  handleSubmit(event) {
    // ...
    this.context.router.push(path)
  },
})
```

## 常见配置方案

```javascript
React.render((
  <Router>
    <Route path="/" component={App}>
      <Route path="about" component={About} />
      <Route path="inbox" component={Inbox}>
        <Route path="messages/:id" component={Message} />
      </Route>
    </Route>
  </Router>
), document.body)
```

| URL | 组件| 
| ------| ------ | 
| / | APP | 
| /about | App -> About |
| /inbox | App -> Inbox |
| /inbox/messages/:id | App -> Inbox -> Message |



#### 添加首页

```javascript
React.render((
  <Router>
    <Route path="/" component={App}>
      {/* 当 url 为/时渲染 Dashboard */}
      <IndexRoute component={Dashboard} />
      <Route path="about" component={About} />
      <Route path="inbox" component={Inbox}>
        <Route path="messages/:id" component={Message} />
      </Route>
    </Route>
  </Router>
), document.body)
```

| URL | 组件| 
| ------| ------ | 
| / | App -> Dashboard | 
| /about | App -> About |
| /inbox | App -> Inbox |
| /inbox/messages/:id | App -> Inbox -> Message |


#### 让 UI 从 URL 中解耦出来

```javascript
React.render((
  <Router>
    <Route path="/" component={App}>
      <IndexRoute component={Dashboard} />
      <Route path="about" component={About} />
      <Route path="inbox" component={Inbox}>
        {/* 使用 /messages/:id 替换 messages/:id */}
        <Route path="/messages/:id" component={Message} />
      </Route>
    </Route>
  </Router>
), document.body)
```

| URL | 组件| 
| ------| ------ | 
| / | App -> Dashboard | 
| /about | App -> About |
| /inbox | App -> Inbox |
| /messages/:id | App -> Inbox -> Message |


#### 兼容旧的 URL

现在任何人访问 /inbox/messages/5 都会看到一个错误页面。

```javascript
import { Redirect } from 'react-router'

React.render((
  <Router>
    <Route path="/" component={App}>
      <IndexRoute component={Dashboard} />
      <Route path="about" component={About} />
      <Route path="inbox" component={Inbox}>
        <Route path="/messages/:id" component={Message} />

        {/* 跳转 /inbox/messages/:id 到 /messages/:id */}
        <Redirect from="messages/:id" to="/messages/:id" />
      </Route>
    </Route>
  </Router>
), document.body)
```

#### 替换的配置方式

```javascript
const routeConfig = [
  { path: '/',
    component: App,
    indexRoute: { component: Dashboard },
    childRoutes: [
      { path: 'about', component: About },
      { path: 'inbox',
        component: Inbox,
        childRoutes: [
          { path: '/messages/:id', component: Message },
          { path: 'messages/:id',
            onEnter: function (nextState, replaceState) {
              replaceState(null, '/messages/' + nextState.params.id)
            }
          }
        ]
      }
    ]
  }
]

React.render(<Router routes={routeConfig} />, document.body)
```

> 转载自[react router使用教程](http://www.ruanyifeng.com/blog/2016/05/react_router.html)

	

