title: css3之3D动画
date: 2016-12-13 15:21:04
tags: [css,css3]
categories: 动画效果
---

# 3D笛卡尔坐标系统

首先，脑海里要有一个3D坐标体系：

<img src="/myBlog/images/css-3d/donghua14.png" alt="笛卡尔坐标" width="400" height="400">

<!-- more -->

# transform

* CSS3中的3D变换主要包括以下几种功能函数：

 * 3D位移：CSS3中的3D位移主要包括`translateZ()`和`translate3d()`两个功能函数
 * 3D旋转：CSS3中的3D旋转主要包括`rotateX()`、`rotateY()`、`rotateZ()`和`rotate3d()`四个功能函数
 * 3D缩放：CSS3中的3D缩放主要包括`scaleZ()`和`scale3d()`两个功能函数
 * 3D矩阵：CSS3中3D变形中和2D变形一样也有一个3D矩阵功能函数`matrix3d()`

> 本质上都是应用的`matrix()`方法实现的（修改`matrix()`方法固定几个值），只是类似于`transform`、`rotate`这种表现形式，我们更容易理解，记忆与上手。

- translate3d(tx,ty,tz) == matrix3d(1,0,0,0,0,1,0,0,0,0,1,0,tx,ty,tz,1)

<img src="/myBlog/images/css-3d/translate.png">

- scale3d(sx,sy,sz) == matrix3d(sx,0,0,0,0,sy,0,0,0,0,sz,0,0,0,0,1)

 <img src="/myBlog/images/css-3d/scale.png" alt="">

- `rotate3d(x,y,z,a)`中的第四个参数alpha用于sc和sq中,如下图：

![rotate](/myBlog/images/css-3d/rotate.png)

![rotate1](/myBlog/images/css-3d/rotate1.png)

## 3D位移-translate3d

```css
transform: translate3d(x,y,z)
transform: translateZ(z)
```
> z不能取百分比值，否则无效。<br/>z轴越大，元素离用户越近，反之越远！

<iframe width="100%" height="300" src="//jsfiddle.net/Elaine_liao/gyo9me21/embedded/html,css,result/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

## 3D旋转-rotate3d

```css
rotate3d(x,y,z,angle)
```

* `rotate3d(x,y,z,a)`中取值说明：
  * x：主要用来描述元素围绕X轴旋转的矢量值；
  * y：主要用来描述元素围绕Y轴旋转的矢量值；
  * z：主要用来描述元素围绕Z轴旋转的矢量值；
  * a：是一个角度值，主要用来指定元素在3D空间旋转的角度，如果其值为正值，元素顺时针旋转，反之元素逆时针旋转。 

上面介绍的三个旋转函数功能等同：

- rotateX(a)函数功能等同于rotate3d(1,0,0,a)
- rotateY(a)函数功能等同于rotate3d(0,1,0,a)
- rotateZ(a)函数功能等同于rotate3d(0,0,1,a)

<iframe width="100%" height="300" src="//jsfiddle.net/Elaine_liao/o3v4ncdj/embedded/html,css,result/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

## 3D缩放-scale3d

```css
scale3d(x,y,z)
```

> 默认值为１，当值大于１时，元素放大，反之小于１大于0.01时，元素缩小。

<iframe width="100%" height="300" src="//jsfiddle.net/Elaine_liao/Lwzqj83w/embedded/html,css,result/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

## transform-style

要利用 CSS3 实现 3D 的效果，最主要的就是借助 `transform-style` 属性。

```css
transform-style: flat|preserve-3d;
transform-style: flat; // 默认，子元素将不保留其位置
transform-style: preserve-3d; 
```


当我们指定一个容器的 `transform-style` 的属性值为 `preserve-3d` 时，容器的后代元素便会具有 3D 效果，也就是当前父容器设置了 `preserve-3d` 值后，它的子元素就可以相对于父元素所在的平面，进行 3D 变形操作。

## transform-origin

```css
transform-origin: x y z
```

元素变形的原点默认为物体的正中心（`transform-origin: 50% 50% 0`），该数值和后续提及的百分比均默认基于元素自身的宽高算出具体数值：

> `transform-origin`来对元素进行原点位置改变，使元素原点不在元素的中心位置，以达到需要的原点位置。

<img src="/myBlog/images/css-3d/transform-2.jpg" alt="">

