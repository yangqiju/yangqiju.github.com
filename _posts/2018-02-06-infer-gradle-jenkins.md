---
layout: post
title: "infer 对idea和jenkins的支持"
description: "infer 对idea和jenkins的支持"
category: ""
tags: [infer,jenkins,idea]
---

[infer](https://github.com/facebook/infer)是facebook开源的代码检查工具，里面提供了findbugs、阿里pmd所没有的竞态的资源问题。
在终端上执行infer相关命令没有问题，但是结合gradle 执行infer 相关命令时，在idea或者jenkins下
就会有问题(当前2018-02-06)。


错误信息如下：
{% highlight java %}
Caused by: java.io.IOException: error=2, No such file or directory
	at java.lang.UNIXProcess.forkAndExec(Native Method)
	at java.lang.UNIXProcess.<init(UNIXProcess.java:248)
	at java.lang.ProcessImpl.start(ProcessImpl.java:134)
	at java.lang.ProcessBuilder.start(ProcessBuilder.java:1029)
	... 91 more
{% endhighlight %}

原因就是因为在运行idea或jenkins时，infer的路径不在`/usr/local/bin`中，所以需要在`PATH`中
加上。
idea可参考[此内容](http://depressiverobot.com/2016/02/05/intellij-path.html)

jenkins可以直接在`系统设置`中添加`环境变量`,`键`为`PATH`,值为`$PATH:/usr/local/bin`,重启即可.
