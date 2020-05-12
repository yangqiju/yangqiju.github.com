---
layout: post
title: "java bitset之set方法解惑"
description: "java bitset"
category: ""
tags: [java,bitset]
---


在java的Bitset中的set方法中有两个方法思考了很长时间，记录一下。

{% highlight java %}
public void set(int bitIndex) {
   if (bitIndex < 0)
       throw new IndexOutOfBoundsException("bitIndex < 0: " + bitIndex);
   //A
   int wordIndex = wordIndex(bitIndex);
   expandTo(wordIndex);
   //B
   words[wordIndex] |= (1L << bitIndex); // Restores invariants
   checkInvariants();
}

private static int wordIndex(int bitIndex) {
       return bitIndex  ADDRESS_BITS_PER_WORD;
}

private final static int ADDRESS_BITS_PER_WORD = 6;
{% endhighlight %}
在A处，wordIndex 方法中，右移6位。原因是在bitset中，记录实际数据的是long数组，
为了明确bitIndex在属于数组中的位置。对bitIndex 进行64取整。

在B处，1L << bitIndex 等同于下列代码
{% highlight java %}
int transderBits = bitIndex % 64;
words[wordsIndex] |= (1L << transferBits);
{% endhighlight %}
