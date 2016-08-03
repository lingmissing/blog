---
title: Sass基本语法（@规则）
date: 2016-03-10 11:43:18
tags: Sass
---
## @import ##

Sass 扩展了 CSS 的 @import 规则，让它能够引入 SCSS 和 Sass 文件。 所有引入的 SCSS 和 Sass 文件都会被合并并输出一个单一的 CSS 文件。 另外，被导入的文件中所定义的变量或 mixins 都可以在主文件中使用。

## @media ##

sass 中的 @media 指令和 CSS 的使用规则一样的简单，但它有另外一个功能，可以嵌套在 CSS 规则中。有点类似 JS 的冒泡功能一样，如果在样式中使用 @media 指令，它将冒泡到外面。
## @extend ##
Sass 中的 @extend 是用来扩展选择器或占位符。

@extend不能继承选择器序列。

@extend继承会把其下面的子类一起继承。

解决方案：使用%来构建需要被继承的元素。但是代码不会被合并。
## @at-root ##
@at-root 从字面上解释就是跳出根元素。

当你选择器嵌套多层之后，想让某个选择器跳出，此时就可以使用 @at-root。不适合嵌套过多的时候使用

```css
.a {
  color: red;
  .b {
    color: orange;
    .c {
      color: yellow;
      @at-root .d {
        color: green;
      }
    }
  }  
}
```
<!--more-->

编译出来的CSS

```css
.a {
  color: red;
}
.a .b {
  color: orange;
}
.a .b .c {
  color: yellow;
}
.d {
  color: green;
}
```

## @debug ##
@debug 在 Sass 中是用来调试的，当你的在 Sass 的源码中使用了 @debug 指令之后，Sass 代码在编译出错时，在命令终端会输出你设置的提示 Bug:
## @warn ##
@warn 和 @debug 功能类似，用来帮助我们更好的调试 Sass。
## @error ##
@error 和 @warn、@debug 功能是如出一辙。

