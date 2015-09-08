---
layout: post
title: "glassfish OSGi 环境使用obr部署选择版本部署 "
description: "glassfish的OSGi环境使用obr部署的问题"
category: ""
tags: [Glassfish,OSGi,OBR,deploy]
---
	
	在glassfish中使用OSGi有一段时间了，我们一直使用obr(Apache Felix OSGi Bundle Repository)来
	对bundle包进行deploy等操作，obr他能够自动识别并部署所部署的bundle的依赖bundle。
	但我们之前就发现了不能自主选择version部署这个问题，由于时间问题，我们没有考虑太多，
	现在是时候来解决他了。
	
 [Apache Felix	documentation](http://felix.apache.org/documentation/subprojects/apache-felix-osgi-bundle-repository.html)
		
从obr官网我们能看到obr有多个命令：

{% highlight java %}
obr help
obr list-url
obr add-url
obr remove-url
obr list
obr info
obr deploy
obr start
obr source
obr javadoc
{% endhighlight  %}

我们最主要的是要看看 obr deploy 这个命令：
	
{% highlight java %}
Syntax:
obr deploy <bundle-name>[;<version>] ... | <bundle-id> ...

This command tries to install or update the specified bundles and all of their dependencies by default. 
You can specify either the bundle name or the bundle identifier. If a bundle's name contains spaces, 
then it must be surrounded by quotes. It is also possible to specify a precise version if more than one version exists, such as:

obr deploy "Bundle Repository";1.0.0

For the above example, if version "1.0.0" of "Bundle Repository" is already installed locally, 
then the command will attempt to update it and all of its dependencies; 
otherwise, the command will install it and all of its dependencies.
{% endhighlight  %}

好吧，看到这里也应该知道该怎么做了，比如部署P1项目：
	
{% highlight java %}
obr deploy "P1";1.0.0
{% endhighlight %}

确定分号(;)可以在命令行里面使用的么？无论你怎么搞，用什么转义`\`单引`'`都没用。按照shell的罗辑也
应该是这样才对。看着官方文档，有点无力。
	
{% highlight java %}
bash: 1.0.0: command not found
{% endhighlight %}

于是乎我想起了之前使用的`Apache Karaf`
	
> Apache Karaf is a small OSGi based runtime which provides a lightweight container onto which various 
components and applications can be deployed.


看看Karaf是如何部署带版本号的bundle的呢？
	
{% highlight java %}
karaf@root()> obr:deploy org.apache.karaf.wrapper.core,4.0.0
{% endhighlight %}
	
呵呵，他居然直接用的逗号`,` 
好吧，拿你没办法，bundle包互相依赖，把bundle升级一次，要大费周折，并且还要测试，看看
升级之后有没有问题，想了想，既然只是一个简单的符号问题，倒不如把源码download下来进行简单的修改。
我们使用的obr 包为：`org.apache.felix.bundlerepository-1.6.6`
遇到了些问题，有意思的记录一下：
	
{% highlight java %}
使用jar tf 查看META-INF/MANIFEST.MF 是否在前两列，不是就有问题
如果想替换其中个class，重新打jar包，使用 jar cvfm 命令
{% endhighlight %}
	
然后接下来开始了虐心情节，不管如何重新部署，删除 osgi-cache ，都无法运行我所修改的代码，不管我把
当前代码修改成什么样子。无语了，难不成还有别的相同的包？好吧，还真的是，在`glassfish4/glassfish/modules`
目录中有个`org.apache.felix.bundlerepository.jar`
我把所有的bundlerepository包都删除了，手动导入我自己的包，好吧，不论这么样还是不行，依旧没有走我的代码。
	
	
>Apache Felix Gogo is a subproject of Apache Felix implementing the OSGi RFC 147, which describes a standard shell for OSGi-based environments

偶然在google错误的时候发现了，gogo.runtime 有deploy的方法,好吧，我觉得我找到问题了，因为在我们找错的时候
发现在 `glassfish4/glassfish/modules/autostart`的目录中有如下文件：
{% highlight java %}
org.apache.felix.configadmin.jar
org.apache.felix.eventadmin.jar
org.apache.felix.fileinstall.jar
org.apache.felix.gogo.command.jar
org.apache.felix.gogo.runtime.jar
org.apache.felix.gogo.shell.jar
org.apache.felix.scr.jar
osgi-cdi.jar
osgi-ee-resources.jar
osgi-ejb-container.jar
osgi-http.jar
osgi-javaee-base.jar
osgi-jdbc.jar
osgi-jpa.jar
osgi-jta.jar
osgi-web-container.jar
{% endhighlight %}

在autostart里面居然包含这全套的gogo的jar包，包括了runtime，shell，command，也就是说glassfish是建立在gogo
上的。好吧。
看了下Apache Felix Gogo 的文档，也没有说deploy是如何使用，还是直接看源码吧。
{% highlight java %}
@Descriptor("deploy resource from repository")
  public void deploy(@Descriptor("start deployed bundles") 
  @Parameter(names={"-s", "--start"}, presentValue="true", absentValue="false") 
  boolean start, @Descriptor("( <bundle-name> | <symbolic-name> | <bundle-id> )[@<version>] ...") String[] args)
    throws IOException, InvalidSyntaxException
  {
  ...
  }
{% endhighlight %}
	
看到这就明白了，gogo很明智的使用了`@`符号来分割version。
{% highlight java %}
obr deploy "P1"@1.0.0
{% endhighlight %}

由于felix给出的文档是错误的，并且google了半天也没有答案，在此记录一下，希望能帮到其他人。
	
