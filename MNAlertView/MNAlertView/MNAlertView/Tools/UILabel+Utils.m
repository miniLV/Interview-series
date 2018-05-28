//
//  UILabel+Utils.m
//  HCCF
//
//  Created by Lyh on 2017/12/6.
//  Copyright © 2017年 xmhccf. All rights reserved.
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing fontSize:(UIFont *)fontSize textColor:(UIColor *)textColor{
    
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSFontAttributeName value:fontSize range:NSMakeRange(0, text.length)];

    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}


@end
