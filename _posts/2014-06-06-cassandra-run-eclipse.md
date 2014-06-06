---
layout: post
title: "Running Cassandra In Eclipse "
description: ""
category: ""
tags: [cassandra,eclipse]
---
	最近在Cassandra中发现一些问题，然后就打算调试一下Cassandra。
	在官网上有RuningCassandraInEclipse的指导，但是总有些小问题。这里把他记录下来。
	
	官方需要在本机安装ANT，并配置环境变量。
	我自己在电脑上没有下载ANT，用Eclipse自带了ANT功能完成了类似的功能。
	
	Step:
	1.首先下个Cassandra的source包(http://cassandra.apache.org/download/)
	2.下载后解压(example path: E:\apache-cassandra-2.0.8-src)
	3.eclipse中新建项目:
		-->New
		-->Java Project-->
		-->Project Name:cassandra-->
		-->取消Use default location的选择-->
		-->location中写刚刚解压的path-->
		-->Next-->
		-->勾选Allow output folders for soure folders-->
		-->Default output folder中写cassandra/build/classes/main-->
		-->Finsh
	4.找到build.xml --> 
		-->Run As --> 
		-->Ant Build(点第一个,默认jar,会下载包)-->
		-->设置项目Java Compiler:1.6或1.7-->
		-->再次build.xml-->
		-->Run As-->
		-->Ant Build(第二个，选择：build, generate-eclipse-files, jar)-->
		-->把项目刷新 重新编译。ok了。
	5.在项目conf 中修改 cassandra.yaml 配置。(data,commitlog,save_cached..)
		Run CassandraDaemon 这个类，Run Configuratoins 
		VM arguments:
		-Dstorage-config=(conf地址)
		-Dcassandra-foreground 
		-ea -Xmx1G
		-Dlog4j.configuration=file:(conf地址)\log4j-server.properties
	6.Run..
	
	这样的话应该就能启动Cassandra了。我在本机能通过，不知道在别人那会不会有问题，
	
---	
	
官方[http://wiki.apache.org/cassandra/RunningCassandraInEclipse](http://wiki.apache.org/cassandra/RunningCassandraInEclipse)
					
---

