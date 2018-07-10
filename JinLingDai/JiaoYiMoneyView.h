//
//  JiaoYiMoneyView.h
//  JinLingDai
//
//  Created by 001 on 2017/7/8.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiaoYiMoneyView : UIView

@property (nonatomic, copy) void(^inputPassEndBlock)(NSString *password);
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, copy) NSString *titleStr;
- (void)showAlertType;
- (void)hidenAlertType;
@end
