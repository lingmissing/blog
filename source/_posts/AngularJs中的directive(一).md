---
title: AngularJs中的directive（一）
date: 2016-07-04 10:09:53
tags: angular
---

```javascript
angular.module('app', []).directive('directiveName', function() {
  return {
    //通过设置项来定义
  }
})
```

<!--more-->

## restrict

类型：（字符串）可选参数

取值有：`E`(元素),`A`(属性),`C`(类),`M`(注释)，其中默认值为`A`；

- `E`(元素)：`<directiveName></directiveName>`
- `A`(属性)：`<div directiveName='expression'></div>`
- `C`(类)：`<div class='directiveName'></div>`
- `M`(注释)：`<-- directive:directiveName expression-->`

## template

类型：（字符串或者函数）可选参数

```javascript
var myModule = angular.module('MyModule', [])
myModule.directive('hello', function() {
  return {
    restrict: 'AEMC',
    template: '<div>Hi everyone!</div>',
    replace: true
  }
})
```

HTML 代码为：`<hello></hello>`

```javascript
angular.module('app', []).directive('directitle', function() {
  return {
    restrict: 'EAC',
    template: function(tElement, tAttrs) {
      var _html = ''
      _html += '<div>' + tAttrs.title + '</div>'
      return _html
    }
  }
})
```

HTML 代码为：`<directitle title="biaoti"></directitle>`

## templateUrl

类型：（字符串或者函数），可选参数

- 一个代表 HTML 文件路径的字符串
- 一个函数，可接受两个参数 tElement 和 tAttrs（大致同上）

```javascript
var myModule = angular.module("MyModule", []);
}])
myModule.directive("hello", function() {
    return {
        restrict: 'AECM',
        templateUrl: 'hello-tpl.html',
        replace: true
    }
});
```

注意：在本地开发时候，需要运行一个服务器，不然使用 templateUrl 会报错

## templateCache

由于加载 html 模板是通过异步加载的，若加载大量的模板会拖慢网站的速度，这里有个技巧，就是先缓存模板。

```javascript
var myModule = angular.module('MyModule', [])

//注射器加载完所有模块时，此方法执行一次
myModule.run(function($templateCache) {
  //使用内置的方法缓存起来
  $templateCache.put('hello.html', '<div>Hello everyone!!!!!!</div>')
})

myModule.directive('hello', function($templateCache) {
  return {
    restrict: 'AECM',
    //使用get方法获取
    template: $templateCache.get('hello.html'),
    replace: true
  }
})
```

## replace

类型：（布尔值），默认值为 false

如果设置 repace:true 的话，就会隐藏掉对于指令命名的 html 标签

类似<hello></hello>如果 replace 设置为 true 的话，就会消失不显示。

```javascript
var myModule = angular.module('MyModule', [])
myModule.directive('hello', function() {
  return {
    restrict: 'AE',
    template: '<div>Hello everyone!</div>',
    //可以嵌套，默认为false
    replace: true
  }
})
```

HTML 代码为：`<hello></hello>`

渲染之后的代码：`<div><h3>hello world</h3></div>`

对比下没有开启`replace`时候的渲染出来的 HTML。发现`<hello></hello>`不见了。

## transclude

类型：（布尔值或者字符`element`），默认值为`false`；

如果设置了`transclude`为`true`的话，就会把原本指令标签中用于写的东西放置到`ng-transclude` 中去。

```javascript
var myModule = angular.module('MyModule', [])
myModule.directive('hello', function() {
  return {
    restrict: 'AE',
    transclude: true,
    template: '<div>Hello everyone!<div ng-transclude></div></div>'
  }
})
```

HTML 代码为：

```html
<hello> <div>这里是指令内部的内容。</div> </hello>
```

注意:在一个指令的模板 template 上只能申明一个 ng-transclude。

如果我们想把嵌入部分多次放入我们的模板中要怎么办？则可以在`link`或者`controller`里面添加一个参数`$transclude` 。

```javascript
link:function($scope,$element,$attrs,controller,$transclude){
    // clone 参数就是用户输入进去的内容。
    $transclude(function(clone){
        // 进行其他操作。
    });
}
```

