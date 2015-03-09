---
layout: post
title: "Jboss EAP DataSource Configuration"
description: ""
category: ""
tags: [Jboss,mysql,dataSource]
---
	今天使用Jboss EAP 创建JDBC连接,发现默认只提供h2的驱动支持,mysql 什么的都没有。
	按照他官方提供的用 modules add 的方式未果,找到了更方便的快捷的
	直接把jar包放到该目录下，就有在后台就能看到可以使用mysql服务了。
	
{% highlight java %}
	/standalone/deployments/mysql-connector-java-5.1.15.jar
{% endhighlight %}

	下面这个讲解了全部添加驱动或dataSource的全部方法
		
---	
	
官方[https://docs.jboss.org/author/display/AS7/How+do+I+migrate+my+application+from+AS5+or+AS6+to+AS7](https://docs.jboss.org/author/display/AS7/How+do+I+migrate+my+application+from+AS5+or+AS6+to+AS7)
					
---
	

