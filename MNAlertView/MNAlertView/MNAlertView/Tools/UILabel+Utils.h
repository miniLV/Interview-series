//
//  UILabel+Utils.h
//  HCCF
//
//  Created by Lyh on 2017/12/6.
//  Copyright © 2017年 xmhccf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)

/// 设置label - 富文本的行间距
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing fontSize:(UIFont *)fontSize textColor:(UIColor *)textColor;

@end
