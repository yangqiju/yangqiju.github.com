---
layout: post
title: "JVM 飞行记录抓取"
description: ""
category: ""
tags: [JVM,JFR,java]
---
	在项目调优的时候，时常会去抓取一下飞行记录，网上没什么介绍，简单记录一下。

{% highlight java %}
## 找到相关的监控进程 example:4885
/usr/java/jdk1.7.0_51/bin/jcmd
## 开启飞行记录
/usr/java/jdk1.7.0_51/bin/jcmd 4885 JFR.start duration=10m filename=/cassandra10G.jfr compress=true
## 可能会遇到 Java Flight Recorder not enabled.以下开启
/usr/java/jdk1.7.0_51/bin/jcmd 4885 VM.unlock_commercial_features
##查看飞行记录是否完成
/usr/java/jdk1.7.0_51/bin/jcmd 4885 JFR.check

## jcmd 还可以主动gc
/usr/java/jdk1.7.0_51/bin/jcmd 4885 GC.run
{% endhighlight %}

---
---
