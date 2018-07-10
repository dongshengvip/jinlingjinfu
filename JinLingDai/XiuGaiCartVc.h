//
//  XiuGaiCartVc.h
//  JinLingDai
//
//  Created by 001 on 2017/7/5.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface XiuGaiCartVc : ViewController
@property (nonatomic, copy) void(^JieBangCartBlock)(BOOL succ);
@end
