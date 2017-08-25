title: 自定义postcss插件
date: 2017-08-25 16:45:00
tags: [webpack,postcss]
---

# 案例一 

```javascript
var postcss = require('postcss')

module.exports = postcss.plugin('postcss-font', function myplugin () {
  return function (css) {
    var fontstacksConfig = {
      Arial: 'Arial, "Helvetica Neue", Helvetica, sans-serif',
      'Times New Roman':
        'TimesNewRoman, "Times New Roman", Times, Baskerville, Georgia, serif'
    }
    function toTitleCase (str) {
      return str.replace(/\w\S*/g, function (txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
      })
    }
    // css.walkRules方法用来遍历每一条css规则
    css.walkRules(function (rule) {
      // walkDecls方法用来解析属性跟值
      rule.walkDecls(function (decl, i) {
        var value = decl.value
        if (value.indexOf('fontstack(') !== -1) {
          var fontstackRequested = value
            .match(/\(([^)]+)\)/)[1]
            .replace(/["']/g, '')
          fontstackRequested = toTitleCase(fontstackRequested)

          var fontstack = fontstacksConfig[fontstackRequested]
          var firstfont = value.substr(0, value.indexOf('fontstack('))
          decl.value = firstfont + fontstack
        }
      })
    })
  }
})

```

# 案例二

```js
var postcss = require('postcss')

module.exports = postcss.plugin('postcss-vr', function (options) {
  return function (css, result) {
    options = options || {}
    let htmlFont = options.htmlFont || 100
    // 使用 PostCSS 的 eachDecl() 遍历每个 CSS 声明，并传入声明字符串 (decl)。
    css.walkDecls(function (decl) {
      // 如果声明值匹配到了 vr 单位。
      if (decl.value.match(/vr/)) {
        // 使用计算值替换声明值。
        // 使用 parseFloat() 移除 vr 单位并返回一个数字。
        decl.value = `${parseFloat(decl.value) / (htmlFont * 2)}rem`
      }
    })
  }
})

```

# 如何引入webpack

```javascript
// postcss.config.js
module.exports = {
  plugins: [
    require('./postcss-font')
    require('./postcss-vr')({
      htmlFont: 100
    })
  ]
}

```
# 如何调用

```css
.test {
  height: 2vr;
  font-family: "Open Sans", fontstack("Arial");
}
```