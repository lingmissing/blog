---
title: ES6数据操作
date: 2016-08-25 21:05:00
tags: javascript
---

```javascript
//两个对象连接返回新的对象
let a = {aa:'aa'}
let b = {bb:'bb'}
let c = {...a,...b}
console.log(c)
// {"aa":"aa","bb":"bb"}
```

```javascript
//两个数组连接返回新的数组
let d = ['dd']
let e = ['ee']
let f = [...d,...e]
console.log(f)
// ["dd","ee"]
```


```javascript
// 数组加上对象返回新的数组
let g = [{gg:'gg'}]
let h = {hh:'hh'}
let i = [...g,h]
console.log(i)
// [{"gg":"gg"},{"hh":"hh"}
```

```javascript
// 数组+字符串
let j = ['jj']
let k = 'kk'
let l = [...j,k]
console.log(l)
// ["jj","kk"]
```

```javascript
//带有数组和对象的结合
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

