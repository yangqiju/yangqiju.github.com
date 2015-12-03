---
layout: post
title: "无锁的队列 disruptor"
description: "disruptor"
category: ""
tags: [disruptor,paldb,queue,lock-free]
---

   之前调研学习了paldb，速度的确很快，但是它是非线程安全的，如果是单个操作必然没什么问题。
但是涉及到多个线程的时候，怎么办呢？

   最直接简单的办法就是直接加锁，试了一下，但是加锁操作，在单线程的情况下，性能就缩短成了
不加锁的大约1/5，170万左右降到了30万左右，虽然还是很快，但是性能这么消耗了，也太不爽了。

   还有中方法就是使用队列，paldb的查询是消费者，使用单线程，一般情况下性能是能提高不少了，
但是使用了队列，就意味着，向队列里面添加对象时，还是加锁了还是涉及到了多线程竞争。

能不能把他实现成redis一样，单线程就能拥有如此高的效率。
	
   高效无锁，这是个很值得思考的方式。disruptor便实现了它。随便google一下，有很多，引用一篇
比较好的：[disruptor 调研报告](http://www.cnblogs.com/killmyday/archive/2012/12/02/2798218.html)
 
之前看过一篇关于[java日志的性能的报告](http://www.infoq.com/cn/articles/things-of-java-log-performance)，提到Log4j 2.x的异步Logger，底层使用了disruptor，在
64线程下：

* 	比异步Appender快12倍
*	比同步Logger快68倍
*	LogBack的AsyncAppender快12倍
*	Log4J 1.x的异步Appender快19倍

那么，是时候使用disruptor了。经过简单的测试：

*	使用单线程不加锁paldb，大约170万TPS
* 使用单线程加锁paldb，大约30万TPS
* 使用单线程disruptor，一个生产者，一个消费者，大约150万TPS左右

性能的确很惊人，当然使用了disruptor多个生产者时也没有出现问题，因为始终就一个消费者来查询paldb，
以上是为了同级比较所以使用一个生产者。

不禁感叹在无锁情况下，效率真的比加锁的情况好太多。在disruptor背后，不但是使用了无锁，而是从系统，
jvm，甚至是cpu内存的硬件级别来思考，优化程序。
他们提供了他们论文报告，在这找到了一个中文翻译后的[文章](http://outofmemoryerror.github.io/2015/07/14/concurrent-disruptor)，阅读之后，受益匪浅。


-	CAS不需要涉及内核上下文切换，会用到memory barrier刷新内存状态
-	CPU操作缓存是以cache-line为单位，如果两个变量不幸在同一个cache-line里，且它们分别由不同的线程来进行写入操作，那么此时这两个变量的写入会发生竞争，这被称之为JVM的伪共享
- 现代CPU的可以预取，包括指令预取和数据预取，遍历数组就是一个非常好的例子，它的访问模式就是可预测的，因此遍历数组是非常高效的，一般小于2048个字节。
-	Ring Buffer是一个指针数组，预先分配避免了java内存回收，由于预先分配，有很大的可能这些对象在内存中是连续的，即使不连续它们在内存中得间隔也有可能是固定的，这样非常有利于缓存的数据预取。


有篇文章对actor模式和disruptor有较好的分析，并且提出了自己更加强的无锁算法[详情](http://www.infoq.com/cn/articles/High-Performance-Java-Inter-Thread-Communications)


