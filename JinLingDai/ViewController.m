//
//  ViewController.m
//  JinLingDai
//
//  Created by 001 on 2017/6/26.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Util.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    
}

- (void)loginUser{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = [[NSClassFromString(@"LogingVc") alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [window.rootViewController presentViewController:nav animated:YES completion:nil];
}
- (void)setNavOrangeColor{
    [self.navigationController.navigationBar setTintColor:[UIColor getOrangeColor]];
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor getOrangeColor],
                              NSFontAttributeName:[UIFont gs_fontNum:17]
                              }];
}

- (void)setNavBlackColor{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastVc)];
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor getOrangeColor],
//                              NSFontAttributeName:[UIFont gs_fontNum:17]
//                              }];
}

- (void)backToLastVc{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
