//
//  ExtractMoneyView.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ExtractMoneyView.h"
#import <Masonry.h>
#import "UIColor+Util.h"
@interface ExtractMoneyView ()

@end
@implementation ExtractMoneyView

- (instancetype)init{
    if (self = [super init]) {
        UILabel *tipLab = [UILabel new];
        tipLab.textColor = [UIColor darkGrayColor];
        tipLab.font = [UIFont gs_fontNum:12];
        tipLab.text = @"提现金额（元）";
        [self addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ChangedHeight(15));
            make.top.equalTo(self).offset(ChangedHeight(18));
            make.height.mas_equalTo(ChangedHeight(15));
        }];
        UILabel *lab = [UILabel new];
        lab.text = @"¥";
        lab.font = [UIFont gs_fontNum:25];
        lab.bounds = CGRectMake(0, 0, ChangedHeight(30), ChangedHeight(50));
//        KeyBordToolView *toolView = [KeyBordToolView shareManager];
        
        self.moneyText = [[UITextField alloc]init];
        self.moneyText.keyboardType = UIKeyboardTypeDecimalPad;
        self.moneyText.font = [UIFont gs_fontNum:20];
        self.moneyText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入提款金额" attributes:@{NSForegroundColorAttributeName:[UIColor getColor:134 G:135 B:136],NSFontAttributeName:[UIFont gs_fontNum:20]}];
        self.moneyText.leftView = lab;
        self.moneyText.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.moneyText];
        [self.moneyText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLab);
            make.top.equalTo(tipLab.mas_bottom).offset(ChangedHeight(10));
            make.bottom.equalTo(self).offset(ChangedHeight(- 10));
            make.right.equalTo(self).offset(ChangedHeight(-15));
        }];
//        toolView.DoneBlock = ^{
//            [self.moneyText resignFirstResponder];
//        };
//        self.moneyText.inputAccessoryView = toolView;
    }
    return self;
}

@end
