title: canvas的基本使用
date: 2016-12-13 17:27:34
tags: [canvas,html5,javascript]
categories: 动画效果
---

# canvas API说明
## canvas主要属性和方法

|   方法 |  描述 | 
| ---------- | ----------- |
|save()   |                        保存当前环境的状态|
|restore()   |                        返回之前保存过的路径状态和属性|
|createEvent()   |     - |
|getContext()  |                 返回一个对象，指出访问绘图功能必要的API|
|toDataURL()  |                 返回canvas图像的URL|

<!-- more -->

## canvas的API颜色、样式和阴影属性和方法

|属性        |                       描述|
| ------------ | ------------- |
|fillStyle  |                         设置或返回用于**填充**绘画的颜色、渐变或模式|
|strokeStyle |                  设置或返回用于**笔触**的颜色、渐变或模式|
|shadowColor |                  设置或返回用于**阴影**的颜色|
|shadowBlur  |                 设置或返回用于**阴影**的**模糊**级别|
|shadowOffsetX  |         设置或返回**阴影**距形状的**水平**距离|
|shadowOffsetY  |         设置或返回**阴影**距形状的**垂直**距离|

|方法     |                                      描述|
| --------------- | ---------------- |
|createLinearGradient()    |       创建线性渐变（用在画布内容上）|
|createPattern()     |              在指定的方向上重复指定的元素|
|createRadialGradient()   |        创建放射状/环形的渐变（用在画布内容上）|
|addColorStop()     |              规定渐变对象中的颜色和停止位置|

## Canvas的API-线条样式属性和方法

|属性   |                                 描述|
| ----------- | ----------- |
|lineCap   |                         设置或返回线条的**结束端点**样式|
|lineJoin  |                          设置或返回两条线相交时，所创建的**拐角类型**|
|lineWidth  |                          设置或返回当前的**线条宽度**|
|miterLimit |                           设置或返回**最大斜接**长度|

## Canvas的API-矩形方法

|方法   |                            描述|
| ------------ | -------------- |
|rect()   |                         创建矩形|
|fillRect()   |                         绘制"被填充"的矩形|
|strokeRect()    |                绘制矩形（无填充）|
|clearRect()       |             在给定的矩形内清除指定的像素|

## Canvas的API-路径方法

|方法      |                              描述|
| -------------- | ---------------- |
|fill()   |                                 填充当前绘图（路径）|
|stroke() |                           绘制已定义的路径|
|beginPath()  |                  起始一条路径，或重置当前路径|
|moveTo()   |                         把路径移动到画布中的指定点，不创建线条|
|closePath()  |                  创建从当前点回到起始点的路径|
|lineTo()     |                       添加一个新点，创建从该点到最后指定点的线条|
|clip()       |                             从原始画布剪切任意形状和尺寸的区域|
|quadraticCurveTo() |           创建二次贝塞尔曲线|
|bezierCurveTo()    |        创建三次方贝塞尔曲线|
|arc()              |                      创建弧/曲线（用于创建圆形或部分圆）|
|arcTo()            |                创建两切线之间的弧/曲线|
|isPointInPath()    |          如果指定的点位于当前路径中，返回布尔值|

## Canvas的API-转换方法

|方法   |                           描述|
| ------------ | ----------- |
|scale()   |                        缩放当前绘图至更大或更小|
|rotate()  |                         旋转当前绘图|
|translate() |                  重新映射画布上的 (0,0) 位置|
|transform()  |                 替换绘图的当前转换矩阵|
|setTransform()   |                将当前转换重置为单位矩阵。然后运行 transform()|

## Canvas的API-文本属性和方法

|属性          |                  描述|
| --------- | ---------- |
|font          |                        设置或返回文本内容的当前字体属性|
|textAlign    |                      设置或返回文本内容的当前对齐方式|
|textBaseline  |                设置或返回在绘制文本时使用的当前文本基线|

|方法               |                   描述|
| ---------- | ---------- |
|fillText()        |                  在画布上绘制"被填充的"文本|
|strokeText()      |            在画布上绘制文本（无填充）|
|measureText()     |       返回包含指定文本宽度的对象|

## Canvas的API-图像绘制方法

|方法    |                         描述|
| --------- | ------- |
|drawImage() |                 向画布上绘制图像、画布或视频  chrome不支持|

## Canvas的API-像素操作方法和属性

|属性              |                描述|
| ---------- | --------- |
|width             |             返回 ImageData 对象的宽度|
|height            |              返回 ImageData 对象的高度|
|data              |                    返回一个对象，其包含指定的 ImageData 对象的图像数据|

|方法               |            描述|
| ---------- | --------- |
|createImageData()  |        创建新的、空白的 ImageData 对象|
|getImageData()     |     返回 ImageData 对象，该对象为画布上指定的矩形复制像素数据|
|putImageData()     |     把图像数据（从指定的 ImageData 对象）放回画布上|

## Canvas的API-图像合成属性

|属性      |                            描述|
| -------- | -------- |
|globalAlpha    |              设置或返回绘图的当前 alpha 或透明值|
|globalCompositeOperation  |      设置或返回新图像如何绘制到已有的图像上|


