---
title: JS回到顶部效果
date: 2016-03-10 15:48:32
tags:  [javascript,jquery]
---
话不多说，直接粘上代码啦！

```html
<a id="totop" href="javascript:void(0);"></a>
```

```css
#totop {
  width: 20px;
  height: 20px;
  position: fixed;
  bottom: 0;
  right: 0;
}
```

<!--more-->

```javascript
function toTop(){

    $("#totop").click(function(e){
        e.preventDefault();
        pageScroll();
        // $('html,body').animate({scrollTop:0},700);
    });

    //获取页面的最小高度，无传入值则默认为600像素
    var min_height = $(window).height();

    //为窗口的scroll事件绑定处理函数
    $(window).scroll(function(){

        //获取窗口的滚动条的垂直位置
        var s = $(window).scrollTop();

        //当窗口的滚动条的垂直位置大于页面的最小高度时，让返回顶部元素渐现，否则渐隐
        if( s > min_height){
            $("#totop").css('display','inline-block');
        }else{
            $("#totop").css('display','none');
        };
    });
};

function pageScroll(){

    //把内容滚动指定的像素数（第一个参数是向右滚动的像素数，第二个参数是向下滚动的像素数）
    window.scrollBy(0,-100);

    //延时递归调用，模拟滚动向上效果
    scrolldelay = setTimeout('pageScroll()',20);

    //获取scrollTop值，声明了DTD的标准网页取document.documentElement.scrollTop，否则取document.body.scrollTop；因为二者只有一个会生效，另一个就恒为0，所以取和值可以得到网页的真正的scrollTop值
    var sTop=document.documentElement.scrollTop+document.body.scrollTop;

    //判断当页面到达顶部，取消延时代码（否则页面滚动到顶部会无法再向下正常浏览页面）
    if(sTop<10) clearTimeout(scrolldelay);
}
```
