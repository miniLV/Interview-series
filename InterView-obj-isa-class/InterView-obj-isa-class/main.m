//
//  main.m
//  InterView-obj-isa-class
//
//  Created by 梁宇航 on 2019/1/20.
//  Copyright © 2019年 梁宇航. All rights reserved.
//

#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "NSObject+MNTest.h"

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
- (void)compareSelfWithSuperclass;
@end

@implementation MNSubclass

- (void)subclassInstanceMethod{
    NSLog(@"subclassInstanceMethod- %p",self);
    
}

- (void)compareSelfWithSuperclass{
    NSLog(@"self class = %@",[self class]);
    NSLog(@"super class = %@",[super class]);
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool
    {
        MNSubclass *subclass = [[MNSubclass alloc]init];
        [subclass superclassInstanceMethod];
        NSLog(@"subclass = %p, MNSubclass = %p",subclass,[MNSubclass class]);
        
        [MNSubclass superClassMethod];
        
        //检验 - root-meta-class的superclass 是否指向 root-class
        [MNSubclass checkSuperclass];
        NSLog(@"MNSubclass = %p",[MNSubclass class]);
        
        //回答 - [self class] && [super class] 的答案
        [subclass compareSelfWithSuperclass];
        
    }
    
    return 0;
}


