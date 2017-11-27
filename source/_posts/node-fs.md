title: NODE文件处理
date: 2017-10-19 16:55:53
tags: [node,fs]
---

# 基本概念

- 所有文件路径均可以是绝对路径或者相对路径 
- 所有函数都具有同步函数，没有`callback` 
- `filname` 读取文件的路径，可以是绝对路径，也可以是相对路径 
- `flag` 文件读写模式对应编码

| Flag | 描述 |
| ----- | ----- |
| `r`	  | 以读取模式打开文件。如果文件不存在抛出异常。|
| `r+`  |	以读写模式打开文件。如果文件不存在抛出异常。|
| `rs`  | 以同步的方式读取文件。|
| `rs+`	| 以同步的方式读取和写入文件。|
| `w`	  | 以写入模式打开文件，如果文件不存在则创建。|
| `wx ` |	类似 `w`，但是如果文件路径存在，则文件写入失败。|
| `w+`  |	以读写模式打开文件，如果文件不存在则创建。|
| `wx+`	| 类似 `w+`， 但是如果文件路径存在，则文件读写失败。|
| `a`	  | 以追加模式打开文件，如果文件不存在则创建。|
| `ax`	| 类似 `a`， 但是如果文件路径存在，则文件追加失败。|
| `a+`	| 以读取追加模式打开文件，如果文件不存在则创建。|
| `ax+`	| 类似 `a+`， 但是如果文件路径存在，则文件读取追加失败 |

- `mode` 读写权限
第一个数字必须是0，表示该数据是一个八进制的数字。
第二个数字，用于规定文件或者目录所有者的权限。
第三个数字，用于规定文件或者目录所有者所属用户组的权限。
第四个数字，规定其他人的权限。
对于上述的第二，第三，第四个数字，读写权限的设置符合以下规则。
设置为1：表示为执行权限。
设置为2：表示有写权限。
设置为4：表示有毒权限。

> 多个权限需要对应权限数组相加

# path

文件路径大概有 __dirname, __filename, process.cwd(), ./ 或者 ../

- `__dirname` 总是返回被执行的 js 所在文件夹的绝对路径
- `__filename` 总是返回被执行的 js 的绝对路径
- `process.cwd()` 总是返回运行 node 命令时所在的文件夹的绝对路径

## 获取路径部分名称

- `path.dirname` 返回路径的所在的文件夹名称

```js
// 输出：/tmp/demo/js
console.log(path.dirname('/tmp/demo/js/test.js'))
```

- `path.basename` 返回指定的文件名，返回结果可排除[ext]后缀字符串 

```js
// 输出：test.js
console.log(path.basename('/tmp/demo/js/test.js'))
// 输出：test
console.log(path.basename('/tmp/demo/js/test'))
// 输出：test
console.log(path.basename('/tmp/demo/js/test.js', '.js'))
```

- `path.extname` 返回指定文件名的扩展名称 

```js
// 输出：.js
console.log(path.extname('/tmp/demo/js/test.js'))
```

## 路径组合


- `path.normalize` 将不符合规范的路径格式化

```js
path.normalize('/foo/bar//baz/asdf/quux/..');  
// returns   
'/foo/bar/baz/asdf' 
```
- `path.relative`  返回某个路径下相对于另一个路径的相对位置串

```js
path.relative('/data/orandea/test/aaa', '/data/orandea/impl/bbb')  
// returns  
'../../impl/bbb'  
```

- `path.join` 将所有名称用path.seq串联起来，然后用normailze格式化 

```js
// 输出 '/foo/bar/baz/asdf'
path.join('/foo', 'bar', 'baz/asdf')
```

- `path.resolve` 相当于不断的调用系统的cd命令 

```js
// cd /foo/bar
// cd ./baz
// 输出 /foo/bar/baz
console.log(path.resolve('/foo/bar', './baz'))
// 输出 /foo/bar/baz
console.log(path.resolve('/foo/bar', './baz/'))
// 输出 /tmp/file
console.log(path.resolve('/foo/bar', '/tmp/file/'))
```

# 常规函数

## open

