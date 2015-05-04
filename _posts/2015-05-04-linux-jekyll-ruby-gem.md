---
layout: post
title: "linux上搭建jekyll应用问题"
description: "在linux上搭建jekyll的问题"
category: ""
tags: [linux,jekyll,ruby,gem]
---
	
	最近把工作环境换到了linux mint下,所以把jekyll搭建的博客什么的也转移过来,遇到了很多问题,记录一下.
	
	安装jekyll 第一步就是 gem install jekyll
	所以需要先安装ruby什么的,使用默认的(sudo apt-get install -y ruby)安装,然后 gem install jekyll 就有问题了.
	首先超时问题,查看 http://ruby.taobao.org/ 修改源就能解决.
	然后就是下面的问题
{% highlight ruby %}
	Fetching: yajl-ruby-1.2.1.gem (100%)
	ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions into the /var/lib/gems/1.9.1 directory.
		yangqiju@yqj ~/work/software $ sudo gem install jekyll
Building native extensions.  This could take a while...
ERROR:  Error installing jekyll:
	ERROR: Failed to build gem native extension.

{% endhighlight %}

	大家都说是因为版本的问题,看了一下ruby 版本 1.9.1 
	执行下面命令,用开发版本
{% highlight ruby %}
	sudo apt-get install ruby-dev
{% endhighlight %}

	再来安装jekyll 结果就ok了.
	当启动jekyll的时候,结果报下面的错误
{% highlight java %}
/var/lib/gems/1.9.1/gems/execjs-2.5.2/lib/execjs/runtimes.rb:48:in `autodetect':
 Could not find a JavaScript runtime. See https://github.com/rails/execjs 
 for a list of available runtimes. (ExecJS::RuntimeUnavailable)
{% endhighlight %}

	据说是少了点东西,解决方案直接安装nodejs,就会安装少的东西了
{% highlight java %}
	sudo apt-get install -y nodejs
{% endhighlight %}

	最后启动一下 jekyll ,应该就ok了
{% highlight java %}
	jekyll serve
{% endhighlight %}

