---
title: Sass基本语法（基础使用）
date: 2016-03-07 11:42:38
tags: [Sass,css]
categories: 前端布局
---
## 全局变量/局部变量 ##
创建变量用`$`符号开头。
#### 创建变量的条件： ####
- 该值至少重复出现了两次；
- 该值至少可能会被更新一次；
- 该值所有的表现都与变量有关（非巧合）。
<!-- more -->
注意：当在局部范围（选择器内、函数内、混合宏内...）声明一个已经存在于全局范围内的变量时，局部变量只会在局部范围内覆盖全局变量。
```css
/** SCSS **/
$color: orange !default;//定义全局变量
.block {
  color: $color;//调用全局变量
}
em {
  $color: red;//定义局部变量（全局变量 $color 的影子）
  a {
    color: $color;//调用局部变量
  }
}
```
<!--more-->

## 嵌套 ##
#### 嵌套的三种类型： ####
- 选择器嵌套
- 属性嵌套
- 伪类嵌套

#### 选择器嵌套： ####

```css
/** scss **/
nav {
  a {
    color: red;
    header & {       
      color:green;
    }
  } 
}
```

编译出来之后：

```css
/** css **/
nav a {
  color:red;
}
header nav a {
  color:green;
}
```
#### 属性嵌套： ####

```css
	/** scss **/
	.box {
	  border: {
	   top: 1px solid red;
	   bottom: 1px solid green;
	  }
	}
```

编译出来之后：

```css	
/** css **/
.box {
    border-top: 1px solid red;
    border-bottom: 1px solid green;
}
```

#### 伪类嵌套： ####

```css
/** scss **/
.clearfix {
  &:before,
  &:after {
    content: "";
    display: table;
  }
  &:after {
    clear: both;
    overflow: hidden;
  }
}
```
编译出来之后：

```css
/** css **/
clearfix:before, .clearfix:after {
  content: "";
  display: table;
}
.clearfix:after {
  clear: both;
  overflow: hidden;
}
```

## 混合宏@mixin ##
#### 声明混合宏 ####
`@mixin` 是用来声明混合宏的关键词。

- 不带参数混合宏：

```css
@mixin border-radius {
	-webkit-border-radius: 5px;
	border-radius: 5px;
}
```

- 带参数混合宏：

```css
@mixin border-radius($radius:5px) {
    -webkit-border-radius: $radius;
    border-radius: $radius;
}
```

- 复杂的混合宏：

```css
@mixin box-shadow($shadow...) {  // 带有多个参数，可以使用“ … ”来替代。
  @if length($shadow) >= 1 {
    @include prefixer(box-shadow, $shadow);
  } @else{      // 当 $shadow 的参数数量值大于或等于“ 1 ”时，表示有多个阴影值，反之调用默认的参数值“ 0 0 4px rgba(0,0,0,.3) ”。
    $shadow:0 0 4px rgba(0,0,0,.3);
    @include prefixer(box-shadow, $shadow);
  }
}
```

#### 调用混合宏 ####
匹配了一个关键词`@include`来调用声明好的混合宏。


1. 不传参数

```css
/** scss **/
button {
    @include border-radius;
}
```
编译出来之后：

```css
/** css **/
button {
  -webkit-border-radius: 3px;
  border-radius: 3px;
}
```


2. 传一个不带值的参数


```css
/** scss **/
@mixin border-radius($radius){
  -webkit-border-radius: $radius;
  border-radius: $radius;
}
.box {
  @include border-radius(3px);
}
```
编译出来之后：

```css
.box {
  -webkit-border-radius: 3px;
  border-radius: 3px;
}
```

3. 传一个带值的参数

```css
/** scss **/
@mixin border-radius($radius:3px){      // 传了一个参数“$radius”，而且给这个参数赋予了一个默认值“3px”。
  -webkit-border-radius: $radius;
  border-radius: $radius;
}
```
当不写的时候取值为默认:
```css
.btn {
  @include border-radius; 
}
```
编译出来之后：

```css
.btn {
  -webkit-border-radius: 3px;
  border-radius: 3px;
}
```
当写的时候取值为写入的值:

