title: 上传文件的几种情况
date: 2017-05-24 13:33:45
tags: [upload,ajax]
---
# 通过base64上传文件（适用于小文件）
```html
<input type="file" onchange="upload(e)" />
```
执行`onchange`函数：

```javascript
function upload (e) {
  const file = e.target.files[0]
  const { name, size, type } = file
  const reader = new FileReader()
  reader.readAsDataURL(file)

  reader.onload = function (e) {
    const _img = e.target.result
    const base64 = _img.split(',')[1]
    const data = {
      size,
      name,
      type,
      base64
    }
    // 上传action....参数data
  }
}
```
# form提交

```html
<input type="file" onchange="upload(e)" />
```
执行`onchange`函数：

```javascript
function upload (e) {
  const file = e.target.files[0]
  const { name, size } = file
  const data = new FormData()
  data.append('file', file)
  // 上传action....参数data
}
```

# 拿到base64转为form提交

> 比如本地裁剪图片生成base64并上传至服务器

```javascript
const canvasBase = canvas.toDataURL()
```

```javascript
// base64信息需要通过window.atob转换成由二进制字符串。
// 但window.atob转换后的结果仍然是字符串，直接给Blob还是会出错。
// 所以又要用 Uint8Array转换一下。
function upload(canvasBase) {
  const base64 = canvasBase.split(',')[1]
  const ia = new Uint8Array(data.length)
  for (let i = 0; i < data.length; i++) {
    ia[i] = data.charCodeAt(i)
  };
  const blob = new Blob([ia], { type: 'image/png' })
  const fd = new FormData()
  fd.append('file', blob)
  // 上传action....参数fd
}
```
