//
//  TouZiModel.m
//  JinLingDai
//
//  Created by 001 on 2017/7/17.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "TouZiModel.h"
//#import ""
@implementation TouZiModel
- (id)copyWithZone:(NSZone *)zone
{
    TouZiModel *copy = [[[self class] allocWithZone:zone] init];
//    copy.dishId = _dishId;
    return copy;
}
@end
