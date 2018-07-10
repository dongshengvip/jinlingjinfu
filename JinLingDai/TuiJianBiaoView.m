//
//  TuiJianBiaoView.m
//  JinLingDai
//
//  Created by 001 on 2017/8/16.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "TuiJianBiaoView.h"
#import "UIView+Radius.h"
#import "ZZCACircleProgress.h"
#import "NSMutableAttributedString+contentText.h"
#import "NSTextAttachment+Util.h"
#import "NSString+formatFloat.h"
#import <objc/runtime.h>
@interface TuiJianBiaoView ()
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *durationLab;
@property (nonatomic, strong) UILabel *remainLab;
@property (nonatomic, strong) ZZCACircleProgress *gressView ;
@property (nonatomic, strong) UILabel *liLvLab;
@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) ListModel *model;
@property (nonatomic, strong) UILabel *IsXinShouLab;

@end
@implementation TuiJianBiaoView

- (instancetype)init{
    if (self = [super init]) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBorrowDetailVc)]];
        UIView *bgview = [UIView new];
        bgview.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgview];
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, ChangedHeight(5), 0, ChangedHeight(5)));
        }];
        UILabel *tipLab = [UILabel new];
        tipLab.text = @"推荐标";
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.textColor = [UIColor whiteColor];
        tipLab.backgroundColor= [UIColor getOrangeColor];
        tipLab.font = [UIFont gs_fontNum:14];
        [self addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgview).offset(ChangedHeight(5));
            make.top.equalTo(bgview).offset(ChangedHeight(5));
            make.height.mas_equalTo(ChangedHeight(25));
            make.width.mas_equalTo(ChangedHeight(60));
        }];
        
        [tipLab.superview layoutIfNeeded];
        [tipLab setCornerRadiusAdvance:5];
        self.IsXinShouLab = tipLab;
        
        UIView *lineView = [UIView drawDashLineWidth:K_WIDTH - ChangedHeight(30) lineLength:6 lineSpacing:2 lineColor:[UIColor tipTextColor]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(bgview);
            make.top.equalTo(tipLab.mas_bottom).offset(ChangedHeight(5));
            make.height.mas_equalTo(1);
        }];
        
        self.gressView = [[ZZCACircleProgress alloc] initWithFrame:CGRectMake(ChangedHeight(30), ChangedHeight(41), K_WIDTH - ChangedHeight(60), (K_WIDTH - ChangedHeight(60))/2) pathBackColor:nil pathFillColor:[UIColor getOrangeColor] startAngle:180 strokeWidth:10];
        self.gressView.reduceAngle = 180;
        self.gressView.showProgressText = NO;
        self.gressView.increaseFromLast = YES;
        self.gressView.duration = 1.f;//动画时长
        [self addSubview:self.gressView];
        self.gressView.prepareToShow = YES;
        [self.gressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).offset(ChangedHeight(-60));
            make.height.equalTo(self.gressView.mas_width).multipliedBy(0.5);
            make.centerX.equalTo(self);
            make.top.equalTo(lineView.mas_bottom).offset(ChangedHeight(10));
        }];
        
        [self addSubview:self.durationLab];
        [self.durationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgview).offset(- ChangedHeight(5));
            make.top.equalTo(self.gressView);
        }];
        
        [self addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLab.mas_right).offset(ChangedHeight(5));
            make.right.equalTo(self.durationLab);
            make.centerY.equalTo(tipLab);
        }];
        
        
        
        
        [self addSubview:self.liLvLab];
        [self.liLvLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.gressView).offset(ChangedHeight(50));
            make.left.right.equalTo(self.gressView);
        }];
        
        [self addSubview:self.remainLab];
        [self.remainLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.liLvLab.mas_bottom).offset(ChangedHeight(20));
            make.left.right.equalTo(self.liLvLab);
        }];
        UILabel *investLab = [UILabel new];
        investLab.text = @"立即投资";
        investLab.textColor = [UIColor whiteColor];
        investLab.layer.cornerRadius = 5;
        investLab.font = [UIFont gs_fontNum:14];
        investLab.textAlignment = NSTextAlignmentCenter;
        investLab.clipsToBounds = YES;
        investLab.backgroundColor = [UIColor getOrangeColor];
        [self addSubview:investLab];
        [investLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(self.gressView);
            make.top.equalTo(self.gressView.mas_bottom).offset(ChangedHeight(15));
            make.height.mas_equalTo(ChangedHeight(30));
        }];
        [self addSubview:self.tipsView];
        [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(bgview);
            make.height.mas_equalTo(ChangedHeight(25));
            make.top.equalTo(self.gressView.mas_bottom).offset(ChangedHeight(60));
        }];
        
        
    }
    return self;
}

