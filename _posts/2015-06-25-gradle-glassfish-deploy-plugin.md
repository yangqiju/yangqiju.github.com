---
layout: post
title: "glassfish4 deploy gradle plugin"
description: "glassfish4 gradle 部署插件"
category: ""
tags: [gradle,war,deploy,plugin,glassfish]
---

	以前的项目一直用的maven管理，新项目又一直使用osgi，没有涉及到web项目的直接
	部署，才发现官网貌似没有提供glassfish的插件，有点费解，找了找解决方案：
	1.Codehaus cargo 能够完成相应的功能
	2.直接使用glassfish 的 asadmin直接部署
	3.etc

	看了下 cargo 集成的挺多东西的，功能强大，但是太复杂，不是我想要的。
	试了试使用glassfish自带的deploy方法，貌似也挺好用，想了想，要不自己写个简单的gradle插件吧。
	在之前做好准备：
	1.一套glassfish环境
	2.一个web项目

	在web项目的build.gradle中添加如下配置
{% highlight groovy %}
	task deploy2glassfish << {
        def deployfile =  project.file(project.war.archivePath)
        if(!deployfile.exists()) return
        def proc = "asadmin deploy --name ${project.name} --contextroot ${project.name} ${deployfile.absolutePath}".execute()
        proc.in.each { println it }
        proc.err.each {println '[ERROR]'+it }
}
{% endhighlight %}

	其中有写比较有意思的是 task deploy2glassfish(){} 和 task deploy2glassfish << {} 有点分别，没有 << 的会
	自动运行，添加了<< 的task 需要手动执行(gradle deploy2glassfish)。
	peoject 是build.gradle 中的内置对象。

	执行gradle deploy2glassfish 相当于执行运行了
{% highlight groovy %}
        asadmin deploy --name webtest --contextroot webtest /home/....path/webtext.war
{% endhighlight %}

	部署的结果可以直接使用下列命令查看，或者进入到glassfish 4848 后台进行查看
{% highlight groovy %}
        asadmin list-applications
{% endhighlight %}

	进一步把上面deploy脚本加工成为gradle 插件，方便以后扩展，代码如下
	https://github.com/yangqiju/glassfish4-gradle-plugin/tree/master

	其他项目在使用的时候在下面添加如下配置,便可以调用gradle deploy2glassfish进行部署
{% highlight groovy %}
 buildscript {
	repositories {
		mavenLocal()
	}
	dependencies {
		classpath "com.joyveb:glassfish4-gradle-plugin:1.0.0"
	}
}
apply plugin: 'glassfish4'
{% endhighlight %}

	web项目中也遇到了写比较有意思的地方，需要添加如下配置
{% highlight groovy %}
apply plugin: 'war'
apply plugin:'java'
apply plugin:'maven'
apply plugin: 'eclipse-wtp' //web 项目

webAppDirName = 'WebContent'    // 设置 WebApp 根目录
sourceSets.main.java.srcDir 'src/main/java'   // 设置 Java 源码所在目录
{% endhighlight %}
