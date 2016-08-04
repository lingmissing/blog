---
title: sessionStorage和localStorage
date: 2016-06-12 14:10:32
tags: html5
---
## sessionStorage和localStorage区别 ##
- `sessionStorage`用于本地存储一个会话（session）中的数据，这些数据只有在同一个会话中的页面才能访问并且当会话结束后数据也随之销毁。因此sessionStorage不是一种持久化的本地存储，仅仅是会话级别的存储。
- `localStorage`用于持久化的本地存储，除非主动删除数据，否则数据是永远不会过期的。
## web storage和cookie的区别 ##
- `Cookie`的大小是受限的，并且每次你请求一个新的页面的时候Cookie都会被发送过去，这样无形中浪费了带宽，另外cookie还需要指定作用域，不可以跨域调用。
- `Web Storage`拥有setItem,getItem,removeItem,clear等方法，不像cookie需要前端开发者自己封装setCookie，getCookie。
- `Cookie`的作用是与服务器进行交互，作为HTTP规范的一部分而存在 ，而`Web Storage`仅仅是为了在本地“存储”数据而生。
## localStorage和sessionStorage操作 ##
#### setItem存储value ####
用途：将value存储到key字段
用法：.setItem( key, value)
代码示例：
```javascript
sessionStorage.setItem("key", "value");         
localStorage.setItem("site", "js8.in");
```
#### getItem获取value ####
用途：获取指定key本地存储的值
用法：.getItem(key)
代码示例：
```javascript
var value = sessionStorage.getItem("key");     
var site = localStorage.getItem("site");
```
#### removeItem删除key ####
用途：删除指定key本地存储的值
用法：.removeItem(key)
代码示例：
```javascript
sessionStorage.removeItem("key");   
localStorage.removeItem("site");
```
#### clear清除所有的key/value ####
用途：清除所有的key/value
用法：.clear()
代码示例：
```javascript
sessionStorage.clear();  
localStorage.clear();
```
#### 其他操作方法：点操作和[] ####
web Storage不但可以用自身的setItem,getItem等方便存取，也可以像普通对象一样用点(.)操作符，及[]的方式进行数据存储，像如下的代码：
```javascript
var storage = window.localStorage; 
storage.key1 = "hello"; 
storage["key2"] = "world"; 
console.log(storage.key1); 
console.log(storage["key2"]);
```
#### localStorage和sessionStorage的key和length属性实现遍历 ####
sessionStorage和localStorage提供的key()和length可以方便的实现存储的数据遍历，例如下面的代码：
```javascript
var storage = window.localStorage;
for (var i=0, len = storage.length; i < len; i++){
    var key = storage.key(i);
    var value = storage.getItem(key);
    console.log(key + "=" + value);
}
```
## storage事件 ##
storage还提供了storage事件，当键值改变或者clear的时候，就可以触发storage事件，如下面的代码就添加了一个storage事件改变的监听：
```javascript
if(window.addEventListener){  
     window.addEventListener("storage",handle_storage,false);
}else if(window.attachEvent){      
     window.attachEvent("onstorage",handle_storage);
}
function handle_storage(e){ 
     if(!e){e=window.event;}  
}
```
storage事件对象的具体属性如下表：

|  属性                   |     类型                     | 说明                     |
|-------------------------|------------------------------|--------------------------|
| Property                | Type                         | 读取一个 jsons 文件      |
| key                     | string                       |  less 编译               |
| oldValue                | any                          | scss 编译                |
| newValue                | any                          | css 插件处理器           |
| url/uri                 | string                       | 解析 css 添加前缀 css 规则 |


