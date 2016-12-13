---
title: AngularJs中的provide
date: 2016-07-04 17:26:54
tags: angular
categories: 前端框架之angular
---
`AngularJS`用`$provide`去定义一个供应商,这个`$provide`有5个用来创建供应商的方法：

- `constant`
- `value`
- `service`
- `factory`
- `provider`
- `decorator`

<!-- more -->

## Constant ##
定义常量用的，它定义的值当然就不能被改变，它可以被注入到任何地方，但是不能被装饰器(`decorator`)装饰

```javascript
var app = angular.module('app', []);
 
app.config(function ($provide) {
  $provide.constant('movieTitle', 'The Matrix');
});
 
app.controller('ctrl', function (movieTitle) {
  expect(movieTitle).toEqual('The Matrix');
});
```

语法糖：

```javascript
app.constant('movieTitle', 'The Matrix');
```

<!--more-->

## Value ##
它可以是`string,number`甚至`function`,它和`constant`的不同之处在于，它可以被修改，不能被注入到`config`中，但是它可以被`decorator`装饰


```javascript
var app = angular.module('app', []);
 
app.config(function ($provide) {
  $provide.value('movieTitle', 'The Matrix')
});
 
app.controller('ctrl', function (movieTitle) {
  expect(movieTitle).toEqual('The Matrix');
})
```

语法糖：

```javascript
app.value('movieTitle', 'The Matrix');
```

## Service ##

当使用`service`创建服务的时候，相当于使用`new`关键词进行了实例化。因此，你只需要在`this`上添加属性和方法，然后，服务就会自动的返回`this`。当把这个服务注入控制器的时候，控制器就可以访问在那个对象上的属性了。

```javascript
var app = angular.module('app' ,[]);
 
app.config(function ($provide) {
  $provide.service('movie', function () {
    this.title = 'The Matrix';
  });
});
 
app.controller('ctrl', function (movie) {
  expect(movie.title).toEqual('The Matrix');
});
```

语法糖：

```javascript
app.service('movie', function () {
  this.title = 'The Matrix';
});
```

在`service`里面可以不用返回东西，因为`AngularJS`会调用`new`关键字来创建对象。但是返回一个自定义对象好像也不会出错。

## Factory ##

它是一个可注入的`function`，它和`service`的区别就是：`factory`是普通`function`，而`service`是一个构造器(`constructo`r)，这样`Angular`在调用`service`时会用new关键字，而调用`factory`时只是调用普通的`function`，所以`factory`可以返回任何东西，而`service`可以不返回(可查阅`new`关键字的作用)

当使用`factory`来创建服务的时候，相当于新创建了一个对象，然后在这个对象上新添属性，最后返回这个对象。当把这个服务注入控制器的时候，控制器就可以访问在那个对象上的属性了。

```javascript
var app = angular.module('app', []);
 
app.config(function ($provide) {
  $provide.factory('movie', function () {
    return {
      title: 'The Matrix';
    }
  });
});
 
app.controller('ctrl', function (movie) {
  expect(movie.title).toEqual('The Matrix');
});
```

语法糖：

```javascript
app.factory('movie', function () {
  return {
    title: 'The Matrix';
  }
});
```

`factory`可以返回任何东西，它实际上是一个只有`$get`方法的`provider`

## Provider ##

`provider`是唯一一种可以创建用来注入到`config()`函数的服务的方式。想在你的服务启动之前，进行一些模块化的配置的话，就使用`provider`。

`provider`是他们的老大，上面的几乎(除了`constant`)都是`provider`的封装，`provider`必须有一个`$get`方法，当然也可以说`provider`是一个可配置的`factory`


```javascript
var app = angular.module('app', []);
 
app.provider('movie', function () {
  var version;
  return {
    setVersion: function (value) {
      version = value;
    },
    $get: function () {
      return {
          title: 'The Matrix' + ' ' + version
      }
    }
  }
});
 
app.config(function (movieProvider) {
  movieProvider.setVersion('Reloaded');
});
 
app.controller('ctrl', function (movie) {
  expect(movie.title).toEqual('The Matrix Reloaded');
});
```

注意这里`config`方法注入的是`movieProvider`，上面定义了一个供应商叫`movie`，但是注入到`config`中不能直接写`movie`，因为前文讲了注入的那个东西就是服务，是供应商提供出来的，而`config`中又只能注入供应商（两个例外是`$provide`和`$injector`），所以用驼峰命名法写成`movieProvider`，`Angular`就会帮你注入它的供应商。

## Decorator ##

这个比较特殊，它不是`provider`,它是用来装饰其他`provider`的，而前面也说过，他不能装饰`Constant`，因为实际上`Constant`不是通过`provider()`方法创建的。


```javascript
var app = angular.module('app', []);
 
app.value('movieTitle', 'The Matrix');
 
app.config(function ($provide) {
  $provide.decorator('movieTitle', function ($delegate) {
    return $delegate + ' - starring Keanu Reeves';
  });
});
 
app.controller('myController', function (movieTitle) {
  expect(movieTitle).toEqual('The Matrix - starring Keanu Reeves');
});
```

## 总结 ##

- 所有的供应商都只被实例化一次，也就说他们都是单例的
- 除了`constant`，所有的供应商都可以被装饰器(`decorator`)装饰
- `value`就是一个简单的可注入的值
- `service`是一个可注入的构造器
- `factory`是一个可注入的方法
- `decorator`可以修改或封装其他的供应商，当然除了`constant`
- `provider`是一个可配置的`factory`

