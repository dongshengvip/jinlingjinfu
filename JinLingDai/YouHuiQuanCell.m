//
//  YouHuiQuanCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/8.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "YouHuiQuanCell.h"
#import "NSMutableAttributedString+contentText.h"
#import "NSDate+Formatter.h"
#import "NSString+formatFloat.h"
@interface YouHuiQuanCell ()

@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UILabel *contextLab;
@property (nonatomic, strong) UILabel *tiptextLab;
@property (nonatomic, strong) UIImageView *stateImg;
@end
@implementation YouHuiQuanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.logoImg = [[UIImageView alloc]init];
//        self.logoImg.backgroundColor = [UIColor getOrangeColor];
        [self.contentView addSubview:self.logoImg];
        [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(ChangedHeight(15), ChangedHeight(15), ChangedHeight(15), ChangedHeight(15)));
            make.left.equalTo(self.contentView).offset(ChangedHeight(15));
            make.centerY.equalTo(self.contentView);
        }];
        
        self.contextLab = [UILabel new];
        self.contextLab.font = [UIFont gs_fontNum:13];
        self.contextLab.textColor = [UIColor newSecondTextColor];
        self.contextLab.numberOfLines = 3;
        [self.contentView addSubview:self.contextLab];
        [self.contextLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImg.mas_right).offset(ChangedHeight(10));
            make.centerY.equalTo(self.logoImg);
            make.right.equalTo(self.contentView).offset(ChangedHeight(- 10));
//            make
        }];
        
        self.tiptextLab = [UILabel new];
        self.tiptextLab.textAlignment = NSTextAlignmentCenter;
        self.tiptextLab.font = [UIFont gs_fontNum:12];
        self.tiptextLab.textColor = [UIColor whiteColor];
        self.tiptextLab.numberOfLines = 3;
        [self.contentView addSubview:self.tiptextLab];
        [self.tiptextLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.logoImg);
            make.left.equalTo(self.logoImg).offset(ChangedHeight(10));
            make.width.equalTo(self.logoImg).multipliedBy(275/380.0);
        }];
        
        
        self.stateImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"已使用"]];
        self.stateImg.hidden = YES;
        [self.contentView addSubview:self.stateImg];
        [self.stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.logoImg);
            make.centerX.equalTo(self.tiptextLab.mas_right).offset(ChangedHeight(-5));
            make.height.equalTo(self.logoImg).offset(ChangedHeight(- 15 ));
            make.width.equalTo(self.stateImg.mas_height);
        }];
        
    }
    return  self;
}
- (void)setContenView:(RedBagModel *)item{
    self.stateImg.hidden = [item.status integerValue] != 4;
    
    self.logoImg.image = [UIImage imageNamed:item.imgStr];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元起投\n%@月标及以上可用\n结束日期:%@",item.invest_money,item.min_borrow_duration,[[NSDate dateWithTimeIntervalSince1970:[item.end_date longLongValue]] dateWithFormat:@"yyyy-MM-dd"]]];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = ChangedHeight(10);
    [attr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attr.string.length)];
    self.contextLab.attributedText = attr;
    
    
//    NSMutableAttributedString *tipAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@元",item.name,item.money]];
//    [tipAttr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:18] range:NSMakeRange(0, 1)];
    //[NSString formatFloat:[item.money floatValue]]
    NSString *add_rate_day = [item.add_rate_day integerValue] == 0 ? @"加息期为整个投资期" : [NSString stringWithFormat:@"加息天数:%@天",item.add_rate_day];
    self.tiptextLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"%.2g%%\n%@",[item.money floatValue],add_rate_day] Font:[UIFont gs_fontNum:22] Color:[UIColor whiteColor] grayText:[NSString stringWithFormat:@"%.2g",[item.money floatValue]] TextAligment:NSTextAlignmentCenter LineSpace:ChangedHeight(7)];
    if ([item.status integerValue] == 4) {
        [self.contentView bringSubviewToFront:self.stateImg];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
