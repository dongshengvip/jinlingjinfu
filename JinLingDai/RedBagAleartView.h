//
//  RedBagAleartView.h
//  JinLingDai
//
//  Created by 001 on 2017/7/10.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RedBagAleartType) {
    RedBagUsedNow,
    RedBagChanceUse
};

@interface RedBagAleartView : UIView
@property (nonatomic, assign) RedBagAleartType redBagType;
@property (nonatomic, copy) void(^confirmBtnBlock)();
@property (nonatomic, copy) void(^hidenRedBagBlock)();
- (void)aleartWithTip:(NSString *)tip Message:(NSString *)message Thanks:(NSString *)thanks Cancel:(NSString *)cancel Confirm:(NSString *)confirm;
- (void)showAlertType;
- (void)hidenAlertType;
@end
