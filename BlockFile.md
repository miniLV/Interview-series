# Block

> 面试驱动技术合集（初中级iOS开发），关注仓库，及时获取更新 [Interview-series](https://github.com/miniLV/Interview-series)

![](https://user-gold-cdn.xitu.io/2019/3/10/16967d7dc4bb1e67?w=1360&h=896&f=jpeg&s=158902)

Block 在 iOS 算比较常见常用且常考的了，现在面试中，要么没面试题，有面试题的，基本都会考到 block 的点。

先来个面试题热热身，题目: **手撕代码 - 用Block实现两个数的求和**

*(这题如果会的，block基础知识可以跳过了，直接到* Block原理探究）



####  简单介绍block入门级用法

Block结构比较复杂，一般用 typedef 定义，直接调用的感觉比较简单、清晰易懂

```
//typedef block的时候有提示
typedef void(^MNBlock)(int);

@interface ViewController ()

@property (nonatomic, copy) MNBlock block;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //直接用self.block调用
    self.block = ^(int a) {
        //dosomething...
    };
}
```

- **参数解释:**

`typedef <#returnType#>(^<#name#>)(<#arguments#>);`


![](https://user-gold-cdn.xitu.io/2019/3/6/16952561d5d28953?w=838&h=281&f=png&s=378402)


**题目: 手撕代码 - 用Block实现两个数的求和**

*日常开发中，block声明一般写的比较多，实现一般是靠Xcode自动补全提示出现的，手撕代码的情况下，等号右侧的block实现要怎么写？*

声明:
```
typedef int(^MNBlock)(int a, int b);

@interface ViewController ()

@property (nonatomic, copy) MNBlock sum;
```

Vip补全功能:

![](https://user-gold-cdn.xitu.io/2019/3/6/1695258327b5d40d?w=338&h=41&f=png&s=4862)

纸上按Enter没用啊兄弟！看来还是需要了解一下Block右边的东西~

先在 Xcode上按下 Enter，了解下再撕
![](https://user-gold-cdn.xitu.io/2019/3/6/16952597e5c08f81?w=1251&h=80&f=png&s=13055)

```
^int(int a, int b) {
    //Control reaches end of non-void block    
    因为返回值是int类型，所以这里需要返回
}
```

![](https://user-gold-cdn.xitu.io/2019/3/6/169526002706cf63?w=926&h=516&f=png&s=681574)


```
int(^Sum)(int, int) = ^(int a, int b){
    return a + b;
};
int result = Sum(5, 10);
```


![](https://user-gold-cdn.xitu.io/2019/3/6/16952676c9db9951?w=1030&h=285&f=png&s=504069)



#### Block的坑出现！新手可能会写错的地方

1.声明出错 - `void ^(testBlock)`

![](https://user-gold-cdn.xitu.io/2019/3/6/169526924a0616d0?w=713&h=91&f=png&s=14053)


修正版：

```
void (^testBlock)() = ^{
    
};
```
block的声明，^ 和 blockName 都是在小括号里面！！


2.block各种实现的参数问题

声明`typedef int(^MNBlock)(int, int);`


![](https://user-gold-cdn.xitu.io/2019/3/6/169526c0aac25322?w=773&h=180&f=png&s=39960)

```
    self.sum = ^int(int a, int b) {
        return a + b;
    };
```

这里要注意，block声明里面只有参数类型，没有实际参数的话，Xcode提示也只有参数，这里涉及到形参和实参的问题

声明是形参，可以不写参数，但是使用的时候，必须有实际参数，才可以进行使用，所以这里需要实参，可以在 `^int(int , int)` 中手动添加实参`^int(int a, int b)`，就可以让a 和 b 参与运算

小tips：实际开发中，建议声明的时候，如果需要带参数，最好形参也声明下，这样使用Xcode提示的时候，会把参数带进去，方便得多~(踩过坑的自然懂！)




3. 省略void导致看不懂block结构的 *(正常是两个void导致局面混乱)*

```
//声明
typedef void(^MNBlock)(void);

//实现
self.sum = ^{
    //dosomething...
};

```

这种情况下，能知道怎么省略的，声明里两个void，能知道怎么对应的吗？

这个其实比较简单，block不管声明 or 实现，最后一个小括号，里面都是参数，而参数是可以省略的！

而为了把声明的两个void区分开，返回值 or 参数区分开，其实就ok了

参数非void的例子
```
//声明非void的参数
typedef void(^MNBlock)(int a);

//实现就必须带参数，不可省略！
self.sum = ^(int a) {
    
}
```

参数void的例子 ==> 参数可以省略
```
typedef int(^MNBlock)(void);

self.sum = ^{
    //声明的返回值类型是int，所以一定要return；
    return 5;
};
```

其实-返回值是void的，也可以不省略
```
typedef void(^MNBlock)(void);

//实现的返回值不省略
self.sum = ^void () {
    
};

```

参数是void的省略:
```
typedef int(^MNBlock)();

//实现里面，没有参数，就可以不写()
self.sum = ^int{
    return 5;
}
```

**注意！！ 声明里面的返回值void是不可以省略的！！**

![](https://user-gold-cdn.xitu.io/2019/3/7/16956f058259665d?w=403&h=88&f=png&s=13283)


4. 小箭头^混乱的问题,到底放小括号内还是小括号外

声明是 `int(^MNBlock)(int a , int b)`

实现是 `^int(int a, int b)`

注意，这里箭头之后的，不管是多写() 还是少写，都会出错

![](https://user-gold-cdn.xitu.io/2019/3/6/1695278e3061b90d?w=1020&h=103&f=png&s=23020)

![](https://user-gold-cdn.xitu.io/2019/3/6/16952795f17d3bb9?w=1038&h=191&f=png&s=32246)

> 所以这里还不能死记，比如不管声明还是实现,死记 (^ xxx) 是没问题的 or 死记 ^…… xxx 不加括号是没问题的,在这里都行不通，只能靠脑记了

这时候，就需要用到巧记了！

*^ 和小括号组合的，一共有三种情况*

- 一种是声明的，`void(^MNBlock)`
- 一种是实现的，`^int(int a,)`
- 还一种 `^(int a)`

兄弟，看到这你还不乱吗！！


![](https://user-gold-cdn.xitu.io/2019/3/7/16956e251f2c8ce3?w=222&h=227&f=jpeg&s=6734)

怎么记看这里，
- 手写分为两个部分，block等号左边 or 等号右边的，左边为声明，右边为实现区分开
- 声明记住：^后面跟blockName，他们需要包起来！ (^blockName),只有声明会用到blockName，先记住一点，如果有blockName，要和^一起，用小括号包起来
- 实现又分为两种：
    - `^int`:^后面跟的是返回值类型
      - ^ 直接跟类型，不用加"( )" ==> `^int`
    - `^(int a)`:^后面直接跟参数 *(返回值是void)*。
        - 参数都是要用"( )"包起来的，如果^后面跟参数，就得用"( )" ==> `^(int a)`,
        - 实现里，肯定有实际参数，这时候，参数类型和实参，就得用( )包起来

### ^与小括号纠缠的总结

- ^ 后面仅跟类型，不需要小括号，==> `^int`
- ^ 后面跟参数，参数需要小括号 ==> `^(int a)`
- ^ 后面跟block名称，^和blockName需要小括号 ==> `void (^MNBlock)`

<br>



## Block原理探究 

```objective-c
void (^MNBlock)(void) = ^(void){
    NSLog(@"this is a Block~ rua~");
};
MNBlock();
```



 使用 `xcrun  -sdk  iphoneos  clang  -arch  arm64  -rewrite-objc main.m` 转成 C++ 代码, 查看底层结构



```objective-c
//对应上面的 MNBlock声明
void (*MNBlock)(void) = (&__main_block_impl_0(__main_block_func_0,
                                                      &__main_block_desc_0_DATA));
        
//对应上面的 MNblock() 调用
MNBlock->FuncPtr(MNBlock);
```



```objective-c
//block声明调用的 - __main_block_impl_0
struct __main_block_impl_0 {
  //结构体内的参数
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  
  //c++中的构造函数，类似于 OC 的 init 方法，返回一个结构体对象
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
}
```



这里的block封装的函数调用解释`MNBlock->FuncPtr(MNBlock);`

MNBlock 其实内部结构是 `__main_block_impl_0`，

```
struct __main_block_impl_0 {

  //函数调用地址在这个结构体内
  struct __block_impl impl;

  struct __main_block_desc_0* Desc;
  }
  
  struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  //函数调用地址在这里
  void *FuncPtr;
};
```

内部只有两个参数，一个`impl`，一个`Desc`，而函数的调用地址 - `FuncPtr`是再`impl`中的，为什么这里能直接这样写呢？

> 因为，__main_block_impl_0 结构的地址和他的第一个成员一样，第一个成员的地址是__block_impl，所以__main_block_impl_0 和 __block_impl 的地址其实是同一个，通过格式强制转换，将 main_block_impl_0 转成 block_impl 就可以直接拿到他内部的 FuncPtr 函数地址，然后进行调用！



![image-20190307213258239](https://user-gold-cdn.xitu.io/2019/3/8/1695da89a57989cf?w=1489&h=1080&f=jpeg&s=303137)



- 可见- block本质上是OC对象，内部有一个isa指针

- block是封装了函数调用已经函数调用的oc对象

  

### Block面试题抛砖引玉~

**开胃菜先来一下，以下结果输出什么**

```
int a = 10;
void (^MNBlock)(void) = ^{
    NSLog(@"a = %d",a);
};
a += 20;

MNBlock();
```



调用 `MNBlock();` 之前，a 已经 + 20了，输出30？ 太天真了兄弟，这里涉及到capture的概念，即变量捕获



### Block捕获变量(capture)

捕获：Block内部会新增一个成员，来存储传进来的变量



![image-20190307214010613](https://user-gold-cdn.xitu.io/2019/3/8/1695da89a686ef14?w=1988&h=586&f=jpeg&s=141880)

block 内部直接捕获了穿进去的这个变量a(10)

![image-20190307214351958](/Users/liangyuhang/Library/Application Support/typora-user-images/image-20190307214351958.png)



创建block的时候，已经将变量a=10 捕获到 block内部，之后再怎么修改，不会影响block 内部的  a



**auto 和 static的区别**:以下会输出什么~ 

```
static int b = 10;
void (^MNBlock)(void) = ^{
    NSLog(@"a = %d, b = %d",a,b);
};
a = 20;
b = 20;

MNBlock();
```

输出

```
2019-03-07 21:49:49 Block-Demo a = 10, b = 20
```



why?

查看原因:

```
auto int a = 10;
static int b = 10;
void (*MNBlock)(void) = (&__main_block_impl_0(__main_block_func_0,
                                              &__main_block_desc_0_DATA,
                                              a,
                                              &b));
```



发现：两种变量，都有捕获到block内部。

a 是auto变量，走的是值传递，

b 是 static 变量，走的是地址传递，所以会影响(指针指向同一块内存，修改的等于是同个对象)



**总结**

- 只有局部变量才需要捕获，
- 全局变量不需要捕获，因为在哪都可以访问
- 需不需要捕获，其实主要是看作用域问题
- auto局部变量 ==>值传递->因为会销毁
- static局部练练==>不会销毁==>所以地址传递



**看图就行~**

![image-20190307220857223](https://user-gold-cdn.xitu.io/2019/3/8/1695da89a7997ead?w=1566&h=1012&f=jpeg&s=247371)



**进阶考题 - self 会被捕获到 block 内部吗**

```
void (^MNBlock)(void) = ^{
    NSLog(@"p = %p",self);
};
```



模拟看官作答：不会，因为整个类里，都能调用self，应该是全局的，全局变量不会捕获到block中



哈哈哈哈！中计了！其实 self 是参数(局部变量)



```
struct __MNDemo__test_block_impl_0 {
  struct __block_impl impl;
  struct __MNDemo__test_block_desc_0* Desc;
  MNDemo *self; ==> 捕捉到了兄弟
  }
```



> 解释原因：
>
> - 每个OC函数，其实默认有两个参数，一个self，一个_cmd，只是他们倆兄弟默认是隐藏的
> - 而由于他们是参数，所以是局部变量，局部变量就要被 block 捕获
> - `- (void)test(self, SEL _cmd){XXX}` 默认的OC方法里面其实有这两个隐藏的参数！所以上题的答案，self是会被block捕获的！**（能听懂掌声！）**



**进进阶考题 - 成员变量_name 会被捕获到 block 内部吗**



```
void (^MNBlock)(void) = ^{
    NSLog(@"==%@",_name);
};
```

模拟看官作答：呵呵，老子都中了这么多次技了，这题学会了！！ 因为_name是成员变量，全局的，也没有self，所以不需要捕获整个类就都可以随便访问它！



哎，兄弟，还是太年轻了！！

```
void (^MNBlock)(void) = ^{
    NSLog(@"==%@",self->_name);
};
```

看图说话，不多bb, *（能听懂掌声！）*



## Block的类型

- `__NSGlobalBlock__`

- `__NSStackBlock__`

- `__NSMallocBlock__`



MRC环境下

```
void (^global)() = ^{
    NSLog(@"globalValue = %d",globalValue);
};

void (^autoBlock)() = ^{
    NSLog(@"this is a Block~ rua~ = %d",a);
};

void (^copyAuto)() = [autoBlock copy];

--------------------------------------------
print class
2019-03-08 17:40:43 Block-Demo

 global class = __NSGlobalBlock__ 
 autoBlock class = __NSStackBlock__ 
 copyAuto = __NSMallocBlock__
```



总结:

![image-20190308174640436](/Users/liangyuhang/Library/Application Support/typora-user-images/image-20190308174640436.png)


![](https://user-gold-cdn.xitu.io/2019/3/8/1695daddd8d9af3c?w=1482&h=920&f=png&s=1979727)



栈上的内存系统会自动回收

- 栈空间的block 不会对 对象进行强引用
- 堆空间的block 可能会对对象产生强引用：
  - 如果是weak指针，不会强引用
  - 如果是strong指针，会强引用

堆上的内存是由程序员控制，所以一般将block 拷贝到堆上，让程序员控制他与内部变量的生命周期



题目：以下输出的顺序是什么(ARC环境下)

```
@implementation MNPerson

- (void)dealloc{
    NSLog(@"MNPerson - dealloc");
}

@end

--------------------------------------

MNPerson *person = [[MNPerson alloc]init];

__weak MNPerson *weakPerson = person;

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    NSLog(@"1-----%@",person);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"2------%@",weakPerson);
    });
    
});

NSLog(@"touchesBegan");
```



输出结果

```
2019-03-08 22:38:59.038452+0800 touchesBegan
2019-03-08 22:39:00.056746+0800 1-----<MNPerson: 0x604000207840>
2019-03-08 22:39:00.057891+0800 MNPerson - dealloc
2019-03-08 22:39:02.058011+0800 2-----(null)
```

解释：

1. gcd的block会自动对auto变量进行copy操作

2. block内部对 auto 变量的强弱引用，取决于指针类型

3. 1 中的auto变量是 person，没声明默认对象是 strong 类型，所以 gcd1 会对 person进行 1s的强引用

4. gcd2 中的变量是 weakPerson，看到是__wesk指针，所以block内部不会对其产生强引用

5. 随后，gcd1 对 person进行1s的强引用之后，gcd1 的block销毁，person对象销毁，打印MNPerson dealloc

6. 最终，2s过后打印 2——weakPerson，因为person对象在gcd1 block结束之后，释放掉了，所以此时person是空，因为是weak指针，对象是null不会crash，最终打印null



#### 对象类型的auto变量

- 当 block 内部访问了对象类型的auto变量时	
  - 如果block在展示，不会对 auto 变量产生强引用
  - 如果 block 被 拷贝到堆上
    - 会调用 block 内部的 copy 函数
    - copy 函数内部会调用 _Block_object_assign 函数
    - _Block_object_assign 函数会根据auto变量的修饰符 *( strong、 weak、unsafe_unretained )* 做出对应的操作，看对内部auto变量进行强引用还是弱引用(类似于 retain)
  - 如果 block 从 堆上移除
    - 会调用 block 内部的 dispose 函数
    - dispose函数内部会调用_Block_object_dispose 函数
    - _Block_object_dispose 类似于 release，会对auto变量进行自动释放(当引用计数器=0的时候 )

![image-20190308173027757](/Users/liangyuhang/Library/Application%20Support/typora-user-images/image-20190308173027757.png)



#### block中的copy

- 在ARC环境下，编译器会根据情况，自动将栈上的block拷贝到堆上，比如以下几种情况
  - block 作为函数返回值的时候
  - 将block复制给__strong指针的时候
  - block作为Cocoa API中方法名含有usingBlock的方法参数事
    - 比如：`[array enumerateObjectsUsingBlock:XXX]`



### __block 修饰符的使用



题目：以下代码的是否编译通过，可以的话输出结果是什么

```
int a = 10;
void (^block)() = ^{
    a = 20;
    NSLog(@"a = %d",a);
};
```



结果如下：

![image-20190308225448279](https://user-gold-cdn.xitu.io/2019/3/8/1695dee6803c470f?w=1770&h=280&f=jpeg&s=75077)

*思考：无法编译，为啥呢？编译的时候，block应该是会把auto变量捕获进去的，那block结构中应该有a才对啊*



```
//main函数
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        int a = 10;
        void (*block)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, a));

    }
    return 0;
}

//block执行地址
  static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int a = __cself->a; // bound by copy
  NSLog((NSString *)&__NSConstantStringImpl__var_folders_kh_0rp73c0s2mvfp5gjf25j5y6h0000gn_T_main_1a12fa_mi_0,a);}
```



block执行的时候，内部是 `__main_block_func_0` 函数，而a的声明，是在`main`函数，两个函数相互独立，对于他们来说，a都是一个局部变量，而且两个函数中都对a初始化，两个函数的中a不是同一个，那怎么可以在 执行函数中，修改main函数中的局部变量呢，所以编译报错！



如何改？



- **方案一：使用static**

```
static int a = 10;
void (^block)() = ^{
    a = 20;
    NSLog(@"a = %d",a);
};
```



因为static修饰的auto变量，最终在block中进行的不是值传递，而是地址传递，措意执行函数中的a 和 main 函数中的a，是同一个地址 ==> 等于同一个a，所以可以修改，输出20



但是使用static，就会变成静态变量，永远在内存中



- **方案二： 使用__blcok**

```
__block auto int a = 10;
void (^block)() = ^{
    a = 20;
    NSLog(@"a = %d",a);
};
```



```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_a_0 *a; // by ref ==> auto的话，是int a，__block，变成对象了
}
```



```
struct __Block_byref_a_0 {
  void *__isa;
__Block_byref_a_0 *__forwarding;==> 指向自己的结构体
 int __flags;
 int __size;
 int a; ==> 10在这里
};
```

a = 20;最终转成 `(a->__forwarding->a) = 20;`

> 解释下：__forwarding  是指向结构体本身的指针，等价于a本身，其实就是通过a的结构体指针，拿到里面的成员a，再对他赋值
>
> 指针传递，所以可以修改 auto 变量，通过block，间接引用 auto 变量



![image-20190309205908169](https://user-gold-cdn.xitu.io/2019/3/9/16962f6575523772?w=1526&h=978&f=jpeg&s=287383)



#### __block的内存管理

- 当 block 在栈上的时候，不会对内部的__block 变量产生强硬有
- 当 block 从栈上被 copy 到堆上的时候
  - 会调用block内部的copy函数
  - copy函数内部会调用_Block_object_assign 函数
  - _Block_object_assign 函数会对 __block 变量进行一次 retain操作，产生强引用



抄图分析 :

![image-20190309210956453](https://user-gold-cdn.xitu.io/2019/3/9/16962f6581a28a56?w=832&h=400&f=jpeg&s=27226)

![image-20190309211009229](https://user-gold-cdn.xitu.io/2019/3/9/16962f657a06fcdf?w=954&h=394&f=jpeg&s=28143)



- 当block从堆中移除时
  - 会调用 block 内部的 dispose 函数
  - dispose内部会调用_Block_object_dispose函数
  - _Block_object_dispose函数会对`__block`变量进行一次release操作，如果retainCount为0，自动释放该__block变量



![image-20190309211246277](https://user-gold-cdn.xitu.io/2019/3/9/16962f6579f78ec5?w=754&h=388&f=jpeg&s=20257)

![image-20190309211257030](https://user-gold-cdn.xitu.io/2019/3/9/16962f657a5060f1?w=1018&h=438&f=jpeg&s=41360)

**总结：**

- block在栈上的时候，不会对内部的变量产生强引用
- 当block从栈上 copy 到堆上的时候，内部都会调用 __Block_object_assign
  - 如果是`__block`修饰的变量，会__block修饰的对象产生强引用
  - 如果是普通auto变量，看修饰的指针类型是strong 还是 weak(unsafe_unretained)
    - strong修饰的，block就会对内部的auto变量产生强引用
    - weak修饰的，block就不会对内部的auto变量产生强引用
  - 特别注意！上述条件仅在ARC环境下生效，如果是MRC环境下，block不会对内部auto变量产生强引用！**(MRC下不会进行retain操作)**
- 当block从堆上移除的时候，内部会调用`__Block_object_dispose `函数，相当于对`block`内部所持有的对象进行移除release操作，如果retainCount为0，自动释放该__block变量



#### __block中的 _ forwarding 指针

内存拷贝的时候，如果block从栈被copy到堆上，肯定也希望内部的变量一起存储到堆上(让变量的生命周期可控，才不会被回收)



加入变量a在栈上，在栈上的指针，指向堆上的 block，堆上的block的 forwarding指向他自己，就可以保证，修改&获取的变量，都是堆上的变量

![image-20190309213120820](https://user-gold-cdn.xitu.io/2019/3/9/16962f657a64e5e6?w=1404&h=1046&f=jpeg&s=83580)

最终，__block指向的变量，是指向堆上的



#### __block 修饰的类型



```
@implementation MNObject

- (void)dealloc{
    NSLog(@"MNObject - dealloc");
}

@end


--------------------------------------------

typedef void (^MNBlock)();

MNBlock block;
{
    MNObject *obj = [[MNObject alloc]init];
    __block __weak MNObject *weakObj = obj;
    
    block = ^{
        NSLog(@"----------%p",weakObj);
    };
}
block();

```



问，上述代码的输出顺序是？

```
2019-03-09 21:57:56.673296+0800 Block-Demo[72692:8183596] MNObject - dealloc
2019-03-09 21:57:56.673520+0800 Block-Demo[72692:8183596] ----------0x0
```



解释：ARC下

![image-20190309220353476](https://user-gold-cdn.xitu.io/2019/3/9/16962f65b2fe9473?w=1444&h=922&f=jpeg&s=274783)



上述代码，block 持有的是 weakObj，weak指针，所以block内部的__block结构体，对他内部持有的person不强引用！所以出了 小括号后，person没有被强引用，生命gg，先dealloc，输出`dealloc`，之后进行block调用，打印 ---------



**特别注意，上述逻辑进在ARC下，如果在MRC下，中间结构体对象，不会对person 进行retain操作! 即便 person 是强指针修饰，也不会对内部的person对象进行强引用！**



MRC环境下

```
MNBlock block;
{
    MNObject *obj = [[MNObject alloc]init];
    block = [^{
        NSLog(@"----------%p",obj);
    }copy];
    
    [obj release];
}
block();

[block release];

--------------------
输出:
2019-03-09 21:59:56.673296+0800 Block-Demo[72692:8183596] MNObject - dealloc
2019-03-09 21:59:56.673520+0800 Block-Demo[72692:8183596] ----------0x0
```



上述代码，obj 是 __strong 修饰，但是并没有被 block 强引用！可见MRC环境下，__修饰的对象，生成的中间block对象不会对 auto变量产生强引用。



### Block的循环应用问题

传送门：[ 实际开发中-Block导致循环引用的问题(ARC环境下)](https://www.jianshu.com/p/fc2f4d207d25)



**考题：MRC 下，block的循环引用如何解决呢？**



- **方案1：unsafe_unretained**

MRC下，没有__weak，所以只能用_unsafe_unretained指针，原理和 weak 一样(ARC环境下不推荐使用，可能导致野指针，推荐使用weak)

```
__unsafe_unretained MNObject *weakSelf = self;
self.block = [^{
    NSLog(@"----------%p",weakSelf);
}copy];
```



- **方案2： __block**

```
__block self;
self.block = [^{
    NSLog(@"----------%p",self);
}copy];
```



why? 上面关于 __block的总结 

> 特别注意！上述条件仅在ARC环境下生效，如果是MRC环境下，block不会对内部auto变量产生强引用！(MRC下不会进行retain操作)



![image-20190309224535679](https://user-gold-cdn.xitu.io/2019/3/9/16962f914228a686?w=1374&h=940&f=jpeg&s=262830)



- **方案3: 手动在block函数内将对象制空，并且必须手动保证block调用**

```
MNObject *obj = [[MNObject alloc]init];
__unsafe_unretained MNObject *weakObj = obj;
obj.block = [^{
    NSLog(@"----------%p",obj);
    obj = nil;
}copy];

obj.block();
```

![image-20190309225056495](https://user-gold-cdn.xitu.io/2019/3/9/16962f65bf4c0f7f?w=1550&h=584&f=jpeg&s=175229)



但是这个一定要注意，block必须调用，因为对象指针的清空操作，是写在block函数中的，如果没调用block，循环引用问题还是会存在，所以不推荐使用。



实际开发中，循环引用的检测工具推荐，facebook开源的 [FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector)，用过的都说好~



---

老实说，block其实非常难，能考得特别深，本文也只是简单探究&总结下中级iOS常见的block考题，以及对Block底层的初步探究，如果是像我所在的三线城市，去面试那种非一线公司的话，如果能掌握本文，可能block相关的题目能答个八九不离十吧！*(可能题目会变换组合，但是万变不离其宗)*



block的文章其实很多，但是如果要真的深入理解，还是得动手，这里推荐初中级iOSer可以跟着本文的思路，一步一步跟着探究试试，本文只是起个抛砖引玉的作用

<br>

---

<br>



友情演出:[小马哥MJ](https://github.com/CoderMJLee)


*参考资料*

[实际开发中-Block导致循环引用的问题(ARC环境下)](https://www.jianshu.com/p/fc2f4d207d25)

[招聘一个靠谱的 iOS](https://blog.sunnyxx.com/2015/07/04/ios-interview/)

[ChenYilong/iOSInterviewQuestions](https://github.com/ChenYilong/iOSInterviewQuestions/blob/master/01%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88/%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88%EF%BC%88%E4%B8%8B%EF%BC%89.md#45-addobserverforkeypathoptionscontext%E5%90%84%E4%B8%AA%E5%8F%82%E6%95%B0%E7%9A%84%E4%BD%9C%E7%94%A8%E5%88%86%E5%88%AB%E6%98%AF%E4%BB%80%E4%B9%88observer%E4%B8%AD%E9%9C%80%E8%A6%81%E5%AE%9E%E7%8E%B0%E5%93%AA%E4%B8%AA%E6%96%B9%E6%B3%95%E6%89%8D%E8%83%BD%E8%8E%B7%E5%BE%97kvo%E5%9B%9E%E8%B0%83)