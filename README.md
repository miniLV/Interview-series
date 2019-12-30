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

## 底层探究专栏

### [isa&&Class&&meta-class 初步认识](https://minilv.github.io/2018/07/01/ias-class-metaClass)

### [isa与class详解](https://minilv.github.io/2019/03/18/isa%E8%AF%A6%E8%A7%A3-&&-class%E5%86%85%E9%83%A8%E7%BB%93%E6%9E%84/)

### [Category && 关联对象](https://minilv.github.io/2019/02/27/category/)

### [KVO && KVC 常考点](https://minilv.github.io/2018/03/27/KVO&KVC/)

### [Block看我就够了](https://minilv.github.io/2019/02/27/BlockFile/)

### [runtime消息机制](https://minilv.github.io/2019/03/17/Runtime-%E6%B6%88%E6%81%AF%E6%9C%BA%E5%88%B6%E5%9C%9F%E5%91%B3%E8%AE%B2%E8%A7%A3/)

### [一道高级iOS面试题(runtime方向)](https://minilv.github.io/2019/03/27/%E4%B8%80%E9%81%93%E9%AB%98%E7%BA%A7iOS%E9%9D%A2%E8%AF%95%E9%A2%98(runtime%E6%96%B9%E5%90%91)/)

<br>

## 性能优化专栏
### [UITableView的性能优化 - 中级篇](https://minilv.github.io/2018/06/29/TableViewCellOptimization/)

## 架构专栏
### [iOS架构入门 - MVC模式实例演示](https://minilv.github.io/2018/05/29/MVC/)

<br>

## 面试专栏

### [iOS 初中级工程师简历指北](https://minilv.github.io/2019/05/05/iOS%E5%88%9D%E4%B8%AD%E7%BA%A7%E5%BC%80%E5%8F%91%E7%AE%80%E5%8E%86%E6%8C%87%E5%8C%97/)

### [萌新iOS面试官迷你厂第一视角](https://minilv.github.io/2019/12/29/interviewer/)