```javascript
// 异步打开
fs.open(filename, flags, [mode], (err, fd) => {
  // fd返回的是一个文件的描述符，是一个数字 
})
// 同步打开文件 
var fs = openSync(filename, flags, [mode])
```


## close

```javascript
fs.open(filename, flags, [mode], (err, fd) => {
  // fd返回的是一个文件的描述符，是一个数字 
  fs.close(fd, err => {})
})
```
      
## truncate

> 文件句柄,截断长度,回调函数

```js
fs.ftruncate(fd, 10, err => {

})
```  
=============   

## exists

> 判断文件是否存在

```js
fs.exists(path, callback)
```

```js
const outputFolder = './test'
if (fs.existsSync(outputFolder)) {
  console.log('Removing ' + outputFolder)
  fs.rmdirSync(outputFolder)
} else {
  fs.mkdirSync(outputFolder)
}
```
## rename

> 新目录/文件的完整路径及名；如果新路径与原路径相同，而只文件名不同，则是重命名

```js
fs.rename(oldPath, newPath, callback);
```

```js
fs.rename('./renameFile1.txt', './renameFile.txt', function(err) {
  if (err) {
    console.error(err)
    return
  }
  console.log('重命名成功')
})
```

# 文件属性


```js
fs.stat(path,callback); 
//传入的参数是文件路径，和回调函数 
 
fs.lstat(path,callback); 
//传入的参数是目录的路径，和回调函数 
 
fs.fstat(fd,callback); 
//传入的参数是文件描述符，和回调函数 
//所以，该方法在readFile时，在open打开文件成功之后，才使用。 
 
callback(err,stats){ 
//回调函数的参数是相同的，第一个参数为错误对象，包含错误信息 
//第二个参数，也就是本篇文章的重点，为一个State对象的实例，包含对应文件的或者目录的相关信息 
} 
```


- `atime` 文件数据上次被访问的时间
- `mtime` 文件上次被修改的时间
- `ctime` 文件状态上次改变的时间
- `birthtime`  文件被创建的时间
- `stats.isFile()`	如果是文件返回 true，否则返回 false。
- `stats.isDirectory()`	如果是目录返回 true，否则返回 false。
- `stats.isBlockDevice()`	如果是块设备返回 true，否则返回 false。
- `stats.isCharacterDevice()`	如果是字符设备返回 true，否则返回 false。
- `stats.isSymbolicLink()`     	如果是软链接返回 true，否则返回 false。
- `stats.isFIFO()   `	如果是FIFO，返回true，否则返回 false。FIFO是UNIX中的一种特殊类型的命令管道。
- `stats.isSocket()	`如果是 Socket 返回 true，否则返回 false。

# 读操作

## read 

```javascript
fs.read(fd, buffer, offset, length, position, callback)
``` 

- `fd` 文件描述符，是open方法的回调函数中获取到的，是一个数字。
- `buffer` buffer对象，用于指定将文件数据读取到那个缓存区，如果不定义，则会生成一个新的缓存区，进行存放新读取到的数据。
- `offset` 整数，用于指定向缓存区中写入数据时的开始位置，以字节为单位。其实也就是，读入到缓存中的数据，从buffer对象的第几个元素开始写入。
- `length` 整数，表示读入的数据，多少数据写入到buffer对象中去，要保证不能超出buffer的容纳范围，否则会抛出一个范围异常。
- `position` 整数值，表示，从文件中的哪个位置，开始读取数据，如果设置为非0的整数，则从该整数所示的位置，读取长度为length的数据到buffer对象中。 
- `callback` 三个参数 err,bytesRead,buffer
  - `err`为读取文件操作失败时，触发的错误对象 
  - `bytesRead`为读取到的字节数，如果文件的比较大，则该值就是length的值，如果文件的大小比length小，则该值为实际中读取到的字节数。 
  - `buffer`为读取到的内容，保存到了该缓存区，如果在使用read时，传入了buffer对象，则此处的buffer就是传入的buffer对象。 如果在read时没有传入buffer，则此处的buffer为新创建的buffer对象 


