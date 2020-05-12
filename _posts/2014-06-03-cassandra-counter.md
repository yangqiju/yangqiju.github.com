---
layout: post
title: "Cassandra Counter delete 之后update失效的问题"
description: ""
category: ""
tags: [cassandra,counter]
---
	这两天在做项目的时候，发现Cassandra使用有点问题，所以把他记录下来，给自己提个醒，也希望也能帮到其他人。
	
	1.运行版本：Cassandra-2.0.8
	2.问题：使用Counter的delete之后，不能update。
	3.结论：Counter 对一个key进行delete之后，就不能再对这个key进行操作。
	
	实现步骤：
	1.create table
		CREATE TABLE expendbulk (key text,expend counter,PRIMARY KEY (key));
	2.insert data
		UPDATE expendbulk SET expend = expend + 1 WHERE key = 'TJ';
	3.select data
		cqlsh:lottery SELECT * FROM expendbulk ;
				key | expend
				----+-------
				TJ  | 1
	4.delte data
		DELETE from expendbulk where key = 'TJ';
	5.insert data
		UPDATE expendbulk SET expend = expend + 1 WHERE key = 'TJ';
	6.select data
		cqlsh:lottery SELECT * FROM expendbulk ;
				(0 rows)
	这样一个流程下来，这个问题就出现了，只要对这个Key进行delete之后，update就失效了。
	后来提给Cassandra提了一个关于这个的bug.
	Datastax公司的人很快回复说：这个说Cassandra对counter的正常处理。
	
---
	
(原文:[https://issues.apache.org/jira/browse/CASSANDRA-7326](https://issues.apache.org/jira/browse/CASSANDRA-7326))
	
---
	
	额。。好吧，那就是说Counter就最好不要用delete了，试了一下，truncate表没有同样的问题。
	所以。。建议大家，再用Cassandra的时候，不要踩到这个坑里面。
	另外目前Cassandra的Counter功能并支持的不要，大概看了下，官方说会开发Counter2.0，来完善它的功能。
	目前他就支持个原子的加减，不支持SetAndGet 等功能。很失望。
	
	