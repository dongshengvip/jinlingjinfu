//
//  ProductionCell.m
//  JinLingDai
//
//  Created by 001 on 2017/6/29.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ProductionCell.h"
#import "UIView+Radius.h"
#import "NSMutableAttributedString+contentText.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#import "NSString+formatFloat.h"
@interface ProductionCell ()
@property (nonatomic, strong) UILabel *biaoQiXianLab;
@property (nonatomic, strong) UILabel *durationLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *fulfilLab;//满额
@property (nonatomic, strong) UIButton *rightBtn;//抢购按钮
@property (nonatomic, strong) UILabel *LiLvLab;//利率
@property (nonatomic, strong) UILabel *remainedLab;//剩余
@property (nonatomic, strong) UIImageView *songImg;//送的利率
@property (nonatomic, strong) UIProgressView *gressView ;//进度
@property (nonatomic, strong) UILabel *progressLab;//进度值
@end
@implementation ProductionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.durationLab = [UILabel new];
        self.durationLab.backgroundColor = [UIColor getOrangeColor];
        self.durationLab.textColor = [UIColor whiteColor];
        self.durationLab.textAlignment = NSTextAlignmentCenter;
        self.durationLab.font = [UIFont gs_fontNum:12];
        [self.contentView addSubview:self.durationLab];
        [self.durationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(-17));
            make.top.equalTo(self.contentView).offset(ChangedHeight(5));

            make.height.equalTo(self.contentView).dividedBy(6.0).offset(-5);
            make.width.mas_equalTo(ChangedHeight(65));
        }];
        [self.durationLab.superview layoutIfNeeded];
        self.durationLab.transform = CGAffineTransformMakeRotation(-M_PI/4.1);
        self.layer.masksToBounds = YES;
        
        self.rightBtn = [UIButton new];
        self.titleLab = [UILabel new];
        [self.contentView addSubview:self.titleLab];
        
        [self.contentView addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(ChangedHeight(-10));
            make.centerY.equalTo(self.titleLab);
//            make.top.equalTo(self.contentView);
//            make.height.equalTo(self.contentView).dividedBy(3.0).offset(ChangedHeight(-15));
            make.height.equalTo(self.titleLab).offset(ChangedHeight(-15));
            make.width.equalTo(self.rightBtn.mas_height).dividedBy(0.5);
        }];
        
        
        
        self.titleLab.textColor = [UIColor getColor:83 G:84 B:85];
        self.titleLab.font = [UIFont gs_fontNum:14];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(45));
            make.top.equalTo(self.contentView);
            make.height.equalTo(self.contentView).dividedBy(3.0);
            make.right.lessThanOrEqualTo(self.rightBtn.mas_left).offset(-5);
        }];
        
        
        [self.rightBtn addTarget:self action:@selector(rightbtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.fulfilLab = [UILabel new];
        self.fulfilLab.text = @"融资满额";
        self.fulfilLab.hidden = YES;
        self.fulfilLab.textColor = self.titleLab.textColor;
        self.fulfilLab.font = self.titleLab.font;
        [self.contentView addSubview:self.fulfilLab];
        [self.fulfilLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.rightBtn);
//            make.
        }];
        UIView *line = [UIView drawDashLineWidth:K_WIDTH lineLength:5 lineSpacing:1 lineColor:[UIColor newSeparatorColor]];
        
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.titleLab);
        }];
        
        self.LiLvLab = [UILabel new];
        self.LiLvLab.textColor = [UIColor getColor:83 G:84 B:85];
        self.LiLvLab.font = [UIFont gs_fontNum:14];
        self.LiLvLab.textAlignment = NSTextAlignmentCenter;
        self.LiLvLab.numberOfLines = 2;
        [self.contentView addSubview:self.LiLvLab];
        [self.LiLvLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(12));
            make.top.equalTo(line.mas_bottom).offset(ChangedHeight(15));
//            make.height.mas_equalTo(ChangedHeight(20));
//            make.width.mas_equalTo(ChangedHeight(<#height#>));
        }];
        
        UIView *verLine = [UIView new];
        verLine.backgroundColor = [UIColor newSeparatorColor];
        [self.contentView addSubview:verLine];
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(100));
            make.top.equalTo(self.LiLvLab).offset(ChangedHeight(-2));
            make.bottom.equalTo(self.LiLvLab).offset(ChangedHeight(1));
            make.width.mas_equalTo(1);
        }];
        UIView *verLine2 = [UIView new];
        verLine2.backgroundColor = [UIColor newSeparatorColor];
        [self.contentView addSubview:verLine2];
        [verLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(ChangedHeight(-75));
            make.top.equalTo(self.LiLvLab).offset(ChangedHeight(-2));
            make.bottom.equalTo(self.LiLvLab).offset(ChangedHeight(1));
            make.width.mas_equalTo(1);
        }];
        self.songImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"送"]];
        [self.contentView addSubview:self.songImg];
        [self.songImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(verLine.mas_top);
            make.right.equalTo(verLine).offset(ChangedHeight(-5));
        }];
        self.remainedLab = [UILabel new];
        self.remainedLab.textColor = [UIColor getColor:83 G:84 B:85];
        self.remainedLab.numberOfLines = 2;
        self.remainedLab.font = [UIFont gs_fontNum:13];
        [self.contentView addSubview:self.remainedLab];
        [self.remainedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(verLine).offset(ChangedHeight(15));
            make.right.equalTo(verLine2).offset(-ChangedHeight(10));
            make.centerY.equalTo(self.LiLvLab);
            
        }];
        
        [self.contentView addSubview:self.biaoQiXianLab];
        [self.biaoQiXianLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(verLine2).offset(ChangedHeight(5));
            make.right.equalTo(self.contentView).offset(-ChangedHeight(5));
            make.centerY.equalTo(self.LiLvLab);
        }];
        self.gressView = [[UIProgressView alloc]init];
        self.gressView.progressTintColor = [UIColor getOrangeColor];
        self.gressView.trackTintColor = [UIColor infosBackViewColor];
        [self.contentView addSubview:self.gressView];
        [self.gressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.LiLvLab);
            make.width.equalTo(self.contentView).offset(ChangedHeight(-65));
            make.bottom.equalTo(self.contentView).offset(ChangedHeight(-10));
            make.height.mas_equalTo(ChangedHeight(3));
        }];
        
        self.progressLab = [UILabel new];
        self.progressLab.font = [UIFont gs_fontNum:13];
        self.progressLab.textColor = [UIColor getColor:133 G:134 B:135];
        [self.contentView addSubview:self.progressLab];
        [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gressView.mas_right).offset(ChangedHeight(5));
            make.centerY.equalTo(self.gressView);
            
        }];
    }
    return self;
}

