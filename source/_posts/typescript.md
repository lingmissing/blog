---
title: typescript
date: 2016-09-30 13:30:47
tags: [javascript,typescript]
categories: 代码如诗，前端如画
---

## 基础类型
为了让程序有价值，我们需要能够处理最简单的数据单元：数字，字符串，结构体，布尔值等。
### boolean
```javascript
let isDone: boolean = false;
```
### number
```javascript
let decLiteral: number = 6;
let hexLiteral: number = 0xf00d;
let binaryLiteral: number = 0b1010;
let octalLiteral: number = 0o744;
```
<!-- more -->

### string
```javascript
let name: string = "bob";
name = "smith";
```
当然也可以用模板字符串：
```javascript
let name: string = `Gene`;
let age: number = 37;
let sentence: string = `Hello, my name is ${ name }.I'll be ${ age + 1 } years old next month.`;
```
### array
- 在元素类型后面接上 []，表示由此类型元素组成的一个数组：
  ```javascript
  let list: number[] = [1, 2, 3];
  ```
- 使用数组泛型，Array<元素类型>：
  ```javascript
  let list: Array<number> = [1, 2, 3];
  ```
### 元组 Tuple
元组类型允许表示一个**已知**元素**数量**和**类型**的数组，各元素的类型不必相同。 
```javascript
// Declare a tuple type
let x: [string, number];
// Initialize it
x = ['hello', 10]; // OK
// Initialize it incorrectly
x = [10, 'hello']; // Error
```
打印出来的结果：
```javascript
console.log(x[0].substr(1)); // OK
console.log(x[1].substr(1)); // Error, 'number' does not have 'substr'
```
### 枚举
像C#等其它语言一样，使用枚举类型可以为一组数值赋予友好的名字。
```javascript
enum Color {Red, Green, Blue};
let c: Color = Color.Green;
```
默认情况下，从0开始为元素编号。 你也可以手动的指定成员的数值。 例如，我们将上面的例子改成从 1开始编号：
```javascript
enum Color {Red = 1, Green, Blue};
let c: Color = Color.Green;
```
或者全部手动赋值：
```javascript
enum Color {Red = 1, Green = 2, Blue = 4};
let c: Color = Color.Green;
```
枚举类型提供的一个便利是你可以由枚举的值得到它的名字。 例如，我们知道数值为2，但是不确定它映射到Color里的哪个名字，我们可以查找相应的名字：
```javascript
enum Color {Red = 1, Green, Blue};
let colorName: string = Color[2];

alert(colorName);
```
### 任意值
```javascript
let notSure: any = 4;
notSure = "maybe a string instead";
notSure = false; // okay, definitely a boolean
```
### 空值
某种程度上来说，void类型像是与any类型相反，它表示没有任何类型。 当一个函数没有返回值时，你通常会见到其返回值类型是 void：
```javascript
function warnUser(): void {
    alert("This is my warning message");
}
```
### Null 和 Undefined
```javascript
// Not much else we can assign to these variables!
let u: undefined = undefined;
let n: null = null;
```
### 类型断言
类型断言好比其它语言里的类型转换，但是不进行特殊的数据检查和解构。 它没有运行时的影响，只是在编译阶段起作用。
- “尖括号”语法：
  ```javascript
  let someValue: any = "this is a string";
  let strLength: number = (<string>someValue).length;
  ```
- as语法
  ```javascript
  let someValue: any = "this is a string";
  let strLength: number = (someValue as string).length;
  ```
## 变量声明
### var声明
```javascript
function f() {
    var a = 10;
    return function g() {
        var b = a + 1;
        return b;
    }
}

var g = f();
g(); // returns 11;
```
### let声明
### const声明
const拥有与 let相同的作用域规则，但是不能对它们重新赋值。
```javascript
const numLivesForCat = 9;
const kitty = {
    name: "Aurora",
    numLives: numLivesForCat,
}

// Error
kitty = {
    name: "Danielle",
    numLives: numLivesForCat
};

// all "okay"
kitty.name = "Rory";
kitty.name = "Kitty";
kitty.name = "Cat";
kitty.numLives--;
```
### let vs. const
使用最小特权原则，所有变量除了你计划去修改的都应该使用const。 基本原则就是如果一个变量不需要对它写入，那么其它使用这些代码的人也不能够写入它们，并且要思考为什么会需要对这些变量重新赋值。 使用 const也可以让我们更容易的推测数据的流动。
## 接口
### 接口初探
```javascript
function printLabel(labelledObj: { label: string }) {
  console.log(labelledObj.label);
}

let myObj = { size: 10, label: "Size 10 Object" };
printLabel(myObj);
```
类型检查器会查看printLabel的调用。 printLabel有一个参数，并要求这个对象参数有一个名为label类型为string的属性。
下面我们重写上面的例子，这次使用接口来描述：必须包含一个label属性且类型为string：
```javascript
// 定义接口
interface LabelledValue {
  label: string;
}

function printLabel(labelledObj: LabelledValue) {
  console.log(labelledObj.label);
}

let myObj = {size: 10, label: "Size 10 Object"};
printLabel(myObj);
```
LabelledValue接口就好比一个名字，用来描述上面例子里的要求。 它代表了有一个 label属性且类型为string的对象。 
### 可选属性
```javascript
interface SquareConfig {
  color?: string;
  width?: number;
}

function createSquare(config: SquareConfig): {color: string; area: number} {
  let newSquare = {color: "white", area: 100};
  if (config.color) {
    newSquare.color = config.color;
  }
  if (config.width) {
    newSquare.area = config.width * config.width;
  }
  return newSquare;
}

let mySquare = createSquare({color: "black"});
```
带有可选属性的接口与普通的接口定义差不多，只是在可选属性名字定义的后面加一个?符号。
### 只读属性
一些对象属性只能在对象刚刚创建的时候修改其值。 你可以在属性名前用 readonly来指定只读属性:
```javascript
interface Point {
    readonly x: number;
    readonly y: number;
}
```
你可以通过赋值一个对象字面量来构造一个Point。 赋值后， x和y再也不能被改变了。
```javascript
let p1: Point = { x: 10, y: 20 };
p1.x = 5; // error!
```
TypeScript具有ReadonlyArray<T>类型，它与Array<T>相似，只是把怕有可变方法去掉了，因此可以确保数组创建后再也不能被修改：
```javascript
let a: number[] = [1, 2, 3, 4];
let ro: ReadonlyArray<number> = a;
ro[0] = 12; // error!
ro.push(5); // error!
ro.length = 100; // error!
a = ro; // error!
```
就算使用赋值也不可以，除非使用类型断言重写：
```javascript
a = ro as number[];
```
#### readonly vs const

最简单判断该用readonly还是const的方法是看要把它做为变量使用还是做为一个属性。 做为变量使用的话用 const，若做为属性则使用readonly。
### 函数类型
## 类
