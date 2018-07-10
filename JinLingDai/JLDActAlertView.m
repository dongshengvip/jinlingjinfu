//
//  JLDActAlertView.m
//  JinLingDai
//
//  Created by 001 on 2017/8/9.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "JLDActAlertView.h"
#import "JLDTabBarController.h"
@interface JLDActAlertView (){
    UIButton *_cancel;
}
@property (nonatomic, strong) UIImageView *bankView;
//@property (nonatomic, strong) UILabel *bankTipLab;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *bangdingKa;

@property (nonatomic, strong) UIView *RistView;
@property (nonatomic, strong) UILabel *RistTipLab;
@property (nonatomic, strong) UIButton *RistBtn;
@end
@implementation JLDActAlertView
+ (instancetype)shareManager{
    static JLDActAlertView *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[JLDActAlertView alloc] init];
        }
    });
    return manager;
}
- (instancetype)init{
    if(self = [super init]){
        self.frame = CGRectMake(0, 0, K_WIDTH, K_HEIGHT);
        UIView *shadeView = [UIView new];
        shadeView.backgroundColor = [UIColor titleColor];
        shadeView.alpha = 0.5f;
        [self addSubview:shadeView];
        [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIImageView *tipView = [[UIImageView alloc]init];
        tipView.userInteractionEnabled = YES;
//        tipView.image = [UIImage imageNamed:@"银行存管"];
        [self addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(ChangedHeight(320), ChangedHeight(360)));
            make.center.equalTo(self);
        }];
        
        _tipView = tipView;
        UIButton *cancel = [UIButton new];
        [cancel setImage:[UIImage imageNamed:@"红包关闭按钮"] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelActView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tipView).offset(ChangedHeight(-20));
            make.bottom.equalTo(tipView.mas_top).offset(ChangedHeight(45));
            make.size.mas_equalTo(CGSizeMake(ChangedHeight(25), ChangedHeight(25)));
        }];
        _cancel = cancel;
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [tipView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tipView).offset(ChangedHeight(-20));
            make.height.mas_equalTo(ChangedHeight(80));
            make.centerX.equalTo(tipView);
            make.width.equalTo(tipView).dividedBy(3.0/2);
        }];
        _confirmBtn = confirmBtn;
    }
    return self;
}

- (void)cancelActView{
//    if (self.showType == RistShowType) {
//        [self AnimationGroupToHidn];
//        _cancel.hidden = YES;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self hidenAlertType];
//            [self.RistView removeFromSuperview];
//            if (_cancelBtnBlock) {
//                _cancelBtnBlock();
//            }
//        });
//    }else
        [self hidenAlertType];
}
- (void)hidenAlertType{
    [self removeFromSuperview];
}

/**
 <#Description#>
 */
- (void)showAlertType:(lertType)showType toView:(UIView *)view{

    _cancel.hidden = NO;
    self.showType = showType;
    if (showType == BankShowType) {
        [self insertSubview:self.bankView belowSubview:_cancel];
        [self.bankView addSubview:self.bangdingKa];
        self.tipView.hidden = YES;
        self.bankView.hidden = NO;
        [_cancel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bankView.mas_right);
            make.centerY.equalTo(self.bankView.mas_top);
            make.size.mas_equalTo(CGSizeMake(ChangedHeight(25), ChangedHeight(25)));
        }];

        [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.tipView);
        }];
        [self.bangdingKa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bankView).offset(ChangedHeight(-13));
            make.centerX.equalTo(self.bankView);
            make.width.equalTo(self.bankView).multipliedBy(3/5.0);
            make.height.mas_equalTo(ChangedHeight(25));
        }];
        
//    }else if(showType == RistShowType){
//        [self insertSubview:self.RistView belowSubview:_cancel];
////        [self.bankView addSubview:self.bangdingKa];
//        self.tipView.hidden = YES;
//        self.bankView.hidden = YES;
//        [_cancel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.RistView.mas_right);
//            make.centerY.equalTo(self.RistView.mas_top);
//            make.size.mas_equalTo(CGSizeMake(ChangedHeight(25), ChangedHeight(25)));
//        }];
//
//        [self.RistView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.tipView);
//            make.width.equalTo(self).offset(-ChangedHeight(100));
//            make.height.mas_equalTo(ChangedHeight(280));
//        }];

    }else{
        self.tipView.hidden = NO;
        self.bankView.hidden = YES;
    }
    
    _confirmBtn.hidden = showType == BankShowType;
    [view insertSubview:self atIndex:1];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    self.hidden = NO;
    
}

- (void)confirmBtnClicked{
    [self hidenAlertType];
    if (_confirmBtnBlock) {
        _confirmBtnBlock();
    }
}

