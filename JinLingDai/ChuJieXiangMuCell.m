//
//  ChuJieXiangMuCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/10.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ChuJieXiangMuCell.h"
#import "NSMutableAttributedString+contentText.h"
#import "NSString+formatFloat.h"
@interface ChuJieXiangMuCell (){
    UILabel *dayLab;
}
@property (nonatomic, strong) UILabel *remainMoneyLab;
@property (nonatomic, strong) UILabel *yearLiLvLab;
@property (nonatomic, strong) UILabel *daysLab;
@property (nonatomic, strong) UILabel *totolMoneyLab;
@property (nonatomic, strong) UIProgressView *gressView ;//进度
@property (nonatomic, strong) UILabel *progressLab;//进度值
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation ChuJieXiangMuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.remainMoneyLab = [UILabel new];
        self.remainMoneyLab.textColor = [UIColor titleColor];
        self.remainMoneyLab.font = [UIFont gs_fontNum:14 weight:UIFontWeightBold];
        self.remainMoneyLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.remainMoneyLab];
        [self.remainMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(ChangedHeight(20));
//            make.height.mas_equalTo(ChangedHeight(25));
//            make.width.equalTo(self.contentView).multipliedBy(1/3.0);
        }];
        
        self.yearLiLvLab = [UILabel new];
        self.yearLiLvLab.textColor = [UIColor getOrangeColor];
        self.yearLiLvLab.textAlignment = NSTextAlignmentCenter;
        self.yearLiLvLab.font = [UIFont gs_fontNum:14];
        [self.contentView addSubview:self.yearLiLvLab];

        [self.yearLiLvLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.remainMoneyLab.mas_right);
            make.centerY.width.equalTo(self.remainMoneyLab);
        }];
        
        self.daysLab = [UILabel new];
        self.daysLab.textAlignment = NSTextAlignmentCenter;
        self.daysLab.textColor = [UIColor titleColor];
        self.daysLab.font = [UIFont gs_fontNum:14 weight:UIFontWeightBold];
        [self.contentView addSubview:self.daysLab];
        [self.daysLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.yearLiLvLab.mas_right);
            make.centerY.width.equalTo(self.remainMoneyLab);
            make.right.equalTo(self.contentView);

        }];
        
        UILabel *moneyLab = [UILabel new];
        moneyLab.text = @"剩余金额（元）";
        moneyLab.textAlignment = NSTextAlignmentCenter;
        moneyLab.textColor = [UIColor newSecondTextColor];
        moneyLab.font = [UIFont gs_fontNum:10];
        [self.contentView addSubview:moneyLab];
        [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.remainMoneyLab);
            make.top.equalTo(self.remainMoneyLab.mas_bottom).offset(ChangedHeight(5));
        }];
        
        UILabel *lilvLab = [UILabel new];
        lilvLab.text = @"借款年化";
        lilvLab.textAlignment = NSTextAlignmentCenter;
        lilvLab.textColor = [UIColor newSecondTextColor];
        lilvLab.font = [UIFont gs_fontNum:10];
        [self.contentView addSubview:lilvLab];
        [lilvLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.yearLiLvLab);
            make.top.equalTo(moneyLab);
        }];
        
        dayLab = [UILabel new];
        dayLab.text = @"出借期限（月）";
        dayLab.textAlignment = NSTextAlignmentCenter;
        dayLab.textColor = [UIColor newSecondTextColor];
        dayLab.font = [UIFont gs_fontNum:10];
        [self.contentView addSubview:dayLab];
        [dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.daysLab);
            make.top.equalTo(moneyLab);
        }];
        
        self.gressView = [[UIProgressView alloc]init];
        self.gressView.progressTintColor = [UIColor getOrangeColor];
        self.gressView.trackTintColor = [UIColor infosBackViewColor];
        [self.contentView addSubview:self.gressView];
        [self.gressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(self.contentView).offset(ChangedHeight(-135));
            make.top.equalTo(moneyLab.mas_bottom).offset(ChangedHeight(15));
            make.height.mas_equalTo(ChangedHeight(3));
        }];
        
        self.progressLab = [UILabel new];
        self.progressLab.font = [UIFont gs_fontNum:12];
        self.progressLab.textColor = [UIColor getColor:133 G:134 B:135];
        [self.contentView addSubview:self.progressLab];
        [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gressView.mas_right).offset(ChangedHeight(18));
            make.centerY.equalTo(self.gressView);
            
        }];
        
        [self.contentView addSubview:self.totolMoneyLab];
        [self.totolMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.gressView.mas_bottom).offset(ChangedHeight(14));
            
        }];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor newSeparatorColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.contentView).offset(ChangedHeight(- 35));
        }];
        
        self.tipsView = [UIView new];
        [self.contentView addSubview:self.tipsView];
        [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(line.mas_bottom);
        }];
        
    }
    return self;
}