```javascript
var app = angular.module('app', [])
app.directive('myLink', function() {
  return {
    restrict: 'EA',
    transclude: true,
    controller: function($scope, $element, $attrs, $transclude) {
      $transclude(function(clone) {
        var a = angular.element('<a>')
        a.attr('href', $attrs.value)
        a.attr('target', $attrs.target)
        a.text(clone.text())
        $element.append(a)
      })
    }
  }
})
```

HTML 代码为：

```html
<div my-link value=" target="_blank">百度</div>
```

#### transclude:'element' 和 transclude:true 的区别

有时候我们要嵌入指令元素本身，而不仅仅是他的内容，这种情况下，我们需要使用`transclude:"element"`,和`transclude:true`不同，他讲标记了`ng-transclude`指令的元素一起包含到了指令模板中，使用`transclusion`， 你的`link`函数会获取到一个叫`transclude`的链接函数，这个函数绑定了正确的指令`scope`，并且传入了另外一个拥有被嵌入 dom 元素拷贝的函数，你可以在这个`transclude`函数中执行比如修改元素拷贝或者将他添加到 dom 上等操。

## scope

类型：可选参数，（布尔值或者对象）

- 默认值 false，表示继承父作用域（儿子继承父亲的值，改变父亲的值，儿子的值也随之变化，反之亦如此）;
- true，表示继承父作用域，并创建自己的作用域（子作用域）（儿子继承父亲的值，改变父亲的值，儿子的值随之变化，但是改变儿子的值，父亲的值不变）;
- {}，表示创建一个全新的隔离作用域（没有继承父亲的值，所以儿子的值为空，改变任何一方的值均不能影响另一方的值）；

为了让隔离作用域能读取父作用域的属性，产生了绑定策略：

#### 使用@（@attr）来进行单向文本（字符串）绑定

```javascript
var app = angular.module('myApp', [])
app.controller('MainController', function() {})
app.directive('helloWorld', function() {
  return {
    scope: { color: '@colorAttr' }, //指明了隔离作用域中的属性color应该绑定到属性colorAttr
    restrict: 'AE',
    replace: true,
    template: '<p style="background-color:{{color}}">Hello World</p>'
  }
})
```

HTML 代码为：`<hello-world color-attr='{{color}}'></hello-world>`

这种办法只能单向，通过在运行的指令的那个 html 标签上设置`color-attr`属性，并且采用双层花括号绑定某个模型值。

提示：如果绑定的隔离作用域属性名与元素的属性名相同，则可以采取缺省写法。

HTML 代码为：

```html
<hello-world color="{{color}}"/></hello-world>
```

js 定义指令的片段：

```javascript
app.directive('helloWorld',function(){
 return {
     scope: {
         color: '@'
     },
     ...
     //配置的余下部分
 }
});
```

#### 使用=（=attr）进行双向绑定

```javascript
var app = angular.module('myApp', [])
app.controller('MainController', function() {})
app.directive('helloWorld', function() {
  return {
    scope: { color: '=' },
    restrict: 'AE',
    replace: true,
    template:
      '<div style="background-color:{{color}}">Hello World<div><input type="text" ng-model="color"></div></div>'
  }
})
```

HTML 代码为：

```html
<input type="text" ng-model="color" placeholder="Enter a color" /> {{color}}
<hello-world color="color"></hello-world>
```

#### 使用&来调用父作用域中的函数

```javascript
var myModule = angular.module('MyModule', [])
myModule.controller('MyCtrl', [
  '$scope',
  function($scope) {
    $scope.sayHello = function(name) {
      alert('Hello ' + name)
    }
  }
])
myModule.directive('greeting', function() {
  return {
    restrict: 'AE',
    scope: {
      greet: '&'
    },
    template:
      '<input type="text" ng-model="userName" /><br/>' +
      '<button class="btn btn-default" ng-click="greet({name:userName})">Greeting</button><br/>'
  }
})
```

HTML 代码为：

```html
<greeting greet="sayHello(name)"></greeting>
```

备注：

- & 父级作用域： 传递进来的参数必须是父级的函数方法， 然后在指令中，通过 test() 获取到 传递进来的函数，这个还不够，还必须再执行一次 test()() 才是真正的执行这个方法。
- @ 本地作用域： 只能传递字符串进来，对于方法或者对象是传递不进来的。
- = 双向属性： 可以传递对象进来，也可以是字符串，但是不能传递方法。 同时可以在指令中修改这个对象，父级里面的这个对象也会跟着修改的。
