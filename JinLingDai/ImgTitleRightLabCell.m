//
//  ImgTitleRightLabCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ImgTitleRightLabCell.h"
#import <Masonry.h>
#import "UIImage+Comment.h"
#import "UIView+Radius.h"
#import "UIColor+Util.h"
#import "NSDate+Formatter.h"
@implementation ImgTitleRightLabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.logoImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.logoImg];
        
        self.titleLab = [UILabel new];
        self.titleLab.font = [UIFont gs_fontNum:14];
        [self.contentView addSubview:self.titleLab];
        
        self.rightLab = [UILabel new];
        [self.contentView addSubview:self.rightLab];
        
        self.rightLab.font = [UIFont gs_fontNum:13];
        self.rightLab.textColor = [UIColor getColor:134 G:135 B:136];
        [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(ChangedHeight(10));
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImg.mas_right).offset(ChangedHeight(10));
            make.centerY.equalTo(self.logoImg);
            make.width.equalTo(self.contentView).dividedBy(3/2.0);
        }];
        
        [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(ChangedHeight(-10));
            make.centerY.equalTo(self.logoImg);
        }];
    }
    return self;
}
- (void)setCellType:(CellStyle)CellType{
    if (_CellType == CellType) {
        return;
    }
    _CellType = CellType;
    switch (CellType) {
        case NSCellDefulet:
        {
            self.titleLab.font = [UIFont gs_fontNum:14];
            self.rightLab.font = [UIFont gs_fontNum:13];
            self.rightLab.textColor = [UIColor getColor:134 G:135 B:136];
            [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(ChangedHeight(10));
            }];
            
            [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.logoImg.mas_right).offset(ChangedHeight(10));
                make.centerY.equalTo(self.logoImg);
                make.width.equalTo(self.contentView).dividedBy(3/2.0);
            }];
            
            [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(ChangedHeight(-10));
                make.centerY.equalTo(self.logoImg);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutContent:(MessageModel *)item{
    self.logoImg.bounds = CGRectMake(0, 0, ChangedHeight(5), ChangedHeight(5));
    self.logoImg.image = [UIImage createImageWithColor:[UIColor getOrangeColor] imageRect:self.logoImg.bounds];
    [self.logoImg setCornerRadiusAdvance:CGRectGetWidth(self.logoImg.bounds)/2];
    
    self.titleLab.text = item.title;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item.send_time longLongValue]];
    self.rightLab.text = [date dateWithFormat:@"yyyy-MM-dd"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
