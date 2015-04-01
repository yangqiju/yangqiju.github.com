---
layout: post
title: "Thread 泄露"
description: "线程未捕获的异常处理问题"
category: ""
tags: [Thread,Runnable,泄露,Exception]
---
	
	在线程池执行线程时,可能会遇到线程泄露的问题,在java并发编程中有提到对于很多Exception 线程池是没有捕获的，
	对于这类异常,如果没有提供任何异常处理,那么默认输出到System.err 
	Thread API中提供了 UncaughtExceptionHandler来处理这个问题.
{% highlight java %}
	public interface UncaughtExceptionHandler {
        void uncaughtException(Thread t, Throwable e);
    }
{% endhighlight %}
	我们可以通过他来处理线程发生的异常，例如输出日志，重启线程，或者修复等操作。
{% highlight java %}
	public static class LogHandler implements UncaughtExceptionHandler{
		@Override
		public void uncaughtException(Thread t, Throwable e) {
			System.out.println("线程[" + t.getName() + "]发生异常" + e);
		}
	}
{% endhighlight %}
	我们把handler投入到使用中,需要实现ThreadFactory的帮助
{% highlight java %}
	public static class TestThreadFactory implements ThreadFactory {
		@Override
		public Thread newThread(Runnable r) {
			Thread t = new Thread(r);
			t.setUncaughtExceptionHandler(new LogHandler());
			return t;
		}
	}
{% endhighlight %}
	这样当线程抛出没有捕获到的异常的时候,我们就能够通过日志去了解了,避免线程的泄露问题.
{% highlight java %}
	ExecutorService executors = Executors.newFixedThreadPool(1, new TestThreadFactory());
	executors.execute(new Runnable() {
			@Override
			public void run() {
				throw new RuntimeException();
			}
		});
{% endhighlight %}

	或者override ThreadPoolExecutor 的afterExecute 方法,帮我们打印出error信息
{% highlight java %}
	@Override
		protected void afterExecute(Runnable r, Throwable t) {
			System.out.println("after::"+t);
			super.afterExecute(r, t);
		}
{% endhighlight %}

