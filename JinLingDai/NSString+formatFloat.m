//
//  NSString+formatFloat.m
//  JinLingDai
//
//  Created by 001 on 2017/8/23.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "NSString+formatFloat.h"

@implementation NSString (formatFloat)
+ (NSString *)formatFloat:(float)f
{
    if (fmodf(f, 1)==0) {//如果整数
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有1位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {//如果有两位小数点
        return [NSString stringWithFormat:@"%.2f",f];
    }
}

@end
