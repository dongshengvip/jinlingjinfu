//
//  HuanKuanCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/10.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "HuanKuanCell.h"
#import "NSDate+Formatter.h"
@interface HuanKuanCell ()

@property (nonatomic, strong) UILabel *firstLab;
@property (nonatomic, strong) UILabel *secondLab;
@property (nonatomic, strong) UILabel *thirdLab;
@property (nonatomic, strong) UILabel *fourthLab;
@end
@implementation HuanKuanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor infosBackViewColor];
        self.firstLab = [UILabel new];
        [self.contentView addSubview:self.firstLab];
        [self.firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo(self.contentView);
            
        }];
        
        self.secondLab = [UILabel new];
        [self.contentView addSubview:self.secondLab];
        [self.secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(self.firstLab);
            make.left.equalTo(self.firstLab.mas_right);
            
        }];
        
        self.thirdLab = [UILabel new];
        [self.contentView addSubview:self.thirdLab];
        [self.thirdLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(self.firstLab);
            make.left.equalTo(self.secondLab.mas_right);
//            make.left.equalTo(self)
        }];
        
        
        self.fourthLab = [UILabel new];
        [self.contentView addSubview:self.fourthLab];
        [self.fourthLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(self.contentView);
            make.left.equalTo(self.thirdLab.mas_right);
            make.width.equalTo(self.firstLab);
        }];
        
        self.firstLab.textColor = [UIColor titleColor];
        self.firstLab.textAlignment = NSTextAlignmentCenter;
        self.firstLab.font = [UIFont gs_fontNum:13];
        
        self.fourthLab.textAlignment = self.secondLab.textAlignment = self.thirdLab.textAlignment = self.firstLab.textAlignment;
        self.secondLab.textColor = self.thirdLab.textColor = self.firstLab.textColor;
        self.fourthLab.font = self.secondLab.font = self.thirdLab.font = self.firstLab.font;
        self.fourthLab.textColor =  [UIColor getOrangeColor];
    }
    return self;
}

- (void)setContenView:(PlantListModel *)item{
    if (!item) {
        return;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item.date longLongValue]];
    self.firstLab.text = [date dateWithFormat:@"yyyy-MM-dd"];
    self.secondLab.text = item.capital;
    self.thirdLab.text = item.interest;
    self.fourthLab.text = [item.status integerValue] ==0?@"未获得":@"已获得";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
