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

## [OC对象的本质](https://github.com/miniLV/Interview-series/blob/master/%E4%BB%80%E4%B9%88%E6%98%AFNSObject.md)


## [isa&&Class&&meta-class](https://github.com/miniLV/Interview-series/blob/master/isa%26%26Class%26%26meta-class.md)

## [Category && 关联对象](https://minilv.github.io/2019/02/27/category/)

## [KVO && KVC 常考点](https://minilv.github.io/2018/03/27/KVO&KVC/)

## [Block看我就够了](https://minilv.github.io/2019/02/27/BlockFile/)
