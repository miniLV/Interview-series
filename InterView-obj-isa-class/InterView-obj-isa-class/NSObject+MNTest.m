//
//  NSObject+MNTest.m
//  InterView-obj-isa-class
//
//  Created by 梁宇航 on 2019/1/20.
//  Copyright © 2019年 梁宇航. All rights reserved.
//

#import "NSObject+MNTest.h"

@implementation NSObject (MNTest)

//+ (void)checkSuperclass{
//    NSLog(@"+NSObject checkSuperclass - %p",self);
//}

- (void)checkSuperclass{
    NSLog(@"-NSObject checkSuperclass - %p",self);
}

@end
