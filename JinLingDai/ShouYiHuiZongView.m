//
//  ShouYiHuiZongView.m
//  JinLingDai
//
//  Created by 001 on 2017/7/5.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ShouYiHuiZongView.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#import "NSDate+Formatter.h"
#import "UIView+Masonry.h"
@interface ShouYiHuiZongView ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UILabel *huiKuanNumLab;
@property (nonatomic, strong) UILabel *totolMoneyLab;
@property (nonatomic, strong) UILabel *benJinLab;
@property (nonatomic, strong) UILabel *liXiLab;
@end
@implementation ShouYiHuiZongView

- (instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor infosBackViewColor];
        self.titleLab = [UILabel new];
        self.titleLab.textColor = [UIColor borderColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.font = [UIFont gs_fontNum:12];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(ChangedHeight(40));
        }];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLab.mas_bottom);
            make.height.mas_equalTo(ChangedHeight(50));
        }];
        
        UIView *verLine1 = [UIView new];
        verLine1.backgroundColor = [UIColor borderColor];
        [bgView addSubview:verLine1];
        [verLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerY.equalTo(bgView);
            make.height.equalTo(bgView).multipliedBy(5/8.0);
        }];
        
        UIView *verLine2 = [UIView new];
        verLine2.backgroundColor = [UIColor borderColor];
        [bgView addSubview:verLine2];
        [verLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerY.equalTo(bgView);
            make.height.equalTo(bgView).multipliedBy(5/8.0);
        }];
        UIView *verLine3 = [UIView new];
        verLine3.backgroundColor = [UIColor borderColor];
        [bgView addSubview:verLine3];
        [verLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerY.equalTo(bgView);
            make.height.equalTo(bgView).multipliedBy(5/8.0);
        }];
        
        [bgView distributeSpacingHorizontallyWith:@[verLine1,verLine2,verLine3]];
        
        self.huiKuanNumLab = [UILabel new];
        self.huiKuanNumLab.textColor = [UIColor getOrangeColor];
        self.huiKuanNumLab.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.huiKuanNumLab];
        [self.huiKuanNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView);
            make.right.equalTo(verLine1.mas_left);
            make.bottom.equalTo(verLine1.mas_centerY).offset(ChangedHeight(5));
            make.top.equalTo(bgView);
        }];
        
        UILabel *huikuan = [UILabel new];
        huikuan.textColor = [UIColor borderColor];
        huikuan.text = @"回款笔数";
        huikuan.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:huikuan];
        [huikuan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView);
            make.right.equalTo(verLine1.mas_left);
            make.top.equalTo(verLine1.mas_centerY).offset(ChangedHeight(-5));
            make.bottom.equalTo(bgView);
        }];
        
        self.totolMoneyLab = [UILabel new];
        self.totolMoneyLab.textColor = [UIColor getOrangeColor];
        self.totolMoneyLab.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.totolMoneyLab];
        [self.totolMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(verLine1.mas_right);
            make.right.equalTo(verLine2.mas_left);
            make.bottom.equalTo(self.huiKuanNumLab);
            make.top.equalTo(bgView);
        }];
        
        UILabel *jineLab = [UILabel new];
        jineLab.textColor = [UIColor borderColor];
        jineLab.text = @"总金额";
        jineLab.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:jineLab];
        [jineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.totolMoneyLab);
            make.top.equalTo(huikuan);
            make.bottom.equalTo(bgView);
        }];
        
        self.benJinLab = [UILabel new];
        self.benJinLab.textColor = [UIColor getOrangeColor];
        self.benJinLab.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.benJinLab];
        [self.benJinLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(verLine2.mas_right);
            make.right.equalTo(verLine3.mas_left);
            make.bottom.equalTo(self.huiKuanNumLab);
            make.top.equalTo(bgView);
        }];
        UILabel *benjin = [UILabel new];
        benjin.textColor = [UIColor borderColor];
        benjin.text = @"本金";
        benjin.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:benjin];
        [benjin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.benJinLab);
            make.top.equalTo(huikuan);
            make.bottom.equalTo(bgView);
        }];
        self.liXiLab = [UILabel new];
        self.liXiLab.textColor = [UIColor getOrangeColor];
        self.liXiLab.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.liXiLab];
        [self.liXiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView);
            make.left.equalTo(verLine3.mas_right);
            make.bottom.equalTo(self.huiKuanNumLab);
            make.top.equalTo(bgView);
        }];
        UILabel *lixi = [UILabel new];
        lixi.textColor = [UIColor borderColor];
        lixi.text = @"利息";
        lixi.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:lixi];
        [lixi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.liXiLab);
            make.top.equalTo(huikuan);
            make.bottom.equalTo(bgView);
        }];
        
        self.tipLab = [UILabel new];
        self.tipLab.textColor = [UIColor borderColor];
        self.tipLab.text = @"无收益记录";
        self.tipLab.font = [UIFont gs_fontNum:12];
        self.tipLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tipLab];
        [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_bottom).offset(ChangedHeight(12));
            make.left.right.equalTo(self);
        }];
        
        self.huiKuanNumLab.font = [UIFont gs_fontNum:12];
        self.totolMoneyLab.font = [UIFont gs_fontNum:12];
        self.benJinLab.font = [UIFont gs_fontNum:12];
        self.liXiLab.font = [UIFont gs_fontNum:12];
        huikuan.font = [UIFont gs_fontNum:12];
        jineLab.font = [UIFont gs_fontNum:12];
        benjin.font = [UIFont gs_fontNum:12];
        lixi.font = [UIFont gs_fontNum:12];
    }
    return self;
}

- (void)setConten:(MonthModel *)item{
    self.titleLab.text = item.dateValue.yyyyMMddByLineWithDate;
    NSComparisonResult result = [item.dateValue compare:[NSDate getDateTypeyyyyMMdd]];
    if (result == NSOrderedDescending) {
        self.huiKuanNumLab.text = @"0";
        self.totolMoneyLab.text = self.benJinLab.text = self.liXiLab.text = @"0.00";
        self.tipLab.hidden = NO;
    }else{
        self.tipLab.hidden = YES;
        self.huiKuanNumLab.text = @"1";
        self.totolMoneyLab.text = self.benJinLab.text = self.liXiLab.text = @"0.10";
    }
}

@end
