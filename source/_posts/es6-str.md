---
title: ES6展开运算符
date: 2016-08-25 21:05:00
tags: [javascript,es6]
categories:  代码如诗，前端如画
---

### 语法
- 用于函数调用
    ```javascript
    myFunction(...iterableObj);
    ```
- 用于数组字面量
    ```javascript
    [...iterableObj, 4, 5, 6]
    ```
### 函数传参

<!-- more -->

目前为止,我们都是使用`Function.prototype.apply`方法来将一个数组展开成多个参数:

```javascript
function myFunction(x, y, z) { }
var args = [0, 1, 2];
myFunction.apply(null, args);
```
使用es6的展开运算符可以这么写：

```javascript
function myFunction(x, y, z) { }
var args = [0, 1, 2];
myFunction(...args);
```

- 选择性传参
    ```javascript
    function filter(type, ...items) {
        return items.filter(item => typeof item === type);
    }
    filter('boolean', true, 0, false);        // => [true, false]
    filter('number', false, 4, 'Welcome', 7); // => [4, 7]
    ```

还可以同时展开多个数组：

```javascript
function myFunction(v, w, x, y, z) { }
var args = [0, 1];
myFunction(-1, ...args, 2, ...[3]);
```
### 数据解构

```javascript
let cold = ['autumn', 'winter'];
let warm = ['spring', 'summer'];
// 析构数组
let otherSeasons, autumn;
[autumn, ...otherSeasons] = cold;
otherSeasons      // => ['winter']
```
### 数据构造
- 两个对象连接返回新的对象
    ```javascript
    let a = {aa:'aa'}
    let b = {bb:'bb'}
    let c = {...a,...b}
    console.log(c)
    // {"aa":"aa","bb":"bb"}
    ```
- 两个数组连接返回新的数组
    ```javascript
    let d = ['dd']
    let e = ['ee']
    let f = [...d,...e]
    console.log(f)
    // ["dd","ee"]
    ```
    - 在中间插入数组
        ```javascript
        var parts = ['shoulder', 'knees'];
        var lyrics = ['head', ...parts, 'and', 'toes']; // ["head", "shoulders", "knees", "and", "toes"]
        ```
    - 在尾部插入数组
        ```javascript
        // ES5
        var arr1 = [0, 1, 2];
        var arr2 = [3, 4, 5];
        // 将arr2中的所有元素添加到arr1中
        Array.prototype.push.apply(arr1, arr2);

        // ES6
        var arr1 = [0, 1, 2];
        var arr2 = [3, 4, 5];
        arr1.push(...arr2);
        ```

- 数组加上对象返回新的数组
    ```javascript
    let g = [{gg:'gg'}]
    let h = {hh:'hh'}
    let i = [...g,h]
    console.log(i)
    // [{"gg":"gg"},{"hh":"hh"}
    ```
- 数组+字符串
    ```javascript
    let j = ['jj']
    let k = 'kk'
    let l = [...j,k]
    console.log(l)
    // ["jj","kk"]
    ```
- 带有数组和对象的结合
    ```javascript
    let state = {
        resultList: [],
        currentPage: 0,
        totalRows: {}
    }
    let data = {
        resultList: [{new:'new'}],
        currentPage: 2,
        totalRows: {row:'row'}
    }
    let combile = {
                    ...state,
                    resultList: [
                        ...state.resultList,
                        ...data.resultList
                    ],
                    currentPage: data.currentPage,
                    totalRows: data.totalRows
                }
    console.log(combile)
    // {"resultList":[{"new":"new"}],"currentPage":2,"totalRows":{"row":"row"}}
    ```

