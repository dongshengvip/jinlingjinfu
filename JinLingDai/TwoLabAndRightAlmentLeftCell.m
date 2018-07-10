//
//  TwoLabAndRightAlmentLeftCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "TwoLabAndRightAlmentLeftCell.h"

@implementation TwoLabAndRightAlmentLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftLab = [UILabel new];
        [self.contentView addSubview:self.leftLab];
        [self.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(10));
            make.centerY.equalTo(self.contentView);
        }];
        
        self.rightLab = [UILabel new];
        [self.contentView addSubview:self.rightLab];
        [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX).offset(ChangedHeight(20));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContenView:(id)item{
    self.leftLab.text = @"预期收益：¥133.7";
    self.rightLab.text = @"额外收益：¥0";
    self.leftLab.textColor = [UIColor titleColor];
    self.rightLab.textColor = [UIColor getOrangeColor];
    self.leftLab.font = self.rightLab.font = [UIFont gs_fontNum:14];
}
@end
