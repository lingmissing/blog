---
title: Sass基本语法（运算）
date: 2016-03-18 11:42:56
tags: Sass
---

## 运算

- 加法/减法

加法/减法运算是 Sass 中运算中的一种，在变量或属性中都可以做加法运算。

但对于携带不同类型的单位时，在 Sass 中计算会报错：`20px + 3em`错误

<!-- more -->

- 乘法/除法

当一个单位同时声明两个值时会有问题。`2px*3px`错误

Sass 的乘法运算和加法、减法运算一样，在运算中有不同类型的单位时，也将会报错，`20px * 3em`错误。

- 除法

`/`符号在 CSS 中已做为一种符号使用。因此在 Sass 中做除法运算时，直接使用“/”符号做为除号时，将不会生效，编译时既得不到我们需要的效果，也不会报错。

生效的前提条件：

1. 如果数值或它的任意部分是存储在一个变量中或是函数的返回值。
2. 如果数值被圆括号包围。
3. 如果数值是另一个数学表达式的一部分。

```css
p {
  font: 10px/8px; // 纯 CSS，不是除法运算
  $width: 1000px;
  width: $width/2; // 使用了变量，是除法运算
  width: round(1.5) / 2; // 使用了函数，是除法运算
  height: (500px/2); // 使用了圆括号，是除法运算
  margin-left: 5px + 8px/2px; // 使用了加（+）号，是除法运算
}
```

<!--more-->

- 变量计算

```css
$content-width: 720px;
$sidebar-width: 220px;
$gutter: 20px;

.container {
  width: $content-width + $sidebar-width + $gutter;
  margin: 0 auto;
}
```

- 数字运算

```css
.box {
  width: ((220px + 720px) - 11 * 20) / 12;
}
```

- 颜色运算

有算数运算都支持颜色值，并且是分段运算的。也就是说，红、绿和蓝各颜色分段单独进行运算。

```css
p {
  color: #010203 + #040506; /** 01 + 04 = 05, 02 + 05 = 07, 03 + 06 = 09  ============050709 **/
}
p {
  color: #010203 * 2; /** 01 * 2 = 02, 02 * 2 = 04, 03 * 2 = 06  ================020406 **/
}
```

- 字符运算

```css
$content: 'Hello' + ' ' + 'Sass!';
.box:before {
  content: ' #{$content} ';
}
```

## 数据类型

sass 和 JavaScript 语言类似，也具有自己的数据类型，在 Sass 中包含以下几种数据类型：

- 数字: 如，1、 2、 13、 10px；
- 字符串：有引号字符串或无引号字符串，如，"foo"、 'bar'、 baz；
- 颜色：如，blue、 #04a3f9、 rgba(255,0,0,0.5)；
- 布尔型：如，true、 false；
- 空值：如，null；
- 值列表：用空格或者逗号分开，如，1.5em 1em 0 2em 、 Helvetica, Arial, sans-serif。

Sass 列表函数（Sass list functions）赋予了值列表更多功能（Sass 进级会有讲解）：

1. nth 函数（nth function） 可以直接访问值列表中的某一项；
2. join 函数（join function） 可以将多个值列表连结在一起；
3. append 函数（append function） 可以在值列表中添加值；
4. @each 规则（@each rule） 则能够给值列表中的每个项目添加样式。

## 字符串

SassScript 支持 CSS 的两种字符串类型：

- 有引号字符串 (quoted strings)，如 "Lucida Grande" 、'http://sass-lang.com'；
- 无引号字符串 (unquoted strings)，如 sans-serifbold。

在编译 CSS 文件时不会改变其类型。只有一种情况例外，使用 #{ }插值语句 (interpolation) 时，有引号字符串将被编译为无引号字符串，这样方便了在混合指令 (mixin) 中引用选择器名。

## 注释

注释对于一名程序员来说，是极其重要，良好的注释能帮助自己或者别人阅读源码。在 Sass 中注释有两种方式，我暂且将其命名为：

- 类似 CSS 的注释方式，使用 ”/_ ”开头，结属使用 ”_/ ”
- 类似 JavaScript 的注释方式，使用“//”

两者区别，前者会在编译出来的 CSS 显示，后者在编译出来的 CSS 中不会显示。
