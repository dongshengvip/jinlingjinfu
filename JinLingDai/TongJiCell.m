//
//  TongJiCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/6.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "TongJiCell.h"
#import "UIColor+Util.h"
#import <Masonry.h>

@interface TongJiCell ()
@property (nonatomic, strong) UILabel *moneyLab;
@end
@implementation TongJiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *verLine = [UIView new];
        verLine.backgroundColor = [UIColor getOrangeColor];
        [self.contentView addSubview:verLine];
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(10));
            make.width.mas_equalTo(2);
            make.top.equalTo(self.contentView).offset(ChangedHeight(13));
            make.height.mas_equalTo(ChangedHeight(17));
        }];
        
        self.titleLab = [UILabel new];
        self.titleLab.textColor = [UIColor getOrangeColor];
        self.titleLab.font = [UIFont gs_fontNum:14];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(verLine);
            make.left.equalTo(verLine.mas_right).offset(ChangedHeight(4));
        }];
        
        self.moneyLab = [UILabel new];
        self.moneyLab.textColor = [UIColor titleColor];
        self.moneyLab.font = [UIFont gs_fontNum:12];
        [self.contentView addSubview:self.moneyLab];
        [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLab);
            make.bottom.equalTo(self.contentView).offset(ChangedHeight(- 10));
        }];
    }
    return self;
}


- (void)setMoney:(NSString *)money tip:(NSString *)tip{
    if (money.length == 0 && tip.length == 0) {
        self.moneyLab.text = @"";
        return;
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",tip,money]];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor getOrangeColor] range:[attr.string rangeOfString:money]];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:16] range:[attr.string rangeOfString:money]];
    self.moneyLab.attributedText = attr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
