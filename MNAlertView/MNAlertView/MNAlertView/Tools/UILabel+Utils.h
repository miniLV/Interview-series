//
//  UILabel+Utils.h
//  HCCF
//
//  Created by Lyh on 2017/12/6.
//  Copyright © 2017年 xmhccf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)

/// 设置textLabel 行间距
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

/// 设置label - 富文本的行间距
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing fontSize:(UIFont *)fontSize textColor:(UIColor *)textColor;

///计算 - 有行间距的label的高度 - 传的是fontSize的float，比如13
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

///计算高度 - 传的是UIFont，HZ_13Font
+ (CGFloat)text:(NSString*)text HZFontSize:(UIFont *)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;


/**
 设置富文本 && 并改变局部颜色

 @param text 要改变的内容str
 @param lineSpacing 行间距
 @param fontSize 字号大小
 @param textColor 基本颜色
 @param changeColor 局部变化颜色
 @param startIndex 变化颜色的起始坐标
 @param length 变化颜色的长度
 */
- (void)mn_setText:(NSString*)text
       lineSpacing:(CGFloat)lineSpacing
          fontSize:(UIFont *)fontSize
         textColor:(UIColor *)textColor
       changeColor:(UIColor *)changeColor
        startIndex:(NSInteger)startIndex
            length:(NSInteger)length;

@end
