---
title: 浅谈如何封装css
date: 2016-04-06 15:37:43
tags: [javascript,css]
categories: 代码如诗，前端如画
---

- 前台调用

```javascript
var $ = function() {
        return new Base();
    }
```

- 基础类
<!-- more -->

```javascript
function Base() {
    //创建一个类
    //创建一个数组来获取一个节点和节点数组
    this.elements = [];
}
```

- 创建一个数组来获取一个节点和节点数组

```javascript
//Base.prototype.elements=[];这是是在类外面定义的，所以要把它放在类里面进行私有化
Base.prototype.getId = function(id) {
    this.elements.push(document.getElementById(id));
    return this;
};
```

<!--more-->

- 获取元素节点

```javascript
Base.prototype.getTagName = function(tag) {
    var tags = document.getElementsByTagName(tag);
    for (var i = 0; i < tags.length; i++) {
        this.elements.push(tags[i]);
    }
    return this;
};
```

- 获取Class节点的信息

```javascript
Base.prototype.getClass = function(className) {
    var all = document.getElementById('aaa').getElementsByTagName('*');
    for (var i = 0; i < all.length; i++) {
        if (all[i].className == className) {
            this.elements.push(all[i]);
        }
    }
    return this;
};
```

- 获取某一个节点

```javascript
Base.prototype.getElement = function(num) {
    var element = this.elements[num];
    this.elements = [];
    this.elements[0] = element;
    return this;
};
```

- 设置CSS

```javascript
Base.prototype.css = function(attr, value) { //这里的参数是两个，
    for (var i = 0; i < this.elements.length; i++) {
        if (arguments.length == 1) { //当参数的长度等于1的时候，就返回这个元素的style
            //这个只能获取d行内样式，不能获取demo1.css中的样式
            //return this.elements[i].style[attr];
            if (typeof window.getComputedStyle != 'undefined') { //W3C
                return window.getComputedStyle(this.elements[i], null)[attr];
            } else if (typeof this.elements[i].currentStyle != 'undefined') { //IE
                return this.elements[i].currentStyle[attr];
            }
        }
        this.elements[i].style[attr] = value;
    }
    return this;
};
```

- 设置innerHTML

```javascript
Base.prototype.html = function(str) {
    for (var i = 0; i < this.elements.length; i++) {
        if (arguments.length == 0) { //这里判断参数是否为0个，如果是0个则获取这个的innerHTML
            return this.elements[i].innerHTML; //一旦这么设置就不能实现连缀了
        }
        this.elements[i].innerHTML = str;
    }
    return this;
};
```

- 添加class属性

```javascript
Base.prototype.addClass = function(className) {
    //先循环一下，看有多少个颜色
    for (var i = 0; i < this.elements.length; i++) {
        if (!this.elements[i].className.match(new RegExp(('//s|^') + 
        className + '(//s|$)'))) { 
            //查看传进来的属性原来是否存在
            this.elements[i].className += ' ' + className;
        }
    }
    return this;
};
```
-删除class属性

```javascript
Base.prototype.removeClass = function(className) {
    for (var i = 0; i < this.elements.length; i++) {
        if (!this.elements[i].className.match(new RegExp(('//s|^') + 
        className + '(//s|$'))) { 
            //查看传进来的属性原来是否存在
            this.elements[i].className = 
            this.elements[i].className.replace(new RegExp(('//s|^') + 
            className + '(//s|$)'), ' ');
        }
    }
    return this;
};
```

- 添加link或style的CSS规则

```javascript
Base.prototype.addRule = function(num, selectorText, cssText, position) {
    var sheet = document.styleSheets[num];
    if (typeof sheet.insertRule != 'undefined') { //w3c
        sheet.insertRule(selectorText + '{' + cssText + '}', position);
    } else if (typeof sheet.addRule != 'undefined') { //ie
        sheet.addRule(selectorText, cssText, position);
    }
    return this; //返回this才能实行连缀功能
};
```

- 删除link或style的CSS规则

```javascript
Base.prototype.removeRule = function(num, index) {
    var sheet = document.styleSheets[num];
    if (typeof sheet.deleteRule != 'undefined') { //W3C
        sheet.deleteRule(index);
    } else if (typeof sheet.removeRule != 'undefined') { //IE
        sheet.removeRule(index);
    }
    return this;
};
```

- 设置点击事件

```javascript
Base.prototype.click = function(fn) {
    for (var i = 0; i < this.elements.length; i++) {
        this.elements[i].onclick = fn;
    }
    return this;
};
```
- 实际运行

```javascript
// JavaScript Document
window.onload = function() {
    //$().getId('box').html('pox');
    //alert($().getId('box').html());
    //因为在base里面，返回的是一个base对象，而他本身也没有设置html对象 
    //这里这么设置也是不需要实现连缀功能的
    //alert($().getId('box').css('color'));
    //alert($().getId('box').css('color','green'));
    //alert($().getId('box').css('background'));
    //n背景是一个复合是的样式 打印出来red none repeat scroll 0% 0%
    //alert($().getId('box').css('font-size'));
    //alert($().getClass('red').elements.length);
    //$().getClass('red').css('color','red');
    //$().getClass('red').getElement(1).css('color','green');
    //alert($().getClass('red').getElement(1).elements.length);
    $().getClass('red', 'aaa').getElement(2).css('color', 'green');
    //$().getId('box').css('color','red');
    //$().getId('pox').css('color','green');
    //$().getId('pox').addClass('a').addClass('b');
    //$().getId('pox').addClass('a').addClass('b').removeClass('a');
    //$().addRule(0,'body','background:green',0).addRule(0,'div','font-size:150px',0);
    //$().removeRule(0,0);
}
```

