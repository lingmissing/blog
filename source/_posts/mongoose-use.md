title: mongoose的用法
date: 2017-07-13 16:11:58
tags: [node, mongodb]
---
# schemas

允许使用的SchemaTypes

* `String`
* `Number`
* `Date`
* `Buffer`
* `Boolean`
* `Mixed`
* `ObjectId`
* `Array`

```javascript
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var blogSchema = new Schema({
  title:  String,
  author: String,
  body:   String,
  comments: [{ body: String, date: Date }],
  date: { type: Date, default: Date.now },
  hidden: Boolean,
  meta: {
    votes: Number,
    favs:  Number
  }
});
```
<!--more  -->
有效的选项:

* `autoIndex`
```javascript
var schema = new Schema({..}, { autoIndex: false });
```
* `capped`
* `collection`
默认情况下通过模型名称的utils.tocollectionname方法产生的集合名称。

```javascript
var dataSchema = new Schema({..}, { collection: 'data' });
```
* `emitIndexErrors`
* `id`
  ```javascript
  // disabled id
  var dataSchema = new Schema({..}, { id: false });
  ```
* `_id`
```javascript
// disabled _id
var dataSchema = new Schema({..}, { _id: false });
```
* `minimize`
* `read`
* `safe`
* `shardKey`
* `strict`
* `toJSON`
* `toObject`
* `typeKey`
* `validateBeforeSave`
* `versionKey`
* `skipVersioning`
* `timestamps`

## 创建模型

```javascript
var Blog = mongoose.model('Blog', blogSchema);
```

## 实例方法

模型的实例是文档（documents）

```javascript
// 在blogSchema添加一个内置方法
blogSchema.methods.findSimilarTitle = function(cb) {
  return this.model('Ling').find({ title: this.title }, cb);
};
```

现在我们所有的Ling的实例有一个findSimilarTitle方法可用。

```javascript
var Ling = new Blog({ title: 'aa' });

Ling.findSimilarTypes(function(err, data) {
  console.log(data);
});
```

## 静态方法

```javascript
blogSchema.statics.findByTitle = function(title, cb) {
  return this.find({ title: new RegExp(title, 'i') }, cb);
};
// 调用
Blog.findByName('aa', function(err, data) {
  console.log(data);
});
```
## 查询助手

为了形成链式查询，如下：

```javascript
blogSchema.query.byTitle = function(title) {
  return this.find({ title: new RegExp(title, 'i') });
};
// 调用
Blog.find().byTitle('aa').exec(function(err, data) {
  console.log(data);
});
```

# 创建colecction（表）

```javascript
var mongoose = require('mongoose')
var Schema = mongoose.Schema

var Todo = new Schema({
	content: {
		type: String, 
		required: true
	},
	date: {
		type: String, 
		required: true
	}
}, { collection: 'todo' })
// 创建一个模型
var Model = mongoose.model('TodoBox', TodoSchema)
```

# 新增数据
```javascript
var h = new Model({ content: 'hello' });
h.save(function (err) {
  if (err) return handleError(err);
  // saved!
})
```

或者

```javascript
Model.create({ content: 'hello' }, (err) => {
  if (err) {
    console.log(err)
  } else {
    // todo
  }
})
```
# 删除数据

```javascript
Model.remove({ content: 'hello' }, function (err, data){
  // todo
})
```
# 更新数据

```javascript
Model.update({ content: 'hello' }, { content: 'update info' }, options, callback)
```
- `$inc` 增减修改器,只对数字有效

```javascript
Model.update({ 'age': 22 }, {'$inc':{ 'age': 1 } }); // 执行后: age=23
```
- `$set` 指定一个键的值,这个键不存在就创建它.可以是任何MondoDB支持的类型

```javascript
Model.update({ 'age': 22 }, {'$set':{ 'age': 'haha' }}); // 执行后: age='haha'
```
- `$unset` 同上取反,删除一个键

```javascript
Model.update({'age':22}, {'$unset':{'age':'haha'} }); // 执行后: age键不存在
```

# 查找数据

* `find()`指定查询条件
* `limit(n)`指定查询结果数量（最多为n条）
* `skip(n)`指定查询偏移量（跳过前n条）
* `sort()`实现查询结果排序（1 升序,-1降序）
* `select()`返回需要的列
* `hint()`
* `asc()`
* `slaveOk(Bollean)`允许当前连接允许读操作在辅助成员上运行

```javascript
// With a JSON doc
Person.
  find({
    occupation: /host/,
    'name.last': 'Ghost',
    age: { $gt: 17, $lt: 66 },
    likes: { $in: ['vaporizing', 'talking'] }
  }).
  limit(10).
  sort({ occupation: -1 }).
  select({ name: 1, occupation: 1 }).
  exec(callback);

// Using query builder
Person.
  find({ occupation: /host/ }).
  where('name.last').equals('Ghost').
  where('age').gt(17).lt(66).
  where('likes').in(['vaporizing', 'talking']).
  limit(10).
  sort('-occupation').
  select('name occupation').
  exec(callback);
```