- (void)setTipsTitle:(NSArray *)tips{
    [self.tipsView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    __block UIView *last = nil;
    [tips enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = [UILabel new];
        lab.textColor = [UIColor tipTextColor];
        lab.font = [UIFont gs_fontNum:12];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = obj;
        [self.tipsView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (idx == 0) {
                make.top.bottom.left.equalTo(self.tipsView);
            }else{
                make.top.bottom.width.equalTo(last);
                make.left.equalTo(last.mas_right);
            }
            if (idx == tips.count - 1) {
                make.right.equalTo(self.tipsView);
            }
            
        }];
        last = lab;
    }];
}

- (void)setContenView:(ListModel *)item{
    if (!item) {
        return;
    }
    dayLab.text = [item.duration_unit containsString:@"天"] ?@"出借天数（天）":@"出借期限（月）";
    NSString *rate_type= [item.rate_type integerValue] == 1?@"即投计息":@"满标计息";//1=>即投计息，2=》满标计息
    
    [self setTipsTitle:@[[NSString stringWithFormat:@"%@起投",Nilstr2Zero(item.borrow_min)], item.repayment_type, rate_type]];
    self.remainMoneyLab.text = item.rest_borrow_money;
    
    NSString *borrow_interest_rate = [item.reward floatValue] > 0 ? [NSString stringWithFormat:@"%@ + %@%%",[NSString formatFloat:[item.borrow_interest_rate floatValue]],[NSString formatFloat:[item.reward floatValue]]] : [NSString stringWithFormat:@"%@%%",[NSString formatFloat:[item.borrow_interest_rate floatValue]]];
    
//    NSString *interest_rate = [NSString stringWithFormat:@"%@%%",Nilstr2Space(item.borrow_interest_rate)];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:borrow_interest_rate];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:18 weight:UIFontWeightBold] range:[attr.string rangeOfString:borrow_interest_rate]];
//    attr addAttribute:<#(nonnull NSString *)#> value:<#(nonnull id)#> range:<#(NSRange)#>
    self.yearLiLvLab.attributedText = attr;
    
    self.totolMoneyLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"借款金额：%@元",item.borrow_money] Font:[UIFont gs_fontNum:14] Color:[UIColor getOrangeColor] grayText:item.borrow_money TextAligment:NSTextAlignmentCenter LineSpace:1.f];
    self.daysLab.text = [NSString stringWithFormat:@"%@%@",item.borrow_duration,[item.duration_unit containsString:@"天"]?@"天":@"个月"];
    
    [self.gressView setProgress:[item.progress floatValue]/100];
    self.progressLab.text = [NSString stringWithFormat:@"%.2f%%",[item.progress floatValue]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)totolMoneyLab {
   if (!_totolMoneyLab) {
       _totolMoneyLab = [UILabel new];
       _totolMoneyLab.font = [UIFont gs_fontNum:14];
       _totolMoneyLab.textColor = [UIColor titleColor];
       _totolMoneyLab.textAlignment = NSTextAlignmentCenter;
//       _totolMoneyLab.backgroundColor = [UIColor <#Color#>];
   }
   return _totolMoneyLab;
}

@end
