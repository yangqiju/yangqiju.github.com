---
layout: post
title: "使用gradle打包可运行的jar包"
description: "使用gradle打包可运行的jar包"
category: ""
tags: [gradle,jar,shell,application]
---
	
	对于gradle的打包功能还是比较好的，起初用的是非官方的一个哥们写的插件，
	最近试了试官方的打包功能，还是比较好的，记录一下。
	
	先说一下官方的吧，添加application plugin 和制定main 入口：
{% highlight ruby %}
	apply plugin: 'application'
	mainClassName = "com.joyveb.jkp.pressure.starter.SendClientStarter"
{% endhighlight %}

	然后运行 gradle distZip 就可以打包成zip包了，当然还可以打包成tar包(distTar)
	这个还是比较好的，直接打包成了包含shell脚本和bat脚本的工具。
	在build - distributions 中可以找到打好的包
	当然，还可以把自己想加的配置文件放到里面

{% highlight ruby %}	
distributions {
	main {
		contents {
			into("bin"){//要放的目录
				from { "src/main/resources/config.properties" }//要放的文件
			}
		}
	}
}
{% endhighlight %}
	
	还有个是个人写的，看看写的代码挺有意思，值得学习；
	在build.gradle中添加
{% highlight ruby %}
	apply plugin: 'executable-jar'
	
repositories {
    mavenCentral()
    maven{ url "https://oss.sonatype.org/content/repositories/snapshots" }
}
mainClass = 'com.joyveb.jkp.pressure.starter.SendClientStarter'
buildscript {
       repositories {
              mavenCentral()
       }
       dependencies {
              classpath 'net.nisgits.gradle:gradle-executable-jar-plugin:1.7.0'
       }
}
{% endhighlight %}
	
	


