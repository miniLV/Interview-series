//
//  MNAlertView.m
//  MNAlertView
//
//  Created by Lyh on 2018/5/28.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import "MNAlertView.h"
#import <Masonry.h>

@implementation MNAlertView

static CGFloat viewW = 270;
static CGFloat viewH = 281;
static CGFloat bottomBtnH = 44;

+ (instancetype)mn_alertView{
    
    return [[self alloc]initWithAlertView];
}

- (instancetype)initWithAlertView{
    
    if (self = [super init]) {
        
        [self p_createControls];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}


- (void)p_createControls{
    

    
    self.frame = CGRectMake(0, 0, viewW, viewH);
    
    
    //scrollView
    [self p_createScrollView];
    
    //底部按钮
    [self p_createBottomBtn];

    
}

- (void)p_createScrollView{
    
    CGFloat scrollViewH = viewH - bottomBtnH;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, 0, viewW, scrollViewH);
    [self addSubview:scrollView];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    
    [scrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(viewW - 2 * 10);
    }];
    contentLabel.backgroundColor = [UIColor orangeColor];
    
    NSString *message = @"1、订单何时进入结算，规则如下：\n\
    1）短险产品：达到保单生效日期的订单；\n\
    2）长险产品：达到保单生效日期且过犹豫期的订单；\n\
    3）车险产品：状态为“已出单”的订单；\n\
    2、结算时间：\n\
    当月满足结算规则的订单将在次月月底前完成推广费收入结算。（结算后的推广费收入存入可提现中）\n\
    3、推广费收入存在如下3种状态：\n\
    （1）结算中金额：表示已经完成保单销售，但尚未达到结算时间的推广费收入（包含推广费和推荐奖励等）；\n\
    （2）可提现金额：表示同时满足结算规则和结算时间的推广费收入；\n\
    （3）已提现金额：表示从可提现金额提现至代理人绑定的银行卡的金额；\n\
    （4）累计收入：已完成保单销售的金额（税前）。\n\
    特别说明：\n\
    根据国家《个人所得税法》的劳务报酬所得规定，我们将对您在易保代的收入依法代扣代缴个人所得税：\n\
    若您当月提现超过人民币800元以上，需预先代扣个人所得税，扣税标准如下：\n\
    1）当月提现在800元及以下时，无需扣税；\n\
    2）800元<当月提现<=4000元，当月扣税=(当月提现-800）*20%；\n\
    3）4000元<当月提现<=20000元，当月扣税=当月提现*(1-20%)*20%；\n\
    4）25000元<当月提现<=50000元，当月扣税=当月提现*(1-20%)*30%-2000；\n\
    5）当月提现>50000元，当月扣税=当月提现*(1-20%)*40%-7000";
    
    contentLabel.text = message;
    
    scrollView.contentSize = CGSizeMake(viewW, 750);
    
}

- (void)p_createBottomBtn{
 
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(bottomBtnH);
    }];
    
    [btn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];
}


- (void)p_clickBtn{
    
    [self removeFromSuperview];
//    self = nil;
}

@end
