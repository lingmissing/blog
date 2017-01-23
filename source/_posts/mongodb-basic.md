title: mongodb基础命令
date: 2017-01-20 14:16:13
tags: mongodb
---

# 连接数据库

```bash
mongod
mongo
```
# 数据库操作

```bash
# 查看所有数据库
show dbs
# 查看当前使用的数据库
db.getName()
# 显示当前数据库下的集合
show collections
```
> 创建的数据库必须要插入数据才会显示其中

<!-- more -->

```bash
# 新增或切换数据库
use DATABASE_NAME
```
> 如果数据库不存在，则创建数据库，否则切换到指定数据库。

```bash
# 删除数据库，在当前数据库中删除
db.dropDatabase()
```

```bash
# 删除集合
db.collection.drop()
```

# 集合操作

> 以下collection代表集合，也就是mysql中的表。

## 添加数据

```bash
# 添加数据
db.collection.insert(document)
```
> 使用 insert() 或 save() 方法向集合中插入文档。如果集合不在该数据库中， MongoDB会自动创建该集合并插入文档。

```javascript
// 实例
db.col.insert({title: 'MongoDB 教程', 
  description: 'MongoDB 是一个 Nosql 数据库',
  tags: ['mongodb', 'database', 'NoSQL'],
  likes: 100
})
```

## 查找数据


```bash
# 查找数据
db.collection.find()
# 只返回一个文档
db.collection.findOne()
# 查找后格式化
db.collection.find().pretty()
```

### AND查找

```bash
db.col.find({key1:value1, key2:value2}).pretty()
```

### OR查找

```bash
db.col.find(
  {
      $or: [
      {key1: value1}, {key2:value2}
      ]
  }
).pretty()
```
### AND 和 OR 联合使用

```bash
db.col.find(
  {
    key1: value1, 
    $or: [
      {key1: value1}, {key2:value2}
    ]
  }
)
```
### 函数查找


```bash
# 读取指定数量的数据记录
db.collection.find().limit(NUMBER)
```

```bash
# skip()方法来跳过指定数量的数据
db.collection.find().limit(NUMBER).skip(NUMBER)
```

```bash
# 显示第二条数据
db.col.find({},{"title":1,_id:0}).limit(1).skip(1)
```

### 排序查找

sort()方法可以通过参数指定排序的字段，并使用 1 和 -1 来指定排序的方式，其中 1 为升序排列，而-1是用于降序排列。

```bash
db.collection.find().sort({key:1})
```

## 更新数据

```bash
# 更新集合
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
```

- `query` : update的查询条件，类似sql update查询内where后面的。
- `update` : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
- `upsert` : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
- `multi` : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。
- `writeConcern` :可选，抛出异常的级别。

如上插入数据做更新处理：

```javascript
// 修改单条
db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}})
// 修改多条
db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}},{multi:true})
```

```bash
# save() 方法通过传入的文档来替换已有文档
db.collection.save(
   <document>,
   {
     writeConcern: <document>
   }
)
```

- `document` : 文档数据。
- `writeConcern` :可选，抛出异常的级别。

## 删除数据

```bash
db.collection.remove(
   <query>,
   {
     justOne: <boolean>,
     writeConcern: <document>
   }
)
```

- `query` :（可选）删除的文档的条件。
- `justOne` : （可选）如果设为 true 或 1，则只删除一个文档。
- `writeConcern` :（可选）抛出异常的级别。


```bash
# 删除第一条
db.collection.remove(deletion_critria,1)
# 删除整个表的数据
db.col.remove({})
```

# 条件操作符

- (>) 大于 - $gt
- (<) 小于 - $lt
- (>=) 大于等于 - $gte
- (<= ) 小于等于 - $lte


```bash
db.col.find({"likes" : {$gt : 100}})
# 相当于
Select * from col where likes > 100
```

```bash
db.col.find({likes : {$lt :200, $gt : 100}})
# 相当于
Select * from col where likes>100 AND  likes<200
```

## $type操作符

|类型|数字|
|----|----|
|Double|1| 
|String|2| 
|Object|3| 
|Array|4| 
|Binary data|5| 
|Object id|7| 
|Boolean|8| 
|Date|9| 
|Null|10| 
|Regular Expression|11| 
|JavaScript|13| 
|Symbol|14| 
|JavaScript (with scope)|15| 
|32-bit integer|16| 
|Timestamp|17| 
|64-bit integer|18| 
|Min key|255|
|Max key|127|

```bash
# 找到key为string的数据
db.col.find({key : {$type : 2}})
```

