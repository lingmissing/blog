---
title: Sass基本语法（控制命令）
date: 2016-03-11 11:43:08
tags: [sass,css]
categories: 前端布局
---
## @if ##

@if 指令是一个 SassScript，它可以根据条件来处理样式块，如果条件为 true 返回一个样式块，反之 false 返回另一个样式块。在 Sass 中除了 @if 之，还可以配合 @else if 和 @else 一起使用。
<!-- more -->
```css		
/** SCSS **/
@mixin blockOrHidden($boolean:true) {
  @if $boolean {
      @debug "$boolean is #{$boolean}";
      display: block;  //当不写参数或者参数为true
    }
  @else {
      @debug "$boolean is #{$boolean}";
      display: none;  //参数为false
    }
}

.block {
  @include blockOrHidden;
}

.hidden{
  @include blockOrHidden(false);
}
```
<!--more-->

编译后的css：

```css
.block {
  display: block; 
}

.hidden {
  display: none; 
}
```

## @for循环 ##

Sass 的 @for 循环中有两种方式：

	@for $i from <start> through <end>
	@for $i from <start> to <end>

* $i 表示变量
* start 表示起始值
* end 表示结束值

这两个的区别是关键字 through 表示包括 end 这个数，而 to 则不包括 end 这个数。

```css
/** SCSS------网格系统生成各个格子 **/
$grid-prefix: span;
$grid-width: 60px;
$grid-gutter: 20px;

%grid {
  float: left;
  margin-left: $grid-gutter / 2;
  margin-right: $grid-gutter / 2;
}
@for $i from 1 through 12 {
  .#{$grid-prefix}#{$i}{
    width: $grid-width * $i + $grid-gutter * ($i - 1);
    @extend %grid;
  } 
}
```

编译出css：

```css
.span1, .span2, .span3, .span4, .span5, .span6, .span7, .span8, .span9, .span10, .span11, .span12 {
  float: left;
  margin-left: 10px;
  margin-right: 10px; }

.span1 {
  width: 60px; }

.span2 {
  width: 140px; }

.span3 {
  width: 220px; }

.span4 {
  width: 300px; }

.span5 {
  width: 380px; }

.span6 {
  width: 460px; }

.span7 {
  width: 540px; }

.span8 {
  width: 620px; }

.span9 {
  width: 700px; }

.span10 {
  width: 780px; }

.span11 {
  width: 860px; }

.span12 {
  width: 940px; }
```

## @while循环 ##

```css
/** SCSS **/
$types: 4;
$type-width: 20px;

@while $types > 0 {
    .while-#{$types} {
        width: $type-width + $types;
    }
    $types: $types - 1;
}
```

编译出css：

```css
.while-4 {
  width: 24px; }

.while-3 {
  width: 23px; }

.while-2 {
  width: 22px; }

.while-1 {
  width: 21px; }
```

## @each循环 ##

* @each 循环就是去遍历一个列表，然后从列表中取出对应的值。
* @each 循环指令的形式：
* @each $var in <list>

$var 就是一个变量名，<list> 是一个 SassScript 表达式，他将返回一个列表值。变量 $var 会在列表中做遍历，并且遍历出与 $var 对应的样式块。

```css
$list: adam john wynn mason kuroir;//$list 是一个列表
@mixin author-images {
    @each $author in $list {
        .photo-#{$author} {
            background: url("/images/avatars/#{$author}.png") no-repeat;
        }
    }
}
.author-bio {
    @include author-images;
}
```
编译出 CSS:

```css
.author-bio .photo-adam {
	background: url("/images/avatars/adam.png") no-repeat;
}
.author-bio .photo-john {
	background: url("/images/avatars/john.png") no-repeat;
}
.author-bio .photo-wynn {
	background: url("/images/avatars/wynn.png") no-repeat;
}
.author-bio .photo-mason {
	background: url("/images/avatars/mason.png") no-repeat;
}
.author-bio .photo-kuroir {
	background: url("/images/avatars/kuroir.png") no-repeat;
}
```

## @function ##
	
@function是一个自定义函数，虽然和@maxin一样都是通过传入变量改变数据，但是与之不同的是@mixin传入变量要带上前面的类型，比如width、font-size等待，而@function值传数据，这样可以用于多个属性。

```css
$oneWidth: 10px;  
$twoWidth: 40px;  
  
@function widthFn($n) {  
  @return $n * $twoWidth + ($n - 1) * $oneWidth;  
}    
.leng {   
  width: widthFn(5);  
}
```

编译出 CSS:

```css
.leng {  
  width: 240px;  
} 
```
