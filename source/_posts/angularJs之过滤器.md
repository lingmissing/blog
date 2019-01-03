---
title: angularJs之过滤器
date: 2016-07-14 10:12:06
tags: angular
---

### filter的使用方法 ###

- 在模板中使用`filter`


我们可以直接使用`filter`，跟在表达式后面用 | 分割

	{{ expression | filter }}

也可以多个`filter`连用，上一个`filter`的输出将作为下一个`filter`的输入
			
	{{ expression | filter1 | filter2 | ... }}

`filter`可以接收参数，参数用 : 进行分割

	{{ expression | filter:argument1:argument2:... }}

除了对数据进行格式化，我们还可以在指令中使用`filter`，例如先对数组`array`进行过滤处理，然后再循环输出：

	<span ng-repeat="a in array | filter ">

<!-- more -->

- 在`controller`和`service`中使用`filter`

我们的js代码中也可以使用过滤器，方式就是我们熟悉的依赖注入，例如我要在`controller`中使用`currency`过滤器，只需将它注入到该`controller`中即可，代码如下：

```javascript
app.controller('testC',function($scope,currencyFilter){
    $scope.num = currencyFilter(123534);  
}
```

在模板中使用`{{num}}`就可以直接输出$123,534.00了！在服务中使用`filter`也是同样的道理。

此时你可能会有疑惑，如果我要在`controller`中使用多个`filter`，难道要一个一个注入吗？ng提供了一个`$filter`服务可以来调用所需的`filter`，你只需注入一个`$filter`就够了，使用方法如下：

```javascript
app.controller('testC',function($scope,$filter){
    $scope.num = $filter('currency')(123534);
　　$scope.date = $filter('date')(new Date());  
}
```

### 内置过滤器 ###

- `currency` (货币处理)

使用`currency`可以将数字格式化为货币，默认是美元符号，你可以自己传入所需的符号，例如我传入人民币：

	{{num | currency : '￥'}}

- `date` (日期格式化)

原生的js对日期的格式化能力有限，ng提供的date过滤器基本可以满足一般的格式化要求。用法如下：

	{{date | date : 'yyyy-MM-dd hh:mm:ss EEEE'}}

　　参数用来指定所要的格式，y M d h m s E 分别表示 年 月 日 时 分 秒 星期，你可以自由组合它们。也可以使用不同的个数来限制格式化的位数。另外参数也可以使用特定的描述性字符串，例如“shortTime”将会把时间格式为12:05 pm这样的。ng提供了八种描述性的字符串，个人觉得这些有点多余，我完全可以根据自己的意愿组合出想要的格式，不愿意去记这么多单词~

- `filter`(匹配子串)

　　这个名叫`filter`的`filter`（不得不说这名字起的，真让人容易混淆——！）用来处理一个数组，然后可以过滤出含有某个子串的元素，作为一个子数组来返回。可以是字符串数组，也可以是对象数组。如果是对象数组，可以匹配属性的值。它接收一个参数，用来定义子串的匹配规则。下面举个例子说明一下参数的用法，我用现在特别火的几个孩子定义了一个数组：

```javascript
$scope.childrenArray = [
        {name:'kimi',age:3},
        {name:'cindy',age:4},
        {name:'anglar',age:4},
        {name:'shitou',age:6},
        {name:'tiantian',age:5}
    ];
$scope.func = function(e){return e.age>4;}

{{ childrenArray | filter : 'a' }} //匹配属性值中含有a的
{{ childrenArray | filter : 4 }}  //匹配属性值中含有4的
{{ childrenArray | filter : {name : 'i'} }} //参数是对象，匹配name属性中含有i的
{{childrenArray | filter : func }}  //参数是函数，指定返回age>4的
```

- `json`(格式化json对象)

　　`json`过滤器可以把一个js对象格式化为`json`字符串，没有参数。这东西有什么用呢，我一般也不会在页面上输出一个json串啊，官网说它可以用来进行调试，嗯，是个不错的选择。或者，也可以用在js中使用，作用就和我们熟悉的`JSON.stringify()`一样。用法超级简单：

		{{ jsonTest | json}}

- `limitTo`(限制数组长度或字符串长度)

　　`limitTo`过滤器用来截取数组或字符串，接收一个参数用来指定截取的长度，如果参数是负值，则从数组尾部开始截取。个人觉得这个`filter`有点鸡肋，首先只能从数组或字符串的开头/尾部进行截取，其次，js原生的函数就可以代替它了，看看怎么用吧：

		{{ childrenArray | limitTo : 2 }}  //将会显示数组中的前两项

- `lowercase`(小写)

　　把数据转化为全部小写。太简单了，不多解释。同样是很鸡肋的一个filter，没有参数，只能把整个字符串变为小写，不能指定字母。

- `uppercase`(大写)
　　同上。

- `number`(格式化数字)

　　`number`过滤器可以为一个数字加上千位分割，像这样，123,456,789。同时接收一个参数，可以指定float类型保留几位小数：

		{{ num | number : 2 }}

- `orderBy`(排序)

　　`orderBy`过滤器可以将一个数组中的元素进行排序，接收一个参数来指定排序规则，参数可以是一个字符串，表示以该属性名称进行排序。可以是一个函数，定义排序属性。还可以是一个数组，表示依次按数组中的属性值进行排序（若按第一项比较的值相等，再按第二项比较），还是拿上面的孩子数组举例：

```html
<div>{{ childrenArray | orderBy : 'age' }}</div>      //按age属性值进行排序，若是-age，则倒序
<div>{{ childrenArray | orderBy : orderFunc }}</div>   //按照函数的返回值进行排序
<div>{{ childrenArray | orderBy : ['age','name'] }}</div>  //如果age相同，按照name进行排序
```
　　

### 自定义过滤器 ###

filter的自定义方式也很简单，使用`module`的`filter`方法，返回一个函数，该函数接收输入值，并返回处理后的结果。

```javascript
app.filter('odditems',function(){
    return function(inputArray){
        var array = [];
        for(var i=0;i<inputArray.length;i++){
            if(i%2!==0){
                array.push(inputArray[i]);
            }
        }
        return array;
    }
});
```

格式就是这样，你的处理逻辑就写在内部的那个闭包函数中。你也可以让自己的过滤器接收参数，参数就定义在`return`的那个函数中，作为第二个参数，或者更多个参数也可以。

下面看一个完整案例：

```html
<div ng-controller="myAppCtrl">
    name:{{ name }}<br>
    reverse name:{{ name | reverse }}<br>
    reverse&uppercase name:{{ name | reverse:true }}
</div>
```

```javascript
var myAppModule = angular.module("myApp",[]);

myAppModule.controller("myAppCtrl",["$scope",function($scope){
    $scope.name = "xingoo";
}]);

myAppModule.filter("reverse",function(){
    return function(input,uppercase){
        var out = "";
        for(var i=0 ; i<input.length; i++){
            out = input.charAt(i)+out;
        }
        if(uppercase){
            out = out.toUpperCase();
        }
        return out;
    }
});
```