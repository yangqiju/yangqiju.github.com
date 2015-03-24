---
layout: post
title: "glassfish 使用指令每次输入密码问题解决"
description: "glassfish 使用指令每次输入密码问题解决"
category: ""
tags: [glassfish,osgi]
---
	
	在Glassfish中使用OSGi的时候，如果不是用图形界面操作而是使用命令的时候，会遇到每次使用admin用户的时候要输入密码。
	官方提供了该种方式的解决方案。

	查看help
{% highlight java %}
/usr/local/glassfish4/glassfish/bin/asadmin --help
{% endhighlight %}

{% highlight java %}
......省略.......
OPTIONS
       --user, -u
           The user name of the authorized administrative user of the DAS.

           If you have authenticated to a domain by using the asadmin login
           command, you need not specify the --user option for subsequent
           operations on the domain.

       --passwordfile, -W
           Specifies the name, including the full path, of a file that
           contains password entries in a specific format.

           Note that any password file created to pass as an argument by using
           the --passwordfile option should be protected with file system
           permissions. Additionally, any password file being used for a
           transient purpose, such as setting up SSH among nodes, should be
           deleted after it has served its purpose.

           The entry for a password must have the AS_ADMIN_ prefix followed by
           the password name in uppercase letters, an equals sign, and the
           password.

           The entries in the file that are read by the asadmin utility are as
           follows:

           *   AS_ADMIN_PASSWORD=administration-password

           *   AS_ADMIN_MASTERPASSWORD=master-password
......省略.......
{% endhighlight %}

	根据上面的提示可以指定密码文件，所以新建密码文件  /etc/gf4pwd  内容如下
	AS_ADMIN_PASSWORD=password
	
	命名新的命令
	alias ofish='$GLASSFISH_HOME/bin/asadmin --user admin -W /etc/gf4pwd osgi' 


---	
---
