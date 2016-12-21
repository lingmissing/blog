title: 浏览器的各种事件
date: 2016-12-21 16:56:37
tags: [javascript,browser]
---
# 浏览器关闭

## onbeforeunload

```javascript
window.onbeforeunload = funcRef
```

当窗口即将被卸载时,会触发该事件.此时页面文档依然可见,且该事件的默认动作可以被取消。

## onunload

```javascript
window.onunload = funcRef;
```
<!-- more -->
当页面关闭后,会触发unload事件。

# 浏览器刷新

## onload

```javascript
window.onload = funcRef;
```

当页面重新加载时，会触发onload事件。

# 浏览器路由

## hashchange

```javascript
window.hashchange = funcRef;
```

hashchange事件会在页面URL中的片段标识符(第一个#号开始到末尾的所有字符,包括#号)发生改变时触发.

## popstate

```javascript
window.popstate = funcRef;
```

当前活动历史项(history entry)改变会触发popstate事件

