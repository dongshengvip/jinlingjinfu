//
//  GuideView.h
//  JinLingDai
//
//  Created by 001 on 2017/7/13.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIScrollView

@property (nonatomic, copy) void(^overGuidViewBlock)();
+ (instancetype)share;

//- (void)show;
@end
