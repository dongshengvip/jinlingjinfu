//
//  UIView+Radius.h
//  JinLingDai
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Radius)

/**
 设置全部圆角
 
 @param cornerRadius 圆角值
 */
- (void)setCornerRadiusAdvance:(CGFloat)cornerRadius;

/**
 设置部分圆角或全部圆角
 
 @param cornerRadius 圆角值
 @param rectCornerType 圆角的部位
 */
- (void)setCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

/**
 设置虚线

 @param Width 宽
 @param lineLength 线长
 @param lineSpacing 间隔
 @param lineColor 颜色
 @return 虚线
 */
+ (instancetype)drawDashLineWidth:(CGFloat )Width lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
@end
