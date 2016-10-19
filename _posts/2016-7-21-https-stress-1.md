---
layout: post
title: "https压力测试(1)"
description: "https压力测试(1)"
category: ""
tags: [https,http,RSA]
---

目前需要了解https的基本速率，找了个机器测试了一下。作为记录。

机器信息

| 硬件 | 信息     |
| :------------- | :------------- |
| cpu       | 6 ＊ Intel(R) Xeon(R) CPU E5-2609 v3 @ 1.90GHz       |

测试的nginx环境为默认配置，没有经过优化。
配置好了nginx，采用默认配置。worker_processes为1。

安装 apache benchmark。

{% highlight xml %}
yum install httpd-tools
{% endhighlight %}

执行以下命令：
{% highlight xml %}
ab -kc 20 -n 100000 https://192.168.21.20:8088/index.html
{% endhighlight %}

| 参数 | 描述     |
| :------------- | :------------- |
| －k       | 开启keepalive       |
| -c       | 并发数       |
| -n       | 请求次数       |

由于RSA是比较耗时的操作，测试时加密解密的过程在200以内。http1.1 keepalive是默认开启的，通过测试，大致的对比如下：

| 场景    | request per second    |
| :------------- | :------------- |
| https keepalive       | 11000/s 左右     |
| https keepalive-close   | 200/s 左右     |
| http keepalive       | 42000/s 左右     |
| http keepalive-close    | 20000/s 左右     |