```javascript
fs.open('fs.txt', 'r', function(err, fd) {
  //读取fs.text，文件的内容为“123456789”，长度为9
  var buffer = new Buffer([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
  //创建一个长度为10，初始值为0的buffer对象。
  //数据比较少，就直接写了，否则还是使用fill方法吧。
  console.log(buffer)
  //<Buffer 00 00 00 00 00 00 00 00 00 00>
  //初始时的buffer对象

  fs.read(fd, buffer, 4, 6, 4, function(err, bytesRead, buffer1) {
    //读取到的数据，从buffer对象的第5个元素开始保存，保存6个字节的元素
    //读取文件，是从文件的第5个字节开始，因为文件中内容长度为9，
    //那么，读取到的内容就是56789，所以buffer的最后一位仍然为初始值。
    //由于想要读取的字节长度为6，但是文件内容过短，只读取了5个字节的有效数据
    //就到了文件的结尾了，所以，bytesRead的值不是6，而是5。
    //而buffer对象，为被写入新数据之后的对象。
    console.log(bytesRead) //5
    console.log(buffer1)
    //<Buffer 00 00 00 00 35 36 37 38 39 00>
    console.log(buffer)
    //<Buffer 00 00 00 00 35 36 37 38 39 00>
    //它们俩是完全相同的。其实质是，它们俩占据的内存也是相同的，
    //它们就是同一个缓存区。
  })
})
```


## readFile

> read方法,使用来读取已经打开后的文件。 他不用用来进行打开文件操作

```javascript
fs.readFile(fileName,[options],(err,data) => {
  // data为读取成功时，返回的读取信息，该信息的返回格式，是由options对象中的encoding决定 
})
```

[options]

- `encoding`表示读取文件成功后，返回的数据的编码格式，默认返回格式为buffer对象
- `flag`的值表示是如何读取文件的，支持的参数，与使用fs.open时相同，通常为r，r+着两种方式。

```javascript
fs.readFile('test.js', 'utf-8', (err,data) => { 
 if (err) { 
  console.log('readFile file error') 
  return false
 } 
 console.log(data)
})
```

## readdir

```js
fs.readdir(path, (err, files) => {
  // files 为 目录下的文件数组列表。
})
```

```js
fs.readdir('./testDir', (err, files) => {
  if (err) {
    console.log(err)
    return
  }
  console.log('files', files)
  var count = files.length
  var results = {}
  files.forEach(filename => {
    fs.readFile(`./testDir/${filename}`, 'utf8', (err, data) => {
      results[filename] = data
      count--
      if (count <= 0) {
        // 对所有文件进行处理
        console.log('result', results)
      }
    })
  })
})
```

# 写操作

## write

```js
// 写入Buffer数据
fs.write(fd, buffer, offset, length, position, callback)
// 写入str数据内容
fs.write(fd, data[, position[, encoding]], callback)
```     
```js
//使用Buffer写入
fs.open('sam.js', 'w+', (err, fd) => {
    var buf = new Buffer('sam', 'utf8')
    fs.write(fd, buf, 0, buf.length, 0, (err, bw, buf) => {
        fs.close(fd)
    })
})
//直接使用string写入
fs.open('sam.js', 'w+', (err, fd) => {
    fs.write(fd, 'sam', 'utf8', 0, (err, bw, buf) => {
        fs.close(fd)
    })
})
```

## writeFile


```js
fs.writeFile(fileName, data, [options], (err, data) => {
  // data
})
fs.appendFile(fileName, data, [options], (err, data) => {

})
```

```js
// 代码简短清晰
// 同步读取文件，容易阻塞
// 读取大文件时，容易内存溢出
function copy(src, target) {
  console.log(target)
  fs.writeFileSync(target, fs.readFileSync(src))
}
```

## mkdir

```js
fs.mkdir(path[, mode(0777)], () => {})
```
> mkdir无法创建多层级目录

# 删除操作

```js
fs.unlink(fileName, data, [options], (err, data) => {
  // data
})
fs.rmdir(path, ()=>{})
```

> 使用fs.rmdir(path)是有局限性的，只能删除空目录

