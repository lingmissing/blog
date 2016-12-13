---
title: deferred延迟对象
date: 2016-06-12 17:29:11
tags: jquery
categories:  代码如诗，前端如画
---

延迟对象,在jQuery 1.5中引入的,是通过调用jQuery.Deferred()方法创建的对象。它可以将多个回调存放为一个callback队列,并且返回成功或者失败的方法。
延迟对象拥有自己的方法。在创建一个延迟对象后，可以使用以下方法来调用。
deferred.always()
当Deferred（延迟）对象解决或拒绝时，调用添加处理程序。
deferred.done()
当Deferred（延迟）对象解决时，调用添加处理程序。
deferred.fail()
当Deferred（延迟）对象拒绝时，调用添加的处理程序。
deferred.notify()
根据给定的 args参数 调用Deferred（延迟）对象上进行中的回调 （progressCallbacks）。
deferred.notifyWith()
根据给定的上下文（context）和args递延调用Deferred（延迟）对象上进行中的回调（progressCallbacks ）。
deferred.progress()

<!--more-->

当Deferred（延迟）对象生成进度通知时，调用添加处理程序。
deferred.promise()
返回Deferred(延迟)的Promise（承诺）对象。
deferred.reject()
拒绝Deferred（延迟）对象，并根据给定的args参数调用任何失败回调函数（failCallbacks）。
deferred.rejectWith()
拒绝Deferred（延迟）对象，并根据给定的 context和args参数调用任何失败回调函数（failCallbacks）。
deferred.resolve()
解决Deferred（延迟）对象，并根据给定的args参数调用任何完成回调函数（doneCallbacks）。
deferred.resolveWith()
解决Deferred（延迟）对象，并根据给定的 context和args参数调用任何完成回调函数（doneCallbacks）。
deferred.then()
当Deferred（延迟）对象解决，拒绝或仍在进行中时，调用添加处理程序。
deferred.state()
确定一个Deferred（延迟）对象的当前状态。
jQuery.when()
提供一种方法来执行一个或多个对象的回调函数， Deferred(延迟)对象通常表示异步事件。
.promise()
返回一个 Promise 对象，用来观察当某种类型的所有行动绑定到集合，排队与否还是已经完成。
jQuery.Deferred()
一个构造函数，返回一个链式实用对象方法来注册多个回调，回调队列，调用回调队列，并转达任何同步或异步函数的成功或失败状态。