---
title: JS数据类型学习总结
date: 2016-04-06 15:06:28
tags: javascript
---

## Undefined 类型

- 未赋值的数据为 undefined，例如：

```javascript
var oTemp
alert(oTemp == undefined) //返回true

var oTemp
alert(typeof oTemp) //输出为 “undefined"
```

<!-- more -->

- 如果函数没有返回值，则默认为 undefined，例如：

```javascript
function testFunc() {}
alert(testFunc() == undefined) //输出为 “true"
alert(null == undefined) //输出为 “true"
```

<!--more-->

## 布尔类型

- 尽管 false 不等于 0，但在用于判断时，0 是会被转换为 false。例如：

```javascript
if (0) {
  alert('0会被转换为false')
}
```

- 空字符串将被转换为 false，例如：

```javascript
if ('') {
  alert('空字符串被转换为false')
} //将会弹出警告框
if ('www.itxueyuan.com/javascript/') {
  alert('非空字符串将被转换为true')
} //将会弹出警告框
if ('false') {
  alert('字符串 false 同样会被转换为true')
} //将会弹出警告框
```

## 数字类型

- 几种数字的表示方法

```javascript
var iNum = 55
var iNum = 070 //八进制070等于十进制的56

var iNum = 0x1f //十六进制0x1f等于十进制31
var iNum2 = 0xab //十六进制0xAB等于171

var fNum = 3.125e7 //3.125 × 107, 也就是 3.125 × 10 × 10 × 10 × 10 × 10 × 10 × 10.
```

- 一些常量数字：

```javascript
Number.MAX_VALUE //Javascript所能表示的数字的最大值
Number.POSITIVE_INFINITY //无穷大

Number.MIN_VALUE //Javascript所能表示的数字的最小值
Number.NEGATIVE_INFINITY //无穷小
```

- 函数 isFinite 用于判断一个数字是否为有穷数

```javascript
NaN //不是一个数字
alert(NaN == NaN) //输出为 "false"

alert(isNaN('blue')) //输出为 "true"
alert(isNaN('123')) //输出为 "false"
```

- 特殊符号表：

- 数字转换为不同进制的字符串示例：

```javascript
var iNum = 10
alert(iNum1.toString(2)) //输出为 "1010"
alert(iNum1.toString(8)) //输出为 "12"
alert(iNum1.toString(16)) //输出为 "A"
```

- 将字符串转换为数字

```javascript
var iNum1 = parseInt('1234www.itxueyuan.com') //结果为 1234
var iNum2 = parseInt('0xA') //结果为 10
var iNum3 = parseInt('22.5') //结果为 22
var iNum4 = parseInt('blue') //结果为 NaN

var iNum1 = parseInt('AF', 16) //结果为 175
var iNum1 = parseInt('10', 2) //结果为 2
var iNum2 = parseInt('10', 8) //结果为 8
var iNum2 = parseInt('10', 10) //结果为 10

var fNum1 = parseFloat('1234blue') //结果为 1234.0
var fNum2 = parseFloat('0xA') //结果为 NaN
var fNum3 = parseFloat('22.5') //结果为 22.5
var fNum4 = parseFloat('22.34.5') //结果为 22.34
var fNum5 = parseFloat('0908') //结果为 908
var fNum6 = parseFloat('blue') //结果为 NaN
```

## 类型转换

```javascript
var b1 = Boolean('') //false – empty string
var b2 = Boolean('hi') //true – non-empty string
var b3 = Boolean(100) //true – non-zero number
var b4 = Boolean(null) //false - null
var b5 = Boolean(0) //false - zero
var b6 = Boolean(new Object()) //true – object

Number(false) //0
Number(true) //1
Number(undefined) //NaN
Number(null) //0
Number('5.5') //5.5
Number('56') //56
Number('5.6.7') //NaN
Number(new Object()) //NaN
Number(100) //100
```
