---
title: Sass基本语法（常用函数）
date: 2016-04-01 11:43:40
tags: [sass,css]
categories: 前端布局
---
## 字符串函数 ##

- `unquote($string)`：删除字符串中的引号；

unquote( ) 函数只能删除字符串最前和最后的引号（双引号或单引号），而无法删除字符串中间的引号。如果字符没有带引号，返回的将是字符串本身。

- `quote($string)`：给字符串添加引号。

 quote() 函数只能给字符串增加双引号，而且字符串中间有单引号或者空格时，需要用单引号或双引号括起，否则编译的时候将会报错。
<!-- more -->
- `To-upper-case() `：函数将字符串小写字母转换成大写字母
- `To-lower-case() `：函数 与 To-upper-case() 刚好相反，将字符串转换成小写字母

## 数字函数 ##

Sass 中的数字函数提要针对数字方面提供一系列的函数功能：

- `percentage($value)`：将一个不带单位的数转换成百分比值；
- `round($value)`：将数值四舍五入，转换成一个最接近的整数；（四舍五入）
- `ceil($value)`：将大于自己的小数转换成下一位整数；（向上取整）
- `floor($value)`：将一个数去除他的小数部分；（向下取整）
- `abs($value)`：返回一个数的绝对值；（绝对整数）
- `min($numbers…)`：找出几个数值之间的最小值；（min（1，2，3））
- `max($numbers…)`：找出几个数值之间的最大值；
- `random()`: 获取随机数（random（））

<!--more-->

## 列表函数 ##

列表函数主要包括一些对列表参数的函数使用，主要包括以下几种：

- `length($list)`：返回一个列表的长度值；===length(border 1px solid)===3
- `nth($list, $n)`：返回一个列表中指定的某个标签值===nth(border 1px solid,1)===border
- `join($list1, $list2, [$separator])`：将两个列给连接在一起，变成一个列表；===

```javascript
join(10px 20px, 30px 40px)
(10px 20px 30px 40px)

join((blue,red),(#abc,#def))
(#0000ff, #ff0000, #aabbcc, #ddeeff)

join((blue,red),(#abc #def))
(#0000ff, #ff0000, #aabbcc, #ddeeff)
```

- `append($list1, $val, [$separator])`：将某个值放在列表的最后；

```javascript
append(10px 20px ,30px)
(10px 20px 30px)

append((10px,20px),30px)
(10px, 20px, 30px)

append(green,red)
(#008000 #ff0000)

append(red,(green,blue))
(#ff0000 (#008000, #0000ff))
```

如果没有明确的指定 $separator 参数值，其默认值是 auto。

如果列表只有一个列表项时，那么插入进来的值将和原来的值会以空格的方式分隔。

如果列表中列表项是以空格分隔列表项，那么插入进来的列表项也将以空格分隔；

如果列表中列表项是以逗号分隔列表项，那么插入进来的列表项也将以逗号分隔。

- `zip($lists…)`：将几个列表结合成一个多维的列表；（ 每个单一的列表个数值必须是相同的）

```javascript
zip(1px 2px 3px,solid dashed dotted,green blue red)
((1px "solid" #008000), (2px "dashed" #0000ff), (3px "dotted" #ff0000))
```

zip()函数中每个单一列表的值对应的取其相同位置值：

		|--- List ---|--- nth(1) ---|--- nth(2) ---|--- nth(3) ---|
		|------------|--------------|--------------|--------------|
		|    List1   |      1px     |      2px     |      3px     |
		|------------|--------------|--------------|--------------|
		|    List2   |      solid   |      dashed  |     dotted   |
		|------------|--------------|--------------|--------------|
		|    List3   |      green   |      blue    |      red     |
		|------------|--------------|--------------|--------------|

- `index($list, $value)`：返回一个值在列表中的位置值。

```javascript
index(1px solid red,dotted) //列表中没有找到 dotted
false

index(1px solid red,solid) //列表中找到 solid 值，并且返回他的位置值 2
2
```

## Introspection函数 ##
Introspection函数包括了几个判断型函数：

- `type-of($value)`：返回一个值的类型

返回值：

	1. number 为数值型。
	2. string 为字符串型。
	3. bool 为布尔型。
	4. color 为颜色型。


- `unit($number)`：返回一个值的单位；

碰到复杂的计算时，其能根据运算得到一个“多单位组合”的值，不过只充许乘、除运算：

但加、减碰到不同单位时，unit() 函数将会报错，除 px 与 cm、mm 运算之外

- `comparable($number-1, $number-2)`：判断两个值是否可以做加、减和合并

## Miscellaneous函数 ##

Miscellaneous 函数称为三元条件函数，主要因为他和 JavaScript 中的三元判断非常的相似。他有两个值，当条件成立返回一种值，当条件不成立时返回另一种值：

	if($condition,$if-true,$if-false)

上面表达式的意思是当 $condition 条件成立时，返回的值为 $if-true，否则返回的是 $if-false 值。

	if(true,1px,2px)
	1px
	if(false,1px,2px)
	2px
## 颜色函数 ##

#### RGB颜色函数简介 ####

RGB 颜色只是颜色中的一种表达式，其中 R 是 red 表示红色，G 是 green 表示绿色而 B 是 blue 表示蓝色。在 Sass 中为 RGB 颜色提供六种函数：

* ``rgb($red,$green,$blue)`：根据红、绿、蓝三个值创建一个颜色；
* `rgba($red,$green,$blue,$alpha)`：根据红、绿、蓝和透明度值创建一个颜色；
* `red($color)`：从一个颜色中获取其中红色值；
* `green($color)`：从一个颜色中获取其中绿色值；
* `blue($color)`：从一个颜色中获取其中蓝色值；
* `mix($color-1,$color-2,[$weight])`：把两种颜色混合在一起。[$weight]是合并的比例

#### HSL函数简介 ####

* `hsl($hue,$saturation,$lightness)`：通过色相（hue）、饱和度(saturation)和亮度（lightness）的值创建一个颜色；
* `hsla($hue,$saturation,$lightness,$alpha)`：通过色相（hue）、饱和度(saturation)、亮度（lightness）和透明（alpha）的值创建一个颜色；
* `hue($color)`：从一个颜色中获取色相（hue）值；
* `saturation($color)`：从一个颜色中获取饱和度（saturation）值；
* `lightness($color)`：从一个颜色中获取亮度（lightness）值；
* `adjust-hue($color,$degrees)`：通过改变一个颜色的色相值，创建一个新的颜色；
* `lighten($color,$amount)`：通过改变颜色的亮度值，让颜色变亮，创建一个新的颜色；
* `darken($color,$amount)`：通过改变颜色的亮度值，让颜色变暗，创建一个新的颜色；
* `saturate($color,$amount)`：通过改变颜色的饱和度值，让颜色更饱和，从而创建一个新的颜色
* `desaturate($color,$amount)`：通过改变颜色的饱和度值，让颜色更少的饱和，从而创建出一个新的颜色；
* `grayscale($color)`：将一个颜色变成灰色，相当于desaturate($color,100%);
* `complement($color)`：返回一个补充色，相当于adjust-hue($color,180deg);
* `invert($color)`：反回一个反相色，红、绿、蓝色值倒过来，而透明度不变。

#### Opacity函数简介 ####

* `alpha($color) /opacity($color)`：获取颜色透明度值；
* `rgba($color, $alpha)`：改变颜色的透明度值；
* `opacify($color, $amount) / fade-in($color, $amount)`：使颜色更不透明；
* `transparentize($color, $amount) / fade-out($color, $amount)`：使颜色更加透明。


