//
//  UIFont+Addtion.h
//  zhihui
//
//  Created by kjubo on 15/7/1.
//  Copyright (c) 2015年 吉运软件. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NSAppFontSize){
    NSAppFontXXXS = 0,//9
    NSAppFontXXS,//10
    NSAppFontXS,//11
    NSAppFontS,//12
    NSAppFontM,//13
    NSAppFontXM,//14
    NSAppFontXXM,//15
    NSAppFontXXXM,//16
    NSAppFontL,//17
    NSAppFontLL,//18
    NSAppFontLLL,//19
    NSAppFontXL,//20
    NSAppFontXXL,//21
    NSAppFontXXXL,//22
    NSAppFontXXXXL,//23
};

@interface UIFont (Addtion)
+ (UIFont *)gs_font:(NSAppFontSize)fontSize;
+ (UIFont *)gs_fontNum:(CGFloat)fontSize;
+ (UIFont *)gs_fontNum:(CGFloat)fontSize weight:(CGFloat)weight;
+ (UIFont *)gs_boldfont:(NSAppFontSize)fontSize;
@end
