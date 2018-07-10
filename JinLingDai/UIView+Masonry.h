//
//  UIView+Masonry.h
//  JinLingDai
//
//  Created by 001 on 2017/6/30.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Masonry)

/**
 水平间隔排版

 @param views 需要排版的views
 */
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;

/**
 垂直间隔排版

 @param views 需要排版的views
 */
- (void) distributeSpacingVerticallyWith:(NSArray*)views;
@end
