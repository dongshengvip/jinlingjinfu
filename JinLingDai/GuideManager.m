//
//  GuideManager.m
//  JinLingDai
//
//  Created by 001 on 2017/7/13.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "GuideManager.h"
#import "GuideViewVc.h"
#import "UIView+Radius.h"
#import <YYKit.h>
#import "OSCMotionManager.h"
@interface GuideManager ()


@end
@implementation GuideManager


+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    static GuideManager *share = nil;
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

- (void)showLeadView{
    
    self.window.hidden = NO;
    [self.window makeKeyWindow];
    self.window.windowLevel = UIWindowLevelStatusBar;
    
    
    GuideViewVc *leadView = [[GuideViewVc alloc] init];
    
//    viV.circleType = CircleViewTypeLogin;
    __weak typeof(self) weakSelf = self;
    leadView.liuLangWanCheng = ^{
        [weakSelf performSelector:@selector(hide) withObject:nil afterDelay:0.4];
    };
    [self.window.rootViewController presentViewController:leadView animated:YES completion:nil];

}

- (void)showStarView{
    self.window.hidden = NO;
    [self.window makeKeyWindow];
    self.window.windowLevel = UIWindowLevelStatusBar;
    UIView *bgiew = [UIView new];
    bgiew.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:bgiew];
    [bgiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window);
    }];
    
    UIImageView *imageLogo = [[UIImageView alloc] init];
    imageLogo.image = [UIImage imageNamed:@"StartLOGO"];
    [self.window addSubview:imageLogo];
    [imageLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.window);
        make.top.equalTo(self.window).offset(120 + 24);
    }];
    [imageLogo.superview layoutIfNeeded];
    [imageLogo setCornerRadiusAdvance:imageLogo.height];
    
    UIView *logoBgView = [UIView new];
    logoBgView.layer.cornerRadius = ChangedHeight(55)/2;
    logoBgView.backgroundColor = [UIColor whiteColor];
    [self.window insertSubview:logoBgView belowSubview:imageLogo];
    [logoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageLogo);
        make.width.height.mas_equalTo(ChangedHeight(55));
    }];
    
    
    UIImageView *yellowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"启动黄色"]];
    [bgiew addSubview:yellowView];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageLogo);
        make.width.height.mas_equalTo(ChangedHeight(55));
    }];
    [yellowView.superview layoutIfNeeded];
    
    UIImageView *guoqi = [[UIImageView alloc] init];
    guoqi.image = [UIImage imageNamed:@"LOGO-2"];
    [self.window addSubview:guoqi];
    [guoqi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.window).offset(-30);
        make.centerX.equalTo(imageLogo);
    }];
    
    
    
    UIImageView *pingtai = [[UIImageView alloc] init];
    pingtai.image = [UIImage imageNamed:@"启动平台"];
    [self.window insertSubview:pingtai belowSubview:logoBgView];
    [pingtai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageLogo.mas_bottom).offset(ChangedHeight(-15));
        make.centerX.equalTo(imageLogo);
    }];
    
    UIImageView *text = [[UIImageView alloc] init];
    text.image = [UIImage imageNamed:@"启动字体"];
    [self.window addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pingtai);
        make.top.equalTo(pingtai.mas_bottom).offset(ChangedHeight(15));
    }];
    pingtai.hidden = text.hidden = YES;
    pingtai.alpha = text.alpha = 0;
    
    UIImageView *red1 = [[UIImageView alloc] init];
    red1.image = [UIImage imageNamed:@"启动红包"];
    [bgiew addSubview:red1];
    [red1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgiew).offset(ChangedHeight(45));
        make.left.equalTo(bgiew).offset(ChangedHeight(15));
    }];
    
    UIImageView *red2 = [[UIImageView alloc] init];
    red2.image = [UIImage imageNamed:@"启动红包2"];
    [bgiew addSubview:red2];
    [red2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgiew).offset(ChangedHeight(60));
        make.right.equalTo(bgiew).offset(ChangedHeight(-15));
    }];
    
    UIImageView *red3 = [[UIImageView alloc] init];
    red3.image = [UIImage imageNamed:@"启动红包3"];
    [bgiew addSubview:red3];
    [red3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgiew).offset(ChangedHeight(10));
        make.centerX.equalTo(bgiew);
    }];
    red3.hidden = red2.hidden = red1.hidden = YES;
    red3.alpha = red2.alpha = red1.alpha = 0;
    [yellowView.superview layoutIfNeeded];
    [UIView animateWithDuration:2.f animations:^{
        [yellowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imageLogo);
            make.width.height.mas_equalTo(ChangedHeight(700));
        }];
        [yellowView.superview layoutIfNeeded];
//        yellowView.bounds = CGRectMake(0, 0, ChangedHeight(700), ChangedHeight(700));
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.4f delay:1.f options:UIViewAnimationOptionTransitionNone animations:^{
        pingtai.hidden = text.hidden = NO;
        pingtai.alpha = text.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            red2.hidden = NO;
            red3.alpha = red2.alpha = red1.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                red3.hidden = NO;
                red3.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    red1.hidden = NO;
                    red1.alpha = 1;
                } completion:^(BOOL finished) {
                    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.f];
                }];
            }];
            
        }];
    }];

    
}

- (void)dismiss {
    
//    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
    
        [self.window resignKeyWindow];
        self.window.windowLevel = UIWindowLevelNormal;
        self.window.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UserManager shareManager].user) {
            UserModel *model = [UserManager shareManager].user;
            if (model && model.hadGester && model.gesterOn){
                return ;
            }
            [OSCMotionManager shareMotionManager].canShake = [[UserManager shareManager].user.shake_status integerValue] == 1;
        }
        
    });
//    }];
}

- (void)dealloc {
    if (self.window) {
        self.window = nil;
    }
}

- (void)hide {
    [self.window resignKeyWindow];
    self.window.windowLevel = UIWindowLevelNormal;
    self.window.hidden = YES;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [OSCMotionManager shareMotionManager];
//    });
    
}

@end
