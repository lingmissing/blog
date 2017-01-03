---
title: jquery中each的用法
date: 2016-05-19 16:33:32
tags: jquery
categories:  代码如诗，前端如画
---
## 遍历html对象 ##

```javascript
$('.obj').each(function(){
  var $this = $(this);
});
```

## 遍历对象 ##

- 有附加参数

```javascript
$.each(Object, function(p1, p2) {
  this;   //这里的this指向每次遍历中Object的当前属性值
  p1; p2; //访问附加参数
}, ['参数1', '参数2']);
```
<!-- more -->
- 无附加参数

```javascript
$.each(Object, function(name, value) {
  this;      //this指向当前属性的值
  name;      //name表示Object当前属性的名称
  value;     //value表示Object当前属性的值
});
```

<!--more-->

## 遍历数组 ##

- 有附加参数

```javascript
$.each(Array, function(p1, p2){
  this;       //这里的this指向每次遍历中Array的当前元素
  p1; p2;     //访问附加参数
}, ['参数1', '参数2']);
```

- 无附加参数

```javascript
$.each(Array, function(i, value) {
  this;      //this指向当前元素
  i;         //i表示Array当前下标
  value;     //value表示Array当前元素
});
```

## 案例分析 ##

Js代码1：

```javascript
var arr = [ "one", "two", "three", "four"];     
$.each(arr, function(){     
  alert(this);     
}); 
```   
 
上面这个each输出的结果分别为：

 `one,two,three,four ` 

Js代码2:

```javascript
var arr1 = [[1, 4, 3], [4, 6, 6], [7, 20, 9]];     
$.each(arr1, function(i, item){     
  alert(item[0]);     
}); 
```  
  
其实arr1为一个二维数组，item相当于取每一个一维数组，item[0]相对于取每一个一维数组里的第一个值,所以上面这个each输出分别为：

	`1   4   7`    

Js代码3:

```javascript
var obj = { one:1, two:2, three:3, four:4};     
$.each(obj, function(key, val) {     
  alert(obj[key]); 
  // alert(val);  效果相同        
}); 
```  

这个each能循环每一个属性,输出结果为：
	`1  2  3  4`
> 转载：[http://wenku.baidu.com/view/4796b6145f0e7cd18425368e.html](http://wenku.baidu.com/view/4796b6145f0e7cd18425368e.html "$.each的用法")