---
title: javascript递归
date: 2016-12-12 14:18:17
tags: javascript
---

> 调用自身的函数称为递归函数

- 缺点：递归占用的内存和资源比较多，同时难以实现和维护。
- 优点：在处理 DOM 之类的树形结构数据时，非常适合用递归。

<!-- more -->

# 案例

#### 数字 n 的阶乘通过乘以 1 _ 2 _ 3 \*... n 进行计算

```javascript
var f = function(x) {
  if (x === 1) {
    return 1
  } else {
    return x * f(x - 1)
  }
}

const result = f(n)
```

#### 获取存在某个字段的节点

```javascript
let new_array = []

function _getChilds(data) {
  if (data.ObjType == '某个数') {
    new_array.push(data)
  }
  if (data.Childs && data.Childs.length > 0) {
    getChilds(data.Childs)
  }
}

function getChilds(childData) {
  for (let i = 0; i < childData.length; i++) {
    _getChilds(childData[i])
  }
  // 或者
  // childData.map(item => _getChilds(item))
}
```

#### js 递归实现数组转树结构

```javascript
const jsonArr = [
  { name: 'a', id: 1, pid: 0 },
  { name: 'b', id: 2, pid: 1 },
  { name: 'c', id: 3, pid: 1 },
  { name: 'd', id: 4, pid: 2 },
  { name: 'e', id: 5, pid: 2 }
]

function fn(data, pid) {
  let result = []
  let temp
  for (let i = 0; i < data.length; i++) {
    if (data[i].pid == pid) {
      let obj = {
        name: data[i].name,
        id: data[i].id
      }
      temp = fn(data, data[i].id)
      if (temp.length > 0) {
        obj.children = temp
      }
      result.push(obj)
    }
  }
  return result
}

//调用
const result = fn(jsonArr, 0)
```
