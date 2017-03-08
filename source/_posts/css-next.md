title: CSS未来语法整理
date: 2017-03-01 13:16:38
tags: [css,css3]
categories: 前端布局
---

> 本案例均可通过[http://cssnext.io/playground/](http://cssnext.io/playground/)测试。

# 变量

```css
:root {
  --color: red;
}

div {
  color: var(--color);
}
```
<!-- more -->
# 选择器

input:

```css
@custom-selector :--button button, .button;
@custom-selector :--enter :hover, :focus;
@custom-selector :--heading h1, h2, h3, h4, h5, h6;

:--button{
    box-shadow: 0 0 1px black;
}

a:--enter{
    color: black;
}

article :--heading + p {
  margin-top: 0;
}
```

output:

```css
button, .button{
    box-shadow: 0 0 1px black;
}

a:hover, a:focus{
    color: black;
}

article h1 + p,
article h3 + p,
article h3 + p,
article h4 + p,
article h5 + p,
article h6 + p {
  margin-top: 0;
}
```

# 选择器匹配

input:

```css
p:matches(:first-child, .special) {
  color: red;
}
```

output:

```css
p:first-child, p.special {
  color: red;
}
```

input:

```css
p:not(:first-child, .special) {
  color: red;
}
```

output:

```css
p:not(:first-child), p:not(.special) {
  color: red;
}
```

# 属性集

input:

```css
:root {
  --centered: {
    display: flex;
    align-items: center;
    justify-content: center;
  };
}

.centered {
  @apply --centered;
}
```

output:

```css
.centered {
display: -webkit-box;
display: -ms-flexbox;
display: flex;
-webkit-box-align: center;
-ms-flex-align: center;
align-items: center;
-webkit-box-pack: center;
-ms-flex-pack: center;
justify-content: center;
}
```
# 媒体查询

input:

```css
@custom-media --small-viewport (max-width: 30em);

@media (--small-viewport) {
  /* styles for small viewport */
}
```

output:

```css
@media (max-width: 30em) {
  /* styles for small viewport */
}
```
# 嵌套

input:

```css
a, b {
    color: red;

    & c, & d {
        color: white;
    }

    & & {
        color: blue;
    }

    &:hover {
        color: black;
    }
    @nest span &{
        color: blue;
    }

    @media (min-width: 30em) {
        color: yellow;

        @media (min-device-pixel-ratio: 1.5) {
            color: green;
        }
    }
}
```

output:

```css
a, b {
    color: red
}
a c, a d, b c, b d {
    color: white
}
a a, b b {
    color: blue
}
a:hover, b:hover {
    color: black
}
span a, span b {
    color: blue
}
@media (min-width: 30em) {
    a, b {
        color: yellow
    }
    }
@media (min-width: 30em) and (min-device-pixel-ratio: 1.5) {
    a, b {
        color: green
    }
}
```

# color()

input：

```css
a{
    color: color(red alpha(-10%));
}

a:hover{
    color: color(red blackness(80%));
}
```

output:

```css
a{
    color: #ff0000;
    color: rgba(255, 0, 0, 0.9);
}
a:hover{
    color: rgb(51, 0, 0);
}
```