---
title: angularJs之路由
date: 2016-07-12 17:19:01
tags: angular
categories: 前端框架之angular
---

## 为什么需要前端路由 ##

- `Ajax`请求不会留下`history`记录
- 用户无法直接通过url进入应用中的指定页面（保存书签，链接分享给朋友）
- `Ajax`对`SEO`不友好（没法让搜索引擎索引）

## Angular 路由 ##

在`APP`中定义多个页面的控制器，并给出对应的模板。然后`$routeProvider`进行配置，即可将URL映射到这些控制器和视图。 首先定义一个基本的Angular APP，并引入`ngRoute`：

> Angular`$routeService`在`ngRoute`模块里。需要引入它对应的JavaScript文件，并在我们的APP里`ngRoute`添加为模块依赖。

<!-- more -->

```javascript
var app = angular.module('ngRouteExample', ['ngRoute'])
    .controller('MainController', function($scope) {
    })
    .config(function($routeProvider, $locationProvider) {
      $routeProvider
          .when('/users', {
              templateUrl: 'user-list.html',
              controller: 'UserListCtrl'
          })
          .when('/users/:username', {
              templateUrl: 'user.html',
              controller: 'UserCtrl'
          })
		  .otherwise({
		  	  redirectTo: '/hello'
		  });

        // configure html5
        $locationProvider.html5Mode(true);
    });
```

<!-- more -->

上述代码中，`$routeProvider`定义了两个URL的映射：`/users`使用`user-list.html`作为模板，`UserListCtrl`作为控制器；`/users/:username`则会匹配类似`/users/alice`之类的URL，稍后你会看到如何获得`:username`匹配到的值。先看首页的模板：

> `HTML5Mode`： 服务器端路由和客户端路由的URL以#分隔。例如`/foo/bar#/users/alice`，Angular通过操作锚点来进行路由。 然而`html5Mode(true)`将会去除#，URL变成`/foo/bar/users/alice`（这需要浏览器支持HTML5的，因为此时Angular通过`pushState`来进行路由）。 此时服务器对所有的客户端路由的URL都需要返回首页（`/foo/bar`）视图，再交给Angular路由到`/foo/bar/users/alice`对应的视图。

```html
<div ng-controller="MainController">
  Choose:
  <a href="users">user list</a> |
  <a href="users/alice">user: alice</a>

  <div ng-view></div>
</div>
```
注意到模板文件中有一个`div[ng-view]`，子页面将会载入到这里。

#### 路由参数 ####

用户列表页面：

```javascript
app.controller('UserListCtrl', function($scope) {});
```

```html
<!--user-list.html-->
<h1>User List Page</h1>
```

用户页面：

```javascript
app.controller('UserCtrl', function($scope, $routeParams) {
    $scope.params = $routeParams;
});
```

```html
<!--user.html-->
<h1>User Page</h1>
<span ng-bind="params.userName"></span>
```

我们点击首页的`/users/alice`时，将会载入`user.html`，`span`的值为`alice`。`$routeParams`提供了当前的路由参数，例如：

```javascript
// Given:
// URL: http://server.com/index.html#/Chapter/1/Section/2?search=moby
// Route: /Chapter/:chapterId/Section/:sectionId
//
// Then
$routeParams ==> {chapterId:'1', sectionId:'2', search:'moby'}
```

## UI-Router ##

UI-Router是Angular-UI提供的客户端路由框架，它解决了原生的ng-route的很多不足：

- 视图不能嵌套。这意味着`$scope`会发生不必要的重新载入。这也是我们在`Onboar`d中引入ui-route的原因。
- 同一URL下不支持多个视图。这一需求也是常见的：我们希望导航栏用一个视图（和相应的控制器）、内容部分用另一个视图（和相应的控制器）。

UI-Router提出了`$state`的概念。一个`$state`是一个当前导航和UI的状态，每个`$state`需要绑定一个URL Pattern。 在控制器和模板中，通过改变`$state`来进行URL的跳转和路由。这是一个简单的例子：

```html
<!-- in index.html -->
<body ng-controller="MainCtrl">
<section ui-view></section>
</body>
```


```javascript
// in app-states.js
var myUIRoute = angular.module('MyUIRoute', ['ui.router', 'ngAnimate']);
myUIRoute.config(function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise("/contacts");
    $stateProvider
        .state('contacts', {
            url: '/contacts',
            template: 'contacts.html',
            controller: 'ContactCtrl'
        })
        .state('contacts.detail', {
            url: "/contacts/:contactId",
            templateUrl: 'contacts.detail.html',
            controller: function ($stateParams) {
                // If we got here from a url of /contacts/42
                $stateParams.contactId === "42";
            }
        });
});
```


当访问`/contacts`时，`contacts $state`被激活，载入对应的控制器和视图。在ui-router时，通常使用`$state`来完成页面跳转， 而不是直接操作URL。例如，在脚本使用`$state.go`：

