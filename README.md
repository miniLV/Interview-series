![伪装成首页.jpg](https://upload-images.jianshu.io/upload_images/4563271-78c96d2cb4ee43c7.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 面试驱动技术之 - 带着面试题来找答案
- 一个NSObject 对象，占用多少内存
- 对象方法 与 类方法的存放在哪
- 什么是isa指针
- 什么是meta-class
- megsend 是如何找到方法的
```
@implementation MNSubclass

- (void)compareSelfWithSuperclass{
    NSLog(@"self class = %@",[self class]);
    NSLog(@"super class = %@",[super class]);
}
@end
```
- 输出的结果是什么
- 。。。

<br>

### *友情tips：如果上诉问题你都知道答案，或者没有兴趣知道，就可以不用继续往下看了，兴趣是最好的老师，如果没有兴趣知道这些，往下很难读得进去~*

<br>

## OC对象的本质
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

### 面试题来袭！前方请做好准备！！

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


#### 对象创建 - `alloc init`, 查找alloc底层实现

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

#### lldb 调试下，使用 `memory read` 查看对象内存

```
(lldb) p obj
(NSObject *) $0 = 0x000060000000eb90
(lldb) memory read 0x000060000000eb90
0x60000000eb90: a8 6e 3a 0b 01 00 00 00 00 00 00 00 00 00 00 00
```

也能发现，前8 位存储 `isa` 指针，后 8 位都是0，但是整个对象还是占据了 16 个字节

<br>

#### 一个NSObject内存分配示意图

![一个NSObject内存分配示意图](http://upload-images.jianshu.io/upload_images/4563271-0fd026ab7f8f05b3?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 总结：
    
- 问 ：一个NSObject 对象，占用多少内存?
- 答 ：
     -  系统在alloc的时候，分配了16个字节给 `NSObject` 对象(`malloc_size`函数获得)
     -  但是实际上 `NSObject` 只使用了 8个字节的存储空间(64bit系统下)
     -  可以通过`class_getInstanceSize()`


<br>

#### 循序渐进之面试题又来了！！

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

#### 循循序渐进之面试题双来了！！
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


## OC对象的分类
- 实例对象(instance对象)
- 类对象(class对象)
- 元类对象(meta-class对象)

<br>

### instance 对象
- 通过类 `alloc` 出来的对象
- 每次 `alloc` 都会产生新的`instance` 对象(内存不相同)
- `instance` 对象存储的信息
    - isa 指针
    - 其他成员变量

<br>

### class 对象
- 是创建对象的蓝图，描述了所创建的对象共同的属性和方法(*made in 维基百科*)
- 类在内存中只有一份，每个类在内存中都有且只有一个 `class` 对象
- `class`对象在内存中存储的信息
    - isa 指针
    - superclass 指针
    - 类的对象方法 && 协议
    - 类的属性 && 成员变量信息
    - 。。。

<br>

### meta-class

` Class metaClass = object_getClass([NSObject class]);`

- `metaclss` 是 `NSObject`的`meta-class`对象
- `meta-class` 在内存中只有一份，每个类都有且只有一个 `meta-class` 对象
- `meta-class` 也是类，与`class`的对象结构一样，但是内部的数据不一样(用途不同)
- `meta-clas` 包括:
    - isa指针
    - superclass
    - 类方法
    - 。。。

<br>


![image](http://upload-images.jianshu.io/upload_images/4563271-1b7e14a38f761d54?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

提问：`object_getClass` 与 `objc_getClass`的区别

```
Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}
```
- object_getClass ： 传入的是可以是任意对象(id类型)，返回的是类 or 元类
    - 如果传入 `instance` 对象，返回 `class `
    - 如果传入 `class`, 返回的是 `meta-class` 对象
    - 如果传入的是 `meta-class`，返回的是 `root-meta-class` 对象
<br>

```
Class objc_getClass(const char *aClassName)
{
    if (!aClassName) return Nil;

    // NO unconnected, YES class handler
    return look_up_class(aClassName, NO, YES);
}
```
- 传入的是类名字符串，返回的是该类名对应的类
- 不能返回元类



![指向图.png](http://upload-images.jianshu.io/upload_images/4563271-eb09268ab87a4671?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


(图片来自于 http://www.sealiesoftware.com/blog/archive/2009/04/14/objc_explain_Classes_and_metaclasses.html)

> 看懂这张图 - 就等价于看懂 `isa` && `superclass`了

探究流程：
```
@interface MNSuperclass : NSObject

- (void)superclassInstanceMethod;
+ (void)superClassMethod;

@end

@implementation MNSuperclass

- (void)superclassInstanceMethod{
    NSLog(@"superclass-InstanceMethod - %p",self);
}

+ (void)superClassMethod{
    NSLog(@"+ superClass-classMethod- %p",self);
}

@end

@interface MNSubclass : MNSuperclass

- (void)subclassInstanceMethod;

@end

@implementation MNSubclass

- (void)subclassInstanceMethod{
    NSLog(@"subclassInstanceMethod- %p",self);
}

@end
```

<br>

#### 问: 子类调用父类的对象方法，执行的流程是如何的？

```
MNSubclass *subclass = [[MNSubclass alloc]init];
[subclass superclassInstanceMethod];
```

- 思路：
    - `subclass` 调用对象方法，对象方法存在 `class` 中
    - 第一步，先找到 `subclass`对象,通过 `isa` 指针，找到其对应的 `MNSubclass` 类
    - 看`MNSubclass` 是否有 `superclassInstanceMethod` 方法的实现，发现没有，`MNSubclass` 沿着 `superclass` 指针找到他的父类 - `MNSuperclass`
    - 此时，`MNSuperclass` 中找到 `superclassInstanceMethod` 的实现，调用它，整个流程结束


![image](http://upload-images.jianshu.io/upload_images/4563271-08adc97b80c3923e?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



`[MNSubclass superClassMethod];`

<br>

#### 问: 子类调用父类的类方法，执行的流程是如何的？
- 思路：
    - 类方法存在`meta-class`中
    - 第一步，找到对应的`MNSubclass`,沿着`isa`指针，找到其对应的`meta-class`
    - 看`MNSubclass` 的 `meta-class` 中是否有 `superClassMethod` 方法的实现，发现没有，沿着 `superclass` 指针找到 `MNSuperclass` 的 `meta-class`
    - 发现 `MNSuperclass` 的 `meta-class` 有`superClassMethod` 方法实现，调用，流程结束


![image](http://upload-images.jianshu.io/upload_images/4563271-baf53d692b8ac300?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

<br>

#### 图中比较难理解的一根线

![image](http://upload-images.jianshu.io/upload_images/4563271-5554fa08fb461169?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 探究 : 元类对象的superclass 指针是否指向 rootclass

- 分析：
    - `meta-class` 对象存储的是类方法，`class` 存储的是 对象方法
    - 从面向对象的角度来讲，一个类调用一个类方法，不应该最后调用到 对象方法
    - 这里的`Root class` 就是 `NSObject`, 要给 `NSObject` 添加方法就要用到 `分类`
    - 验证 `NSObject` 的对象方法是否会被调用
    
<br>

```
//"NSObject+MNTest"类的声明 && 实现

@interface NSObject (MNTest)

+ (void)checkSuperclass;

@end

@implementation NSObject (MNTest)

+ (void)checkSuperclass{
    NSLog(@"+NSObject checkSuperclass - %p",self);
}

@end

//main函数中调用
int main(int argc, char * argv[]) {
    @autoreleasepool
    {
        [MNSubclass checkSuperclass];
        NSLog(@"MNSubclass = %p",[MNSubclass class]);
    }
    
    return 0;
}

--------------------------------------------------------
控制台输出：
+NSObject checkSuperclass - 0x105817040
InterView-obj-isa-class[36303:7016608] MNSubclass = 0x105817040

```
>1. 发现，调用`checkSuperclass` 类方法的，是`MNSubclass`类
>2. 这时候要验证上面那条 `meta-class` 指向 `root-class`的线, 这里的`root-class` 即等于 `NSObject`
>3. `root-class`中只存对象方法，这里，只要验证,`NSObject` 中同名的类方法实现取消，变成同名的对象方法测试，即可得出结论
>4. 声明的还是`+ (void)checkSuperclass`，实现的方法用 `- (void)checkSuperclass`对象方法替换

<br>

```
@interface NSObject (MNTest)

+ (void)checkSuperclass;

@end

@implementation NSObject (MNTest)

//+ (void)checkSuperclass{
//    NSLog(@"+NSObject checkSuperclass - %p",self);
//}

- (void)checkSuperclass{
    NSLog(@"-NSObject checkSuperclass - %p",self);
}

@end

//main函数中调用
int main(int argc, char * argv[]) {
    @autoreleasepool
    {
        [MNSubclass checkSuperclass];
        NSLog(@"MNSubclass = %p",[MNSubclass class]);
    }
    
    return 0;
}

--------------------------------------------------------
控制台输出：
-NSObject checkSuperclass - 0x101239040
InterView-obj-isa-class[36391:7022301] MNSubclass = 0x101239040

```

发现 - 调用的还是类方法 `+ (void)checkSuperclass` ，但是最终实现的，却是对象方法 `- (void)checkSuperclass` 

- 原因： 
    - `[MNSubclass checkSuperclass]` 其实本质上，调用的是发送消息方法，函数类似是`objc_msgsend([MNSubclass class], @selector(checkSuperclass))`
    - 这里的`@selector(checkSuperclass)` 并未说明是 类方法 or 对象方法
    - 所以最终走流程图的话，`root-meta-class`通过`isa`找到了`root-class` (NSObject)，
    - `NSObject` 类不是元类，存储的是对象方法，所以 最终调用了`NSObject -checkSuperclass`这个对象方法


![image](http://upload-images.jianshu.io/upload_images/4563271-8d5a450e2e10afd4?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 叮叮叮！循循循序渐进之面试题叒来了！！

```
@implementation MNSubclass

- (void)compareSelfWithSuperclass{
    NSLog(@"self class = %@",[self class]);
    NSLog(@"super class = %@",[super class]);
}
@end

调用:
    MNSubclass *subclass = [[MNSubclass alloc]init];
    [subclass subclassInstanceMethod];

```

- 问: `[self class]` && `[super class]` 分别输出什么

```
@protocol NSObject
- (Class)class OBJC_SWIFT_UNAVAILABLE("use 'type(of: anObject)' instead");
```

- 思路：
    - `class` 方法 是`NSObject` 的一个对象方法,对方方法存在 `class` 中
    - 第一步，先找到 `subclass`对象,通过 `isa` 指针，找到其对应的 `MNSubclass` 类
    - 看`MNSubclass` 是否有 `class` 方法的实现，发现没有，`MNSubclass` 沿着 `superclass` 指针找到他的父类 - `MNSuperclass`
    - 查询`MNSuperclass` 中是否有 `class` 方法的实现，发现没有，`MNSuperclass` 沿着 `superclass` 指针找到他的父类 - `NSObject`
    - 最终在 `NSObject` 中找到 `class` 的实现
    - 而调用方都是都是当前对象，所以最后输出都是 - `MNSubclass`

<br>

#### 验证:

```
NSLog(@"self class = %@",[self class]);
NSLog(@"super class = %@",[super class]);

----------------------------------------------------------------------
控制台输出:
InterView-obj-isa-class[36796:7048007] self class = MNSubclass
InterView-obj-isa-class[36796:7048007] super class = MNSubclass
```

<br>
<br>

感谢[小码哥](https://github.com/CoderMJLee) 的精彩演出，文章中如果有说错的地方，欢迎提出，一起学习~

<br>
<br>
<br>

[demo](https://github.com/miniLV/Interview-series)

*欢迎点赞fork~*

--- 

<br>

友情客串：

[小码哥](https://github.com/CoderMJLee)


[神经病院runtime入学考试](https://blog.sunnyxx.com/2014/11/06/runtime-nuts/)

[gun](https://www.gnu.org/software/libc/)

https://opensource.apple.com/tarballs/libmalloc/
https://opensource.apple.com/tarballs/objc4/
http://www.sealiesoftware.com/blog/archive/2009/04/14/objc_explain_Classes_and_metaclasses.html)
