---
title: js时间控制
date: 2016-04-12 17:09:12
tags: javascript
categories: 代码如诗，前端如画
---

## js倒计时 ##

html代码：

```html
<div id="time">
    <span class="day">00</span>
    <span class="hours">00</span>
    <span class="minute">00</span>
    <span class="second">00</span>
</div>
```
<!--more-->

javascript代码：

```javascript
function countDown(time,id){
    var day_elem = $(id).find('.day');
    var hour_elem = $(id).find('.hours');
    var minu_elem = $(id).find('.minute');
    var seco_elem = $(id).find('.second');
    var end_time = new Date(time).getTime(),
    sys_second = (end_time - new Date().getTime()) / 1000;
    var timer = setInterval(function(){
        if(sys_second > 1){
            sys_second = sys_second - 1;
            var day = Math.floor((sys_second / 3600) / 24);
            var hour = Math.floor((sys_second / 3600) % 24);
            var minute = Math.floor((sys_second / 60) % 60);
            var second = Math.floor(sys_second % 60);
            $(day_elem).text(day < 10 ? "0" + day : day);
            $(hour_elem).text(hour < 10 ? "0" + hour : hour);
            $(minu_elem).text(minute < 10 ? "0" + minute : minute);
            $(seco_elem).text(second < 10 ? "0" + second : second);
        }
        else{
            clearInterval(timer);
        }
    },1000);
}
//调用
$(function(){
    countDown("2015/08/31 00:00:00","#time");
});
```

## js时间戳转换 ##

```javascript
function formatDate(datetime) {
    var year = datetime.getYear() + 1900;
    var month = datetime.getMonth() + 1;
    var date = datetime.getDate();
    var hour = datetime.getHours();
    var minute = datetime.getMinutes();
    var second = datetime.getSeconds();
    return year + "-" + month + "-" + date + " " + hour + ":" + minute + ":" + second;
}
//调用
$(function(){
	var time = formatDate(new Date());
	console.log(time);
});
```


