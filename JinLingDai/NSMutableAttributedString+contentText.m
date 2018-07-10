//
//  NSMutableAttributedString+contentText.m
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "NSMutableAttributedString+contentText.h"

@implementation NSMutableAttributedString (contentText)

+(NSMutableAttributedString *)getAttributedString:(NSString *)str Font:(UIFont *)font Color:(UIColor *)color grayText:(NSString *)grayText TextAligment:(NSTextAlignment)aligment LineSpace:(CGFloat)space{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = space;
    style.alignment = aligment;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:[str rangeOfString:grayText]];
    [attr addAttribute:NSFontAttributeName value:font range:[str rangeOfString:grayText]];
    
    return attr;
}
@end
