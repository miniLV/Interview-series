//
//  ViewController.m
//  ButtonRotateDemo
//
//  Created by 梁宇航 on 2017/9/29.
//  Copyright © 2017年 梁宇航. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIImageView *_arrowIV;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.button
    
    UIButton *btn = [[UIButton alloc]init];
    btn.center = self.view.center;
    
    btn.frame = CGRectMake(100, 100, 200, 70);
    
    [btn setTitle:@"" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //2.addLabel
    UILabel *label = [[UILabel alloc ]init];
    label.frame = CGRectMake(20, 20, 60, 30);
    label.backgroundColor = [UIColor lightGrayColor];
    
    label.text = @"test1";
    
    [btn addSubview:label];
    
    //3.addImageView
    
    UIImageView *iv = [[UIImageView alloc]init];
    
    iv.frame = CGRectMake(100, 20, 40, 30);
    
    iv.image = [UIImage imageNamed:@"注册成功"];
    
    _arrowIV = iv;
    
    [btn addSubview:iv];
    
}


- (void)clickBtn:(UIButton *)sender {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            
            _arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            
            _arrowIV.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    

    
    
   
//    NSLog(@"clickBtn");
    
}


@end
