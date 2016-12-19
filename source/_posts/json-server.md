title: 如何在本地模拟接口
date: 2016-12-19 16:48:00
tags: [node,json,javascript]
categories: 代码如诗，前端如画
---

# 安装依赖包

```bash
npm install express --save-dev
```

# 构建api文件

<!-- more -->

```javascript
// api.js
const express = require('express');
const bodyParser = require('body-parser');
const app = express();


app.use(bodyParser.json());       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
}));


app.use((req, res, next) => {
	res.setHeader('Access-Control-Allow-Origin', '*');
	res.setHeader('Access-Control-Allow-Methods',
		'GET,POST,PUT,DELETE,OPTIONS');
	res.setHeader('Access-Control-Allow-Headers',
		'Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With');
	next();
})
// 接下面的代码...
```

# GET请求

```javascript
// 接上面
app.get('/api/getComments', (req, res) => {
  res.json({
    code: 200,
    message: 'get请求成功'
  })
})
```

# POST请求

```javascript
// 接上面
app.post('/api/list', function(req, res) {
  res.json({
    code: 0,
    data: []
  })
})
```

# 生成端口

```javascript
// 接上面
app.listen(8090, () => {
	console.log('server started at 8090...')
})
```

# 运行服务

```javascript
app.listen(8090, () => {
	console.log('server started at 8090...')
})
```

# 调用接口

```bash
http://localhost:8090/api/...
```