//
//  XiangMuCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/7.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "XiangMuCell.h"
#import "NSDate+Formatter.h"
@interface XiangMuCell ()

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *yearLiLvLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *daysLab;

@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *jixiLab;
@end
@implementation XiangMuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellEditingStyleNone;
        self.backgroundColor = [UIColor infosBackViewColor];
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(ChangedHeight(5), 0, 0, 0));
        }];
        
        self.timeLab = [UILabel new];
        self.timeLab.font = [UIFont gs_fontNum:13];
        self.timeLab.textColor = [UIColor titleColor];
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(10));
            make.top.equalTo(bgView);
            make.height.mas_equalTo(ChangedHeight(35));
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor newSeparatorColor];
        [self.contentView addSubview:line ];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.top.equalTo(self.timeLab.mas_bottom);
        }];
        
        
        
        self.typeLab = [UILabel new];
        self.typeLab.textAlignment = NSTextAlignmentRight;
        self.typeLab.textColor = [UIColor getOrangeColor];
        self.typeLab.font = [UIFont gs_fontNum:13];
        [self.contentView addSubview:self.typeLab];
        [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(ChangedHeight(-10));
            make.centerY.equalTo(self.timeLab);
        }];
        
        
        UIView *line1 = [UIView new];
        line1.backgroundColor = [UIColor newSeparatorColor];
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(bgView).offset(ChangedHeight(-35));
        }];
        
        self.yearLiLvLab = [UILabel new];
        [self.contentView addSubview:self.yearLiLvLab];
        [self.yearLiLvLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLab);
            make.bottom.equalTo(line1.mas_top).offset(ChangedHeight(- 10));
            make.top.equalTo(line.mas_bottom).offset(ChangedHeight(10));
            make.width.mas_equalTo(ChangedHeight(100));
        }];
        
        self.moneyLab = [UILabel new];
        [self.contentView addSubview:self.moneyLab];
        [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.yearLiLvLab.mas_right).offset(ChangedHeight(15));
            make.centerY.height.equalTo(self.yearLiLvLab);
            make.width.mas_equalTo(ChangedHeight(80));
        }];
        
        self.daysLab = [UILabel new];
        [self.contentView addSubview:self.daysLab];
        [self.daysLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.centerY.height.equalTo(self.yearLiLvLab);
            make.width.mas_equalTo(ChangedHeight(65));
        }];
        self.yearLiLvLab.numberOfLines = self.moneyLab.numberOfLines = self.daysLab.numberOfLines = 2;
        
        self.dateLab = [UILabel new];
        [self.contentView addSubview:self.dateLab];
        [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLab);
            make.bottom.equalTo(bgView);
            make.top.equalTo(line1.mas_bottom);
        }];
        
        self.jixiLab = [UILabel new];
        [self.contentView addSubview:self.jixiLab];
        [self.jixiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(ChangedHeight(- 10));
            make.centerY.height.equalTo(self.dateLab);
//            make.width.mas_equalTo(ChangedHeight(65));
        }];
        
        self.dateLab.font = self.jixiLab.font = [UIFont gs_fontNum:13];
        self.dateLab.textColor = self.jixiLab.textColor = [UIColor titleColor];
    }
    return self;
}

- (void)setConten:(TouZiModel *)item{
    self.timeLab.text = [NSString stringWithFormat:@"%@(%@#)",item.borrow_title,item.borrow_id];//@"3月标  消费金融-98765432101";
    self.typeLab.text = item.investor_status;
    NSString *interest_rate = [NSString stringWithFormat:@"%@%%",Nilstr2Space(item.borrow_interest_rate)];
    self.yearLiLvLab.attributedText = [self getAttributedString:interest_rate tip:@"年化利率" bigLength:Nilstr2Space(item.borrow_interest_rate).length];
    
    NSString *capitalStr = [NSString stringWithFormat:@"%.f",[item.investor_capital floatValue]];
    self.moneyLab.attributedText = [self getAttributedString:capitalStr tip:@"出借金额" bigLength:capitalStr.length];
    self.daysLab.attributedText = [self getAttributedString:[NSString stringWithFormat:@"%@%@",item.investor_duration,[item.duration_unit integerValue] == 0 ? @"天" : @"月"] tip:@"期限" bigLength:item.investor_duration.length];
//    self.dateLab.text = @"2017-07-08";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item.add_time longLongValue]];
    self.dateLab.text = [NSString stringWithFormat:@"%@",[date dateWithFormat:@"yyyy-MM-dd"]];
    self.jixiLab.text = [item.rate_type integerValue] == 1 ? @"投即计息" : @"满标记息";
}

- (NSMutableAttributedString *)getAttributedString:(NSString*)num tip:(NSString *)tip bigLength:(NSInteger)length{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 7;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",num,tip]];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor titleColor] range:NSMakeRange(0, attr.string.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:13] range:NSMakeRange(length, attr.string.length - length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:16 weight:UIFontWeightSemibold] range:NSMakeRange(0, length)];
    [attr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attr.string.length)];
    return  attr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
