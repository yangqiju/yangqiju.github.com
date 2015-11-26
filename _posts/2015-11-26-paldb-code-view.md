---
layout: post
title: "linkedin 的paldb 代码赏析(一) "
description: "linkedin 的paldb 代码赏析(一)"
category: ""
tags: [linkedin,paldb,file]
---
	
前不久linkedin开源了一个名叫 paldb 的所谓db，据说速度很快，快到比  LevelDB (1.8) or RocksDB（4.0)还要五倍以上,在作者的笔记本能跑到300万每秒，具体查看[paldb](https://github.com/linkedin/PalDB)

它是一个存储kv的db，他的场景适合一次写入，之后都是查询的情况，刚好有这样的业务，所以进行了初步的代码赏析，看看大概快的原因。

看了实现，原来快速的原因是使用了java对文件的操作，加上一个良好的索引设计，让查询的速度直接就是对文件读取的速度。

对文件的操作有两种，开启java 的 memory mapping，或者不开启，默认为开启状态。

开启memory mapping，使用虚拟内存映射,示例如下：

{% highlight java %}
try(RandomAccessFile mappedFile  = new RandomAccessFile(file, "r");
		FileChannel channel = mappedFile.getChannel();){
			MappedByteBuffer mbb  = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
			mbb.position(num);
			mbb.get(bytes);
		}
{% endhighlight  %}

没有开启内存映射，直接使用RandomAccessFile，示例如下：

{% highlight java %}
try(RandomAccessFile mappedFile  = new RandomAccessFile(file, "r")){
	mappedFile.seek(num);
			byte[] bytes = new byte[25];
				mappedFile.read(bytes);
		}
{% endhighlight  %}

实际操作也就上面两种方式，但是加上巧妙的设计，他就变成了高效的数据查询db了。

我对这两种文件读取方式进行了简单的测试，条件如下

{% highlight java %}
1000万条数据
25byte
1个线程
ssd固态
2核心 Intel(R) Core(TM) i5-3320M CPU @ 2.60GHz
{% endhighlight %}

测试结果表明，使用内存映射时，效率能达到640万TPS以上，直接使用RandomAccessFile 效率达到150万以上。
所以使用MappedByteBuffer效率是高了不少。

paldb还使用了LinkedHashMap进行缓存实现让查询更加快速，使用snappy进行数据压缩。特别的索引的使用，
很值得学习。
	