```css
.box {
  @include border-radius(50%); 
}
```
编译出来之后：

```css
.box {
  -webkit-border-radius: 50%;
  border-radius: 50%;
}
```

4. 传多个带值的参数
	
```css
/** scss **/
@mixin center($width,$height){
  width: $width;
  height: $height;
  position: absolute;
  top: 50%;
  left: 50%;
  margin-top: -($height) / 2;
  margin-left: -($width) / 2;
}
.box-center {
  @include center(500px,300px);
}
```
编译出来之后：

```css
.box-center {
  width: 500px;
  height: 300px;
  position: absolute;
  top: 50%;
  left: 50%;
  margin-top: -150px;
  margin-left: -250px;
}
```

有一个特别的参数`…`。当混合宏传的参数过多之时，可以使用一个参数来替代所有参数。——box-shadow:0px 3px 1px #000

混合宏在实际编码中给我们带来很多方便之处，特别是对于复用重复代码块。但其最大的不足之处是会生成冗余的代码块。
## 扩展/继承@extend ##
在 Sass 中是通过关键词 `@extend`来继承已存在的类样式块，从而实现代码的继承。
```scss
/** scss **/
.btn {
  border: 1px solid #ccc;
  padding: 6px 10px;
  font-size: 14px;
}

.btn-primary {
  background-color: #f36;
  color: #fff;
  @extend .btn;
}

.btn-second {
  background-color: orange;
  color: #fff;
  @extend .btn;
}
```

编译出来之后：

```css
/** css **/
.btn, .btn-primary, .btn-second { /** 继承类样式块中所有样式代码，编译出来的 CSS 会将选择器合并在一起，形成组合选择器： **/
  border: 1px solid #ccc;
  padding: 6px 10px;
  font-size: 14px;
}
.btn-primary {
  background-color: #f36;
  color: #fff;
}
.btn-second {
  background-clor: orange;
  color: #fff;
}
```

## 占位符 %placeholder ##
取代以前 CSS 中的基类造成的代码冗余的情形。因为 %placeholder 声明的代码，如果不被 @extend 调用的话，不会产生任何代码。
	
```css
/** scss **/
%mt5 {    // 如果没被@extend 调用，不会产生任何代码块。只有通过 @extend 调用才会产生代码：
  margin-top: 5px;
}
%pt5{
  padding-top: 5px;
}

.btn {
  @extend %mt5;
  @extend %pt5;
}

.block {
  @extend %mt5;

  span {
    @extend %pt5;
  }
}
```

编译出来的CSS
	
```css
/** css **/
.btn, .block {
  margin-top: 5px;
}

.btn, .block span {
  padding-top: 5px;
}
```

## 混合宏 VS 继承 VS 占位符 ##
#### Sass 中的混合宏使用 ####
总结：编译出来的 CSS 清晰告诉了大家，他不会自动合并相同的样式代码，如果在样式文件中调用同一个混合宏，会产生多个对应的样式代码，造成代码的冗余，但是@mixin可以传参数。

个人建议：如果你的代码块中涉及到变量，建议使用混合宏来创建相同的代码块。
#### Sass 中继承 ####
总结：使用继承后，编译出来的 CSS 会将使用继承的代码块合并到一起，通过组合选择器的方式向大家展现，比如 .mt, .block, .block span, .header, .header span。这样编译出来的代码相对于混合宏来说要干净的多，但是他不能传变量参数。

个人建议：如果你的代码块不需要专任何变量参数，而且有一个基类已在文件中存在，那么建议使用 Sass 的继承。
#### 占位符 ####
总结：编译出来的 CSS 代码和使用继承基本上是相同，只是不会在代码中生成占位符 mt 的选择器。那么占位符和继承的主要区别的。

“占位符是独立定义，不调用的时候是不会在 CSS 中产生任何代码；继承是首先有一个基类存在，不管调用与不调用，基类的样式都将会出现在编译出来的 CSS 代码中。”
来看一个表格：
![](http://s2.51offer.com/event/sass/2016-03-30/sass1.jpg)