- (void)rightbtnClicked{
    if (_robBuyBtnClick) {
        _robBuyBtnClick();
    }
}

- (void)layoutViewsItem:(ListModel *)item{
//    if (Nilstr2Space(item.password).length) {
//        self.durationLab.text = @"定向标";
//    }else
    UIColor *showColor = [UIColor getOrangeColor];
    if ([item.progress floatValue]/100 == 1) {
        showColor = [UIColor newSecondTextColor];
    }
        self.durationLab.text = Nilstr2Zero(item.borrow_tip).length? item.borrow_tip : item.borrow_duration;
    NSMutableAttributedString *biaoQiXianAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"期限%@",item.borrow_duration]];
    [biaoQiXianAttr addAttribute:NSForegroundColorAttributeName value:showColor range:NSMakeRange(2, biaoQiXianAttr.string.length - 2)];
    self.biaoQiXianLab.attributedText = biaoQiXianAttr;
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@#)",item.borrow_name,item.id];
    NSString *borrow_interest_rate = [item.reward floatValue] > 0 ? [NSString stringWithFormat:@"%@ + %@%%",[NSString formatFloat:[item.borrow_interest_rate floatValue]],[NSString formatFloat:[item.reward floatValue]]] : [NSString stringWithFormat:@"%@%%",[NSString formatFloat:[item.borrow_interest_rate floatValue]]];
    
    NSString *str = [NSString stringWithFormat:@"%@\n年化利率",borrow_interest_rate];
    NSAttributedString *attr = [NSMutableAttributedString getAttributedString:str Font:[UIFont gs_fontNum:19] Color:showColor grayText:borrow_interest_rate TextAligment:NSTextAlignmentCenter LineSpace:5];
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc]initWithAttributedString:attr];
    [mutableAttr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:13] range:NSMakeRange(item.borrow_interest_rate.length, 1)];

    self.LiLvLab.attributedText = mutableAttr;
    

    NSString *remainedStr = [NSString stringWithFormat:@"可投金额%@元\n借款总额%@",item.rest_borrow_money,[NSString formatFloat:[item.borrow_money floatValue]]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5;
    NSMutableAttributedString *remainedAttrib = [[NSMutableAttributedString alloc]initWithString:remainedStr attributes:@{NSParagraphStyleAttributeName : style}];
    self.remainedLab.attributedText = remainedAttrib;
    
    [self.gressView setProgress:[item.progress floatValue]/100];
    
    self.progressLab.text = [NSString stringWithFormat:@"%.2f%%",[item.progress floatValue]];
    self.rightBtn.hidden = [item.progress floatValue]/100 == 1;
    self.fulfilLab.hidden = [item.progress floatValue]/100 < 1;
    
    [self.rightBtn setTitle:@"抢购" forState:UIControlStateNormal];

    [self.rightBtn setTitleColor:[UIColor getOrangeColor] forState:UIControlStateNormal];
    self.rightBtn.layer.cornerRadius = ChangedHeight(40 - 15)/2;
    self.rightBtn.layer.borderWidth = 1.f;
    self.rightBtn.layer.borderColor = [UIColor getOrangeColor].CGColor;
    self.rightBtn.titleLabel.font = [UIFont gs_fontNum:13];
    
    self.songImg.hidden = [item.reward floatValue] <= 0 ;
    self.gressView.progressTintColor = showColor;
    self.durationLab.backgroundColor = showColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)biaoQiXianLab {
   if (!_biaoQiXianLab) {
       _biaoQiXianLab = [UILabel new];
       _biaoQiXianLab.font = [UIFont gs_fontNum:12];
       _biaoQiXianLab.textColor = [UIColor newSecondTextColor];
       _biaoQiXianLab.textAlignment = NSTextAlignmentCenter;
//       _biaoQiXianLab.backgroundColor = [UIColor <#Color#>];
   }
   return _biaoQiXianLab;
}

@end
