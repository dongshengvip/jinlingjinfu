//
//  OSCMotionManager.m
//  iosapp
//
//  Created by Graphic-one on 16/10/18.
//  Copyright © 2016年 oschina. All rights reserved.
//

#import "OSCMotionManager.h"
#import <CoreMotion/CoreMotion.h>

#import "JLDTabBarController.h"
#import "UIDevice+SystemInfo.h"
#import "OSCMotionManager.h"
#import "MBProgressHUD+NetWork.h"
//#import "Utils.h"

#import <CoreMotion/CoreMotion.h>
#import <UIView+YYAdd.h>
#import <AudioToolbox/AudioToolbox.h>

#import "ShakeImageVC.h"

#define SHAKING_GIFT_VIEW_W (self.view.bounds.size.width - 60)
#define SHAKING_GIFT_VIEW_H 80
#define SHAKING_GIFT_VIEW_SIZE (CGSize){SHAKING_GIFT_VIEW_W,SHAKING_GIFT_VIEW_H}

#define SHAKING_GIFT_LARGER_VIEW_W ((self.view.bounds.size.width) - (40))
#define SHAKING_GIFT_LARGER_VIEW_H 350
#define SHAKING_GIFT_LARGER_SIZE  (CGSize){ SHAKING_GIFT_LARGER_VIEW_W , SHAKING_GIFT_LARGER_VIEW_H }

#define layer_SPACE_textTip 20
#define giftView_SPACE_TimeTip 15
#define OFFEST_H_GIFT 130


static const double accelerationThreshold_gift = 3.0f;
@interface OSCMotionManager()


@property CMMotionManager *motionManager;
@property NSOperationQueue *operationQueue;

@end
@implementation OSCMotionManager{
    SystemSoundID soundID;
    
    NSTimer* _timeHelper;
    NSString* _msgStr;
    int _successTimeCount;
    int _failureTimeCount;
}
static CMMotionManager* _shareMotionManager;
+ (OSCMotionManager *)shareMotionManager{
    
    static dispatch_once_t onceToken;
    static OSCMotionManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[OSCMotionManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        _successTimeCount = 0;
        _failureTimeCount = 0;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
        _motionManager = [CMMotionManager new];
        _motionManager.accelerometerUpdateInterval = 0.1;
        _operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)dealloc{
    
}
- (void)getRandomMessage{
    _isShaking = YES;
    AudioServicesPlayAlertSound(soundID);//播放
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    
    ShakeImageVC *vc = [[ShakeImageVC alloc]init];
    vc.shakeImage = [self createCurrentImage];
    vc.hidesBottomBarWhenPushed = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
    UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

- (void)setCanShake:(BOOL)canShake{
    if (canShake) {
        [self startAccelerometer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }else{
        [_motionManager stopAccelerometerUpdates];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification  object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}


#pragma mark - 监听动作
-(void)startAccelerometer
{
    if (_successTimeCount == 0 && _failureTimeCount == 0) {
        //以push的方式更新并在block中接收加速度
        [_motionManager startAccelerometerUpdatesToQueue:_operationQueue
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                             }];
    }
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    //综合3个方向的加速度
    double accelerameter = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2));
    //获得 accelerameter 加速度来判断是否摇动.此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）
    if (accelerameter > accelerationThreshold_gift) {
        //立即停止更新加速仪（很重要！）
        [_motionManager stopAccelerometerUpdates];
        [_operationQueue cancelAllOperations];
        if (_isShaking) {return;}
        _isShaking = YES;
        //UI线程必须在此block内执行，例如摇一摇动画、UIAlertView之类
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getRandomMessage];
        });
    }
}

//当App退到后台时必须停止加速仪更新，回到当前时重新执行。
#pragma mark --- Notifacation
-(void)receiveNotification:(NSNotification *)notification{
    if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
        [_motionManager stopAccelerometerUpdates];
    } else {
        [self startAccelerometer];
    }
}

- (UIImage *)createCurrentImage{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
    UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
    CGSize s = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [nav.topViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
