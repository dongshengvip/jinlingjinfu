//
//  JiangLiModel.m
//  JinLingDai
//
//  Created by 001 on 2017/7/17.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "JiangLiModel.h"

@implementation JiangLiModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [RedBagModel class],
             };
}
@end
@implementation RedBagModel

@end
