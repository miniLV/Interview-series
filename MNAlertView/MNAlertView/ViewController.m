//
//  ViewController.m
//  MNAlertView
//
//  Created by Lyh on 2018/5/28.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import "ViewController.h"
#import "MNAlertView.h"
#import "UIColor+Hex.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor orangeColor];
    [self setupUI];
}

- (void)setupUI{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:btn];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)p_clickBtn{
    
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
    
    
    MNAlertView *view = [MNAlertView mn_alertViewWithWidth:270
                                                    height:281
                                                   message:message
                                              messageColor:[UIColor colorWithHexString:@"494949"]
                                               messageFont:[UIFont systemFontOfSize:14]
                                      messageTextAlignment:NSTextAlignmentLeft
                                               lineSpacing:4
                                            ensureBtnTitle:@"我知道了"
                                       ensureBtnTitleColor:[UIColor colorWithHexString:@"24C789"]
                                        ensureBtnTitleFont:[UIFont systemFontOfSize:15]
                                           ensureBtnAction:nil];
    [self.view addSubview:view];
    
}

@end
