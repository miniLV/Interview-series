//
//  MNAlertView.h
//  MNAlertView
//
//  Created by Lyh on 2018/5/28.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNAlertView : UIView

typedef void (^EnsureHandle)(UIAlertAction *action);


/**
 创建自定义可控制大小的alertView

 @param width alertView 宽度
 @param height alertView 高度
 @param message 要展示的content 内容
 @param messageColor 内容颜色
 @param messageFont 内容字体大小
 @param messageTextAlignment - 文本显示对齐（居中对齐 or 左边对齐等等）
 @param lineSpacing 内容行间距
 @param ensureBtnTitle 确定action标题
 @param ensureBtnTitleColor 确定action标题颜色
 @param ensureBtnTitleFont 确定action标题字号
 @param ensureBtnAction 确定action标题点击事件
 @return alertView
 */
+ (instancetype)mn_alertViewWithWidth:(CGFloat)width
                               height:(CGFloat)height
                              message:(NSString *)message
                         messageColor:(UIColor *)messageColor
                          messageFont:(UIFont *)messageFont
                 messageTextAlignment:(NSTextAlignment)messageTextAlignment
                          lineSpacing:(CGFloat)lineSpacing
                       ensureBtnTitle:(NSString *)ensureBtnTitle
                  ensureBtnTitleColor:(UIColor *)ensureBtnTitleColor
                   ensureBtnTitleFont:(UIFont *)ensureBtnTitleFont
                      ensureBtnAction:(EnsureHandle)ensureBtnAction;


@end
