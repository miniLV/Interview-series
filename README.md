![伪装成首页.jpg](https://upload-images.jianshu.io/upload_images/4563271-78c96d2cb4ee43c7.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# iOS初级到中级的进阶之路~

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

## [isa&&Class&&meta-class 初步认识](https://minilv.github.io/2018/07/01/ias-class-metaClass)

## [isa与class详解](https://minilv.github.io/2019/03/18/isa%E8%AF%A6%E8%A7%A3-&&-class%E5%86%85%E9%83%A8%E7%BB%93%E6%9E%84/)

## [Category && 关联对象](https://minilv.github.io/2019/02/27/category/)

## [KVO && KVC 常考点](https://minilv.github.io/2018/03/27/KVO&KVC/)

## [Block看我就够了](https://minilv.github.io/2019/02/27/BlockFile/)

## [runtime消息机制](https://minilv.github.io/2019/03/17/Runtime-%E6%B6%88%E6%81%AF%E6%9C%BA%E5%88%B6%E5%9C%9F%E5%91%B3%E8%AE%B2%E8%A7%A3/)
