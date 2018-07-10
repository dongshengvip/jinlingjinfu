//
//  UIFont+Addtion.m
//  zhihui
//
//  Created by kjubo on 15/7/1.
//  Copyright (c) 2015年 吉运软件. All rights reserved.
//

#import "UIFont+Addtion.h"

#define kAppBaseFonts @{ \
@(NSAppFontXXXS) : @(9), \
@(NSAppFontXXS) : @(10), \
@(NSAppFontXS)  : @(11), \
@(NSAppFontS)   : @(12), \
@(NSAppFontM)   : @(13), \
@(NSAppFontXM)   : @(14), \
@(NSAppFontXXM)   : @(15), \
@(NSAppFontXXXM)   : @(16), \
@(NSAppFontL)   : @(17), \
@(NSAppFontLL)  : @(18), \
@(NSAppFontLLL)  : @(19), \
@(NSAppFontXL)  : @(20), \
@(NSAppFontXXL) : @(21), \
@(NSAppFontXXXL) : @(22), \
@(NSAppFontXXXXL) : @(23), \
}

@implementation UIFont (Addtion)

+ (UIFont *)gs_font:(NSAppFontSize)fontSize{
    if(DEVICE_IPHONE6){
        return [UIFont systemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 1.1];
    }else if(DEVICE_IPHONE6P){
        return [UIFont systemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 1.2];
    }else{
        return [UIFont systemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 0.9];
    }
}
+ (UIFont *)gs_fontNum:(CGFloat)fontSize{
    if(DEVICE_IPHONE6){
        return [UIFont systemFontOfSize:fontSize * 1.1];
    }else if(DEVICE_IPHONE6P){
        return [UIFont systemFontOfSize:fontSize * 1.2];
    }else{
        return [UIFont systemFontOfSize:fontSize * 0.9];
    }
}
+ (UIFont *)gs_fontNum:(CGFloat)fontSize weight:(CGFloat)weight{
    //UIFontWeightUltraLight  - 超细字体
    
//    UIFontWeightThin  - 纤细字体
//
//    UIFontWeightLight  - 亮字体
//
//    UIFontWeightRegular  - 常规字体
//
//    UIFontWeightMedium  - 介于Regular和Semibold之间
//
//    UIFontWeightSemibold  - 半粗字体
//
//    UIFontWeightBold  - 加粗字体
//
//    UIFontWeightHeavy  - 介于Bold和Black之间
//
//    UIFontWeightBlack  - 最粗字体(理解)
    if(DEVICE_IPHONE6){
        return [UIFont systemFontOfSize:fontSize * 1.1 weight:weight];
    }else if(DEVICE_IPHONE6P){
        return [UIFont systemFontOfSize:fontSize * 1.2 weight:weight];
    }else{
        return [UIFont systemFontOfSize:fontSize * 0.9 weight:weight];
    }
}

+ (UIFont *)gs_boldfont:(NSAppFontSize)fontSize{
    if(DEVICE_IPHONE6){
        return [UIFont boldSystemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 1.1];
    }else if(DEVICE_IPHONE6P){
        return [UIFont boldSystemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 1.2];
    }else{
        return [UIFont boldSystemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 0.9];
    }
}

@end
