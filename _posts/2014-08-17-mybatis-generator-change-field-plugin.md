---
layout: post
title: "mybatis generate 修改默认字段类型的plugin"
description: "mybatis generate 修改默认字段类型的plugin"
category: ""
tags: [mybatis,generate,plugin]
---
	最近遇到了个问题,就是mybatis的生成工具,会对应的mysql中的数据类型,生成对应的java类型。
	比如大于18位的数字,他会默认使用BigDecimal,只大于9位的是Long,大于4位的Integer,那下雨4位的就是Short了。
	
	但是现在我想要修改为自己想要的类型,不想用Short,那么怎么办呢。
	
	还好Mybatis 有预留的接口。你只需要实现JavaTypeResolver 这个接口,就能设置你想要的类型了。
	
	它默认有个 JavaTypeResolverDefaultImpl 类,里面定义了数据库类型和java类型的对应。
	
	我们只需要把这个拿来copy一下,然后修改一下自己想要的类型即可。
	
	在 ObjectFactory 中 有如下方法,用来判断是否使用我们自己的类型。
{% highlight java %}
	public static JavaTypeResolver createJavaTypeResolver(Context context,
            List<String warnings) {
        JavaTypeResolverConfiguration config = context.getJavaTypeResolverConfiguration();
        String type;
        if (config != null && config.getConfigurationType() != null) {
            type = config.getConfigurationType();
            if ("DEFAULT".equalsIgnoreCase(type)) { //$NON-NLS-1$
                type = JavaTypeResolverDefaultImpl.class.getName();
            }
        } else {
            type = JavaTypeResolverDefaultImpl.class.getName();
        }
        JavaTypeResolver answer = (JavaTypeResolver) createInternalObject(type);
        answer.setWarnings(warnings);
        if (config != null) {
            answer.addConfigurationProperties(config.getProperties());
        }
        answer.setContext(context);
        return answer;
    }
{% endhighlight %}
	可以看出,在配置为DEFAULT 时,或者我们没配置时,都是用JavaTypeResolverDefaultImpl.
	然后通过 createInternalObject 方法获得我们自己可以定义的 resolver。
	这时候我们只需要给他配置一个type 参数,就ok了。
	
{% highlight java %}
	  public static Object createInternalObject(String type) {
        Object answer;
        try {
            Class<? clazz = internalClassForName(type);
            answer = clazz.newInstance();
        } catch (Exception e) {
            throw new RuntimeException(getString("RuntimeError.6", type), e); //$NON-NLS-1$
        }
        return answer;
    }
    public static Class<? internalClassForName(String type) throws ClassNotFoundException {
        Class<? clazz = null;
        try {
            ClassLoader cl = Thread.currentThread().getContextClassLoader();
            clazz = Class.forName(type, true, cl);
        } catch (Exception e) {
            // ignore - failsafe below
        }
        if (clazz == null) {
            clazz = Class.forName(type, true, ObjectFactory.class.getClassLoader());
        }
        return clazz;
    }
{% endhighlight %}

	看到这里,我们不难看出,他需要的这个type,就是用来获得这个class 的。ok。那我配置给他就好了。
{% highlight xml %}
<generatorConfiguration
	 <context id="CoreGenconfig" targetRuntime="MyBatis3" defaultModelType="hierarchical"
		<javaTypeResolver type="com.joyveb.。。.JavaTypeResolverJoyvebImpl"/
</generatorConfiguration
{% endhighlight %}
	
	这样就搞定了。
	

