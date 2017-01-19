title: shell脚本基础知识
date: 2017-01-19 11:37:06
tags: [shell]
---


# mac终端下运行shell脚本
 
- 写好自己的脚本，比如`aa.sh`
- 打开终端执行
  - 方法一：输入命令`./aa.sh`
  - 方法二：直接把`aa.sh`拖入到终端里面
 
注意事项：

- 如果没有成功报出问题：

  ```bash
  # Permission denied
  没有权限
  ```
 
- 解决办法： 
  修改该文件`aa.sh`的权限：

  ```bash
  chmod 777 aa.sh
  ```
  然后再执行上面第二步的操作。

# 变量
<!-- more -->

## 定义变量

```bash
# 变量名不加美元符号
your_name="elaine"
# 重新定义
your_name="newname"
```
- 首个字符必须为字母（a-z，A-Z）。
- 中间不能有空格，可以使用下划线（_）。
- 不能使用标点符号。
- 不能使用bash里的关键字（可用help命令查看保留关键字）。

### 只读变量

```bash
#!/bin/bash
myUrl="http://lingmissing.github.io"
readonly myUrl
myUrl="http://www.google.com"
```
运行脚本，结果如下：

```bash
/bin/sh: NAME: This variable is read only.
```

## 使用变量

```bash
your_name="qinjx"
echo $your_name
echo ${your_name}
echo "your name is ${your_name}-l"
```
> 变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界。

## 删除变量

```bash
unset variable_name
```
> 变量被删除后不能再次使用。`unset` 命令不能删除只读变量。

```bash
#!/bin/sh
myUrl="http://lingmissing.github.io"
unset myUrl
echo $myUrl
```

## 变量类型

- 局部变量：局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量。
- 环境变量：所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
- shell变量：shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行。

# 字符串

## 单引号

```bash
str='this is a string'
```
- 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的
- 单引号字串中不能出现单引号（对单引号使用转义符后也不行）
## 双引号

```bash
your_name='qinjx'
str="Hello, I know your are \"$your_name\"! \n"
```
- 双引号里可以有变量
- 双引号里可以出现转义字符

## 拼接字符串

```bash
your_name="qinjx"
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting $greeting_1
```
## 获取字符串长度

```bash
string="abcd"
echo ${#string} #输出 4
```

## 提取子字符串

以下实例从字符串第 2 个字符开始截取 4 个字符：

```bash
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```
## 查找子字符串

查找字符 "i 或 s" 的位置：

```bash
string="runoob is a great company"
echo `expr index "$string" is`  # 输出 8
```

# 数组

> bash支持一维数组（不支持多维数组），并且没有限定数组的大小。

## 定义数组

```bash
# 格式：数组名=(值1 值2 ... 值n)
array_name=(value0 value1 value2 value3)
# or 
array_name=(
value0
value1
value2
value3
)
# or
array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen
```

## 读取数组

```bash
# 格式：${数组名[下标]}
valuen=${array_name[n]}
# 使用@符号可以获取数组中的所有元素
echo ${array_name[@]}
```

## 获取数组的长度

```bash
# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
lengthn=${#array_name[n]}
```

# 注释

> 以"#"开头的行就是注释，会被解释器忽略。

```bash
#--------------------------------------------
# 这是一个注释
# author：elaine
# site：lingmissing.github.io
# slogan：学的不仅是技术，更是梦想！
#--------------------------------------------
##### 用户配置区 开始 #####
#
#
# 这里可以添加脚本描述信息
# 
#
##### 用户配置区 结束  #####
```

# 参数传递

> 脚本内获取参数的格式为：$n。n 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推……

```bash
echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
```
执行

```bash
$ ./test.sh 1 2 3
# print
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```

|参数处理	|说明|
|------|-------|
|$#	|传递到脚本的**参数个数**|
|$*	|以一个单**字符串**显示所有向脚本传递的参数。如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。|
|$$	|脚本运行的当前进程ID号|
|$!	|后台运行的最后一个进程的ID号|
|$@	|与$*相同，但是使用时加引号，并在引号中返回每个参数。如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。|
|$-	|显示Shell使用的当前选项，与set命令功能相同。|
|$?	|显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。|

