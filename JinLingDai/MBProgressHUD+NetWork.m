//
//  MBProgressHUD+NetWork.m
//  JinLingDai
//
//  Created by 001 on 2017/6/27.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MBProgressHUD+NetWork.h"

#define KeepTime 1.0    //控件默认显示时间
@implementation MBProgressHUD (NetWork)

+ (MBProgressHUD *)createHUD
{
    UIWindow *window;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow *eachWindow in windows){
        if ([eachWindow isKeyWindow]) {
            window = eachWindow;
        }
    }
    if (!window) {
        return nil;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    HUD.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    HUD.detailsLabel.numberOfLines = 0;
    [window addSubview:HUD];
    [HUD showAnimated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    
    
    return HUD;
}
/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    hud.detailsLabel.numberOfLines = 0;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:KeepTime];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"√" view:view];
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error" view:view];
}

/**
 *  显示错误信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //    hud.dimBackground = YES;
    return hud;
}

/**
 *  显示一些信息    使用一个圆形饼图来作为进度视图
 *
 *  MBProgressHUDModeIndeterminate 使用UIActivityIndicatorView来显示进度，这是默认值
 *  MBProgressHUDModeDeterminate 使用一个圆形饼图来作为进度视图
 *  MBProgressHUDModeDeterminateHorizontalBar 使用一个水平进度条
 *  MBProgressHUDModeAnnularDeterminate 使用圆环作为进度条
 *  MBProgressHUDModeCustomView 显示一个自定义视图，通过这种方式，可以显示一个正确或错误的提示图
 *  MBProgressHUDModeText 只显示文本
 *
 *
 *  @param message 信息内容
 *  @param progress 下载的进度
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message  progess:(float)progress  hudMode:(MBProgressHUDMode)hudMode toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.mode = hudMode;
    hud.progress = progress;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //    hud.dimBackground = YES;
    return hud;
}

+ (void)showNetworkIndicator{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:window animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:window animated:YES];
    });
}

+ (void)hideNetworkIndicator{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:window animated:YES];
    });
}

@end
