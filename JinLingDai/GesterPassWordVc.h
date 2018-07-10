//
//  GesterPassWordVc.h
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCCircleView.h"
#import "ViewController.h"
@interface GesterPassWordVc : ViewController

@property (nonatomic, assign) CircleViewType circleType;
@property (nonatomic, copy) void(^gesterSuccessBlock)();
@property (nonatomic, copy) void(^failBock)();
@end
