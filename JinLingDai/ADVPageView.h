//
//  ASPageView.h
//  gosheng3.0
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADVPageView;
@protocol ADVPageViewDelegate <NSObject>

@optional
- (void)pageView:(ADVPageView *)pageView didSelected:(NSInteger)index;

@end

@interface ADVPageView : UIView<UIScrollViewDelegate>
@property (nonatomic, weak) id<ADVPageViewDelegate> delegate;
@property (nonatomic, assign) BOOL hasTip;
- (void)setItems:(NSArray *)items andTimeInterval:(NSTimeInterval)interval;

- (void)setTotalLab:(NSString *)totalText interest:(NSString *)interest;
@end
