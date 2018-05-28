//
//  UIView+HGCorner.h
//  HGCorner
//
//  Created by zhh on 16/9/8.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HGCornerPosition) {
    HGCornerPositionTop,
    HGCornerPositionLeft,
    HGCornerPositionBottom,
    HGCornerPositionRight,
    HGCornerPositionAll
};

@interface UIView (HGCorner)

@property (nonatomic, assign) HGCornerPosition hg_cornerPosition;
@property (nonatomic, assign) CGFloat hg_cornerRadius;

- (void)hg_setCornerOnTopWithRadius:(CGFloat)radius;
- (void)hg_setCornerOnLeftWithRadius:(CGFloat)radius;
- (void)hg_setCornerOnBottomWithRadius:(CGFloat)radius;
- (void)hg_setCornerOnRightWithRadius:(CGFloat)radius;
- (void)hg_setAllCornerWithCornerRadius:(CGFloat)radius;
- (void)hg_setNoneCorner;

@end
