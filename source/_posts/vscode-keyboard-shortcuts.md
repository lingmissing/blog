title: vscode快捷键说明
date: 2017-06-07 17:09:30
tags: vscode
---
> 符号对照表

| 符号 |  名称    | 缩写  |
|-----|----------|------|
| ⌘   |  command | cmd  |
| ⌥   |  option  | opt  |
| ⇧   |  shift   | shft |
| ⌃   |  control | ctrl |

# 通用
|||
|------|------|
|⇧⌘P, F1  |显示命令板 |
|⌘P       |快速打开 |
|⇧⌘N      |新建新项目窗口 |
|⌘W       |关闭当前打开文件 |


# Basic editing
|||
|---|----|
|⌘X               | 移除光标所在行或者选中文案 |
|⌘C               | 复制选中文案 |
|⌥↓ / ⌥↑          | 向下/上移动光标所在行 |
|⇧⌥↓ / ⇧⌥↑        | 复制光标所在行到下/上方 |
|⇧⌘K              | 移除光标所在行 |
|⌘Enter / ⇧⌘Enter | 向下/上新增行 |
|⇧⌘\              | 新增窗口预览 |
|⌘] / ⌘[          | 缩进/减少缩进 |
|Home / End       | 到行首/行尾|
|⌘↑ / ⌘↓          | 到文件头/尾|
|⌘PgUp /⌘PgDown   |滚动至页面顶部/底部|
|⌘PgLeft /⌘PgRight   |滚动至行首/行尾|
|⇧⌘[ / ⇧⌘]        |Fold/unfold region|
|⌘K ⌘[ / ⌘K ⌘]    |Fold/unfold all subregions|
|⌘K ⌘0 / ⌘K ⌘J    |Fold/unfold all regions|
|⌘K ⌘C            |添加行注释|
|⌘K ⌘U            |移除行只是|
|⌘/               |来回切换行注释|
|⇧⌥A              |来回切换光标处插入行注释|
|⌥Z               |Toggle word wrap|

# 多光标处理选中

|||
|---|----|
|Alt+Click               |插入光标 |
|⌥⌘↑                     |向上插入光标 |
|⌥⌘↓                     |向下插入光标 |
|⌘U                      |回到上一个光标位置|
|⇧⌥I                     |在选中区域每行结尾插入光标|
|⌘I                      |选中当前光标所在行|
|⇧⌘L                     |选中所有当前选中的文案|
|⌘F2                     |Select all occurrences of current word |
|⌃⇧⌘→                    |Expand selection |
|⌃⇧⌘←                    |Shrink selection |
|Shift+Alt + drag mouse  | 列（框）选择 |
|⇧⌥⌘↑                    |Column (box) selection up |
|⇧⌥⌘↓                    |Column (box) selection down |
|⇧⌥⌘←                    |Column (box) selection left |
|⇧⌥⌘→                    |Column (box) selection right |
|⇧⌥⌘PgUp                 |向上定位光标|
|⇧⌥⌘PgDown               |Column (box) selection page down |


# Search and replace

|||
|---|----|
|⌘F        |查找 |
|⌥⌘F       |替换 |
|⌘G / ⇧⌘G  |Find next/previous |
|⌥Enter    |Select all occurrences of Find match |
|⌘D        | Add selection to next Find match |
|⌘K ⌘D     |Move last selection to next Find match |



# Rich languages editing

|||
|---|----|
| ⌃Space        | Trigger suggestion |
| ⇧⌘Space       | Trigger parameter hints |
| Tab           | Emmet expand abbreviation |
| ⇧⌥F           | Format document |
| ⌘K ⌘F         | Format selection |
| F12           | Go to Definition |
| ⌥F12          | Peek Definition |
| ⌘K F12        | Open Definition to the side |
| ⌘.            | Quick Fix |
| ⇧F12          | Show References |
| F2            | Rename Symbol |
| ⇧⌘. / ⇧⌘,     | Replace with next/previous value |
| ⌘K ⌘X         | Trim trailing whitespace |
| ⌘K M          | Change file language |


# Navigation

|||
|---|----|
| ⌘T        | Show all Symbols |
| ⌃G        | Go to Line... |
| ⌘P        | Go to File... |
| ⇧⌘O       | Go to Symbol... |
| ⇧⌘M       | Show Problems panel |
| F8 / ⇧F8  | Go to next/previous error or warning |
| ⌃⇧Tab     | Navigate editor group history |
| ⌃- / ⌃⇧-  | Go back/forward |
| ⌃⇧M       | Toggle Tab moves focus |



# Editor management
|||
|---|----|
| ⌘W               | Close editor |
| ⌘K               | F Close folder |
| ⌘\               | Split editor |
| ⌘1 / ⌘2 / ⌘3     | Focus into 1st, 2nd, 3rd editor group |
| ⌘K ⌘← / ⌘K ⌘→    | Focus into previous/next editor group |
| ⌘K ⇧⌘← / ⌘K ⇧⌘→  | Move editor left/right |
| ⌘K ← / ⌘K →      | Move active editor group |




# File management

|||
|---|----|
| ⌘N           | New File |
| ⌘O           | Open File... |
| ⌘S           | Save |
| ⇧⌘S          | Save As... |
| ⌥⌘S          | Save All |
| ⌘W           | Close |
| ⌘K ⌘W        | Close All |
| ⇧⌘T          | Reopen closed editor |
| ⌘K Enter     | Keep Open |
| ⌃Tab / ⌃⇧Tab | Open next / previous |
| ⌘K P         | Copy path of active file |
| ⌘K R         | Reveal active file in Explorer |
| ⌘K O         | Show active file in new window/instance |



# Display

|||
|---|----|
| ⌃⌘F       | 全屏切换 |
| ⌥⌘1       | Toggle editor layout |
| ⌘= / ⇧⌘-  | Zoom in/out |
| ⌘B        | 侧栏可见性|切换
| ⇧⌘E       | Show Explorer / Toggle focus |
| ⇧⌘F       | 跳转到搜索 |
| ⌃⇧G       | 跳转到git|
| ⇧⌘D       | Show Debug |
| ⇧⌘X       | Show Extensions |
| ⇧⌘H       | Replace in files |
| ⇧⌘J       | Toggle Search details |
| ⇧⌘C       | Open new command prompt/terminal |
| ⇧⌘U       | Show Output panel |
| ⇧⌘V       | Toggle Markdown preview |
| ⌘K V      | Open Markdown preview to the side |



# Debug

|||
|---|----|
| F9         | Toggle breakpoint |
| F5         | Start/Continue |
| F11 / ⇧F11 | Step into/ out |
| F10        | Step over |
| ⇧F5        | Stop |
| ⌘K ⌘I      | Show hover |


# Integrated terminal

|||
|---|----|
| ⌃`          | Show integrated terminal |
| ⌃⇧`         | Create new terminal |
| unassigned  | Copy selection |
| unassigned  | Paste into active terminal |
| ⌘↑          | Scroll up |
| ⌘↓          | Scroll down |
| PgUp        | Scroll page up |
| PgDown      | Scroll page down |
| ⌘Home       | Scroll to top |
| ⌘End        | Scroll to bottom |