- (void)setBiaoContenView:(ListModel *)item{
    if (Nilstr2Space(item.password).length) {
        self.IsXinShouLab.text = item.borrow_tip;
    }else
    self.IsXinShouLab.text = [Nilstr2Zero(item.is_xinshou) integerValue] == 1 ? @"新手标" : @"推荐标";
    self.model = item;
    self.durationLab.text = [NSString stringWithFormat:@"期限%@",item.borrow_duration];
    self.nameLab.text = [NSString stringWithFormat:@"%@(%@#)",item.borrow_name,item.id];;
    self.gressView.progress = [item.progress floatValue]/100;
    self.remainLab.text = [NSString stringWithFormat:@"剩余金额  %@元",item.rest_borrow_money];
    NSString *borrow_interest_rate = [item.reward floatValue] > 0 ? [NSString stringWithFormat:@"%@ + %@%%",[NSString formatFloat:[item.borrow_interest_rate floatValue]],[NSString formatFloat:[item.reward floatValue]]] : [NSString stringWithFormat:@"%@%%",[NSString formatFloat:[item.borrow_interest_rate floatValue]]];
    NSMutableAttributedString *attrStr = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"年化利率\n%@",borrow_interest_rate] Font:[UIFont gs_fontNum:21] Color:[UIColor getOrangeColor] grayText:borrow_interest_rate TextAligment:NSTextAlignmentCenter LineSpace:ChangedHeight(6)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:14] range:[attrStr.string rangeOfString:@"%"]];
    self.liLvLab.attributedText = attrStr;
    NSString *rate_type= [item.rate_type integerValue] == 1?@"即投计息":@"满标计息";//1=>即投计息，2=》满标计息
    [self setTipsTitle:@[[NSString stringWithFormat:@"%@起投",Nilstr2Zero(item.borrow_min)], item.huankuan_type, rate_type]];
}

- (void)gotoBorrowDetailVc{
    if (_biaoClickedBlock) {
        
        _biaoClickedBlock(self.model.id);
    }
}

- (void)setTipsTitle:(NSArray *)tips{
    [self.tipsView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    __block UIView *last = nil;
    [tips enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        UITextView *lab = [UITextView new];

        lab.userInteractionEnabled = NO;
        [self.tipsView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.tipsView);
//            make.height.mas_equalTo(20);
            if (idx == 0) {
                make.left.equalTo(self.tipsView);
            }else{
                make.width.equalTo(last);
                make.left.equalTo(last.mas_right);
            }
            if (idx == tips.count - 1) {
                make.right.equalTo(self.tipsView);
            }
            
        }];
        NSString *tibStr = title.length >= 6 ? [title substringWithRange:NSMakeRange(0, 5)]:title;
        NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:[self getIconImg:idx]];
        NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:tibStr]];
        NSRange range = NSMakeRange(0, 0);
        [mutableAttributeString replaceCharactersInRange:range withAttributedString:emojiAttributedString];
        
        lab.attributedText = mutableAttributeString;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor newSecondTextColor];
        lab.selectedRange = NSMakeRange(1, 0);
        [lab insertText:@" "];
        lab.font = [UIFont gs_fontNum:14];
        last = lab;
    }];
}

- (NSTextAttachment *)getIconImg:(NSInteger)index{
    NSTextAttachment *textAttachment = [NSTextAttachment new];
    textAttachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"tip-%@",@(index)]];
    [textAttachment adjustY:-1.5];
    
    objc_setAssociatedObject(textAttachment, @"emoji", [NSString stringWithFormat:@"tip-%@",@(index)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return textAttachment;
}
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont gs_fontNum:14];
        _nameLab.textColor = [UIColor titleColor];
        //       _nameLab.textAlignment = <#NSTextAlignment#>;
        //       _nameLab.backgroundColor = [UIColor <#Color#>];
    }
    return _nameLab;
}

- (UILabel *)durationLab {
    if (!_durationLab) {
        _durationLab = [UILabel new];
        _durationLab.font = [UIFont gs_fontNum:14];
        _durationLab.textColor = [UIColor getOrangeColor];
        _durationLab.textAlignment = NSTextAlignmentRight;
        //       _durationLab.backgroundColor = [UIColor <#Color#>];
    }
    return _durationLab;
}

- (UILabel *)remainLab {
    if (!_remainLab) {
        _remainLab = [UILabel new];
        _remainLab.font = [UIFont gs_fontNum:14];
        _remainLab.textColor = [UIColor newSecondTextColor];
        _remainLab.textAlignment = NSTextAlignmentCenter;
        //       _remainLab.backgroundColor = [UIColor <#Color#>];
    }
    return _remainLab;
}


- (UILabel *)liLvLab {
    if (!_liLvLab) {
        _liLvLab = [UILabel new];
        _liLvLab.font = [UIFont gs_fontNum:14];
        _liLvLab.numberOfLines = 2;
        _liLvLab.textColor = [UIColor newSecondTextColor];
        _liLvLab.textAlignment = NSTextAlignmentCenter;
        //       _liLvLab.backgroundColor = [UIColor <#Color#>];
    }
    return _liLvLab;
}

- (UIView *)tipsView {
    if (!_tipsView) {
        _tipsView = [UIView new];
        _tipsView.backgroundColor = [UIColor clearColor];
    }
    return _tipsView;
}
@end
