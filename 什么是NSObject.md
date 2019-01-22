# OC对象的本质

---

我们平时编写的Objetcive-C,底层实现都是C/C++实现的
![image](http://upload-images.jianshu.io/upload_images/4563271-21c7bda6f74b2c42?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 问 : Objetcive-C 基于 C/C++ 实现的话，Objetcive-C 对象相当于C/C++ 中的什么数据结构呢？

```
@interface MNPerson : NSObject
{
    int _age;
    double _height;
    NSString *name;
}
```

以`MNPerson`为例，里面的成员变量有不同类型是，比如`int`、`double`、`NSString` 类型，假如在C/C++ 中用`数组`存储，显然是不太合理的

- 答: C/C++中用 `结构体` 的数据格式，表示oc对象。

```
// 转成c/c++ 代码后，MNPerson 的结构如下

struct NSObject_IMPL {
	Class isa;
};

struct MNPerson_IMPL {
	struct NSObject_IMPL NSObject_IVARS;
	int _age;
	double _height;
	NSString *name;
};
```

> 使用指令 `xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc oc源文件 -o 输出的c++文件`
将 `oc` 代码转成 `c++` 代码之后，发现内部确实是结构体

<br>

---

## 面试题来袭！前方请做好准备！！

- 一个NSObject 对象，占用多少内存

- 思路：
    - 1. 由上面可知，`NSObject`的本质是结构体，通过`NSObject.m` 可以发现，`NSObject` 只有一个 `isa` 成员，`isa` 的本质是 `class`, `struct objc_object *` 类型，所以应该占据 8 字节
    - 2.`NSLog(@"%zu",class_getInstanceSize([NSObject class]));` 输出 - size = 8

- 注意！实际上，

```
{
    //获得 - NSObject 一个实例对象的成员变量所占用的大小 >> 8
    NSLog(@"%zu",class_getInstanceSize([NSObject class]));
    
    NSObject *obj = [[NSObject alloc]init];
    // 获取 obj 指针，指向的内存大小 >> 16
    NSLog(@"%zu",malloc_size((__bridge const void *)obj));
}
```

```
//基于 `objc-class.m` 文件 750 版本

size_t class_getInstanceSize(Class cls)
{
    if (!cls) return 0;
    return cls->alignedInstanceSize();
}

// Class‘s ivar size rounded up to a pointer-size boundary.
// 点击一下 - 智能翻译 ==> （返回类的成员变量所占据的大小）

uint32_t alignedInstanceSize() 
{
    return word_align(unalignedInstanceSize());
}
```


[opensource 源码](https://opensource.apple.com/tarballs/)


### 对象创建 - `alloc init`, 查找alloc底层实现

```
size_t instanceSize(size_t extraBytes) {
    size_t size = alignedInstanceSize() + extraBytes;
    // CF requires all objects be at least 16 bytes.
    if (size < 16) size = 16;
    return size;
}
```

> - `CoreFoundation` 硬性规定，一个对象，至少有 16 字节
> - 以 `NSObject`为例，这里传入的 `size` 是 `alignedInstanceSize`, 而`alignedInstanceSize` 已经知道 = 8, 8 < 16,retun 16, 最终 NSObject 创建的对象，占据的内存大小是 16


<br>

### lldb 调试下，使用 `memory read` 查看对象内存

```
(lldb) p obj
(NSObject *) $0 = 0x000060000000eb90
(lldb) memory read 0x000060000000eb90
0x60000000eb90: a8 6e 3a 0b 01 00 00 00 00 00 00 00 00 00 00 00
```

也能发现，前8 位存储 `isa` 指针，后 8 位都是0，但是整个对象还是占据了 16 个字节

<br>

### 一个NSObject内存分配示意图

![一个NSObject内存分配示意图](http://upload-images.jianshu.io/upload_images/4563271-0fd026ab7f8f05b3?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 总结：
    
- 问 ：一个NSObject 对象，占用多少内存?
- 答 ：
     -  系统在alloc的时候，分配了16个字节给 `NSObject` 对象(`malloc_size`函数获得)
     -  但是实际上 `NSObject` 只使用了 8个字节的存储空间(64bit系统下)
     -  可以通过`class_getInstanceSize()`


<br>

### 循序渐进之面试题又来了！！

```
@interface MNStudent : NSObject
{
    int _age;
    int _no;
}
@end
```

- 问:一个MNStudent 对象，占用多少内存
- 答: 
    - 由上面 `NSObject`占据16个字节可知，base = 16
    -  一个int占4字节，age = 4， no = 4
    -  最终结果， 16 + 4 + 4 = 24！
    
![image](http://upload-images.jianshu.io/upload_images/4563271-03d4237d5e54005f?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

*哈哈！中计了！*

![image](http://upload-images.jianshu.io/upload_images/4563271-7978dbb47c0a4286?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

原理解释：

![image](http://upload-images.jianshu.io/upload_images/4563271-4ffee21e94d8ad99?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 1. 之前 `NSObject` 创建一个对象，确实是分配了 16 个字节的空间
> 2. 但是，他还有未使用的空间8个字节，还是可以存储的
> 3. 这里的`age` && `no` 存进去，正好 `16`,之前分配的空间正好够用！所以答案是 16！
 
<br>

### 循循序渐进之面试题双来了！！
(大哥别打了，这次保证不挖坑了，别打，疼，别打脸别打脸。。。)

```
@interface MNPerson : NSObject
{
    int _age;
    int _height;
    NSString *name;
}
```

- 问:  一个`MNPerson`对象，占用多少内存
- 答: 这题我真的会了！上面的坑老夫已经知道了！
    - 默认创建的时候，分配的内容是16
    - `isa` = 8, `int age` = 4, `int height` = 4, `NSString` = char * = 8
    -  最终分配: 8 + 4 + 4 + 8 = 24


![image](http://upload-images.jianshu.io/upload_images/4563271-ccfa1407c65170cc?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

哈哈哈哈！ 又中计了！


![image](http://upload-images.jianshu.io/upload_images/4563271-2984c712cdb346c7?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

<br>

这时候你肯定好奇了

```
    uint32_t alignedInstanceSize() {
        return word_align(unalignedInstanceSize());
    }

    
    size_t instanceSize(size_t extraBytes) {
        size_t size = alignedInstanceSize() + extraBytes;
        // CF requires all objects be at least 16 bytes.
        if (size < 16) size = 16;
        return size;
    }
    
```

> - `extraBytes` 一般都是 0，这里可以理解为 `size = alignedInstanceSize()`；
> - `alignedInstanceSize = class_getInstanceSize`, `class_getInstanceSize` 由上图的log信息也可以知道 = `24`
> - 内心os: who tm fucking 32?


![image](http://upload-images.jianshu.io/upload_images/4563271-c7bddeced8471c44?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


[ios内存分配源码](https://opensource.apple.com/tarballs/libmalloc/)

```
下载`libmalloc`,找到`calloc`的实现

void *
calloc(size_t num_items, size_t size)
{
	void *retval;
	retval = malloc_zone_calloc(default_zone, num_items, size);
	if (retval == NULL) {
		errno = ENOMEM;
	}
	return retval;
}

发现这个函数，就是我们调用的`calloc`函数的底层

void *
malloc_zone_calloc(malloc_zone_t *zone, size_t num_items, size_t size)
{
	MALLOC_TRACE(TRACE_calloc | DBG_FUNC_START, (uintptr_t)zone, num_items, size, 0);

	void *ptr;
	if (malloc_check_start && (malloc_check_counter++ >= malloc_check_start)) {
		internal_check();
	}

	ptr = zone->calloc(zone, num_items, size);
	
	if (malloc_logger) {
		malloc_logger(MALLOC_LOG_TYPE_ALLOCATE | MALLOC_LOG_TYPE_HAS_ZONE | MALLOC_LOG_TYPE_CLEARED, (uintptr_t)zone,
				(uintptr_t)(num_items * size), 0, (uintptr_t)ptr, 0);
	}

	MALLOC_TRACE(TRACE_calloc | DBG_FUNC_END, (uintptr_t)zone, num_items, size, (uintptr_t)ptr);
	return ptr;
}

```

内心os: exo me? 这传入的 `size_t size = 24`,怎么返回32的？？

#### 涉及到 - 内存对齐

检索`Buckets` - (libmalloc 源码)

```
#define NANO_MAX_SIZE			256 
/* Buckets sized {16, 32, 48, ..., 256} */
```


> 1. 发现，iOS 系统分配的时候，有自己的分配规则, 不是说你需要的size多大，就创建多大
> 2. 操作系统内部有自己的一套规则，这里的都是 16 的倍数，而操作系统在此基础之上，操作系统的操作访问最快
> 3. 所以，在`MNPerson` 对象需要 24 的size的时候，操作系统根据他的规则，直接创建了 32 的size的空间，所以这里的答案是 32！


![image](http://upload-images.jianshu.io/upload_images/4563271-85cdba9dd850a245?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

<br>

补充说明: `sizeof` 运算符
```
(lldb) po [obj class]
MNPerson

(lldb) po sizeof(obj)
8

(lldb) po sizeof(int)
4
```

> - `sizeof`是运算符，不是函数，编译时即知道，不是函数
> - 这里的 `obj` 是对象， *obj - 指针指向，编译器知道他是指针类型，所以 sizeof = 8(指针占据8个字节) - 特别注意，这里传入的不是对象！是指针
> - `sizeof`是告诉你传入的类型，占多少存储空间




<br>

--- 

*欢迎点赞fork~*

<br>

友情客串：

[小码哥](https://github.com/CoderMJLee)

[gun](https://www.gnu.org/software/libc/)

[libmalloc](https://opensource.apple.com/tarballs/libmalloc/)

[objc4](https://opensource.apple.com/tarballs/objc4/)

