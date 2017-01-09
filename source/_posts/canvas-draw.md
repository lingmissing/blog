title: 利用vue制作在线涂鸦板
date: 2017-01-03 17:48:34
tags: [canvas,javascript,vue]
categories: 前端框架之vue
---

> 效果展示

![绘画板](/myBlog/images/canvas-draw/draw.jpeg)

# Canvas API简介

## 调用方法
- `getImageData()` 返回`ImageData`对象，该对象为画布上指定的矩形复制像素数据
- `putImageData()` 把图像数据（从指定的 `ImageData` 对象）放回画布上
- `clearRect()` 在给定的矩形内清除指定的像素
- `toDataURL()` 返回canvas图像的URL
- `lineTo()` 添加一个新点，创建从该点到最后指定点的线条
- `stroke()` 绘制已定义的路径
- `beginPath()` 起始一条路径，或重置当前路径
- `moveTo()` 把路径移动到画布中的指定点，不创建线条

## 调用属性
<!-- more -->
- `strokeStyle` 设置或返回用于笔触的颜色、渐变或模式
- `shadowBlur` 设置或返回用于阴影的模糊级别
- `shadowColor` 设置或返回用于阴影的颜色
- `lineWidth` 设置或返回当前的线条宽度

> 更多API请参考 [canvas基本使用](https://lingmissing.github.io/myBlog/2016/12/13/canvas-basic/)

# 功能需求说明

- 基础线条绘制功能
- 笔触颜色修改
- 笔刷粗细调整
- 撤回、前进、情况功能
- 生成图片

# 初始化数据

- `colors`: 笔触颜色列表
- `brushs`: 笔刷对应的粗细
- `context`: canvas context
- `imgUrl`: 用于存放保存图片的地址
- `canvasMoveUse`: 是否允许执行move时候绘制线条
- `preDrawAry`: 存储当前表面状态数组-上一步
- `nextDrawAry`: 存储当前表面状态数组-下一步
- `middleAry`: 中间数组
- `lineWidth`: 线条宽度
- `lineColor`: 线条颜色
- `shadowBlur`: 阴影

```javascript
data() {
  return {
    colors: ['#fef4ac','#0018ba','#ffc200','#f32f15','#cccccc','#5ab639'],
    brushs: [{
            className: 'small fa fa-paint-brush',
            lineWidth: 3
          },{
            className: 'middle fa fa-paint-brush',
            lineWidth: 6
          },{
            className: 'big fa fa-paint-brush',
            lineWidth: 12
          }],
    context: {},
    imgUrl: [],
    canvasMoveUse: true,
    preDrawAry: [],
    nextDrawAry: [],
    middleAry: [],
    config: {
      lineWidth: 1,
      lineColor: "#f2849e",
      shadowBlur: 2
    }
  }
}
```
# 设置绘画配置

```javascript
  setCanvasStyle() {
    this.context.lineWidth = this.config.lineWidth
    this.context.shadowBlur = this.config.shadowBlur
    this.context.shadowColor = this.config.lineColor
    this.context.strokeStyle = this.config.lineColor
  }
```

笔触颜色及粗细相关设置（点击修改config数据）：

```html
<!-- 画笔颜色 -->
<li 
  v-for="item in colors" 
  :class="{'active':config.lineColor === item}"
  :style="{ background: item }" 
  @click="setColor(item)"
></li>
```

```html
<!-- 画笔粗细 -->
 <span 
  v-for="pen in brushs" 
  :class="[pen.className,{'active': config.lineWidth === pen.lineWidth}]"
  @click="setBrush(pen.lineWidth)"
></span>
```

## 画笔的移动操作

```javascript
// 当在屏幕中移动时即开始绘制准备
beginPath(e){
  const canvas = document.querySelector('#canvas')
  if (e.target !== canvas) {
    this.context.beginPath()
  }
}
```

```javascript
// 在canvas中鼠标按下
 canvasDown(e) {
  // 让move方法可用
  this.canvasMoveUse = true
  // client是基于整个页面的坐标
  // offset是cavas距离顶部以及左边的距离
  const canvasX = e.clientX - e.target.parentNode.offsetLeft
  const canvasY = e.clientY - e.target.parentNode.offsetTop
  // 设置canvas的配置
  this.setCanvasStyle()
  //清除子路径
  this.context.beginPath()
  // 移动的起点
  this.context.moveTo(canvasX, canvasY)
  //当前绘图表面状态
  const preData = this.context.getImageData(0, 0, 600, 400)
  //当前绘图表面进栈
  // 按下相当于新的操作的开始，所以把当前记录数据放到prev中
  this.preDrawAry.push(preData)
},
```

```javascript
// canvas中鼠标移动
canvasMove(e) {
  if(this.canvasMoveUse) {
    // 只有允许移动时调用
    const t = e.target
    let canvasX
    let canvasY
    // 由于手机端和pc端获取页面坐标方式不同，所以需要做出判断
    if(this.isPc()){
      canvasX = e.clientX - t.parentNode.offsetLeft
      canvasY = e.clientY - t.parentNode.offsetTop
    }else {
      canvasX = e.changedTouches[0].clientX - t.parentNode.offsetLeft
      canvasY = e.changedTouches[0].clientY - t.parentNode.offsetTop
    }
    // 连接到移动的位置并上色
    this.context.lineTo(canvasX, canvasY)
    this.context.stroke()
  }
},
```

```javascript
// canvas中鼠标放开
canvasUp(e){
  const preData = this.context.getImageData(0, 0, 600, 400)
  if (!this.nextDrawAry.length) {
    // 在没有撤销过的情况下，将当前数据放入prev
    //当前绘图表面进栈
    this.middleAry.push(preData)
  } else {
    // 在撤销的情况下，将在后面步骤的数据情况记录
    this.middleAry = []
    this.middleAry = this.middleAry.concat(this.preDrawAry)
    this.middleAry.push(preData)
    this.nextDrawAry = []
  }
  // 设置move时不可绘制
  this.canvasMoveUse = false
}
```


为了保证移动端的可用性，加入touchstart等。

```html
<canvas 
  id="canvas" 
  class="fl" 
  width="600" 
  height="400" 
  @mousedown="canvasDown($event)" 
  @mouseup="canvasUp($event)"
  @mousemove="canvasMove($event)"
  @touchstart="canvasDown($event)" 
  @touchend="canvasUp($event)"
  @touchmove="canvasMove($event)"
>
```

## 撤销清空等操作

```javascript
// 撤销
if (this.preDrawAry.length) {
  const popData = this.preDrawAry.pop()
  const midData = this.middleAry[this.preDrawAry.length + 1]
  this.nextDrawAry.push(midData)
  this.context.putImageData(popData, 0, 0)
}
```

```javascript
// 前进
if (this.nextDrawAry.length) {
  const popData = this.nextDrawAry.pop()
  const midData = this.middleAry[this.middleAry.length - this.nextDrawAry.length - 2]
  this.preDrawAry.push(midData)
  this.context.putImageData(popData, 0, 0)
}
```

```javascript
// 清空
this.context.clearRect(0, 0, this.context.canvas.width, this.context.canvas.height)
// 清空前后数据
this.preDrawAry = []
this.nextDrawAry = []
// middleAry恢复到默认数据
this.middleAry = [this.middleAry[0]]
```

> [demo地址](https://lingmissing.github.io/#/draw)

------

> [查看代码](https://github.com/lingmissing/lingmissing.github.com/tree/code/src/router/OnlineTools/Draw)