- (void)bankBtnClicked{
    [self hidenAlertType];
    if (_bankBlock) {
        _bankBlock();
    }
}
- (void)ristBtnClicked{
    [self hidenAlertType];
    if (_ristBlock) {
        _ristBlock();
    }
}
- (void)AnimationGroupToHidn{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    JLDTabBarController *tab = window.rootViewController;
    //创建组动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.duration = 1.5;
    animationGroup.repeatCount = 0;
    animationGroup.removedOnCompletion = NO;
    /* beginTime 可以分别设置每个动画的beginTime来控制组动画中每个动画的触发时间，时间不能够超过动画的时间，默认都为0.f */
    
    //缩放动画
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation1.values = @[[NSNumber numberWithFloat:1.0],
//                          [NSNumber numberWithFloat:0.2],
//                          [NSNumber numberWithFloat:0.1],
                          [NSNumber numberWithFloat:0.05]];
    animation1.beginTime = 0.f;
    
    //按照圆弧移动动画
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:self.center];
    [bezierPath addQuadCurveToPoint:CGPointMake(K_WIDTH - 40, K_HEIGHT - tab.tabBar.frame.size.height) controlPoint:CGPointMake(K_WIDTH - 80, K_HEIGHT/2 - 20)];
    animation2.path = bezierPath.CGPath;
    animation2.beginTime = 0.f;
    
    //透明度动画
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation3.fromValue = [NSNumber numberWithDouble:1.0];
    animation3.toValue = [NSNumber numberWithDouble:0.0];
    animation3.beginTime = 0.f;
    
    //添加组动画
    animationGroup.animations = @[animation1, animation2,animation3];
    [self.RistView.layer addAnimation:animationGroup forKey:nil];
}
- (UIImageView *)bankView {
   if (!_bankView) {
       _bankView = [UIImageView new];
       _bankView.contentMode = UIViewContentModeScaleAspectFit;
       _bankView.image = [UIImage imageNamed:@"银行存管1"];
       _bankView.userInteractionEnabled = YES;
   }
   return _bankView;
}

//- (UILabel *)bankTipLab {
//   if (!_bankTipLab) {
//       _bankTipLab = [UILabel new];
//       _bankTipLab.font = [UIFont gs_fontNum:12];
//       _bankTipLab.textColor = [UIColor whiteColor];
//       _bankTipLab.textAlignment = NSTextAlignmentCenter;
//       _bankTipLab.backgroundColor = [UIColor getOrangeColor];
//       _bankTipLab.text = @"开户绑卡";
////       _bankTipLab.fon
//       _bankTipLab.layer.cornerRadius = 5;
//       _bankTipLab.clipsToBounds = YES;
//   }
//   return _bankTipLab;
//}

- (UIButton *)bangdingKa {
   if (!_bangdingKa) {
       _bangdingKa = [UIButton buttonWithType:UIButtonTypeCustom];
       _bangdingKa.titleLabel.font = [UIFont gs_fontNum:12];
       [_bangdingKa setTitle:@"开户绑卡" forState:UIControlStateNormal];
       [_bangdingKa setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       _bangdingKa.backgroundColor = [UIColor getOrangeColor];
       [_bangdingKa addTarget:self action:@selector(bankBtnClicked) forControlEvents:UIControlEventTouchUpInside];
       _bangdingKa.layer.cornerRadius = 5;
       _bangdingKa.clipsToBounds = YES;
   }
   return _bangdingKa;
}

- (UIView *)RistView {
   if (!_RistView) {
       _RistView = [UIView new];
       _RistView.backgroundColor = [UIColor infosBackViewColor];
       _RistView.layer.masksToBounds = YES;
       _RistView.layer.cornerRadius = 5;
       [_RistView addSubview:self.RistTipLab];
       [_RistView addSubview:self.RistBtn];
       [self.RistTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(_RistView).offset(20);
           make.centerX.equalTo(_RistView);
           make.width.mas_lessThanOrEqualTo(_RistView).offset(-40);
       }];
       UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"启动平台"]];
       [_RistView addSubview:image];
       [image mas_makeConstraints:^(MASConstraintMaker *make) {
           make.center.equalTo(_RistView);
       }];
       [self.RistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(_RistView);
           make.bottom.equalTo(_RistView).offset(-20);
           make.width.equalTo(_RistView).multipliedBy(3/5.0);
           make.height.mas_equalTo(40);
       }];
   }
   return _RistView;
}

- (UILabel *)RistTipLab {
   if (!_RistTipLab) {
       _RistTipLab = [UILabel new];
       _RistTipLab.font = [UIFont gs_fontNum:14];
       _RistTipLab.textColor = [UIColor getOrangeColor];
       _RistTipLab.textAlignment = NSTextAlignmentCenter;
       _RistTipLab.numberOfLines = 2;
       _RistTipLab.text = @"hi，来测评一下你属于那种类型的投资人";
   }
   return _RistTipLab;
}

- (UIButton *)RistBtn {
   if (!_RistBtn) {
       _RistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _RistBtn.titleLabel.font = [UIFont gs_fontNum:14];
       [_RistBtn setTitle:@"点击测评" forState:UIControlStateNormal];
//       [_RistBtn setTitleColor:<#Color#> forState:UIControlStateNormal];
       _RistBtn.backgroundColor = [UIColor getOrangeColor];
       [_RistBtn addTarget:self action:@selector(ristBtnClicked) forControlEvents:UIControlEventTouchUpInside];
       _RistBtn.layer.cornerRadius = 5;
       _RistBtn.clipsToBounds = YES;
   }
   return _RistBtn;
}

@end
