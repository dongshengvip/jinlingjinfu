//
//  MBProgressHUD+NetWork.h
//  JinLingDai
//
//  Created by 001 on 2017/6/27.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (NetWork)
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message  progess:(float)progress  hudMode:(MBProgressHUDMode)hudMode toView:(UIView *)view;
+ (MBProgressHUD *)createHUD;
//+ (void)hideHUD;
//+ (void)hideHUDForView:(UIView *)view;

+(void)showNetworkIndicator;
+(void)hideNetworkIndicator;
@end
