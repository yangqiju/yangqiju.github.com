---
layout: post
title: "twtter 全局id snowflake 算法"
description: "twtter snowflake "
category: ""
tags: [twtter,snowflake,uuid]
---
snowflake是twtter开源的分布式全局id算法[github地址](https://github.com/twitter/snowflake)。

google能搜出很多相关内容，那我为什么还要写呢，原因是很多博客都很不责任的粘贴了来自不同地方的文章，最后拼凑在了一起，导致我刚开始看关于这个算法的时候，算法描述和展示代码完全就不是同一个内容，害得我质疑自己所学的知识。并且搜到的很多blog居然都有此类情况。

以下只作为自己对该算法的记录。

snowflake是个分布式唯一编号的方案，对于全局唯一编号，基本满足了如下内容：

- 支持分布式
- 高并发
- 长时间可用，至少10年以上吧
- 基本可排序

该算法采用了64位long类型作为基础，分成多段，代表不同的意义，如下：

| 符号位     | 时间戳     | 服务器id     |序列号    |
| :------------- | :------------- |:------------- |:------------- |
| 1位     | 41位       |10位     |12位       |

- 第一位始终是符号位，不会考虑去修改它
- 41位时间戳可代表69年的时间戳<br/>
41位最大值为：2199023255551
- 10位能代表1023个工作机
- 12位序列号能代表4095个序列号

在使用时，只需要对每台机器进行编号，即可达到分布式不重复的效果，并且通过时间戳在高位，也能满足通过时间排序的需求。

服务器id中，服务器id采用5位datacenter+5位workid的方式进行再次划分。

代码如下：

{% highlight java %}
public class IdWorker {
	private final long workerId;
	private final long datacenterId;
	// private final static long twepoch = 1288834974657L;
	private final static long twepoch = 1457936936799L;
	private long sequence = 0L;
	private final static long workerIdBits = 5L;
	private final static long datacenterIdBits = 5L;
	public final static long maxWorkerId = -1L ^ (-1L << workerIdBits);
	private final static long maxDatacenterId = -1L ^ (-1L << datacenterIdBits);
	private final static long sequenceBits = 12L;

	private final static long workerIdShift = sequenceBits;
	private final static long datacenterIdShift = sequenceBits + workerIdBits;
	private final static long timestampLeftShift = sequenceBits + workerIdBits
			+ datacenterIdBits;
	public final static long sequenceMask = -1L ^ (-1L << sequenceBits);

	private long lastTimestamp = -1L;

	public IdWorker(final long workerId) {
		this(workerId, 1);
	}

	public IdWorker(final long workerId, final long datacenterId) {
		super();
		if (workerId > maxWorkerId || workerId < 0) {
			throw new IllegalArgumentException(String.format(
					"worker Id can't be greater than %d or less than 0",
					maxWorkerId));
		}
		if (datacenterId > maxDatacenterId || datacenterId < 0) {
			throw new IllegalArgumentException(String.format(
					"datacenter Id can't be greater than %d or less than 0",
					maxDatacenterId));
		}
		this.workerId = workerId;
		this.datacenterId = datacenterId;
	}

	public synchronized long nextId() {
		long timestamp = this.timeGen();
		if (this.lastTimestamp == timestamp) {
			this.sequence = (this.sequence + 1) & sequenceMask;
			if (this.sequence == 0) {
				System.out.println("###########" + sequenceMask);
				timestamp = this.tilNextMillis(this.lastTimestamp);
			}
		} else {
			this.sequence = 0;
		}
		if (timestamp < this.lastTimestamp) {
				throw new RuntimeException(
						String.format(
								"Clock moved backwards.  Refusing to generate id for %d milliseconds",
								this.lastTimestamp - timestamp));
		}

		this.lastTimestamp = timestamp;
		long nextId = ((timestamp - twepoch) << timestampLeftShift)
				| (datacenterId << datacenterIdShift)
				| (this.workerId << workerIdShift) | (this.sequence);
		return nextId;
	}

	private long tilNextMillis(final long lastTimestamp) {
		long timestamp = this.timeGen();
		while (timestamp <= lastTimestamp) {
			timestamp = this.timeGen();
		}
		return timestamp;
	}

	private long timeGen() {
		return System.currentTimeMillis();
	}

}
{% endhighlight %}
