title: ES6实现内部类的写法
date: 2017-01-17 16:55:15
categories: [前端, ES6]
tags: [ES6, Class]
---
最近在把 `JIris` 移植到JS平台 `Iris.js` 的过程中不断的在Java和JS两种语言之间切换，ES6的 `Class` 某种程度来说可以写出更加优雅的代码，而不用去管背后的原型实现。但是不得不说有一个遗憾就是 ES6 虽然支持了静态方法，但是还不支持静态属性和静态类，于是仔细观察了下发现了几种ES6实现静态类的相对优雅的写法。
<!-- more -->
## 问题
简化一个Demo，先是 Java 的写法：  
** IrisValue.java **
``` Java
public class IrisValue {
    private int mValue;

    public IrisValue(int value) {
        this.mValue = value;
    }

    public int getValue() {
        return mValue;
    }

    public void setValue(int value) {
        mValue = value;
    }

    static public class Test {
        private int test = 0;

        public int getTest() {
            return test;
        }

        public void setTest(int value) {
            test = value;
        }
    }

    public static void main (String[] args) {
        IrisValue irisValue = new IrisValue(10);
        IrisValue irisValue2 = new IrisValue(10);

        irisValue.setValue(100);

        System.out.println(irisValue.getValue());
        System.out.println(irisValue2.getValue());

        Test testValue = new Test();
        Test testValue2 = new Test();

        System.out.println(testValue.getTest());
        System.out.println(testValue2.getTest());
        testValue.setTest(9);
        testValue2.setTest(99);
        System.out.println(testValue.getTest());
        System.out.println(testValue2.getTest());
    }

}
```
`Test` 是`IrisValue`类的静态方法，并不属于`IrisValue`的实例对象。上面代码执行结果是：
```
100
10
0
0
9
99
```

那么等同的JS代码应该怎么写呢？  
ES6的Class本质还是函数，所以有一个很容易想到的写法：
``` JavaScript
class IrisValue {
    constructor(value) {
        this.mValue = value;
    }

    get value() {
        return this.mValue;
    }

    set value(value) {
        this.mValue = value;
    }

}

class Test {
    constructor() {
        this.mTest = 0;
    }

    get test() {
        return this.mTest;
    }

    set test(value) {
        this.mTest = value;
    }
}

IrisValue.Test = Test;


let irisValue = new IrisValue(10);
let irisValue2 = new IrisValue(10);

irisValue.value = 100;

console.log(irisValue.value);
console.log(irisValue2.value);

let testValue = new IrisValue.Test();
let testValue2 = new IrisValue.Test();

console.log(testValue.test);
console.log(testValue2.test);
testValue.test = 9;
testValue2.test = 99;
console.log(testValue.test);
console.log(testValue2.test);
```
输出结果和上面Java（预想的）一样，静态属性目前也能这样实现。  

但是不要忘了`get/set`函数，所以应该有更加优雅的静态类和静态属性的写法：
``` JavaScript
class IrisValue {
    constructor(value) {
        this.mValue = value;
    }

    get value() {
        return this.mValue;
    }

    set value(value) {
        this.mValue = value;
    }

    static get Test() {
    		return Test;
    }

}

class Test {
    constructor() {
        this.mTest = 0;
    }

    get test() {
        return this.mTest;
    }

    set test(value) {
        this.mTest = value;
    }

}
```
其实我们还能再<del>优雅</del>一点～
``` JavaScript
class IrisValue {
    constructor(value) {
        this.mValue = value;
    }

    get value() {
        return this.mValue;
    }

    set value(value) {
        this.mValue = value;
    }

    static get Test() {
        return class Test {
            constructor() {
                this.mTest = 0;
            }

            get test() {
                return this.mTest;
            }

            set test(value) {
                this.mTest = value;
            }

        };
    }

}
```

其实上面的这些写法还是不够优雅，避免不了的牺牲了可读性。既然ES6已经引进了Class，期待以后能和Java一样去写静态类和静态属性。
