---
title: Emmet语法总结（css篇）
date: 2016-03-28 12:27:35
tags: emmet
---
## 值  ##
比如要定义元素的宽度，只需输入w100，即可生成 
    ```html
		width: 100px;
	```
除了px，也可以生成其他单位，比如输入h10p+m5e，结果如下：
	```css
		height: 10%;
		margin: 5em;
	```
单位别名列表： 
- p 表示%
- e 表示 em
- x 表示 ex

## 附加属性  ##
`@f`

	```css
		@font-face {
			font-family:;
			src:url();
		}
	```

`@f+`
	
	```css
		@font-face {
		font-family: 'FontName';
		src: url('FileName.eot');
		src: url('FileName.eot?#iefix') format('embedded-opentype'),
			 url('FileName.woff') format('woff'),
			 url('FileName.ttf') format('truetype'),
			 url('FileName.svg#FontName') format('svg');
		font-style: normal;
		font-weight: normal;
	    }
	```
## 模糊匹配  ##
如果有些缩写你拿不准，Emmet会根据你的输入内容匹配最接近的语法，比如输入ov:h、ov-h、ovh和oh，生成的代码是相同的：
`overflow: hidden;`
## 供应商前缀  ##
如果输入非W3C标准的CSS属性，Emmet会自动加上供应商前缀，比如输入-trs，则会生成：

	```css
		-webkit-transition: prop time;
		-o-transition: prop time;
		transition: prop time;
	```
如果不希望加上所有前缀，可以使用缩写来指定，比如-wm-trf表示只加上-webkit和-moz前缀：

前缀缩写如下： 

- w 表示 -webkit-
- m 表示 -moz-
- s 表示 -ms-
- o 表示 -o-

## 渐变  ##

`lg(left, #fff 50%, #000)`

	```css
		background-image: -webkit-linear-gradient(left, #fff 50%, #000);
		background-image: -o-linear-gradient(left, #fff 50%, #000);
		background-image: linear-gradient(to right, #fff 50%, #000);
	```