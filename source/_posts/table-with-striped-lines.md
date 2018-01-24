title: 制作列带有斑马条纹背景的表格
date: 2016-05-16 13:27:00
categories: 前端
tags: [css]
---
在切页面时，遇到了一个有趣的表格，如图所示：
<!-- more -->
![](/img/table-with-striped-lines0.png)  

下意识的想到了`bootstrap`的斑马纹效果table，然而记忆中bs只有行斑马纹效果，至于实现事实上很简单，直接去Github看最终生成的`bootstrap.css`文件，当前的2321~2323行为：
```css
.table-striped > tbody > tr:nth-of-type(odd) {
  background-color: #f9f9f9;
}
```

事实上这给了我一个很好的思路，借助`nth-child()`选择器，先对每行的奇数`td`设定背景，连起来就是奇数列做了特殊背景处理，也就是斑马纹效果，然后再对第一行和最后一行做特殊处理让边角圆润，下面贴上自己的代码（主要提供一个思路，css比较烂，请轻喷==）：  
__html__
```html
<table class="account-course-lessons">
    <tbody>
        <tr>
            <td><input type="checkbox"><a href="#">L1</a></td>
            <td><input type="checkbox"><a href="#">L2</a></td>
            <td><input type="checkbox"><a href="#">L3</a></td>
            <td><input type="checkbox"><a href="#">L4</a></td>
        </tr>
        <tr>
            <td><input type="checkbox"><a href="#">L5</a></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
    </tbody>
</table>
```
__scss__  
```scss
table.account-course-lessons {
  width: 600px;
  height: 300px;
  margin: 1em;
  background-color: rgb(221, 221, 221);
  border-radius: 10px;
  text-align: center;
  text-decoration: underline;

  tr {
    td {
      border-bottom: 2px solid rgb(215, 215, 215);
      height: 60px;

      a {
        color: gray;
        font-size: 1.5em;
        margin: 0 1em;
      }
    }
  }
  tr {
    td:nth-child(2n+1) {
      background-color: rgb(235, 235, 235);
      border-bottom: 2px solid rgb(215, 215, 215);
    }
  }
  tr:nth-child(1) {
    td:nth-child(2n+1) {
      background-color: rgb(235, 235, 235);
      border-top: 10px solid transparent;
      border-left: 10px solid transparent;
      border-right: 10px solid transparent;
      border-radius: 20px 20px 0 0 ;
    }
  }
  tr:nth-last-child(1) {
    td:nth-child(2n+1) {
      background-color: rgb(235, 235, 235);
      border-bottom: 10px solid transparent;
      border-left: 10px solid transparent;
      border-right: 10px solid transparent;
      border-radius:  0 0 20px 20px ;
    }
    td {
      border-bottom: 0;
    }
  }
}
```
