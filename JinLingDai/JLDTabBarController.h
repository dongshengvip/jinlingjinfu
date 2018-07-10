//
//  JLDTabBarController.h
//  JinLingDai
//
//  Created by 001 on 2017/6/26.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface JLDTabBarController : UITabBarController
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) ViewController *presentVc;
+ (JLDTabBarController *)shareManager;
@end
