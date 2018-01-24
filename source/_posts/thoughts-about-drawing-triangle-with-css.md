title: CSS画三角形引发的一些思考
date: 2015-8-31
categories: 前端
tags: CSS
---
&emsp;&emsp;今天刷知乎时看到了一个问题，[有谁能详细讲一下css如何画出一个三角形？怎么想都想不懂？ - 知乎](http://www.zhihu.com/question/35180018)。很巧，刚入前端坑的我前不久也遇到过这个问题，今天再来谈一谈这个问题则是因为知乎的一些答案引发了我的更深的思考。  

<!-- more -->
&emsp;&emsp;第一次遇到这个问题是在撸Bootstrap的一个demo ——[Blog Template for Bootstrap](http://v3.bootcss.com/examples/blog/)，它的导航栏中用到了CSS来画三角形：  
![截图1](/img/20150831231156.png)  
我们来看一看其中重点的那段CSS代码：  
```css
            .blog-nav .active:after {  
                  position: absolute;  
                  bottom: 0;  
                  left: 50%;  
                  width: 0;  
                  height: 0;  
                  margin-left: -5px;  
                  vertical-align: middle;  
                  content: " ";  
                  border-right: 5px solid transparent;  
                  border-bottom: 5px solid;  
                  border-left: 5px solid transparent;  
            }
```
&emsp;&emsp;这只是一段简单的用CSS画出等腰直角三角形的实现案例，当时我在SF的一篇文章找到了答案：[图解利用CSS实现三角形 - SegmentFault](http://segmentfault.com/a/1190000000652249)，通过这篇文章，我明白了原来border是一个梯形，当梯形的上底为0的极限情况时，梯形就成了一个三角形，画一个正方形，正方形的div为0时，隐藏三条border，剩下的可见的border便是所需的三角形。于是bootstrap的demo中的问题迎刃而解。  
&emsp;&emsp;然而，bootstrap的demo中的等边直角三角形是一个非常经典的情况，那么画任意三角形的时候怎么办呢？知乎的[@Vkki](http://www.zhihu.com/people/vkki)用户给出了结论：  
>（上边的 width 控制了这个三角形上顶点离 div 边缘的距离是 10px）
下边的 width 控制了三角形的高（150px）
左右两边的 width 分别控制了三角形的底边长的两部分（加起来共 200px）  
![Vkki](/img/Vkki.png)  
![Vkki](/img/Vkki2.png)  

&emsp;&emsp;记住结论固然重要，然而我又引发了好奇心，如果左右上下四边的width不相等的情况下，各个border又是什么样的的？  
&emsp;&emsp;于是我画了一个div，CSS代码如下：  
```css
            div{  
                  width:0;  
                  height:0;  
                  border-top:100px solid;  
                  border-bottom:125px solid;  
                  border-left:150px solid;  
                  border-right:175px solid;  
                  border-color:red green blue yellow;  
            }
```

&emsp;&emsp;在浏览器中的效果图：  
![效果图](/img/20150831235000.png)   
&emsp;&emsp;结果和预想的有点不一样，但是结合上面的结论，已经非常好理解了：）  
&emsp;&emsp;其实在回答中，[@王潇](http://www.zhihu.com/people/wang-xiao-9-14)的答案也让我想到了很多，他利用CSS3中transform属性的shewX()方法以及rotate()方法还有活用skewX()方法画出了一般形状的三角形，和其他答案不一样的思路确实让我眼前一亮，想起了强大的CSS3，利用CSS3的新特性可以完成很多以前只能用js实现的效果，真棒！当然，付出的代价是兼容性。
