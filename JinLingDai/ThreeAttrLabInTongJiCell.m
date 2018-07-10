//
//  ThreeAttrLabInTongJiCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ThreeAttrLabInTongJiCell.h"
@interface ThreeAttrLabInTongJiCell ()

@property (nonatomic, strong) UILabel *firstLab;
@property (nonatomic, strong) UILabel *secondLab;
@property (nonatomic, strong) UILabel *thirdLab;
@end
@implementation ThreeAttrLabInTongJiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.firstLab = [UILabel new];
        [self.contentView addSubview:self.firstLab];
        [self.firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView);
            
        }];
        
        self.secondLab = [UILabel new];
        [self.contentView addSubview:self.secondLab];
        [self.secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.firstLab);
            make.width.equalTo(self.firstLab);
            make.left.equalTo(self.firstLab.mas_right);
            
        }];
        
        self.thirdLab = [UILabel new];
        [self.contentView addSubview:self.thirdLab];
        [self.thirdLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.firstLab);
            make.width.equalTo(self.firstLab);
            make.left.equalTo(self.secondLab.mas_right);
            make.right.equalTo(self.contentView);
        }];
        
        

        
        self.firstLab.textColor = [UIColor titleColor];
        self.firstLab.textAlignment = NSTextAlignmentCenter;
        self.firstLab.font = [UIFont gs_fontNum:13];
        
        self.secondLab.numberOfLines = self.thirdLab.numberOfLines = self.firstLab.numberOfLines = 2;
        self.secondLab.textColor = self.thirdLab.textColor = self.firstLab.textColor;
        self.secondLab.font = self.thirdLab.font = self.firstLab.font;
        self.secondLab.textAlignment = self.thirdLab.textAlignment = self.firstLab.textAlignment;
    }
    return self;
}

- (void)setContenView:(id)item{
    self.firstLab.attributedText = [self getAttr:@"0.00\n本月收益" grayColorText:@"0.00"];
    self.secondLab.attributedText = [self getAttr:@"0.00\n本月回款" grayColorText:@"0.00"];
    self.thirdLab.attributedText = [self getAttr:@"0.00\n本月余额" grayColorText:@"0.00"];
}

- (NSAttributedString *)getAttr:(NSString *)str grayColorText:(NSString *)grayStr{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setAlignment:NSTextAlignmentCenter];
    style.lineSpacing = 6;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor getOrangeColor] range:[str rangeOfString:grayStr]];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:15 weight:UIFontWeightSemibold] range:[str rangeOfString:grayStr]];
    
    return attr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
