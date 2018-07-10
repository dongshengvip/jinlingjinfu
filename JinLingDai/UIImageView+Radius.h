//
//  UIImageView+Radius.h
//  JinLingDai
//
//  Created by 001 on 2017/6/27.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Radius)

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
@end
