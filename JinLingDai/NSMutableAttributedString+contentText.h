//
//  NSMutableAttributedString+contentText.h
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (contentText)

+(NSMutableAttributedString *)getAttributedString:(NSString *)str Font:(UIFont *)font Color:(UIColor *)color grayText:(NSString *)grayText TextAligment:(NSTextAlignment)aligment LineSpace:(CGFloat)space;
@end
