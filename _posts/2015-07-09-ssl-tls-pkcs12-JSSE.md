---
layout: post
title: "java SSL/TLS "
description: "java 使用SSL/TLS的花边"
category: ""
tags: [SSL,TLS,Java,PKCS12]
---
	
	最近在使用SSL/TLS相关的技术，使用语言为Java,遇到了一些值得记录的问题。
	
	Java实现SSL/TLS网上有很多现成的例子，这里就不重复了
	(http://www.cnblogs.com/yqskj/p/3142861.html)
	但是稍微深入一些就会发信啊有些地方是有问题的，下面是部分示例的代码
{% highlight java %}
SSLContext ctx = SSLContext.getInstance("SSL");  
KeyStore ks = KeyStore.getInstance("JKS");  
{% endhighlight %}
	
	SSL/TLS这个技术被人习惯的称为SSL，可能也误解了SSL也就是TLS了，我们现在
	使用的安全技术其实是TLS,截止目前(2015-07-09)牛ｘ的网站是用的是TLSv1.2版本
	TLSv1.3马上也要和大家见面了
	
	SSL 已经是不建议使用的技术了,最高版本SSL3.0,因为他被目前是有漏洞的,google在
	2014年10月声明他们将取消对SSL3.0的支持,论文中所描述的POODLE攻击，导致秘
	钥的特定部分在会话过程中泄露.SSL 3.0使用RC4流加密（存在已知漏洞）或CBC模
	式的块加密。[http://googleonlinesecurity.blogspot.co.uk/2014/10/this-poodle-bites-exploiting-ssl-30.html]
	
	在oracle 2015年1月对java 进行一次升级时,修复漏洞的同时也对SSL 3.0安全协议默
	认支持禁用，这是因为SSL 3.0安全协议已经成了一个易于受攻击、过时的协议。
(http://www.oracle.com/technetwork/topics/security/cpujan2015-1972971.html)
	
	花边:
	微软将停止接受用于SSL和代码签名的SHA1证书(http://www.infoq.com/cn/news/2013/11/SHA-1)
	RC4和SHA1被证明是不安全的,但是aliplay还是使用的RC4和SHA1,结果被百度的人吐槽了一下
	
	
	绕了一圈，我们便知道我们的确应该改改了,把SSL修改为TLS,可选参数为
	SSLv3 TLSv1 TLSv1.1 TLSv1.2
{% highlight java %}
SSLContext ctx = SSLContext.getInstance("TLSv1.2");  
{% endhighlight %}

	当我们写Java 示例的时候,都会默认使用 .jks (java key store)来做keystore.但实际运用中发现
	还有和其他语言通信,这时候出现个新的keystore 类型,例如.pfx .p12 这两个的文件类型是
	PKCS12的文件形式,PKCS12是种交换数字证书的加密标准，用来描述个人身份信息.
	
	Java 的keytool对PKCS12也是支持的,只需要加参数即可
{% highlight java %}
keytool  -keystore example.pfx -storetype PKCS12 ......
{% endhighlight %}
	
	在代码中做如下配置
{% highlight java %}
KeyStore ks = KeyStore.getInstance("PKCS12");  
{% endhighlight %}


