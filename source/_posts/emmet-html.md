---
title: Emmet语法总结（html篇）
date: 2016-03-28 10:58:35
tags: emmet
categories:  代码插件
---
## 初始化界面 ##
HTML文档需要包含一些固定的标签，比如<html>、<head>、<body>等，现在你只需要1秒钟就可以输入这些标签。比如输入“!”或“html:5”，然后按Tab键：

`html:5 ` 

```html
<!DOCTYPE html>
<html lang="en">
  <head>
  	<meta charset="UTF-8">
  	<title>Document</title>
  </head>
  <body>
  
  </body>
</html> 	
```
<!--more-->

## 添加类、id、文本和属性  ##

如果我们不给出标签名称的话,则Emmet会根据父标签进行判定,否则需要加上标签名称。

- 添加id用#，添加class用. 

`span#aaa.bbb.ccc`

```html
<span id="aaa" class="bbb ccc"></span>
```

- 添加内容

`.aaa{我是内容}`


```html
<div class="aaa">我是内容</div>
```

- 添加属性

添加属性使用[]，多个属性用空格区分

`a[href="index.html" title="内容"]`

```html
<a href="index.html" title="内容"></a>
```

## 生成后代元素> ##

`div.aaa>ul>li`

```html
<div class="aaa">
  <ul>
    <li></li>
  </ul>
</div>
```

### 生成兄弟元素+ ###

`div+p+bq`

```html
<div></div>
<p></p>
<blockquote></blockquote>
```

`a>{click}+b{here} `

```html
<a href="">click<b>here</b></a> 
```

## 生成上级元素^ ##

比如需要一个和ul平级的span标签：

`div>ul>li^span `

```html
<div>
  <ul>
    <li></li>
  </ul>
  <span></span>
</div>
```

## 生成多个相同标签* ##

`ul>li{子元素}*5 `

```html
<ul>
  <li>子元素</li>
  <li>子元素</li>
  <li>子元素</li>
  <li>子元素</li>
  <li>子元素</li>
</ul>
```

## 生成分组标签（） ##

`div>(header>ul>li*2>a)+footer>p `

```html
<div>
  <header>
    <ul>
      <li><a href=""></a></li>
      <li><a href=""></a></li>
    </ul>
  </header>
  <footer>
    <p></p>
  </footer>
</div>
```

`(div>dl>(dt+dd)*3)+footer>p `

```html
<div>
  <dl>
    <dt></dt>
    <dd></dd>
    <dt></dt>
    <dd></dd>
    <dt></dt>
    <dd></dd>
  </dl>
</div>
<footer>
  <p></p>
</footer>
```

## 生成内容编号 ##

`div>p#item$*3`

```html
<div>
  <p id="item1"></p>
  <p id="item2"></p>
  <p id="item3"></p>
</div>
```	
其他例子：`div>p#item$*3`


- $ 就表示一位数字，只出现一个的话，就从1开始。如果出现多个，就从0开始。如果我想生成三位数的序号，那么要写三个 $：

`ul>li.item$$$*5`

```html
<ul>
  <li class="item001"></li>
  <li class="item002"></li>
  <li class="item003"></li>
  <li class="item004"></li>
  <li class="item005"></li>
</ul>
```

- 我们也可以在 $ 后面增加 @- 来实现倒序排列：
		
`ul>li.item$@-*5`

```html
<ul>
  <li class="item5"></li>
  <li class="item4"></li>
  <li class="item3"></li>
  <li class="item2"></li>
  <li class="item1"></li>
</ul>
```

- 我们也可以使用 @N 指定开始的序号：

`ul>li.item$@3*5`

```html
<ul>
  <li class="item3"></li>
  <li class="item4"></li>
  <li class="item5"></li>
  <li class="item6"></li>
  <li class="item7"></li>
</ul>
```

配合上面倒序输出，可以这样写：

`ul>li.item$@-3*5`

```html
<ul>  
  <li class="item7"></li>
  <li class="item6"></li>
  <li class="item5"></li>
  <li class="item4"></li>
  <li class="item3"></li>
</ul>	
```
## 生成Lorem ipsum文本  ##
Lorem ipsum指一篇常用于排版设计领域的拉丁文文章，主要目的是测试文章或文字在不同字型、版型下看起来的效果。通过Emmet，你只需输入lorem 或 lipsum即可生成这些文字。还可以指定文字的个数，比如lorem10，将生成：

    Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eum, debitis. 

		
注意事项：

1. 不要有空格
2. 在写指令的时候，你可能为了代码的可读性，使用一些空格什么的排版一下。这就会导致代码无法使用。