# perspective

```css
perspective: number|none;
```

perspective在css里它是有数值的，例如perspective: 1000px这个代表什么呢？我们可以这样理解，如果我们直接眼睛靠着物体看，物体就超大占满我们的视线，我们离它距离越来越大，它在变小，立体感也就出来了是不是，其实这个数值构造了一个我们眼睛离屏幕的距离，也就构造了一个虚拟3D假象。

> `perspective` 为一个元素设置三维透视的距离，仅作用于元素的后代，而不是其元素本身。


- `perspective`取值为none或不设置，就没有真3D空间。此時所有后代元素被压缩在同一个二维平面上，不存在景深的效果。
- `perspective`取值越小，3D效果就越明显，也就是你的眼睛越靠近真3D。
- `perspective`的值无穷大，或值为0时与取值为none效果一样。

<img src="/myBlog/images/css-3d/prs.jpg" alt="">

## 使用场景

在3D变形中，除了`perspective`属性可以激活一个3D空间之外，在3D变形的函数中的`perspective()`也可以激活3D空间。他们不同的地方是：`perspective`用在舞台元素上（变形元素们的共同父元素）；`perspective()`就是用在当前变形元素上，并且可以与其他的`transform`函数一起使用。

```css
.stage {
    perspective: 600px
}
```
写成：

```css
.stage .box {
    transform: perspective(600px)
}
```

<iframe width="100%" height="300" src="//jsfiddle.net/Elaine_liao/m4dfkyk6/embedded/html,css,result/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

区别在于：

- `perspective`属性可以取值为none或长度值；
- `perspective()`函数取值只能大于0，如果取值为0或比0小的值，将无法激活3D空间;
- `perspective`属性用于变形对像父元素；
- `perspective()`函数用于变形对像自身，并和transform其他函数一起使用;

## perspective-origin

```css
  perspective-origin: x y
```

> 第一个数值是 3D 元素所基于的 X 轴，第二个定义在 y 轴上的位置

`perspective-origin`表示 3D 元素透视视角的基点位置，默认的透视视角中心在容器是`perspective`所在的元素，而不是他的后代元素的中点。

默认值：`perspectice-origin: 50% 50%`

我们前面说的这个是眼睛离物体的距离，而这个就是眼睛的视线，我们的视点的不同位置就决定了我们看到的不同景象，默认是中心，为`perspectice-origin: 50% 50%`,第一个数值是 3D 元素所基于的 X 轴，第二个定义在 y 轴上的位置往往我们看一样东西不可能一直都在中心位置看，想换个角度，换个位置一看究竟，这个时候就离不开`perspective-origin`这个属性。

> 当为元素定义 `perspective-origin` 属性时，其子元素会获得透视效果，而不是元素本身。必须与 `perspective` 属性一同使用，而且只影响 3D 转换元素。

<img src="/myBlog/images/css-3d/prso.jpg" alt="">

# backface-visibility

```css
backface-visibility: visible | hidden
```

`backface-visibility`属性决定元素旋转背面是否可见，默认为可见。

# perspective，preserve-3d，translate

3D环境3个要素，摄像机（Camera）、舞台（stage）和物体（Object）本身:

- 摄像机 
  - 为摄像机加上`perspective`
- 舞台
  - 为舞台加上`preserve-3d`，使到一个舞台内为同一3D渲染环境
- 物体
  - 实际`transform`效果

# 3D与硬件加速

<iframe width="100%" height="450" src="//jsfiddle.net/Elaine_liao/dsaLkmqs/2/embedded/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

打开控制台的rendering => paint flashing,将会看到发生重绘的区域变为绿色。

> transform 属性不会触发浏览器的 repaint，而 left 和 top 则会一直触发 repaint。

那么，为什么 transform 没有触发 repaint 呢？简而言之，transform 动画由GPU控制，支持硬件加速，并不需要软件方面的渲染。


注意：

* 如果GPU加载了大量的纹理，那么很容易就会发生内容问题，这一点在移动端浏览器上尤为明显，所以，一定要牢记不要让页面的每个元素都使用硬件加速。

* 使用GPU渲染会影响字体的抗锯齿效果。这是因为GPU和CPU具有不同的渲染机制。即使最终硬件加速停止了，文本还是会在动画期间显示得很模糊。