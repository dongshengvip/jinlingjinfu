//
//  JLDActAlertView.h
//  JinLingDai
//
//  Created by 001 on 2017/8/9.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,lertType)  {
    ActivityType,
    BankShowType,
    RistShowType,
};
@interface JLDActAlertView : UIView
@property (nonatomic, assign) lertType showType;
@property (nonatomic, copy) void(^confirmBtnBlock)();
@property (nonatomic, copy) void(^cancelBtnBlock)();
@property (nonatomic, copy) void(^bankBlock)();
@property (nonatomic, copy) void(^ristBlock)();
@property (nonatomic, strong) UIImageView *tipView;
+ (instancetype)shareManager;
- (void)showAlertType:(lertType)showType toView:(UIView *)view;
//- (void)showAlertType:(UIView *)view;
- (void)hidenAlertType;
@end