# 创建索引

MongoDB使用 ensureIndex() 方法来创建索引。

```bash
# 创建单个索引
db.collection.ensureIndex({key:1})
# 创建多个索引
db.collection.ensureIndex({key1:1,key2,-1})
```
> Key 值为你要创建的索引字段，1为指定按升序创建索引，如果你想按降序来创建索引指定为-1即可。


|可选参数	|类型	|描述|
|-----|-----|------|
|background	|Boolean	|建索引过程会阻塞其它数据库操作，background可指定以后台方式创建索引，即增加 "background" 可选参数。 "background" 默认值为false。|
|unique|	Boolean	|建立的索引是否唯一。指定为true创建唯一索引。默认值为false.|
|name	|string	|索引的名称。如果未指定，MongoDB的通过连接索引的字段名和排序顺序生成一个索引名称。|
|dropDups|	Boolean	|在建立唯一索引时是否删除重复记录,指定 true 创建唯一索引。默认值为 false.|
|sparse|	Boolean	|对文档中不存在的字段数据不启用索引；这个参数需要特别注意，如果设置为true的话，在索引字段中不会查询出不包含对应字段的文档.。默认值为 false.|
|expireAfterSeconds|	integer|	指定一个以秒为单位的数值，完成 TTL设定，设定集合的生存时间。|
|v	|index version	|索引的版本号。默认的索引版本取决于mongod创建索引时运行的版本。|
|weights|	document	|索引权重值，数值在 1 到 99,999 之间，表示该索引相对于其他索引字段的得分权重。|
|default_language	|string|	对于文本索引，该参数决定了停用词及词干和词器的规则的列表。 默认为英语|
|language_override	|string|	对于文本索引，该参数指定了包含在文档中的字段名，语言覆盖默认的language，默认值为 language.|


```bash
db.values.ensureIndex({open: 1, close: 1}, {background: true})
```
# 聚合

聚合(aggregate)主要用于处理数据(诸如统计平均值,求和等)，并返回计算后的数据结果。

```bash
db.collection.aggregate(AGGREGATE_OPERATION)
```
聚合框架中常用的几个操作：

- `$project`：修改输入文档的结构。可以用来重命名、增加或删除域，也可以用于创建计算结果以及嵌套文档。
- `$match`：用于过滤数据，只输出符合条件的文档。$match使用MongoDB的标准查询操作。
- `$limit`：用来限制MongoDB聚合管道返回的文档数。
- `$skip`：在聚合管道中跳过指定数量的文档，并返回余下的文档。
- `$unwind`：将文档中的某一个数组类型字段拆分成多条，每条包含数组中的一个值。
- `$group`：将集合中的文档分组，可用于统计结果。
- `$sort`：将输入文档排序后输出。
- `$geoNear`：输出接近某一地理位置的有序文档。


```bash
# 获取分数大于70小于或等于90记录,然后到下一步
db.articles.aggregate([
  { $match : { score : { $gt : 70, $lte : 90 } } },
  { $group: { _id: null, count: { $sum: 1 } } }
])
```

```bash
# 结果中就只还有_id,tilte和author三个字段
db.article.aggregate(
  { $project : {
      title : 1 ,
      author : 1 ,
  }}
)
```

```bash
# 过滤前5个文档
db.article.aggregate({ $skip : 5 })
```

```bash
db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : 1}}}])
# 类似于
select by_user, count(*) from mycol group by by_user
```

|表达式	|描述	|实例|
|----|-----|------|
|$sum	|计算总和。|	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : "$likes"}}}])|
|$avg	|计算平均值	|db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$avg : "$likes"}}}])|
|$min	|获取集合中所有文档对应值得最小值。	|db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$min : "$likes"}}}])|
|$max	|获取集合中所有文档对应值得最大值。|	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$max : "$likes"}}}])|
|$push	|在结果文档中插入值到一个数组中。|	db.mycol.aggregate([{$group : {_id : "$by_user", url : {$push: "$url"}}}])|
|$addToSet	|在结果文档中插入值到一个数组中，但不创建副本。|	db.mycol.aggregate([{$group : {_id : "$by_user", url : {$addToSet : "$url"}}}])|
|$first	|根据资源文档的排序获取第一个文档数据。|	db.mycol.aggregate([{$group : {_id : "$by_user", first_url : {$first : "$url"}}}])|
|$last	|根据资源文档的排序获取最后一个文档数据	|db.mycol.aggregate([{$group : {_id : "$by_user", last_url : {$last : "$url"}}}])|