```javascript
$state.go('contacts');  // 指定state名，相当于跳转到 /contacts
$state.go('contacts.detail', {contactId: 42});  // 相当于跳转到 /contacts/42
```

在模板中使用`ui-sref`（这是一个Directive）：

```html
<a ui-sref="contacts">Contacts</a>
<a ui-sref="contacts.detail({contactId: 42})">Contact 42</a>
```

#### 嵌套视图 ####

不同于Angular原生的`ng-route`，ui-router的视图可以嵌套，视图嵌套通常对应着`$state`的嵌套。 `contacts.detail`是`contacts`的子`$state`，`contacts.detail.html`也将作为`contacts.html`的子页面：

```html
<!-- contacts.html -->
<h1>My Contacts</h1>
<div ui-view></div>
```

```html
<!-- contacts.detail.html -->
<span ng-bind='contactId'></span>
```

上述`ui-view`的用法和`ng-view`看起来很相似，但不同的是`ui-view`可以配合`$state`进行任意层级的嵌套， 即`contacts.detail.html`中仍然可以包含一个`ui-view`，它的`$state`可能是`contacts.detail.hobbies`。

#### 命名视图 ####

在ui-router中，一个`$state`下可以有多个视图，它们有各自的模板和控制器。这一点也是`ng-route`所没有的， 给了前端路由极大的灵活性。来看例子：

```html
<!-- index.html -->
<body>
  <div ui-view="filters"></div>
  <div ui-view="tabledata"></div>
  <div ui-view="graph"></div>
</body>
```

这一个模板包含了三个命名的`ui-view`，可以给它们分别设置模板和控制器：

```javascript
$stateProvider
  .state('report',{
    views: {
      'filters': {
        templateUrl: 'report-filters.html',
        controller: function($scope){ ... controller stuff just for filters view ... }
      },
      'tabledata': {
        templateUrl: 'report-table.html',
        controller: function($scope){ ... controller stuff just for tabledata view ... }
      },
      'graph': {
        templateUrl: 'report-graph.html',
        controller: function($scope){ ... controller stuff just for graph view ... }
      }
    }
  })
```

#### 综合实例 ####

HTML:

```html
//uiRoute.html
<div ui-view></div>
```

```html
//index.html
<div class="container">
	//头部
    <div ui-view="topbar"></div>
	//主体
    <div ui-view="main"></div>
</div>
```

```html
//topbar.html
//顶部
<nav class="navbar navbar-inverse" role="navigation">
    <div class="navbar-header">
        <a class="navbar-brand" ui-sref="#">ui-router综合实例</a>
    </div>
    <ul class="nav navbar-nav">
        <li>
            <a ui-sref="index">首页</a>
        </li>
        <li>
            <a ui-sref="index.usermng">用户管理</a>
        </li>
    </ul>
</nav>

```

```html
//usermng.html
//左侧
<div class="row">
    <div class="col-md-3">
        <div class="row">
            <div class="col-md-12">
                <div class="list-group">
                    <a ui-sref="#" class="list-group-item active">用户分类</a>
                    <a ui-sref="index.usermng.highendusers" class="list-group-item">高端用户</a>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <button class="btn btn-primary" ng-click="addUserType()">新增用户</button>
            </div>
        </div>
    </div>
    <div class="col-md-9">
		//用于存放右边部分
        <div ui-view></div>
    </div>
</div>

```

```html
//highendusers.html
。。。
```



javascript:

```javascript
var routerApp = angular.module('routerApp', ['ui.router']);
routerApp.config(function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/index');
    $stateProvider
        .state('index', {
            url: '/index',
            views: {
                '': {
                    templateUrl: 'tpls/index.html'
                },
                'topbar@index': {
                    templateUrl: 'tpls/topbar.html'
                },
                'main@index': {
                    templateUrl: 'tpls/home.html'
                }
            }
        })
        .state('index.usermng', {
            url: '/usermng',
            views: {
                'main@index': {
                    templateUrl: 'tpls/usermng.html',
                    controller: function($scope, $state) {
                        $scope.addUserType = function() {
                            $state.go("index.usermng.addusertype");
                        }
                    }
                }
            }
        })
        .state('index.usermng.highendusers', {
            url: '/highendusers',
            templateUrl: 'tpls/highendusers.html'
        })
        .state('index.usermng.addusertype', {
            url: '/addusertype',
            templateUrl: 'tpls3/addusertypeform.html',
            controller: function($scope, $state) {
                $scope.backToPrevious = function() {
                    window.history.back();
                }
            }
        })
});

```

> 转载自：[http://harttle.com/2015/06/10/angular-route.html](http://harttle.com/2015/06/10/angular-route.html "ng-route 与 ui-router")
