---
title: weinre调试手机端
date: 2016-10-09 12:04:51
tags: weinre
---
> 安装前提：安装node
----------
### 全局安装
```
npm -g install weinre
```
### 启动weinre
```
weinre --boundHost -all- --httpPort 8081
```
### 访问页面获取js
在浏览器中访问生成的页面获取js，地址为`ip`加端口号，如下：

```
http://[ip]:8081
```
### 粘贴js
在上个步骤中的页面找到如下类型的代码，将该js引入项目：
```
<script type="text/javascript">http://[ip]:8081/target/target-script-min.js#{app标识}</script>
```
### 启动webapp
### 电脑端访问
新开标签页输入如下地址并在手机上刷新app，将会看到数据结构。
```
http://[ip]:8081/client/#{app标识}
```