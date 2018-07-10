//
//  CompanyInfoView.m
//  JinLingDai
//
//  Created by 001 on 2017/6/29.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "CompanyInfoView.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#import "UIView+Masonry.h"
#define CompanyArr @[@"2013年", @"江苏", @"经济信息"]
#define CompanyBtnArr @[@"成立于", @"总部位于", @"经营范围"]
@interface CompanyInfoView ()
@property (nonatomic, strong) UIView *verLine;//
@property (nonatomic, strong) UILabel *companyInfoLab;//
@property (nonatomic, strong) UIButton *moreThanBtn;//

@end
@implementation CompanyInfoView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.verLine = [UIView new];
        self.verLine.backgroundColor = [UIColor getOrangeColor];
        [self addSubview:self.verLine];
        
        self.companyInfoLab = [UILabel new];
        self.companyInfoLab.text = @"公司简介";
        self.companyInfoLab.textColor = [UIColor getBlueColor];
        self.companyInfoLab.font = [UIFont gs_fontNum:16 weight:UIFontWeightBold];
        [self addSubview:self.companyInfoLab];
        
        self.moreThanBtn = [UIButton new];
        [self.moreThanBtn setTitle:@"更多 >" forState:UIControlStateNormal];
        [self.moreThanBtn addTarget:self action:@selector(moreThanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.moreThanBtn.titleLabel.font = [UIFont gs_fontNum:16];
        [self.moreThanBtn setTitleColor:[UIColor getColor:82 G:83 B:84] forState:UIControlStateNormal];
        [self addSubview:self.moreThanBtn];
        
        UIView *lastView = nil;
        for (int i = 0; i < 3; i++) {
            UIView *bgView = [UIView new];
            bgView.backgroundColor = [UIColor infosBackViewColor];
            bgView.layer.masksToBounds = YES;
            bgView.layer.cornerRadius = 6;
            [self addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (!lastView) {
                    make.left.equalTo(self.verLine);
                }else{
                    make.left.equalTo(lastView.mas_right).offset(ChangedHeight(5));
                    make.width.equalTo(lastView);
                }
                if (i == 2) {
                    make.right.equalTo(self).offset(ChangedHeight(-9));
                }
                
                make.top.equalTo(self.verLine.mas_bottom).offset(ChangedHeight(10));
                make.bottom.equalTo(self).offset(ChangedHeight(-10));
            }];
            lastView = bgView;
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CompanyArr[i]]];
//            img.backgroundColor = [UIColor yellowColor];
            [bgView addSubview:img];
            img.contentMode = UIViewContentModeScaleAspectFill;
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(bgView);
                make.height.equalTo(bgView).dividedBy(2.0);
            }];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:CompanyBtnArr[i]] forState:UIControlStateNormal];
            [btn setTitle:CompanyBtnArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            btn.titleLabel.font = [UIFont gs_fontNum:14];
            [bgView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(bgView);
                make.top.equalTo(img.mas_bottom).offset(ChangedHeight(5));
                make.height.mas_equalTo(ChangedHeight(30));
            }];
            
            UILabel *tipLab = [UILabel new];
            tipLab.textColor = [UIColor getBlueColor];
            tipLab.textAlignment = NSTextAlignmentCenter;
            tipLab.font = [UIFont gs_fontNum:16];
            tipLab.text = CompanyArr[i];
            [bgView addSubview:tipLab];
            [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(bgView);
                make.top.equalTo(btn.mas_bottom).offset(ChangedHeight(5));
            }];
        }

        
        [self setLayoutMasnory];
    }
    return self;
}


- (void)setLayoutMasnory{
    [self.verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ChangedHeight(9));
        make.top.equalTo(self).offset(ChangedHeight(18));
        make.width.mas_equalTo(ChangedHeight(2));
        make.height.mas_equalTo(ChangedHeight(15));
    }];
    
    [self.companyInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verLine.mas_right).offset(ChangedHeight(5));
        make.centerY.equalTo(self.verLine);
    }];
    
    [self.moreThanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.companyInfoLab);
        make.height.mas_equalTo(ChangedHeight(22));
        make.width.mas_equalTo(ChangedHeight(50));
    }];
    
}

/**
 more按钮的点击
 */
- (void)moreThanBtnClicked{
    if (_moreTahnBtnBlock) {
        _moreTahnBtnBlock();
    }
}
@end
