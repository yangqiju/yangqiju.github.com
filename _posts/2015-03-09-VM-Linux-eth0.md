---
layout: post
title: "VirtualBox set network"
description: ""
category: ""
tags: [VirtualBox,linux,network]
---
	准备在本地安装docker，使用VirtualBox，想用Xmanager来连接，结果连接不了。
	使用ifconfig 没有显示eth0重启报错
	
{% highlight java %}
	service network restart
Shutting down loopback insterface:            [  OK  ]
Bringing up loopback insterface:              [  OK  ]
Bringing up interface eth0:  
Device eth0 does not seem to be present,delaying initialization.  [FAILED]
{% endhighlight %}

	如下解决:
	1. vi /etc/udev/rules.d/70-persistent-net.rules 
	2. 记录eth1网卡的mac地址 00:00:00:00:00:00(example1)
	3. vi /etc/sysconfig/network-scripts/ifcfg-eth0
	4. 把 DEVICE="eth0"  改成  DEVICE="eth1"
	5. 将 HWADDR="00:00:00:00:00:00(example2)" 之前记录的  HWADDR="00:00:00:00:00:00(example1)"
	6. service network restart  或者     /etc/init.d/network restart
		
---	
---
	

