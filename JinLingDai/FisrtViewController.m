//
//  FisrtViewController.m
//  JinLingDai
//
//  Created by 001 on 2017/11/6.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "FisrtViewController.h"

@interface FisrtViewController ()

@end

@implementation FisrtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 隐藏导航栏
 @param animated v1
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:self.isAnimat];
    if (@available(iOS 11.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isAnimat = NO;
//    if (@available(iOS 11.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
    
}
/** 不隐藏导航栏  @param animated 1 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    if (@available(iOS 11.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
