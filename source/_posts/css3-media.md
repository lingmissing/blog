title: css3之媒体查询
date: 2016-12-22 14:57:22
tags: [css,css3,media]
categories: 前端布局
---
# 语法

## link中的媒体查询

```html
<!-- link元素中的CSS媒体查询 -->
<link rel="stylesheet" media="(max-width: 800px)" href="example.css" />
```

## style中的媒体查询

```css
<!-- 样式表中的CSS媒体查询 -->
<style>
@media (max-width: 600px) {
  .facet_sidebar {
    display: none;
  }
}
```
<!--more -->

## 逻辑操作符

- and 操作符用来把多个媒体属性组合起来，合并到同一条媒体查询中。只有当每个属性都为真时，这条查询的结果才为真。
- not 操作符用来对一条媒体查询的结果进行取反。(not 关键字仅能应用于整个查询)
- only 操作符表示仅在媒体查询匹配成功的情况下应用指定样式。可以通过它让选中的样式在老式浏览器中不被应用。

> 若使用了 not 或 only 操作符，必须明确指定一个媒体类型。

> 你也可以将多个媒体查询以逗号分隔放在一起；只要其中任何一个为真，整个媒体语句就返回真。相当于 or 操作符。

```css
// and
@media tv and (min-width: 700px) and (orientation: landscape) { ... }
```

```css
// not
@media not all and (monochrome) { ... } 
//等价于
@media not (all and (monochrome)) { ... }
```

```css
@media not screen and (color), print and (color) { ... }
//等价于
@media (not (screen and (color))), print and (color) { ... }
```

```css
<!-- or -->
@media (min-width: 700px), handheld and (orientation: landscape) { ... }
```

```html
// only
<link rel="stylesheet" media="only screen and (color)" href="example.css" />
```

# 媒体特性

- 支持min/max前缀
  - 颜色（color）：指定输出设备每个像素单元的比特值
  - 颜色索引（color-index）：指定了输出设备中颜色查询表中的条目数量。
  - 宽高比（aspect-ratio）：描述了输出设备目标显示区域的宽高比
  - 设备宽高比（device-aspect-ratio）
  - 设备高度（device-height）
  - 设备宽度（device-width）
  - 高度（height）
  - 宽度（width）
  - 黑白（monochrome）指定了一个黑白（灰度）设备每个像素的比特数
  - 分辨率（resolution）指定输出设备的分辨率（像素密度）
- 不支持min/max前缀
  - 网格（grid） 判断输出设备是网格设备还是位图设备
  - 方向（orientation）指定了设备处于横屏（宽度大于高度）模式还是竖屏（高度大于宽度）模式。
  - 扫描（scan）描述了电视输出设备的扫描过程。