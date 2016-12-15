---
title: Sass基本语法（Map）
date: 2016-03-25 11:43:26
tags: [sass,css]
categories: 前端布局
---
## 声明 Map ##

sass 的 map 常常被称为数据地图，也有人称其为数组，因为他总是以 key:value 成对的出现，但其更像是一个 JSON 数据。

```css
$map: (
    $key1: value1,
    $key2: value2,
    $key3: value3
)
```
<!-- more -->
在 Sass 中常用下面的方式定义变量：

```css
$default-color: #fff;
$primary-color: #22ae39;
```

我们使用 map 可以更好的进行管理：

```css
$color: (
    default: #fff,
    primary: #22ae39
);

$theme-color: (
    default: (
        bgcolor: #fff,
        text-color: #444,
        link-color: #39f
    ),
    primary:(
        bgcolor: #000,
        text-color:#fff,
        link-color: #93f
    ),
    negative: (
        bgcolor: #f36,
        text-color: #fefefe,
        link-color: #d4e
    )
);
```
<!--more-->

## 获取 Map ##

Sass 中获取变量，或者对 map 做更多有意义的操作，我们必须借助于 map 的函数功能。在 Sass 中 map 自身带了七个函数：

* map-get($map,$key)：根据给定的 key 值，返回 map 中相关的值。
* map-merge($map1,$map2)：将两个 map 合并成一个新的 map。
* map-remove($map,$key)：从 map 中删除一个 key，返回一个新 map。
* map-keys($map)：返回 map 中所有的 key。
* map-values($map)：返回 map 中所有的 value。
* map-has-key($map,$key)：根据给定的 key 值判断 map 是否有对应的 value 值，如果有返回 true，否则返回 false。
* keywords($args)：返回一个函数的参数，这个参数可以动态的设置 key 和 value。

案例:

```css
$social-colors: (
    dribble: #ea4c89,
    facebook: #3b5998,
    github: #171515,
    google: #db4437,
    twitter: #55acee
);
```

获取map的取值（ 如果 $key 不在 $map 中，不会编译出 CSS）

```css
.btn-facebook {
  color: map-get($social-colors,facebook);===color:#3b5998
}
```

判断取值是否存在

```css
@if map-has-key($social-colors,facebook){
    .btn-facebook {
        color: map-get($social-colors,facebook);
    }
} @else {
    @warn "No color found for faceboo in $social-colors map. Property ommitted."
}
```

获取map的所有key取值

	map-keys($social-colors);
	=============="dribble","facebook","github","google","twitter"

获取map的所有value取值

	map-values($social-colors)
	==============#ea4c89,#3b5998,#171515,#db4437,#55acee

合并map

```css
$color: (
    text: #f36,
    link: #f63,
    border: #ddd,
    backround: #fff
);
$typo: (
    font-size: 12px,
    line-height: 1.6
);
======$newmap: map-merge($color,$typo);
======$newmap:(
    text: #f36,
    link: #f63,
    border: #ddd,
    background: #fff,
    font-size: 12px,
    line-height: 1.6
);
```
删除某个key（若不存在则不变化）

	$map:map-remove($social-colors,dribble);

keywords(args)函数可以说是一个动态创建 map 的函数。
可以通过混合宏或函数的参数变创建 map。参数也是成对出现，
其中args变成 key(会自动去掉$符号)，而args对应的值就是value。

```css
@mixin map($args...){
    @debug keywords($args);
}

@include map(
  $dribble: #ea4c89,
  $facebook: #3b5998,
  $github: #171515,
  $google: #db4437,
  $twitter: #55acee
);
```

在命令终端可以看到一个输入的 @debug 信息：

	DEBUG: (dribble: #ea4c89, facebook: #3b5998, github: #171515, google: #db4437, twitter: #55acee)

