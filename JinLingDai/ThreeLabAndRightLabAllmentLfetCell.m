//
//  ThreeLabAndRightLabAllmentLfetCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ThreeLabAndRightLabAllmentLfetCell.h"
#import "UIView+Masonry.h"
@interface ThreeLabAndRightLabAllmentLfetCell ()

@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UILabel *leftDownLab;
@end

@implementation ThreeLabAndRightLabAllmentLfetCell

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
            make.height.mas_equalTo(ChangedHeight(18));
        }];
        
        self.leftDownLab = [UILabel new];
        [self.contentView addSubview:self.leftDownLab];
        [self.leftDownLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.equalTo(self.leftLab);
        }];
        [self.contentView distributeSpacingVerticallyWith:@[self.leftLab,self.leftDownLab]];
        
        self.rightLab = [UILabel new];
        [self.contentView addSubview:self.rightLab];
        [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX).offset(ChangedHeight(20));
            make.centerY.equalTo(self.leftLab);
        }];
    }
    return self;
}

- (void)setContenView:(id)item{
    self.leftLab.text = @"出借金额：¥10000";
    self.rightLab.text = @"收益率：8%";
    self.leftDownLab.text = @"项目期限：2月";
    self.leftLab.textColor = self.rightLab.textColor = self.leftDownLab.textColor = [UIColor titleColor];
    self.leftLab.font = self.rightLab.font = self.leftDownLab.font = [UIFont gs_fontNum:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
