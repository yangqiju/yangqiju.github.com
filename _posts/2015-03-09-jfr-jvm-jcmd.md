---
layout: post
title: "JVM 飞行记录抓取"
description: ""
category: ""
tags: [JVM,JFR,java]
---
	在项目调优的时候，时常会去抓取一下飞行记录，网上没什么介绍，简单记录一下。
	
{% highlight java %}
	/usr/java/jdk1.7.0_51/bin/jcmd ##找到相关的监控进程 example:4885
/usr/java/jdk1.7.0_51/bin/jcmd 4885 JFR.start duration=10m filename=/cassandra10G.jfr compress=true
/usr/java/jdk1.7.0_51/bin/jcmd 4885 JFR.check ##查看飞行记录是否完成
{% endhighlight %}

---	
---
	

