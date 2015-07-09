---
layout: post
title: "使用UKEY调用PKCS11做SSL/TLS的验证 "
description: "SSL/TLS  ukey pkcs11"
category: ""
tags: [SSL,TLS,Java,PKCS11,Ukey]
---
	
	之前使用SSL/TLS 做client和server的双向验证,为了进一步提高安全性，我们设定只允许和指定的client进
	行连接，并且保证client的私钥无法复制,我们采取使用Ukey的方案.
	
	UKey是一种通过USB (通用串行总线接口)直接与计算机相连、具有密码验证功能、可靠高速的小型存储设
	备。Ukey 是对现行的网络安全体系是一个极为有力的补充,Ukey更形象的描述就是以前我们银行使用的Ｕ盾,
	他能确定你的唯一身份,U盾还使用了双因子验证,就是你插了U盾还需要输入pin码.尽可能的提高安全性.
	
	更加详细的Ukey描述就不陈述了,他能使用非对称加密算法，对信息进行数字签名，并且他无法导出私钥,这
	样它能保证身份唯一, 他人不可能造假.
	
	当我们使用java进行对Ukey的调用之前,我们需要了解PKCS11.
	PKCS#11是公钥加密标准（PKCS, Public-Key Cryptography Standards）中的一份子 ，由RSA实验室(RSA 
	Laboratories)发布[1]，它为加密令牌定义了一组平台无关的API ，如硬件安全模块和智能卡.PKCS#11称为
	Cyptoki，定义了一套独立于技术的程序设计接口，UKey安全应用需要实现的接口.
	
	Ukey都遵循PKCS11标准,java也支持对PKCS11的调用,在之前需要如下准备:
	1.Ukey
	2.Ukey驱动或调用库
	
	我手上有safenet的Ukey和本系统调用库,然后直接上代码吧
{% highlight java %}
String pkcs11config = "library = /home/yangqiju/libeTPkcs11.so\n name = safenetSC\n ";//设定算法名称和库地址
Provider testProvider = new sun.security.pkcs11.SunPKCS11(new ByteArrayInputStream(pkcs11config.getBytes()));
Security.addProvider(testProvider);//添加提供者
char[] pin = "password".toCharArray();
//加载自定义的算法
KeyStore testKeystore = KeyStore.getInstance("PKCS11","SunPKCS11-safenetSC");//必须添加SunPKCS11前缀
testKeystore.load(null, pin);

Enumeration<String> aliasesEnum = testKeystore.aliases();
while (aliasesEnum.hasMoreElements()) {
	String alias = (String) aliasesEnum.nextElement();
	X509Certificate cert = (X509Certificate) testKeystore.getCertificate(alias);
	System.out.println("Certificate: " + cert);//查看证书
}
{% endhighlight %}

	这是个很简单但是很直接的例子,需要注意的是load 的时候必须要SunPKCS11前缀.
	
	下一步就是使用Ukey和SSL/TLS结合
{% highlight java %}
System.setProperty("javax.net.ssl.keyStoreType", "pkcs11");
System.setProperty("javax.net.ssl.keyStore", "NONE"); //必须NONE
System.setProperty("javax.net.ssl.keyStorePassword", "password");
System.setProperty("javax.net.ssl.keyStoreProvider","SunPKCS11-safenetSC");//设定提供者
System.setProperty("javax.net.debug", "ssl");
String pkcs11config = "library = /home/yangqiju/libeTPkcs11.so\n name = safenetSC\n ";//设定算法名称和库地址
Provider testProvider = new sun.security.pkcs11.SunPKCS11(new ByteArrayInputStream(pkcs11config.getBytes()));
Security.addProvider(p);//添加算法提供者
SSLSocketFactory factory = (SSLSocketFactory) SSLSocketFactory.getDefault();
SSLSocket socket = (SSLSocket) factory.createSocket("localhost", 10036);//建立连接
try {
	socket.startHandshake();//执行握手协议
	System.out.println("success..");
} catch (Exception e) {
	System.out.println("error...");
	e.printStackTrace();
}
{% endhighlight %}
	
	以上的代码是client 的代码,server的代码和其他的SSL/TLS 相同,网上查查有很多.
	在握手之前,记得把双方证书相互添加信任.
