---
title: flex布局
date: 2016-08-19 14:41:02
tags: css3
---

## Flex容器属性

##### display

定义一个Flex容器，根据其取的值来决定是内联还是块。Flex容器会为其内容建立新的伸缩格式化上下文。

```css
.container {
  display: flex; /* or inline-flex */
}
```

##### flex-direction

指定容器内部排列的方向。

```css
.container {
  flex-direction: row | row-reverse | column | column-reverse;
}
```

- row(默认值):如果书写方式是ltr，那么Flex项目从左向右排列；如果书写方式是rtl，那么Flex项目从右向左排列
- row-reverse:如果书写方式是ltr，那么Flex项目从右向左排列；如果书写方式是rtl，那么Flex项目从左向右排列
- column:和row类似，只不过方向是从上到下排列
- column-reverse:和row-reverse类似，只不过方向是从下向上排列


##### flex-wrap

指定子元素是否可以换行。

```css
.container{
  flex-wrap: nowrap | wrap | wrap-reverse;
}
```

- nowrap(默认值):单行显示，如果书写方式是ltr，Flex项目从左向右排列，反之rtl，从右向左排列
- wrap:多行显示，如果书写方式是ltr，Flex项目从左向右排列，反之rtl，从右向左排列
- wrap-reverse:多行显示，如果书写方式是ltr，Flex项目从右向左排列，反之rtl，从左向右排列


##### flex-flow(适用于flex容器元素)

这是flex-direction和flex-wrap两个属性的缩写。两个属性决定了伸缩容器的主轴与侧轴。默认值是row nowrap（中间用空格隔开）。

```css
flex-flow: <‘flex-direction’> || <‘flex-wrap’>
```

##### justify-content

用于在主轴上对齐伸缩项目。

```css
.container {
  justify-content: flex-start | flex-end | center | space-between | space-around;
}
```

- flex-start(默认值):伸缩项目向一行的起始位置靠齐。该行的第一个伸缩项目在主轴起点边的外边距与该行在主轴起点的边对齐，同时所有后续的伸缩项目与其前一个项目对齐。
- flex-end:伸缩项目向一行的结束位置靠齐。该行的最后一个伸缩项目在主轴终点边的外边距与该行在主轴终点的边对齐，同时所有前面的伸缩项目与其后一个项目对齐。
- center:伸缩项目向一行的中间位置靠齐。该行的伸缩项目将相互对齐并在行中居中对齐，同时第一个项目与该行在主轴起点的边的距离等同与最后一个项目与该行在主轴终点的边的距离（如果剩余空间是负数，则保持两端溢出的长度相等）。
- space-between:伸缩项目会平均地分布在行里。如果剩余空间是负数，或该行只有一个伸缩项目，则此值等效于flex-start。在其它情况下，第一个项目在主轴起点边的外边距会与该行在主轴起点的边对齐，同时最后一个项目在主轴终点边的外边距与该行在主轴终点的边对齐，而剩下的伸缩项目在确保两两之间的空白空间相等下平均分布。
- space-around:伸缩项目会平均地分布在行里，两端保留一半的空间。如果剩余空间是负数，或该行只有一个伸缩项目，则该值等效于center。在其它情况下，伸缩项目在确保两两之间的空白空间相等，同时第一个元素前的空间以及最后一个元素后的空间为其他空白空间的一半下平均分布。

##### align-items

align-items可以用来设置伸缩容器中包括匿名伸缩项目的所有项目的对齐方式。

```css
.container {
  align-items: flex-start | flex-end | center | baseline | stretch;
}
```

- flex-start:伸缩项目在侧轴起点边的外边距紧靠住该行在侧轴起始的边。
- flex-end:伸缩项目在侧轴终点边的外边距靠住该行在侧轴终点的边 。
- center:伸缩项目的外边距盒在该行的侧轴上居中放置。（如果伸缩行的尺寸小于伸缩项目，则伸缩项目会向两个方向溢出相同的量）。
- baseline:如果伸缩项目的行内轴与侧轴为同一条，则该值和flex-start等效。其它情况下，该值将参与基线对齐。所有参与该对齐方式的伸缩项目将按下列方式排列：首先将这些伸缩项目的基线进行对齐，随后其中基线至侧轴起点边的外边距距离最长的那个项目将紧靠住该行在侧轴起点的边。
- stretch:如果侧轴长度属性的值为auto，则此值会使项目的外边距盒的尺寸在遵照min/max-width/height属性的限制下尽可能接近所在行的尺寸。

##### align-content

当伸缩容器的侧轴还有多余空间时，align-content属性可以用来调准伸缩行在伸缩容器里的对齐方式.

