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
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    MNAlertView *view = [MNAlertView mn_alertView];
    [self.view addSubview:view];
    
}

@end
