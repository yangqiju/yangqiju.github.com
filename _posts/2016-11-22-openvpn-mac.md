---
layout: post
title: "mac上安装openvpn支持pkcs11"
description: "mac上安装openvpn支持pkcs11"
category: ""
tags: [mac,openvpn,pkcs11]
---

由于公司的vpn需要通过Ukey身份认证才能进行连接，在mac上一直没有很好的解决方法，Tunnelblick也
一直有问题,所以问题就搁置了。目前对openvpn的需求有些迫切，所以把这件事情重新抓起来。

这里假设已经有了.ovpn 文件，只是没有调试通pkcs11.

1.首先安装openvpn，记得添加'--with-pkcs11-helper' 选项，因为默认pkcs11的依赖是不安装的
{% highlight java %}
brew install openvpn --with-pkcs11-helper
{% endhighlight %}

2.查看自己证书的id,找到Serialized id
{% highlight java %}
/usr/local/sbin/openvpn --show-pkcs11-ids /usr/local/lib/libeTPkcs11.dylib
{% endhighlight %}

3.在.ovpn 中添加证书id,注释pkcs11-id-management
{% highlight java %}
pkcs11-id 'SafeNet\x2C\x20Inc\x2E/eToken/******/*****/***************'
#pkcs11-id-management
{% endhighlight %}

4.命令启动openvpn
{% highlight java %}
sudo /usr/local/sbin/openvpn --config config.ovpn
{% endhighlight %}

5.输入用户名和密码，ukey pin码，应该就大功告成了
