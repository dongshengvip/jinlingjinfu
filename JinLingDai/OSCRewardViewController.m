//
//  OSCRewardViewController.m
//  iosapp
//
//  Created by Graphic-one on 16/10/12.
//  Copyright © 2016年 oschina. All rights reserved.
//

#import "OSCRewardViewController.h"
#import "UIDevice+SystemInfo.h"
#import "OSCMotionManager.h"
#import "MBProgressHUD+NetWork.h"
//#import "Utils.h"

#import <CoreMotion/CoreMotion.h>
#import <UIView+YYAdd.h>
#import <AudioToolbox/AudioToolbox.h>


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

@interface OSCRewardViewController ()

@property (nonatomic, strong) UIImageView *layer;
@property (nonatomic, strong) UILabel* textTip;
@property (nonatomic, strong) UILabel* timerTextTip;
@property CMMotionManager *motionManager;
@property NSOperationQueue *operationQueue;

@property (nonatomic,strong) MBProgressHUD* HUD;

@end

@implementation OSCRewardViewController{
    SystemSoundID soundID;
    
    NSTimer* _timeHelper;
    NSString* _msgStr;
    int _successTimeCount;
    int _failureTimeCount;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _successTimeCount = 0;
        _failureTimeCount = 0;
    }
    return self;
}

#pragma mark --- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"摇一摇";
    self.view.backgroundColor = [UIColor colorWithHex:0xEFEFF4];
    if (self.navigationController.viewControllers.count <= 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    }
    
    [self setLayout];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    _motionManager = [CMMotionManager new];
    _motionManager.accelerometerUpdateInterval = 0.1;
    _operationQueue = [NSOperationQueue new];
}
- (void)getRandomMessage{
    _isShaking = YES;
    AudioServicesPlayAlertSound(soundID);//播放
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self startAccelerometer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [_motionManager stopAccelerometerUpdates];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [super viewDidDisappear:animated];
}

- (void)backButtonClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- layoutUI
- (void)setLayout{
    _layer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_shake"]];
    _layer.size = (CGSize){100,140};
    _layer.centerX = self.view.centerX;
    _layer.centerY = self.view.centerY - 100;
    _layer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_layer];
    
    _textTip = [UILabel new];
    _textTip.size = (CGSize){self.view.bounds.size.width , SHAKING_GIFT_VIEW_H };
    _textTip.centerX = self.view.centerX;
    _textTip.top = _layer.bottom - 10;
    _textTip.numberOfLines = 0;
    _textTip.font = [UIFont systemFontOfSize:15];
    _textTip.textColor = [UIColor colorWithHex:0x9d9d9d];
    _textTip.textAlignment = NSTextAlignmentCenter;
    _textTip.text = @"摇一摇可进行搜寻礼品哦";
    _textTip.hidden = NO;
    [self.view addSubview:_textTip];
    
    _timerTextTip = [UILabel new];
    _timerTextTip.size = (CGSize){self.view.bounds.size.width , SHAKING_GIFT_VIEW_H};
    _timerTextTip.centerX = self.view.centerX;
    _timerTextTip.top = _layer.centerY + SHAKING_GIFT_LARGER_VIEW_H * 0.5 + 35;
    _timerTextTip.numberOfLines = 0;
    _timerTextTip.font = [UIFont systemFontOfSize:15];
    _timerTextTip.textColor = [UIColor colorWithHex:0x9d9d9d];
    _timerTextTip.textAlignment = NSTextAlignmentCenter;
    _timerTextTip.text = @" ";
    _timerTextTip.hidden = YES;
    [self.view addSubview:_timerTextTip];
    
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
            [self rotate:_layer];
        });
    }
}

#pragma mark - 动画效果
- (void)rotate:(UIView *)view{
//    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    rotate.fromValue = [NSNumber numberWithFloat:0];
//    rotate.toValue = [NSNumber numberWithFloat: - M_PI / 8.0];
//    rotate.duration = 0.18;
//    rotate.repeatCount = 2;
//    rotate.autoreverses = YES;
    
//    [CATransaction begin];
//    [self setAnchorPoint:CGPointMake(1.0, 1.3) forView:view];
//    [CATransaction setCompletionBlock:^{
        //摇一摇需要完成的功能
        [self getRandomMessage];
//    }];
//    [view.layer addAnimation:rotate forKey:nil];
//    [CATransaction commit];
}
- (void)startConductReward{
    UIImageView * img = [[UIImageView alloc] initWithImage:[self createCurrentImage]];
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view).multipliedBy(0.5);
    }];
//    [self startAccelerometer];
//    _isShaking = NO;
}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
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


/**
 截图

 @return image
 */
- (UIImage *)createCurrentImage
{
//    self.view.hidden = NO;
    CGSize s = self.view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
