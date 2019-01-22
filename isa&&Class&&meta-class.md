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


--- 

<br>

友情客串：

[小码哥](https://github.com/CoderMJLee)

[神经病院runtime入学考试](https://blog.sunnyxx.com/2014/11/06/runtime-nuts/)

[gun](https://www.gnu.org/software/libc/)

[www.sealiesoftware.com](http://www.sealiesoftware.com/blog/archive/2009/04/14/objc_explain_Classes_and_metaclasses.html)