```css
.container {
  align-content: flex-start | flex-end | center | space-between | space-around | stretch;
}
```

- flex-start:各行向伸缩容器的起点位置堆叠。伸缩容器中第一行在侧轴起点的边会紧靠住伸缩容器在侧轴起点的边，之后的每一行都紧靠住前面一行。
- flex-end:各行向伸缩容器的结束位置堆叠。伸缩容器中最后一行在侧轴终点的边会紧靠住该伸缩容器在侧轴终点的边，之前的每一行都紧靠住后面一行。
- center:各行向伸缩容器的中间位置堆叠。各行两两紧靠住同时在伸缩容器中居中对齐，保持伸缩容器在侧轴起点边的内容边和第一行之间的距离与该容器在侧轴终点边的内容边与第最后一行之间的距离相等。（如果剩下的空间是负数，则行的堆叠会向两个方向溢出的相等距离。）
- space-between:各行在伸缩容器中平均分布。如果剩余的空间是负数或伸缩容器中只有一行，该值等效于flex-start。在其它情况下，第一行在侧轴起点的边会紧靠住伸缩容器在侧轴起点边的内容边，最后一行在侧轴终点的边会紧靠住伸缩容器在侧轴终点的内容边，剩余的行在保持两两之间的空间相等的状况下排列。
- space-around:各行在伸缩容器中平均分布，在两边各有一半的空间。如果剩余的空间是负数或伸缩容器中只有一行，该值等效于center。在其它情况下，各行会在保持两两之间的空间相等，同时第一行前面及最后一行后面的空间是其他空间的一半的状况下排列。
- stretch:各行将会伸展以占用剩余的空间。如果剩余的空间是负数，该值等效于flex-start。在其它情况下，剩余空间被所有行平分，扩大各行的侧轴尺寸。

## Flex项目属性

##### order

默认情况，Flex项目是按文档源的流顺序排列。然而，在Flex容器中可以通过order属性来控制Flex项目的顺序源。

```css
.item {
  order: <integer>;
}
```

##### flex-grow

如果所有Flex项目的flex-grow设置为1时，表示Flex容器中的Flex项目具有相等的尺寸。如果你给其中一个Flex项目设置flex-grow的值为2，那么这个Flex项目的尺寸将是其他Flex项目两倍。

```css
.item {
  flex-grow: <number>; /* default 0 */
}
```

##### flex-shrink

如果有必要，flex-shrink可以定义Flex项目的缩小比例。

```css
.item {
  flex-shrink: <number>; /* default 1 */
}
```

##### flex-basis

flex-basis属性定义了Flex项目在分配Flex容器剩余空间之前的一个默认尺寸。main-size值使它具有匹配的宽度或高度，不过都需要取决于flex-direction的值。

```css
.item {
  flex-basis: <length> | auto; /* default auto */
}
```

##### flex

flex是flex-grow，flex-shrink和flex-basis三个属性的缩写。第二个和第三个参数(flex-shrink和flex-basis)是可选值。其默认值是0 1 auto。

```css
.item {
  flex: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]
}
```

##### align-self

align-self则用来在单独的伸缩项目上覆写默认的对齐方式。（对于匿名伸缩项目，align-self的值永远与其关联的伸缩容器的align-items的值相同。）

```css
.item {
  align-self: auto | flex-start | flex-end | center | baseline | stretch;
}
```

## 常用案例

- 子元素等分

```css
ul{
  display:flex;
}
li{
  flex:1;
}
```
- 左右固定宽度，中间自适应

```css
ul{
  display:flex;
}
li:first-child,
li:last-child{
  width:50px;
}
li:nth-child(2){
  flex:1;
}
```

- 底部贴底

```css
html,body,ul{
  height:100%;
}
ul{
  display:flex;
  flex-direction:column;
}
li:first-child,
li:last-child{
  height:50px;
}
li:nth-child(2){
  flex:1;
}
```

- 多行多列（商品列表）

```css
ul{
  display:flex;
  flex-wrap:wrap; //允许换行
}
li{
  width:50%;
}
```
- 两端对齐垂直居中（导航）

```html
<header>
  <h1>标题</h1>
  <a href="">更多</a>
</header>
```

```css
header{
  display:flex;
  justify-content:space-between;
  align-items:center;
}
```

- 水平垂直居中（img）

```css
header{
  display:flex;
  justify-content:center;
  align-items:center;
}
```

- 子元素横向排列，超过父容器宽度不换行（slider）

```css
ul{
  display:flex;
}
li{
  flex-shrink:0;
}
```

转载自[一个完整的Flexbox指南](http://www.w3cplus.com/css3/a-guide-to-flexbox-new.html)












