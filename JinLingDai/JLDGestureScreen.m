//
//  JLDGestureScreen.m
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "JLDGestureScreen.h"
#import "GesterPassWordVc.h"

#import "OSCMotionManager.h"
@interface JLDGestureScreen ()
{
   
}
@property (nonatomic, strong) UIWindow *window;
@end
@implementation JLDGestureScreen

+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    static JLDGestureScreen *share = nil;
    dispatch_once(&onceToken, ^{
        
        share = [[self alloc]init];
    });
    
    return share;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.windowLevel = UIWindowLevelStatusBar;
        
        UIViewController *vc = [[UIViewController alloc]init];
        _window.rootViewController = vc;
    }
    
    return self;
}

- (void)show {
    
    self.window.hidden = NO;
    [self.window makeKeyWindow];
    self.window.windowLevel = UIWindowLevelStatusBar;
    
    
    GesterPassWordVc *viV = [[GesterPassWordVc alloc]init];
    viV.circleType = CircleViewTypeLogin;
    __weak typeof(self) weakSelf = self;
    viV.gesterSuccessBlock = ^{
        
        [weakSelf performSelector:@selector(dismiss) withObject:nil afterDelay:1.f];
    };
    [self.window.rootViewController presentViewController:viV animated:YES completion:nil];

}

- (void)dismiss {
    
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
        [self.window resignKeyWindow];
        self.window.windowLevel = UIWindowLevelNormal;
        self.window.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
             [OSCMotionManager shareMotionManager].canShake = [[UserManager shareManager].user.shake_status integerValue] == 1;
        });
    }];
}

- (void)dealloc {
    if (self.window) {
        self.window = nil;
    }
}

//- (void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc {
//    
//    [self performSelector:@selector(hide) withObject:nil afterDelay:0.6];
//    
//}

- (void)hide {
    [self.window resignKeyWindow];
    self.window.windowLevel = UIWindowLevelNormal;
    self.window.hidden = YES;
}
@end
