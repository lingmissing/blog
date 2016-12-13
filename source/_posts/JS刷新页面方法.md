---
title: JS刷新页面方法
date: 2016-03-06 15:14:06
tags: javascript
---
## 基本刷新页面方法 ##

```html
<meta http-equiv="refresh"content="10;url=跳转的页面">
<!-- 10表示间隔10秒刷新一次 -->
```

```html
<script language=''javascript''>
  window.location.reload(true);
</script>
<!-- 如果是你要刷新某一个iframe就把window给换成frame的名字或ID号 -->
```

```html
<script language=''javascript''>
  window.navigate("本页面url");
</script>
```

```javascript
function abc() {
  window.location.href="/blog/window.location.href";
  setTimeout("abc()",10000);
}
```

#### 刷新本页 #### 

```javascript
Response.Write("
	<script type="text/javascript">
		window.location.href = window.location.href;
	</script>
")
```

#### 刷新父页 #### 

```javascript
Response.Write("
	<script type="text/javascript" >
		opener.location.href = opener.location.href;
	</script>
")
```

#### 转到指定页 #### 

```javascript
Response.Write("
	<script type="text/javascript" >
		window.location.href = 'yourpage.aspx';
	</script>
")
```

## 定时刷新页面方法 ##
#### 在html中设置 #### 
在<head>标签中加入下面一行代码：
10代表刷新间隔，单位为秒。
```html
<meta http-equiv="refresh" content="10">
```

#### jsp方法 #### 
1代表每一秒刷新一次。

```html
<% response.setHeader("refresh","1"); %>
```

#### javascript方法 #### 
1000代表1000毫秒，即1秒。
```html
<script type="text/javascript">
    setTimeout("self.location.reload();",1000);
<script>
```


