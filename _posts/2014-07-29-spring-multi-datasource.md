---
layout: post
title: "spring multi datasource config"
description: ""
category: ""
tags: [spring,datasource]
---
	最近需要用到一个spring对多个数据源进行查询的问题，每个请求查询可能都是不一样的数据源。
	看了一下，网上的有很多已经实现了该功能，自己做了，也总结一下吧。
	
	spring 的  jdbc 提供了这种需求的实现，那就是他提供的  AbstractRoutingDataSource 类，
	通过继承这个类，就能实现相应的功能。
	
	他会让你去  override 以下方法:
	
{% highlight java %}
	protected Object determineCurrentLookupKey() {
		return null;
	}
{% endhighlight %}

	这个方法的主要任务，源代码中写到：
{% highlight java %}
protected DataSource determineTargetDataSource() {
	Assert.notNull(this.resolvedDataSources, "DataSource router not initialized");
	Object lookupKey = determineCurrentLookupKey();
	DataSource dataSource = this.resolvedDataSources.get(lookupKey);
	if (dataSource == null && (this.lenientFallback || lookupKey == null)) {
		dataSource = this.resolvedDefaultDataSource;//设置默认的 dataSource
	}
	if (dataSource == null) {
		throw new IllegalStateException("Cannot determine target DataSource 
		for lookup key [" + lookupKey + "]");
	}
	return dataSource;
}
{% endhighlight %}
	
	其实他就是获得一个 datasource 的key ，通过这个key，到resolvedDataSources 这个map中去拿DataSource。
	
	而 resolvedDataSources 的初始化 是在 afterPropertiesSet 方法中，
	而且我们能够设置他的默认dataSource。
{% highlight java %}
public void afterPropertiesSet() {
	if (this.targetDataSources == null) {
		throw new IllegalArgumentException("Property 'targetDataSources' is required");
	}
	this.resolvedDataSources = new HashMap<Object, DataSource>(this.targetDataSources.size());
	for (Map.Entry entry : this.targetDataSources.entrySet()) {
		Object lookupKey = resolveSpecifiedLookupKey(entry.getKey());
		DataSource dataSource = resolveSpecifiedDataSource(entry.getValue());
		this.resolvedDataSources.put(lookupKey, dataSource);
	}
	if (this.defaultTargetDataSource != null) {
		this.resolvedDefaultDataSource = resolveSpecifiedDataSource(this.defaultTargetDataSource);
	}
}
{% endhighlight %}
	
	那我们只要把 我们的多个数据源 通过 setTargetDataSources() 方法 ，给他放进去，就完成了我们的多个数据源初始化。
	
	定义  DynamicDataSource 一个类，用来初始化。
{% highlight java %}
public class DynamicDataSource extends AbstractRoutingDataSource {
	private @Setter DataSource defaultDataSource;
	private @Setter Map<Object,Object> targetDataSources;
	@PostConstruct
	private void init(){
		if(defaultDataSource==null){
			throw new RuntimeException(" default dataSource can not be null.");
		}
		super.setDefaultTargetDataSource(defaultDataSource);
		if(targetDataSources!=null){
			super.setTargetDataSources(targetDataSources);
		}
	}
	@Override
	protected Object determineCurrentLookupKey() {
	return null;
	}
}
{% endhighlight %}

	在spring.xml 中配置:
{% highlight xml %}
	<bean id="dataSource_main" class="org.springframework.jndi.JndiObjectFactoryBean">
		<property name="jndiName" value="jndi/jpa"></property>
		<property name="resourceRef">
			<value>true</value>
		</property>
	</bean>  
	
	<bean id="dynamicDataSource" class="com.cwl.iso.db.mysql.DynamicDataSource" >
    <property name="targetDataSources">
        <map key-type="java.lang.String">
           	<entry key="dataSource_main" value-ref="dataSource_main"></entry>
            <entry key="dataSource_bak" value-ref="dataSource_bak"></entry>
        </map>
    </property>
    <property name="defaultDataSource" ref="dataSource_main"/>
{% endhighlight %}

   	到这里，差不多dataSource 的init 任务就完成了。那如何去切换这个当前的数据源呢?
   	这里就要用到 DynamicDataSource 类中的 determineCurrentLookupKey 方法了。
   	现在我们这个map中有 两个key :dataSource_main 和 dataSource_bak
   	
   	这时候我们就需要用到个 ThreadLocal 用来设置当前线程的这个参数：
{% highlight java %}
public class DataSourcesHolder {
	private static ThreadLocal<String> dataSources = new ThreadLocal<String>();
	public static String getDataSource(){
		return dataSources.get();
	}
	public static void setDataSource(String source){
		dataSources.set(source);
	}
}
{% endhighlight %}
 	
 	设置到 DynamicDataSource 中的determineCurrentLookupKey 方法中 
{% highlight java %}
protected Object determineCurrentLookupKey() {
	return DataSourcesHolder.getDataSource();
}
{% endhighlight %}
	
	现在只要请求的时候，你来动态的设置ThreadLocal 的值：
	DataSourcesHolder.setDataSource("dataSource_bak");
	这时候就能切换数据源到 dataSource_bak 了。
