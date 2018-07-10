//
//  RedBagAleartView.m
//  JinLingDai
//
//  Created by 001 on 2017/7/10.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RedBagAleartView.h"
@interface RedBagAleartView ()

@property (nonatomic, strong) UILabel *tipTitleLab;
@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UILabel *thanksLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@end
@implementation RedBagAleartView

- (instancetype)init{
    if (self = [super init]) {
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
        tipView.image = [UIImage imageNamed:@"redBagBg"];
        [self addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ChangedHeight(294), ChangedHeight(275)));
            make.center.equalTo(self);
        }];
        
        UIButton *cancel = [UIButton new];
        [cancel setImage:[UIImage imageNamed:@"红包关闭按钮"] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(hidenAlertType) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tipView);
            make.bottom.equalTo(tipView.mas_top).offset(ChangedHeight(-5));
            make.size.mas_equalTo(CGSizeMake(ChangedHeight(25), ChangedHeight(25)));
        }];
//        cancel.layer.cornerRadius = ChangedHeight(12.5);
//        cancel.backgroundColor = [UIColor redColor];
        
        self.tipTitleLab = [UILabel new];
        self.tipTitleLab.textAlignment = NSTextAlignmentCenter;
        self.tipTitleLab.font = [UIFont gs_fontNum:18 weight:UIFontWeightBold];
        self.tipTitleLab.textColor = [UIColor getOrangeColor];
        [tipView addSubview:self.tipTitleLab];
        [self.tipTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipView).offset(ChangedHeight(66));
            make.height.mas_equalTo(ChangedHeight(42));
            make.left.right.equalTo(tipView);
        }];
        
        self.messageLab = [UILabel new];
        self.messageLab.textAlignment = NSTextAlignmentCenter;
        self.messageLab.font = [UIFont gs_fontNum:14 weight:UIFontWeightBold];
        self.messageLab.numberOfLines = 0;
        self.messageLab.textColor = [UIColor getOrangeColor];
        [tipView addSubview:self.messageLab];
        [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipTitleLab.mas_bottom);
            make.height.mas_equalTo(ChangedHeight(50));
            make.left.right.equalTo(tipView);
        }];
        
        self.thanksLab = [UILabel new];
        self.thanksLab.textAlignment = NSTextAlignmentCenter;
        self.thanksLab.font = [UIFont gs_fontNum:14 weight:UIFontWeightBold];
        self.thanksLab.textColor = [UIColor whiteColor];
        [tipView addSubview:self.thanksLab];
        [self.thanksLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tipView).offset(ChangedHeight(- 55));
            make.height.mas_equalTo(ChangedHeight(20));
            make.left.right.equalTo(tipView);
        }];
        
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"redBagBtn"] forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(hidenAlertType) forControlEvents:UIControlEventTouchUpInside];
        [tipView addSubview:self.cancelBtn];
        
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"redBagBtn"] forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [tipView addSubview:self.confirmBtn];
        
        _confirmBtn.titleLabel.font = cancel.titleLabel.font = [UIFont gs_fontNum:14];
        
        UILabel *tipLab = [UILabel new];
        tipLab.text = @"本活动最终解释权归金陵金服所有";
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.font = [UIFont gs_fontNum:8 weight:UIFontWeightBold];
        tipLab.textColor = [UIColor titleColor];
        [tipView addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tipView);
            make.height.mas_equalTo(ChangedHeight(15));
            make.left.right.equalTo(tipView);
        }];
    }
    return self;
}

- (void)hidenAlertType{
    [self removeFromSuperview];
}

/**
 <#Description#>
 */
- (void)showAlertType{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    self.hidden = NO;
    
}

- (void)confirmBtnClicked{
    [self hidenAlertType];
    if (_confirmBtnBlock) {
        _confirmBtnBlock();
    }
}

- (void)setRedBagType:(RedBagAleartType)redBagType{
    _redBagType = redBagType;
    switch (_redBagType) {
        case RedBagUsedNow:
        {
            self.cancelBtn.hidden = YES;
            [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.thanksLab);
                make.top.equalTo(self.thanksLab.mas_bottom).offset(ChangedHeight(10));
                make.size.mas_equalTo(CGSizeMake(ChangedHeight(80), ChangedHeight(25)));
            }];
        }
            break;
        case RedBagChanceUse:
        {
            self.cancelBtn.hidden = NO;
            [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thanksLab).offset(ChangedHeight(23));
                make.top.equalTo(self.thanksLab.mas_bottom).offset(ChangedHeight(10));
                make.size.mas_equalTo(CGSizeMake(ChangedHeight(80), ChangedHeight(25)));
            }];
            [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.thanksLab).offset(ChangedHeight(- 23));
                make.top.equalTo(self.thanksLab.mas_bottom).offset(ChangedHeight(10));
                make.size.mas_equalTo(CGSizeMake(ChangedHeight(80), ChangedHeight(25)));
            }];
        }
            break;

        default:
            break;
    }
}


- (void)aleartWithTip:(NSString *)tip Message:(NSString *)message Thanks:(NSString *)thanks Cancel:(NSString *)cancel Confirm:(NSString *)confirm{
    self.tipTitleLab.text = tip;
    self.messageLab.text = message;
    self.thanksLab.text = thanks;
    if (self.redBagType == RedBagUsedNow) {
        [self.confirmBtn setTitle:confirm forState:UIControlStateNormal];
    }else{
        [self.cancelBtn setTitle:cancel forState:UIControlStateNormal];
        [self.confirmBtn setTitle:confirm forState:UIControlStateNormal];
    }
}

@end
