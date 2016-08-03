---
title: AngularJs中的directive（二）
date: 2016-07-06 18:09:53
tags: angular
---

## require ##

- ? 如果在当前指令中没有找到所需的控制器，就会将null传递给link函数中的第四个参数

- ^ 如果添加了这个前缀，指令会在上游的指令链中查找require参数所指定的控制器

- ?^ 合并了前面两个说法

- 没有前缀  指令就会自身提供的控制器中查找，如果没有查找到，就会抛出异常来。

## link ##

#### 对于link 与scope ####
scope，我们需要用到一个link函数，他由指令定义对象中的link属性配置。

```javascript
link:function(scope,elem,attrs){
    // scope:父亲controller的scope
    // elem：jqLite(jquery的子集)包装的dom元素，不需要再使用$()包装了。
    // attrs:一个包含了指令所在元素的属性的标准化的参数对象，
    // 例子：比如你在html中添加一些属性，那么可以在link函数中通过attrs.someAttribute来使用他。
}
```

<!--more-->

所以说：`link` 函数主要是为dom 元素添加事件监听，监听模型属性变化，以及更新dom。

另外如果有参数 `require` 的话，对于link 函数方面就会多一个参数 `controller` 

```javascript
{
require:'?ngModal',
link:function(scope,element,attrs,ctrl){
    // 这里 ctrl 就是  require 进来的ctrl
}
}
```

如果require的参数是数组的话。

```javascript
{
require:['?ngModal','?test'],
link:function(scope,element,attrs,ctrls){
    // 这里 ctrl 就是  require 进来的ctrl
    var modalCtrl = ctrls[0];
    var testCtrl = ctrls[1];
}
}
```



## controller ##

类型：字符串或者函数

- 若是为字符串，则将字符串当做是控制器的名字，来查找注册在应用中的控制器的构造函数。

```javascript
angular.module('myApp', [])   
.directive('myDirective', function() {   
  restrict: 'A', // 始终需要  
  controller: 'SomeController'   
})   
// 应用中其他的地方，可以是同一个文件或被index.html包含的另一个文件  
angular.module('myApp')   
.controller('SomeController', function($scope, $element, $attrs, $transclude) {   
  // 控制器逻辑放在这里  
});
```

- 若为匿名函数，直接在指令内部的定义为匿名函数，同样我们可以再这里注入任何服务（$log,$timeout等等）

```javascript
 angular.module('myApp',[])   
 .directive('myDirective', function() {   
   restrict: 'A',   
   controller:   
     function($scope, $element, $attrs, $transclude) {   
       // 控制器逻辑放在这里  
     }   
 });
```

另外还有一些特殊的服务（参数）可以注入:

- `$scope`，与指令元素相关联的作用域
- `$element`，当前指令对应的 元素
- `$attrs`，由当前元素的属性组成的对象
- `$transclude`，嵌入链接函数，实际被执行用来克隆元素和操作DOM的函数

注意： 除非是用来定义一些可复用的行为，一般不推荐在这使用`$transclude`。         

指令的控制器和link函数（后面会讲）可以进行互换。区别在于，控制器主要是用来提供可在指令间复用的行为但link链接函数只能在当前内部指令中定义行为，且无法再指令间复用。

```javascript
angular.module('myApp',[]).directive('mySite', function () {  
return {  
    restrict: 'EA',  
    transclude: true, //注意此处必须设置为true  
    controller:  
    function ($scope, $element,$attrs,$transclude,$log) {  //在这里你可以注入你想注入的服务  
        $transclude(function (clone) {                
            var a = angular.element('<a>');  
                a.attr('href', $attrs.site);  
                a.text(clone.text());  
                $element.append(a);  
            });  
            $log.info("hello everyone");  
        }  
    };  
});
```

HTML代码为：

    <my-site site="http://www.cnblogs.com/cunjieliu">雷锋叔叔的博客</my-site>


#### controller函数与require ####

如果你需要允许其他指令和你的指令发生交互的话，你需要使用controller函数，比如有些情况下，你需要通过组合两个指令来实现一个ui组件，那么你可以通过如下使用

```javascript
app.directive('outerDirective', function() {
  return {
    scope: {},
    restrict: 'AE',
    controller: function($scope, $compile, $http) {
      // $scope is the appropriate scope for the directive
      this.addChild = function(nestedDirective) { // this refers to the controller
        console.log('Got the message from nested directive:' + nestedDirective.message);
      };
    }
  };
});
```

当另外一个指令需要使用到这个controller的时候

```javascript
app.directive('innerDirective', function() {
  return {
    scope: {},
    restrict: 'AE',
    require: '^outerDirective',   //  require controller 方法
    
    // link 参数中就会多一个参数 就是那个require 进来的controller
    link: function(scope, elem, attrs, controllerInstance) {
      //the fourth argument is the controller instance you require
      scope.message = "Hi, Parent directive";
      controllerInstance.addChild(scope);
    }
  };
});
```