# 基本运算

- 算数运算符
- 关系运算符
- 布尔运算符
- 字符串运算符
- 文件测试运算符

> expr 是一款表达式计算工具，使用它能完成表达式的求值操作。

```bash
#!/bin/bash
val=`expr 2 + 2`
echo "两数之和为 : $val"
```
执行脚本，输出结果为

```bash
两数之和为 : 4
```

注意：
- 表达式和运算符之间要有空格
- 完整的表达式要被 ` ` 包含，注意这个字符不是常用的单引号

## 算术运算符

|运算符	|说明|	举例|
|------|------|-------|
|+	|加法	|\`expr $a + $b\`|
|-	|减法	|\`expr $a - $b\`|
|*	|乘法|	\`expr $a \* $b\`|
|/	|除法	|\`expr $b / $a\`|
|%	|取余	|\`expr $b % $a\`|
|=	|赋值	|a=$b|
|==	|等于	|[ $a == $b ] |
|!=	| 不等于 |[ $a != $b ]|

```bash
#!/bin/sh

a=10
b=20

val=`expr $a + $b`
echo "a + b : $val"

val=`expr $a - $b`
echo "a - b : $val"

val=`expr $a \* $b`
echo "a * b : $val"

val=`expr $b / $a`
echo "b / a : $val"

val=`expr $b % $a`
echo "b % a : $val"

if [ $a == $b ]
then
   echo "a 等于 b"
fi
if [ $a != $b ]
then
   echo "a 不等于 b"
fi
```

执行后输出

```bash
a + b : 30
a - b : -10
a * b : 200
b / a : 2
b % a : 0
a 不等于 b
```

- 乘号(*)前边必须加反斜杠(\)才能实现乘法运算；
- if...then...fi 是条件语句，后续将会讲解。
- 在 MAC 中 shell 的 expr 语法是：$((表达式))，此处表达式中的 "*" 不需要转义符号 "\" 。

## 关系运算符

|运算符	|说明|	举例|
|------|------|-------|
|-eq	|检测两个数是否相等，相等返回 true。	|[ $a -eq $b ] |
|-ne	|检测两个数是否相等，不相等返回 true。	|[ $a -ne $b ] |
|-gt	|检测左边的数是否大于右边的，如果是，则返回 true。	|[ $a -gt $b ] |
|-lt	|检测左边的数是否小于右边的，如果是，则返回 true。	|[ $a -lt $b ] |
|-ge	|检测左边的数是否大于等于右边的，如果是，则返回 true。	|[ $a -ge $b ] |
|-le	|检测左边的数是否小于等于右边的，如果是，则返回 true。	|[ $a -le $b ] |

## 布尔运算符

|运算符	|说明|	举例|
|------|------|-------|
| !	| 非运算 | [ ! false ] |
| -o	| 或运算 | [ $a -lt 20 -o $b -gt 100 ] |
| -a	| 与运算 | [ $a -lt 20 -a $b -gt 100 ] |

## 逻辑运算符

> 由于在markdown中||被识别成表格分割，在此以O代替。

|运算符	|说明	|举例|
|-------|------|-----|
| && | 逻辑的 AND | [[ $a -lt 100 && $b -gt 100 ]] |
| O | 逻辑的 OR | [[ $a -lt 100 O $b -gt 100 ]]  |

## 字符串运算符

|运算符	|说明	|举例|
|-------|------|-----|
|=	|检测两个字符串是否相等，相等返回 true。	|[ $a = $b ] |
|!=	|检测两个字符串是否相等，不相等返回 true。	|[ $a != $b ] |
|-z	|检测字符串长度是否为0，为0返回 true。|	[ -z $a ] |
|-n	|检测字符串长度是否为0，不为0返回 true。	|[ -n $a ] |
|str|检测字符串是否为空，不为空返回 true。	|[ $a ] |


## 文件测试运算符

|运算符	|说明	|举例|
|-------|------|-----|
|  -b file	| 检测文件是否是块设备文件，如果是，则返回 true。	| [ -b $file ] |
|  -c file	| 检测文件是否是字符设备文件，如果是，则返回 true。	| [ -c $file ] |
|  -d file	| 检测文件是否是目录，如果是，则返回 true。	| [ -d $file ] |
|  -f file	| 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。	| [ -f $file ] |
|  -g file	| 检测文件是否设置了 SGID 位，如果是，则返回 true。	| [ -g $file ] |
|  -k file	| 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。	| [ -k $file ] |
|  -p file	| 检测文件是否是有名管道，如果是，则返回 true。	| [ -p $file ] |
|  -u file	| 检测文件是否设置了 SUID 位，如果是，则返回 true。	| [ -u $file ] |
|  -r file	| 检测文件是否可读，如果是，则返回 true。	| [ -r $file ] |
|  -w file	| 检测文件是否可写，如果是，则返回 true。	| [ -w $file ] |
|  -x file	| 检测文件是否可执行，如果是，则返回 true。	| [ -x $file ] |
|  -s file	| 检测文件是否为空（文件大小是否大于0），不为空返回 true。	| [ -s $file ] |
|  -e file	| 检测文件（包括目录）是否存在，如果是，则返回 true。	| [ -e $file ] |

```bash
#!/bin/sh
file="/var/www/runoob/test.sh"
if [ -r $file ]
then
   echo "文件可读"