```js
function rmDirAll(dirpath) {
  var stats = fs.statSync(dirpath) // 获取当前文件的状态
  if (stats.isFile()) {
    // 如果是个文件
    fs.unlinkSync(dirpath)
    console.log(`删除成功： ${dirpath}`)
  } else if (stats.isDirectory()) {
    // 若当前路径是文件夹，则获取路径下所有的信息，并循环
    var files = fs.readdirSync(dirpath)

    files.forEach(item => {
      var itempath = path.join(dirpath, item)
      // var itempath = getLastCode(path) == '/' ? path + item : path + '/' + item // 拼接路径
      var st = fs.statSync(itempath)
      if (st.isFile()) {
        fs.unlinkSync(itempath)
        console.log(`删除成功： ${itempath}`)
      } else if (st.isDirectory()) {
        // 当前是文件夹，则递归检索
        rmDirAll(itempath)
      }
    })
    // 现在可以删除文件夹
    fs.rmdir(dirpath)
    console.log(`删除成功： ${dirpath}`)
  }
}
```

# 监听文件

`watchfile`方法监听一个文件，如果该文件发生变化，就会自动触发回调函数。

```js
fs.watchFile(filename[, options], (current, previous) => {
  // 当前的状态对象和以前的状态对象
})
```
[options]
- persistent 表明当文件正在被监视时，进程是否应该继续运行(Default: true)
- interval 表示目标应该每隔多少毫秒被轮询 (Default: 5007)

```js
const fs = require('fs')
const Event = require('events').EventEmitter
const event = new Event()
//原始方法getCur
//原始属性prev
var watchFile = function(file,interval,cb){
    var pre,cur;
    var getPrv = function(file){
        var stat = fs.statSync(file);
        return stat;
    }
    var getCur = function(file){
        cur = getPrv(file);
        console.log(cur,pre);
        if(cur.mtime.toString()!==pre.mtime.toString()){
            cb('change');
        }
        pre = cur; //改变初始状态
    }
    var init = (function(){
        pre = getPrv(file); //首先获取pre
        event.on('change',function(){
            getCur(file);
        });
        setInterval(()=>{
            event.emit('change');
        },interval);
    })()
}
watchFile('sam.js',2000,function(eventname){
    console.log(eventname);
})
 ```


`unwatchfile`方法用于解除对文件的监听。

```js
fs.unwatchFile(filename[, listener])
```

[listener]
- eventType <string>
- filename <string> | <Buffer>


> fs.watch() 比 fs.watchFile 和 fs.unwatchFile 更高效,fs.watch调用的是native API。而fs.watchFile是调用的是fs.stat

```js
fs.watch(filename[, options][, listener])
```

[options]
- `persistent` 指明如果文件正在被监视，进程是否应该继续运行。默认 = true
- `recursive` 指明是否全部子目录应该被监视，或只是当前目录。 适用于当一个目录被指定时，且只在支持的平台（OS X & Windows）。默认 = false
- `encoding` 指定用于传给监听器的文件名的字符编码。默认 = 'utf8'
[listener]
- `eventType` 可以是 'rename' 或 'change'
- `filename` 触发事件的文件的名称

> 在大多数平台，当一个文件出现或消失在一个目录里时，'rename' 会被触发

# 文件流

## 创建读取流

```js
fs.createReadStream(path, [options])
```

[options] 

- `flags`指定文件操作，默认'r',读操作；
- `encoding`指定读取流编码；
- `autoClose`是否读取完成后自动关闭，默认true；
- `start`指定文件开始读取位置；end指定文件开始读结束位置


读取数据触发事件：

- open      开始读取文件
- readable  数据可读时
- data      数据读取后
- end       数据读取完成时
- error     数据读取错误时
- close     关闭流对象时


读取数据的对象操作方法：

- read      读取数据方法
- setEncoding   设置读取数据的编
- pause     通知对象众目停止触发data事件
- resume    通知对象恢复触发data事件
- pipe      设置数据通道，将读入流数据接入写入流；
- unpipe    取消通道
- unshift   当流数据绑定一个解析器时，此方法取消解析器


