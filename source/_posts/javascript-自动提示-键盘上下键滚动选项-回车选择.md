---
title: javascript 自动提示/ 键盘上下键滚动选项/ 回车选择
date: 2016-03-21 15:43:59
tags: [javascript, jquery]
---

在输入框中输入内容，下拉出现自动提示列表，鼠标上下键选择提示中的项，然后回车选择相应的项。
实现原理：JS 监听输入框的 kedown、keyup、focusout 事件。

<!-- more -->

1. 输入内容的时候 keyup 触发调取后台数据，并接收返回的数据弹出自动提示内容。
2. 键盘按下的时候 keydown 判断是否是上下键、回车键、退格删除键，如果是上下键，通过 js 改变相应内容的显示状态标为当前状态，如果是回车键，将标记为当前选中状态的内容添加到目标 HTML 标签中，如果是回退删除键判断下输入框里面是否有内容，如果没内容删除目标 HTML 标签中最后添加的元素。
3. 当 input 框失去焦点的时候出发 focusout 事件，执行隐藏提示内容。

下面看下示例代码吧！

```javascript
$(function(){
    $('#tag-search').on('keydown', function(event){
        var curKeyCode = event.keyCode || event.which;
        if (curKeyCode == 38) {//上方向键
            keychang("up");
            event.preventDefault();
        } else if (curKeyCode == 40) {//下方向键
            keychang();
            event.preventDefault();
        } else if (curKeyCode == 13) {//回车键
            checkTagname();
            $('#tag-tip').hide();
            event.preventDefault();
        } else if (curKeyCode == 8) {//回退删除键
            if ($('#tag-search').val() == '') {
                $('#tag-content :last-child.span-one-tag').remove();
            }
        }
    }).on('focusout', function(){
        $('#tag-tip').hide();
    }).on('keyup', function(){
        var tagname = $('#tag-search').val();
        if (tagname != searchForTagname) {
            searchForTagname = tagname;
            $.ajax({
                type:'GET'
                ,url:apiSearchTag
                ,data: {tagname:tagname}
                ,dataType:'json'
                ,success:function(response) {
                    var tags = response.data;
                    if (tags.length > 0) {
                        var tiphtml = ['<ul class="tag-search-list">'];
                        var i=0;
                        for(var i= 0; i<tags.length; i++) {
                            tiphtml.push('<li data-id="'+tags[i]['id']+'">'+
                            tags[i]['tagname']+'</li>');
                        }
                        tiphtml.push('</ul>')
                        tiphtml = tiphtml.join('');
                        $('#tag-tip').html(tiphtml).show();
                        $('#tag-tip>ul>li:eq(0)').addClass('hover');
                    } else {
                        if ($('#tag-tip').html() != '') {
                            $('#tag-tip').html('');
                        }
                    }
                }
            });
        }
    });
    $('#tag-tip').on('mouseenter', '.tag-search-list li', function(){
        $(this).addClass('hover').siblings().removeClass('hover');
    });

    // 提示信息上下键功能
    function keychang(up) {
        var $list = $('.tag-search-list');
        var hover = $list.children('.hover'), index = hover.index();
        if (up == "up") {
            if (index == 0) {
                hover.removeClass('hover');
                $list.children('li:last').addClass('hover');
            } else {
                hover.removeClass('hover').prev().addClass('hover');
            }
        } else {
            if (index == ($list.children('li').length - 1)) {
                hover.removeClass('hover');
                $list.children('li:first').addClass('hover');
            } else {
                hover.removeClass('hover').next().addClass('hover');
            }
        }
    }

    function checkTagname() {
        var tagname = $('.tag-search-list').children('.hover').text();
        var tagid = $('.tag-search-list').children('.hover').attr('data-id');
        $('#tag-content').append('<span class="span-one-tag">#'+
        tagname+'<input type="hidden" name="tag[]"
        value="'+tagid+'"><span>x</span></span>');
        $('#tag-search').val('');
    }

    $('#tag-content').on('click', '.span-one-tag span', function(){
        $(this).parent().remove();
    });
});
```
