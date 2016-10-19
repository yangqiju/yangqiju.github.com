---
layout: post
title: "mvn deploy 方法"
description: "mvn deploy 方法"
category: ""
tags: [mvn,java,deploy]
---

在开发过程中，常常会遇到编写的包需要传送的公司的nexus中，以此纪录。
在pox.xml 中添加如下配置：

{% highlight xml %}
<distributionManagement>
  <repository>
    <id>joyveb-releases</id>
    <url>http://192.168.3.10:8081/nexus/content/repositories/joyvebhost</url>
    </repository>
  <snapshotRepository>
    <id>joyveb-snapshots</id>
    <url>http://192.168.3.10:8081/nexus/content/repositories/joyvebhost</url>
  </snapshotRepository>
</distributionManagement>
{% endhighlight %}

在/.m2/settings.xml 中配置如下：

{% highlight xml %}
<servers>
  <server>
        <id>joyveb-releases</id>
          <username>username</username>
          <password>password</password>
  </server>
  <server>
          <id>joyveb-snapshots</id>
          <username>username</username>
          <password>password</password>
  </server>
</servers>
{% endhighlight %}

在终端中运行

{% highlight java %}
mvn deploy
{% endhighlight %}
