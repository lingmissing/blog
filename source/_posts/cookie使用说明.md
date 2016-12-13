---
title: cookie使用说明
date: 2016-06-12 13:28:09
tags: cookie
---

## 设置cookie ##

```javascript
//设置cookie
function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}
```

## 获取cookie ##

```javascript
function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length, c.length);
    }
    return "";
}
```
<!--more-->

## 清除cookie ##

```javascript
function clearCookie(name) { 
    setCookie(name, "", -1); 
} 
```