else
   echo "文件不可读"
fi
if [ -w $file ]
then
   echo "文件可写"
else
   echo "文件不可写"
fi
if [ -x $file ]
then
   echo "文件可执行"
else
   echo "文件不可执行"
fi
if [ -f $file ]
then
   echo "文件为普通文件"
else
   echo "文件为特殊文件"
fi
if [ -d $file ]
then
   echo "文件是个目录"
else
   echo "文件不是个目录"
fi
if [ -s $file ]
then
   echo "文件不为空"
else
   echo "文件为空"
fi
if [ -e $file ]
then
   echo "文件存在"
else
   echo "文件不存在"
fi
```

执行脚本，输出结果如下所示：

```bash
文件可读
文件可写
文件可执行
文件为普通文件
文件不是个目录
文件不为空
文件存在
```

# echo命令

- 显示普通字符串:

  ```bash
  echo "It is a test"
  # or
  echo It is a test
  ```
- 显示转义字符

  ```bash
  echo "\"It is a test\""
  ```
- 显示变量

  ```bash
  echo "$name It is a test"
  ```
- 显示换行

  ```bash
  echo -e "OK! \n" # -e 开启转义
  ```
- 显示不换行

  ```bash
  echo -e "OK! \c" # -e 开启转义 \c 不换行
  ```
- 原样输出字符串

  ```bash
  echo '$name\"'
  ```

- 显示执行结果

  ```bash
  echo `date`
  ```

# printf 命令

```bash
printf  format-string  [arguments...]
```
参数说明：
- format-string: 为格式控制字符串
- arguments: 为参数列表。

> 默认printf不会像 echo 自动添加换行符，我们可以手动添加 \n。

```bash
$ echo "Hello, Shell"
Hello, Shell
$ printf "Hello, Shell\n"
Hello, Shell
$
```


|转义序列	| 说明 |
|------|-----|
| \a	| 警告字符，通常为ASCII的BEL字符 |
| \b	| 后退 |
| \c	| 抑制（不显示）输出结果中任何结尾的换行字符（只在%b格式指示符控制下的参数字符串中有效），而且，任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符，都被忽略 |
| \f	| 换页（formfeed） | 
| \n	| 换行 | 
| \r	| 回车（Carriage return） | 
| \t	| 水平制表符 | 
| \v	| 垂直制表符 | 
| \\	| 一个字面上的反斜杠字符 | 
| \ddd	| 表示1到3位数八进制值的字符。仅在格式字符串中有效 | 
| \0ddd	| 表示1到3位的八进制值字符 | 


```bash
#!/bin/sh
printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543 
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876 
```
执行脚本，输出结果如下所示：

```bash
姓名     性别   体重kg
郭靖     男      66.12
杨过     男      48.65
郭芙     女      47.99
```

%s %c %d %f都是格式替代符
%-10s 指一个宽度为10个字符（-表示左对齐，没有则表示右对齐），任何字符都会被显示在10个字符宽的字符内，如果不足则自动以空格填充，超过也会将内容全部显示出来。
%-4.2f 指格式化为小数，其中.2指保留2位小数。

# test命令

```bash
num1=100
num2=100
if test $[num1] -eq $[num2]
then
    echo '两个数相等！'
