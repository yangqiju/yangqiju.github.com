---
layout: post
title: "httpclient对pkcs11 https的支持"
description: "httpclient对pkcs11 https的支持"
category: ""
tags: [httpclient,https,pkcs11]
---

https在相对于http，会再建立连接的时候慢一些，原因是要交换会话秘钥，但是一旦建立好了之后，使用
keepalive的方式进行通讯，也应该是很快的，我在测试客户端使用pkcs11 建立https连接的时候，发生
了一些小问题，记录到此。

首先服务端使用的nginx，并配置好了证书和客户端的关系。
客户端使用Java的HttpClient(4.5.2)。

首先配置nginx单项认证，直接使用httpclient并配置好https设置。测试会发现，建立连接会有些耗时，
然后速度就很快了。

[这是我写的例子](https://github.com/yangqiju/pkcs11Example/blob/master/src/main/java/com/joyveb/pkcs11example/httpclient/HttpClientExample.java)

但是当nginx配置为双向认证时，会发现每次请求都会重新建立链接，速度很慢。通过分析httpclient源码，
如果是双向认证的话，需要认证user token，所以需要手动设置。这样建立的链接将能被重复使用。

[官方描述](http://hc.apache.org/httpcomponents-client-4.2.x/tutorial/html/advanced.html)

示例如下：
{% highlight java %}
String url = "https://127.0.0.1:6699/";
HttpGet httpGet = new HttpGet(url);
// userToken 是证书中的名称
HttpContext context = new HttpCoreContext();
context.setAttribute(HttpClientContext.USER_TOKEN, "CN=yangqiju.joyveb.com");

try (CloseableHttpResponse response = httpclient.execute(httpGet,context)) {
  String responseMsg = EntityUtils.toString(response.getEntity(), "UTF-8");
  System.out.println("response:"+responseMsg);
}
{% endhighlight %}


通过上面配置，就能满足https的keepalive了。

在进一步测试过程中，发现了另外一个问题，每100次请求后便会断开重新链接。原因是因为nginx默认100次
请求后会把链接断开，重新链接。通过设置[keepalive_requests]参数，便能解决这个问题。

[nginx官网描述](http://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_requests)

{% highlight java %}
http{
    server{
        listen 6699;
        ssl on;
        server_name localhost;
        //省略
        ssl_verify_client on;

        keepalive_timeout  75;
        keepalive_requests 1000000;//默认100
        }
}
{% endhighlight %}
