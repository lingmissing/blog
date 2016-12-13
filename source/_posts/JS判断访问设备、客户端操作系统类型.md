---
title: JS判断访问设备、客户端操作系统类型
date: 2016-04-20 14:01:12
tags: javascript
---


### 判断当前设备操作系统 ###

```html
<html>
  <head>
    <title>判断操作系统</title>
    <script type="text/javascript">
      function detectOS() { 
        var sUserAgent = navigator.userAgent; 
        var isWin = (navigator.platform == "Win32") || (navigator.platform == "Windows"); 
        var isMac = (navigator.platform == "Mac68K") || (navigator.platform == "MacPPC") || (navigator.platform == "Macintosh") || (navigator.platform == "MacIntel"); 
        if (isMac) return "Mac"; 
        var isUnix = (navigator.platform == "X11") && !isWin && !isMac; 
        if (isUnix) return "Unix"; 
        var isLinux = (String(navigator.platform).indexOf("Linux") > -1); 

        var bIsAndroid = sUserAgent.toLowerCase().match(/android/i) == "android";
        if (isLinux) {
          if(bIsAndroid) return "Android";
        else return "Linux"; 
        }
        if (isWin) { 
        var isWin2K = sUserAgent.indexOf("Windows NT 5.0") > -1 || sUserAgent.indexOf("Windows 2000") > -1; 
        if (isWin2K) return "Win2000"; 
        var isWinXP = sUserAgent.indexOf("Windows NT 5.1") > -1 || sUserAgent.indexOf("Windows XP") > -1; 
        if (isWinXP) return "WinXP"; 
        var isWin2003 = sUserAgent.indexOf("Windows NT 5.2") > -1 || sUserAgent.indexOf("Windows 2003") > -1; 
        if (isWin2003) return "Win2003"; 
        var isWinVista= sUserAgent.indexOf("Windows NT 6.0") > -1 || sUserAgent.indexOf("Windows Vista") > -1; 
        if (isWinVista) return "WinVista"; 
        var isWin7 = sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1; 
        if (isWin7) return "Win7"; 
        } 
        return "other"; 
      } 
      document.writeln("您的操作系统是：" + detectOS()); 
      alert(detectOS());
    </script>
  </head>
  <body> 
  
  </body>
</html>
```

<!--more-->

### 判断当前访问网站的设备是否是PC ###

```javascript
//平台、设备和操作系统
var system ={
  win : false,
  mac : false,
  xll : false
};
//检测平台
var p = navigator.platform;
system.win = p.indexOf("Win") == 0;
system.mac = p.indexOf("Mac") == 0;
system.x11 = (p == "X11") || (p.indexOf("Linux") == 0);
//跳转语句
if(system.win||system.mac||system.xll){
  alert("PC访问");
}else{
  alert("非PC访问");
}
```

### JS判断访问设备(userAgent)加载不同页面。代码如下： ###

```javascript
function browserRedirect() {
  var sUserAgent = navigator.userAgent.toLowerCase();
  var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
  var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
  var bIsMidp = sUserAgent.match(/midp/i) == "midp";
  var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
  var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
  var bIsAndroid = sUserAgent.match(/android/i) == "android";
  var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
  var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
  if (! (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM)) {
    window.location.href = B页面;
  }
}
browserRedirect();
```

### JS判断客户端操作系统类型(platform)来定义不同的字体表现 ###

```javascript
// 更详细的探测当前客户端使用的操作系统
function detectOS() {
  var sUserAgent = navigator.userAgent;
  var isWin = (navigator.platform == "Win32") || (navigator.platform == "Windows");
  var isMac = (navigator.platform == "Mac68K") || (navigator.platform == "MacPPC") || (navigator.platform == "Macintosh") || (navigator.platform == "MacIntel"); 
  if (isMac) return "Mac";
  var isUnix = (navigator.platform == "X11") && !isWin && !isMac;
  if (isUnix) return "Unix";
  var isLinux = (String(navigator.platform).indexOf("Linux") > -1);
  if (isLinux) return "Linux";
  if (isWin) {
    var isWin2K = sUserAgent.indexOf("Windows NT 5.0") > -1 || sUserAgent.indexOf("Windows 2000") > -1;
    if (isWin2K) return "Win2000";
    var isWinXP = sUserAgent.indexOf("Windows NT 5.1") > -1 || sUserAgent.indexOf("Windows XP") > -1;
    if (isWinXP) return "WinXP";
    var isWin2003 = sUserAgent.indexOf("Windows NT 5.2") > -1 || sUserAgent.indexOf("Windows 2003") > -1;
    if (isWin2003) return "Win2003";
    var isWin2003 = sUserAgent.indexOf("Windows NT 6.0") > -1 || sUserAgent.indexOf("Windows Vista") > -1;
    if (isWin2003) return "WinVista"; 
    var isWin2003 = sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1;
    if (isWin2003) return "Win7";
  } 
  return "other"; 
}
```

### 另一种方法，使用mootools框架 ###

```javascript
var s = null;
s = Browser.Platform.linux;
alert(s);
if (Browser.Platform.linux)
  alert("linux");
else
  alert("not linux");
```

### 使用JS架框有现成的判断  ###

例如motools架框中：

- Browser.Platform.mac - (boolean) 当前操作系统是否为Mac

- Browser.Platform.win - (boolean) 当前操作系统是否为Windows

- Browser.Platform.linux - (boolean) 当前操作系统是否为Linux

- Browser.Platform.ipod - (boolean) 当前操作系统是否为iPod Touch / iPhone

- Browser.Platform.other - (boolean) 当前操作系统即不是Mac, 也不是Windows或Linux

- Browser.Platform.name - (string) 当前操作系统的名称


>转载自：http://www.cnblogs.com/duanguyuan/p/3534470.html