else
    echo '两个数不相等！'
fi
```

# 流程控制


## if语句

```bash
# if
if condition
then
    command1 
    command2
    ...
    commandN 
fi
# or 
if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi
```

```bash
# if else 
if condition
then
    command1 
    command2
    ...
    commandN
else
    command
fi
```

```bash
# if else-if else
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi
```

## for循环

```bash
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
# or
for var in item1 item2 ... itemN; do command1; command2… done;
```
例如

```bash
# 循环数字
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```

```bash
# 循环字符串
for str in 'This is a string'
do
    echo $str
done
```

## while语句
> while循环执行一系列命令直至条件为假时停止。

```bash
while condition
do
    command
done
```

```bash
# 案例
#!/bin/sh
int=1
while(( $int<=5 ))
do
        echo $int
        let "int++"
done
```

## until 循环

> until循环执行一系列命令直至条件为真时停止。

```bash
until condition
do
    command
done
```

## case语句

```bash
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2）
    command1
    command2
    ...
    commandN
    ;;
esac
```

```bash
#!/bin/sh
echo '输入 1 到 4 之间的数字:'
echo '你输入的数字为:'
read aNum
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac
```

## break

> break命令允许跳出所有循环（终止执行后面的所有循环）。

```bash
#!/bin/sh
while :
do
    echo -n "输入 1 到 5 之间的数字:"
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的! 游戏结束"
            break
        ;;
    esac
done
```

## continue

> continue命令与break命令类似，只有一点差别，它不会跳出所有循环，仅仅跳出当前循环。

```bash
#!/bin/sh
while :
do
    echo -n "输入 1 到 5 之间的数字: "
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的!"
            continue
            echo "游戏结束"
        ;;
    esac
done
```

## esac

case语法需要一个esac（就是case反过来）作为结束标记，每个case分支用右圆括号，用两个分号表示break。

# 函数

```bash
[ function ] funname [()]

{

    action;

    [return int;]

}
```

```bash
#!/bin/sh
demoFun(){
    echo "这是我的第一个 shell 函数!"
}
echo "-----函数开始执行-----"
demoFun
echo "-----函数执行完毕-----"
```

```bash
#!/bin/bash
funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !"
```

## 函数参数

```bash
funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73
```


# 常用系统自带命令

- mkdir 创建文件夹
- touch 创建文件
- mvdir 移动或重命名目录
- zip  压缩文件

  ```bash
  zip -q -r -e -m -o [yourName].zip someThing
  ```
  -q 表示不显示压缩进度状态
  -r 表示子目录子文件全部压缩为zip  //这部比较重要，不然的话只有something这个文件夹被压缩，里面的没有被压缩进去
  -e 表示你的压缩文件需要加密，终端会提示你输入密码的
  -m 表示压缩完删除原文件
  -o 表示设置所有被压缩文件的最后修改时间为当前压缩时间

> 结合系统自带的命令

```bash
#!/bin/sh
mkdir shell_tut
cd shell_tut

for ((i=0; i<10; i++)); do
    touch test_$i.txt
done
```


