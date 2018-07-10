//
//  GuideManager.h
//  JinLingDai
//
//  Created by 001 on 2017/7/13.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuideManager : NSObject
@property (nonatomic, strong) UIWindow *window;
+ (instancetype)shared;
- (void)showLeadView;
- (void)showStarView;

- (void)dismiss;
@end