```js
var rs = fs.createReadStream(__dirname + '/test.txt', { start: 0, end: 2 })
//open是ReadStream对象中表示文件打开时事件，
rs.on('open', fd => {
  console.log('开始读取文件')
})

rs.on('data', data => {
  console.log(data.toString())
})

rs.on('end', () => {
  console.log('读取文件结束')
})
rs.on('close', () => {
  console.log('文件关闭')
})

rs.on('error', err => {
  console.error(err)
})

//暂停和回复文件读取；
rs.on('open', () => {
  console.log('开始读取文件')
})

rs.pause()

rs.on('data', data => {
  console.log(data.toString())
})

setTimeout(() => {
  rs.resume()
}, 2000)

```

## 创建写入流

```js
fs.createWriteStream(path, [options])
```

 [options]

 - `flags`:指定文件操作，默认'w'
 - `encoding`,指定读取流编码
 - `start`指定写入文件的位置

写入数据触发事件：

- drain            当write方法返回false时，表示缓存区中已经输出到目标对象中，可以继续写入数据到缓存区
- finish           当end方法调用，全部数据写入完成
- pipe             当用于读取数据的对象的pipe方法被调用时
- unpipe           当unpipe方法被调用
- error            当发生错误

写入数据方法：

- write            用于写入数据
  ```js
  /* chunk,  可以为Buffer对象或一个字符串，要写入的数据
  * [encoding],  编码
  * [callback],  写入后回调
  */
  ws.write(chunk, [encoding], [callback]);
  ```
- end              结束写入，之后再写入会报错；
  ```js
  /* [chunk],  要写入的数据
  * [encoding],  编码
  * [callback],  写入后回调
  */
  ws.end([chunk], [encoding], [callback]);
 ```



```js
var ws = fs.createWriteStream(__dirname + '/test.txt', { start: 0 })
var buffer = new Buffer('我也喜欢你')
ws.write(buffer, 'utf8', (err, buffer) => {
  console.log(arguments)
  console.log('写入完成，回调函数没有参数')
})
//最后再写入的内容
ws.end('再见')
```


```js
// createWriteStream方法和createReadStream方法配合，可以实现拷贝大型文件。
var input = fs.createReadStream(fileName)
var output = fs.createWriteStream('./testFile2.txt')

input.on('data', d => {
  // 读取数据写入
  output.write(d)
})
input.on('error', err => {
  throw err
})
input.on('end', () => {
  output.end()
})
```

## 管道实现读写

```js
rs.pipe(destination, [options])
 ```

- `destination` 必须一个可写入流数据对象
- `[opations]` end 默认为true，表示读取完成立即关闭文件；


 ```js
// node中支持pipe方法，类似于管道，将读出来的内容通过管道写入到目标文件中
function copy(src, target) {
  var rs = fs.createReadStream(src);
  var ws = fs.createWriteStream(target);
  rs.pipe(ws);
  rs.on('data', function (data) {
    console.log('数据可读')
  });
  rs.on('end', function () {
    console.log('文件读取完成');
    //ws.end('再见')
  });
}
copy('./movie.mkv', './new-movie.mkv')
```



# 综合实例
```js
// 文件夹（目录）的复制不同于文件的复制，文件夹操作时还要考虑操作对象是否存在及操作对象的类型（文件或目录）。
function copyDir(src, dist, callback) {
  fs.access(dist, err => {
    if (err) {
      // 目录不存在时创建目录
      fs.mkdirSync(dist)
    }
    _copy(null, src, dist)
  })

  function _copy(err, src, dist) {
    if (err) {
      callback(err)
    } else {
      fs.readdir(src, (err, paths) => {
        if (err) {
          callback(err)
        } else {
          paths.forEach(name => {
            const _src = path.join(src, name)
            const _dist = path.join(dist, name)
            fs.stat(_src, (err, stat) => {
              if (err) {
                callback(err)
              } else {
                // 判断是文件还是目录
                if (stat.isFile()) {
                  fs.writeFileSync(_dist, fs.readFileSync(_src))
                } else if (stat.isDirectory()) {
                  // 当是目录是，递归复制
                  copyDir(_src, _dist, callback)
                }
              }
            })
          })
        }
      })
    }
  }
}
copyDir('./testDir', './new', function(err) {
  if (err) {
    console.log(err)
  }
})
```