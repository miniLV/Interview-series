//
//  MNAlertView.m
//  MNAlertView
//
//  Created by Lyh on 2018/5/28.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import "MNAlertView.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "UILabel+Utils.h"
#import "UIView+HGCorner.h"

@implementation MNAlertView{
    UIView *_contentView;
    
    CGFloat _alertViewW;
    CGFloat _alertViewH;
    
    EnsureHandle _ensureHandle;
}

//屏幕宽高
#define ScreenH  [[UIScreen mainScreen] bounds].size.height
#define ScreenW  [[UIScreen mainScreen] bounds].size.width

//static CGFloat viewW = 270;
//static CGFloat viewH = 281;
static CGFloat bottomBtnH = 44;
static CGFloat topMargin = 18;
static CGFloat widthMargin = 15;
static CGFloat bottomMargin = 14;


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
                      ensureBtnAction:(EnsureHandle)ensureBtnAction{
    
    return [[self alloc]initWithAlertViewWidth:width
                                        height:height
                                       message:message
                                  messageColor:messageColor
                                   messageFont:messageFont
                          messageTextAlignment:messageTextAlignment
                                   lineSpacing:lineSpacing
                                ensureBtnTitle:ensureBtnTitle
                           ensureBtnTitleColor:ensureBtnTitleColor
                            ensureBtnTitleFont:ensureBtnTitleFont
                               ensureBtnAction:ensureBtnAction];
    
}

- (instancetype)initWithAlertViewWidth:(CGFloat)width
                                height:(CGFloat)height
                               message:(NSString *)message
                          messageColor:(UIColor *)messageColor
                           messageFont:(UIFont *)messageFont
                  messageTextAlignment:(NSTextAlignment)messageTextAlignment
                           lineSpacing:(CGFloat)lineSpacing
                        ensureBtnTitle:(NSString *)ensureBtnTitle
                   ensureBtnTitleColor:(UIColor *)ensureBtnTitleColor
                    ensureBtnTitleFont:(UIFont *)ensureBtnTitleFont
                       ensureBtnAction:(EnsureHandle)ensureBtnAction{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:0.67];
        self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        
        _alertViewW = width;
        _alertViewH = height;
        _ensureHandle = ensureBtnAction;
        
        [self p_createControlsWithMessage:message
                             messageColor:messageColor
                              messageFont:messageFont
                     messageTextAlignment:messageTextAlignment
                              lineSpacing:lineSpacing
                           ensureBtnTitle:ensureBtnTitle
                      ensureBtnTitleColor:ensureBtnTitleColor
                       ensureBtnTitleFont:ensureBtnTitleFont];
        
    }
    return self;
}


- (void)p_createControlsWithMessage:(NSString *)message
                       messageColor:(UIColor *)messageColor
                        messageFont:(UIFont *)messageFont
               messageTextAlignment:(NSTextAlignment)messageTextAlignment
                        lineSpacing:(CGFloat)lineSpacing
                     ensureBtnTitle:(NSString *)ensureBtnTitle
                ensureBtnTitleColor:(UIColor *)ensureBtnTitleColor
                 ensureBtnTitleFont:(UIFont *)ensureBtnTitleFont{
    

    //contentView
    [self p_createContentView];
    
    //scrollView
    [self p_createScrollViewWithMessage:message
                           messageColor:messageColor
                            messageFont:messageFont
                   messageTextAlignment:messageTextAlignment
                            lineSpacing:lineSpacing];
    
    //底部按钮
    [self p_createBottomBtnWithEnsureBtnTitle:ensureBtnTitle
                          ensureBtnTitleColor:ensureBtnTitleColor
                           ensureBtnTitleFont:ensureBtnTitleFont];
    
}

- (void)p_createContentView{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 0, _alertViewW, _alertViewH);
    contentView.backgroundColor = [UIColor whiteColor];
    //裁切圆角
    [contentView hg_setAllCornerWithCornerRadius:10.0];
    contentView.center = self.center;
    [self addSubview:contentView];
    
    _contentView = contentView;
}

- (void)p_createScrollViewWithMessage:(NSString *)message
                         messageColor:(UIColor *)messageColor
                          messageFont:(UIFont *)messageFont
                 messageTextAlignment:(NSTextAlignment)messageTextAlignment
                          lineSpacing:(CGFloat)lineSpacing{
    
    CGFloat scrollViewH = _alertViewH - bottomBtnH - topMargin - bottomMargin;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, topMargin, _alertViewW, scrollViewH);
    [_contentView addSubview:scrollView];
    
    UILabel *contentLabel = [[UILabel alloc]init];
//    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    
    [scrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(widthMargin);
        make.width.mas_equalTo(_alertViewW - 2 * widthMargin);
    }];
    
    

    //设置行间距
    [contentLabel setText:message
              lineSpacing:lineSpacing
                 fontSize:messageFont
                textColor:messageColor];
//    contentLabel.textAlignment = messageTextAlignment;
    
}

- (void)p_createBottomBtnWithEnsureBtnTitle:(NSString *)ensureBtnTitle
                        ensureBtnTitleColor:(UIColor *)ensureBtnTitleColor
                         ensureBtnTitleFont:(UIFont *)ensureBtnTitleFont{
 
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:ensureBtnTitle forState:UIControlStateNormal];
    [btn setTitleColor:ensureBtnTitleColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:ensureBtnTitleFont];
    [btn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(bottomBtnH);
    }];
    
    //顶部细线
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    [btn addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];

}

#pragma mark - control click
- (void)p_clickBtn{
    
    //移除当前控件
    [self removeFromSuperview];
    
//    _ensureHandle();
}

@end
