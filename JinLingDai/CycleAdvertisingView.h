//
//  CycleAdvertisingView.h
//  JinLingDai
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleAdvertisingDelegate <NSObject>

- (void)hadClickedAdv:(NSInteger)index;

@end

@interface CycleAdvertisingView : UIView
@property (nonatomic, weak) id <CycleAdvertisingDelegate>delegate;
@property (nonatomic, assign) BOOL hasTip;
//@property (nonatomic)

- (void)creatUI:(NSArray *)items TimeInterval:(NSTimeInterval)interval;
@end