```javascript
Model.find(query, fields, options, callback) // fields 和 options 都是可选参数
```
案例：

```javascript
// 简单查询
Model.find({ 'category': 5 }, function (err, docs) {
    // docs 是查询的结果数组
});

// 只查询指定键的结果
Model.find({}, ['first', 'last'], function (err, docs) {
    // docs 此时只包含文档的部分键值(first, last)
})

// 只返回单个文档
Model.findOne({ age: 5}, function (err, doc){
    // doc 是单个文档
});

// 只接受id作为参数
Model.findById(obj._id, function (err, doc){
    // doc 是单个文档
});

// 返回符合条件的文档数
Model.count({ age: 5}, function (err, data){
    // todo
});
```
## js语法查询
用它可以执行任意javacript语句作为查询的一部分,如果回调函数返回 true 文档就作为结果的一部分返回。

```javascript
  find({"$where" : function(){
		for( var x in this ){
		 //这个函数中的 this 就是文档
		}
		
		if(this.x !== null && this.y !== null){
		    return this.x + this.y === 10 ? true : false;
		}else{
		    return true;
		}
  }}).exec(callback)
```
简易版
```javascript
find( {"$where" :  "this.x + this.y === 10" } ).exec(callback)
find( {"$where" : " function(){ return this.x + this.y ===10; } " } ).exec(callback)
```

## 条件查询

* `$lt` 小于
* `$lte` 小于等于
* `$gt` 大于
* `$gte` 大于等于
* `$ne` 不等于

```javascript
Model.find({'age':{ '$get':18 , '$lte':30 }}); // 查询 age 大于等于18并小于等于30的文档
```

## 或查询

* `$in` 一个键对应多个值
* `$nin` 同上取反, 一个键不对应指定值
* `$or` 多个条件匹配, 可以嵌套 $in 使用
* `$not` 同上取反, 查询与特定模式不匹配的文档

```javascript
Model.find({'age':{ '$in':[20,21,22.'haha']}}); // 查询 age等于20或21或21或'haha'的文档
Model.find({"$or" :  [ {'age':18} , {'name':'xueyou'}]}); // 查询 age等于18 或 name等于'xueyou' 的文档
```

## 类型查询
null 能匹配自身和不存在的值, 想要匹配键的值 为null, 就要通过 '$exists' 条件判定键值已经存在。

```javascript
Model.find('age' :  { '$in' : [null] , 'exists' : true  } ); // 查询 age值为null的文档
Model.find({name: {$exists: true}}, function(error,docs){
    //查询所有存在name属性的文档
});
Model.find({telephone: {$exists: false}}, function(error,docs){
    //查询所有不存在telephone属性的文档
});
```

## 正则表达式

```javascript
Model.find( {'name' : /joe/i } ) // 查询name为 joe 的文档, 并忽略大小写
Model.find( {'name' : /joe?/i } ) // 查询匹配各种大小写组合
var qs = 'search'
var reg = new RegExp(qs, 'i') // 不区分大小写
var data = {
    name: qs
}
Model.find(data)
```

## 查询数组

```javascript
 Model.find({'array':10} ); // 查询 array(数组类型)键中有10的文档,  array : [1,2,3,4,5,10]  会匹配到
 Model.find({'array[5]':10} ); // 查询 array(数组类型)键中下标5对应的值是10,  array : [1,2,3,4,5,10]  会匹配到
```
- `$all` 匹配数组中多个元素
```javascript
Model.find({'array':[5,10]} ); // 查询 匹配array数组中 既有5又有10的文档
```

- `$size`匹配数组长度
```javascript
Model.find({'array':{"$size" : 3} } ); // 查询 匹配array数组长度为3 的文档
```

- `$slice` 查询子集合返回
```javascript
Model.find({'array':{"$skice" : 10} } ); // 查询 匹配array数组的前10个元素
Model.find({'array':{"$skice" : [5,10] } } ); // 查询 匹配array数组的第5个到第10个元素
```

# 如何运行

```javascript
// app
const express = require('express')
const bodyParser = require('body-parser')
const routes = require('../routes')
const app = express()

var mongoose = require('mongoose')
mongoose.connect('mongodb://localhost:27017/todo')

app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true
  })
)

app.use('/', routes)

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS')
  res.setHeader(
    'Access-Control-Allow-Headers',
    'Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With'
  )
  next()
})

app.listen(7070, () => {
  console.log('server started at 7070...')
})

// route
var router = express.Router()
router.get('/getAllItems', (req, res, next) => {
	Todo.find().sort({'date': -1}).exec((err, todoList) => {
		if (err) {
			console.log(err);
		}else {
			res.json(todoList);
		}
	})
});

router.post('/', (req, res, next) => {
  //TODO
})

````