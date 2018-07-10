//
//  YearsInterestCell.m
//  JinLingDai
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "YearsInterestCell.h"
#import <Masonry.h>
#import "UIColor+Util.h"
@interface YearsInterestCell()
@property (nonatomic, strong) UILabel *LiLvLab;//利率
@property (nonatomic, strong) UILabel *remainedLab;//剩余
//@property (nonatomic, strong) UILabel *LiLvLab;//利率
@property (nonatomic, strong) UIProgressView *gressView ;//进度
@property (nonatomic, strong) UILabel *progressLab;//进度值
@end
@implementation YearsInterestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.LiLvLab = [UILabel new];
        self.LiLvLab.textColor = [UIColor getOrangeColor];
        [self.contentView addSubview:self.LiLvLab];
        [self.LiLvLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(20));
            make.top.equalTo(self.contentView).offset(ChangedHeight(5));
            make.height.mas_equalTo(ChangedHeight(35));
//            make.width.mas_equalTo()
        }];
        
        self.remainedLab = [UILabel new];
        self.remainedLab.textColor = [UIColor getColor:83 G:83 B:83];
        self.remainedLab.font = [UIFont gs_fontNum:14];
        [self.contentView addSubview:self.remainedLab];
        [self.remainedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX).offset(ChangedHeight(5));
            make.centerY.equalTo(self.LiLvLab);
            
        }];
        
        UILabel *tip = [UILabel new];
        tip.textColor = [UIColor getColor:83 G:83 B:83];
        tip.font = [UIFont gs_fontNum:14];
        tip.text = @"年化利率";
        [self.contentView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.LiLvLab);
            make.top.equalTo(self.LiLvLab.mas_bottom).offset(ChangedHeight(5));
            make.bottom.equalTo(self.contentView).offset(-ChangedHeight(10));
        }];
        
        self.gressView = [[UIProgressView alloc]init];
        self.gressView.progressTintColor = [UIColor getOrangeColor];
        self.gressView.trackTintColor = [UIColor infosBackViewColor];
        [self.contentView addSubview:self.gressView];
        [self.gressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.remainedLab);
            make.width.mas_equalTo(ChangedHeight(100));
            make.centerY.equalTo(tip);
            make.height.mas_equalTo(ChangedHeight(4));
        }];
        
        self.progressLab = [UILabel new];
        self.progressLab.font = [UIFont gs_fontNum:13];
        self.progressLab.textColor = [UIColor getColor:83 G:83 B:83];
        [self.contentView addSubview:self.progressLab];
        [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gressView.mas_right).offset(ChangedHeight(5));
            make.centerY.equalTo(self.gressView);
            
        }];
    }
    return self;
}

- (void)layoutViews:(ListModel *)item{
    if (!item) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@%%",item.borrow_interest_rate];//@"7.5 + 0.5%";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:19] range:[str rangeOfString:item.borrow_interest_rate]];
//    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:19] range:[str rangeOfString:@"0.5%"]];
//    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:10] range:[str rangeOfString:@"+"]];
    self.LiLvLab.attributedText = attr;
    
    self.remainedLab.text = [NSString stringWithFormat:@"剩余金额%@元",item.rest_borrow_money];
    
    [self.gressView setProgress:[item.progress floatValue]/100];
        self.progressLab.text = [NSString stringWithFormat:@"%.2f%%",[item.progress floatValue]];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
