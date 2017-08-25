title: 常用postcss插件
date: 2017-08-25 16:52:36
tags: [webpack,postcss]
---

# postcss-import

```css
@import "_vars";
```

# postcss-mixins

> 这个插件必须运行在`postcss-nested`和`postcss-simple-vars`插件之后。

```js
@define-mixin icon $network, $color {
  .button.$(network) {
    background-image: url('./$(network).png');
    background-color: $color;
  }
}
// 调用
@mixin icon logo blue;
```
编译后

```css
.icon.logo {
  background-image: url('./logo.png');
  background-color: blue;
}
```

# postcss-for

```css
@from: 1;
@count: 3;
@for $i from @from to @count {
  p:nth-of-type($i) {
    margin-left: calc( 100% / $i );
  }
}
```
编译后

```css
p:nth-of-type(1) {
  margin-left: calc( 100% / 1 );
}
p:nth-of-type(2) {
  margin-left: calc( 100% / 2 );
}
p:nth-of-type(3) {
  margin-left: calc( 100% / 3 );
}
```
# postcss-each

```css
$social: twitter, facebook, youtube;
@each $icon in ($social){
  .icon-$(icon) {
    background: url('img/$(icon).png');
  }
}
```
编译后

```css
.icon-twitter {
  background: url('img/twitter.png');
}
.icon-facebook {
  background: url('img/facebook.png');
}
.icon-youtube {
  background: url('img/youtube.png');
}
```

# postcss-conditionals

```css
$column_count: 3;
.column { 
  @if $column_count == 3 {
    width: 33%;
    float: left;
  } @else if $column_count == 2 {
    width: 50%;
    float: left;
  } @else {
    width: 100%;
  }
}
```

编译后

```css
.column {
  width: 33%;
  float: left
}
```