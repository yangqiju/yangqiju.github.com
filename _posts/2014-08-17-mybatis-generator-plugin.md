---
layout: post
title: "mybatis generate plugin"
description: ""
category: ""
tags: [mybatis,generate,plugin]
---
	相信很多人都在用ibatis,mybatis。那应该也遇到了通过oracle 或者 mysql 去生成表对应的实体的需求。
	毕竟官方有提供这么好的工具,肯定是要用一用的。
	
	网上也有很多提供的插件，最著名的应该就是数据库分页插件了吧。因为oracle 和 mysql的分页机制不太一样,
	mybatis 没有自带分页。那是有些大神写的,当然你也可以自己写。满足你自己的需求。
	
	使用这个插件的方式很多,可以用eclipse 插件,也可以自己写代码,跑main函数。
	我比较喜欢跑代码的形式,这样可以自己debug,也看看他代码怎么实现的。而且还能使用freemaker 生成自己想要的其他代码。
	
	首先 extends PluginAdapter 这个抽象类。会让你override validate这个方法。
{% highlight java %}
	public class MysqlTestPlugin extends PluginAdapter {
		@Override
		public boolean validate(List<String> warnings) {
			// TODO Auto-generated method stub
			return false;
		}
	}
{% endhighlight %}

	这个的方法顾名思义就是去验证你传进来的 warnings,让你在这里决定这个这个插件是否被调用。
	默认false,这里只需要改为true即可。你也可以看看他的源码。
	
{% highlight java %}
	 for (PluginConfiguration pluginConfiguration : pluginConfigurations) {
            Plugin plugin = ObjectFactory.createPlugin(this,
                    pluginConfiguration);
            if (plugin.validate(warnings)) {
                pluginAggregator.addPlugin(plugin);
            } else {
                warnings.add(getString("Warning.24", //$NON-NLS-1$
                        pluginConfiguration.getConfigurationType(), id));
            }
        }
{% endhighlight %}

	PluginAdapter 这是个abstract 类,里面包含很多空方法,只要你overrid的了这些方法即可。
	由于太多,就列举其中一二。
	
{% highlight java %}
	public boolean modelExampleClassGenerated(TopLevelClass topLevelClass,
            IntrospectedTable introspectedTable) {
        return true;
    }
    
    public boolean modelPrimaryKeyClassGenerated(TopLevelClass topLevelClass,
            IntrospectedTable introspectedTable) {
        return true;
    }
    
    public boolean sqlMapDocumentGenerated(Document document,
			IntrospectedTable introspectedTable) {
		 return true;
    }
    
     public boolean providerUpdateByPrimaryKeySelectiveMethodGenerated(
            Method method, TopLevelClass topLevelClass,
            IntrospectedTable introspectedTable) {
        return true;
    }
{% endhighlight %}

	上面很容易看出,可以修改Example,PrimaryKey 的bean,还有可以操作Xml ,或者你可以修改 mybatis 3的java sql方式。
	
	参数 TopLevelClass 中提供当前操作对象的处理,比如说Example,PrimaryKey,model对象。
	你可以按照你的意愿对他进行:addField,addMethod 等方法。
	
	参数 IntrospectedTable 是提过该表的一些配置的基本信息,譬如表名,主键等信息。
	
	如果是用xml配置文件的话,应该就会用到这个 Document 了，你可以把你的分页功能添加 document中。
	id定义为  mysql_Pagination_Tail,当然你可以自己定义.供后面使用。
{% highlight java %}
@Override
	public boolean sqlMapDocumentGenerated(Document document,
			IntrospectedTable introspectedTable) {
		XmlElement rootelement = document.getRootElement();
		//TODO 分页实现,名字为 mysql_Pagination_Tail
		String template = "<sql id=\"mysql_Pagination_Tail\" >\r\n"
				+ "	<if test=\"offset !=null and limit !=null\">\r\n"
				+ "		limit #{offset} ,#{limit} \r\n" + "		 </if> \r\n"
				+ "  </sql>\r\n";
		Element groupByExample = new TextElement(template);
		rootelement.addElement(groupByExample);
		return true;
	}
{% endhighlight %}
	
	到这里往xml中添加分页,就实现了。接下来就是让SelectByExample等方法可以调用到刚刚写的分页功能。
{% highlight java %}
@Override
	@Override
	public boolean sqlMapSelectByExampleWithoutBLOBsElementGenerated(
			XmlElement element, IntrospectedTable introspectedTable) {
		XmlElement pagetail = new XmlElement("include");
		pagetail.addAttribute(new Attribute("refid", "mysql_Pagination_Tail"));
		element.addElement(pagetail);
		return true;
	}
{% endhighlight %}
	 上面的代码就实现了,在selectByExample 的最下面,添加个 limit 分页。
{% highlight xml %}
<select id="selectByExample" resultMap="BaseResultMap" parameterClass="..." >
    select
    <isParameterPresent >
      <isEqual property="distinct" compareValue="true" >
        distinct
      </isEqual>
    </isParameterPresent>
    <include refid="T_ACC_USERINFO.Base_Column_List" />
    from T_ACC_USERINFO
    <isParameterPresent >
      <include refid="T_ACC_USERINFO.Example_Where_Clause" />
      <isNotNull property="orderByClause" >
        order by $orderByClause$
      </isNotNull>
    </isParameterPresent>
    <!-- add ....-->
    <include refid="mysql_Pagination_Tail" />
  </select>
{% endhighlight %}


	这时候差不多这个插件就写完了。当然细节方面还需要自己研究一下。最后一步就是让这个插件可以跑起来。
	这里就用eclipse 插件吧。将写好的pluin 放到配置文件中。
	
{% highlight xml %}
<generatorConfiguration>
	 <context id="CoreGenconfig" targetRuntime="MyBatis3" defaultModelType="hierarchical">
		<plugin type="com.joyveb.....MysqlTestPlugin" />
		.......
		</context>  
</generatorConfiguration>
{% endhighlight %}

	这样就完成了全部的配置了,run一下eclipse 的mybatis generatr 插件,代码应该就都直接生成了。 

