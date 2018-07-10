//
//  RedBagOfFriendsCell.m
//  JinLingDai
//
//  Created by 001 on 2017/8/21.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RedBagOfFriendsCell.h"
#import "NSDate+Formatter.h"
@interface RedBagOfFriendsCell ()
@property (nonatomic, strong) UIImageView *BGView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *monneyLab;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UIImageView *usedImg;
@property (nonatomic, strong) UILabel *statusLab;
@end
@implementation RedBagOfFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor infosBackViewColor];
        [self.contentView addSubview:self.BGView];
        [self.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(ChangedHeight(10), ChangedHeight(10), 0, ChangedHeight(10)));
        }];
        
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.BGView).offset(ChangedHeight(10));
            make.bottom.equalTo(self.BGView.mas_centerY).offset(ChangedHeight(-2));
        }];
        
        [self.contentView addSubview:self.monneyLab];
        [self.monneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(ChangedHeight(10));
            make.centerY.equalTo(self.icon);
        }];
        
        [self.contentView addSubview:self.infoLab];
        [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.monneyLab.mas_right).offset(ChangedHeight(10));
            make.right.lessThanOrEqualTo(self.BGView).offset(ChangedHeight(-10));
            make.centerY.equalTo(self.monneyLab);
        }];
        
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.BGView).offset(ChangedHeight(10));
            make.bottom.equalTo(self.BGView).offset(ChangedHeight(-5));
            make.height.mas_equalTo(ChangedHeight(30));
        }];
        
        [self.contentView addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.BGView).offset(ChangedHeight(-10));
            make.centerY.equalTo(self.timeLab);
        }];
        [self.contentView addSubview:self.usedImg];
        [self.usedImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.BGView);
            make.right.equalTo(self.BGView).offset(ChangedHeight(-35));
        }];
        
        [self.contentView addSubview:self.statusLab];
         [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
             make.bottom.equalTo(self.icon.mas_top);
             make.right.equalTo(self.BGView).offset(ChangedHeight(-10));
         }];
    }
    return self;
}

- (void)setContentView:(YaoQingBagModel *)item{
    
    self.monneyLab.text = [NSString stringWithFormat:@"%@元",@([Nilstr2Zero(item.money) integerValue])];
    self.infoLab.text = [NSString stringWithFormat:@"%@\n%@",item.invest_money ,item.min_borrow_duration];
    self.timeLab.text = item.reward_duration;
    self.nameLab.text = item.type;
    self.statusLab.text = item.status;
    self.usedImg.hidden = ![item.status isEqualToString:@"已使用"];
    if ([item.status isEqualToString:@"已过期"]) {
        self.BGView.image = [UIImage imageNamed:@"redBGView-used"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)BGView {
   if (!_BGView) {
       _BGView = [UIImageView new];
       _BGView.contentMode = UIViewContentModeScaleAspectFit;
       _BGView.image = [UIImage imageNamed:@"redBGView"];
   }
   return _BGView;
}

- (UIImageView *)icon {
   if (!_icon) {
       _icon = [UIImageView new];
       _icon.contentMode = UIViewContentModeScaleAspectFit;
       _icon.image = [UIImage imageNamed:@"￥￥￥"];
   }
   return _icon;
}

- (UILabel *)monneyLab {
   if (!_monneyLab) {
       _monneyLab = [UILabel new];
       _monneyLab.font = [UIFont gs_fontNum:19];
       _monneyLab.textColor = [UIColor getOrangeColor];
//       _monneyLab.textAlignment = <#NSTextAlignment#>;
//       _monneyLab.backgroundColor = [UIColor <#Color#>];
   }
   return _monneyLab;
}

- (UILabel *)infoLab {
   if (!_infoLab) {
       _infoLab = [UILabel new];
       _infoLab.font = [UIFont gs_fontNum:14];
       _infoLab.numberOfLines = 2;
       _infoLab.textColor = [UIColor newSecondTextColor];
//       _infoLab.textAlignment = <#NSTextAlignment#>;
//       _infoLab.backgroundColor = [UIColor <#Color#>];
   }
   return _infoLab;
}

- (UILabel *)timeLab {
   if (!_timeLab) {
       _timeLab = [UILabel new];
       _timeLab.font = [UIFont gs_fontNum:14];
       _timeLab.textColor = [UIColor newSecondTextColor];
//       _timeLab.textAlignment = <#NSTextAlignment#>;
//       _timeLab.backgroundColor = [UIColor <#Color#>];
   }
   return _timeLab;
}

- (UILabel *)nameLab {
   if (!_nameLab) {
       _nameLab = [UILabel new];
       _nameLab.font = [UIFont gs_fontNum:14];
       _nameLab.textColor = [UIColor newSecondTextColor];
       _nameLab.textAlignment = NSTextAlignmentRight;
//       _nameLab.backgroundColor = [UIColor <#Color#>];
   }
   return _nameLab;
}

- (UIImageView *)usedImg {
   if (!_usedImg) {
       _usedImg = [UIImageView new];
       _usedImg.contentMode = UIViewContentModeScaleAspectFit;
       _usedImg.image = [UIImage imageNamed:@"已使用"];
       _usedImg.hidden = YES;
   }
   return _usedImg;
}

- (UILabel *)statusLab {
   if (!_statusLab) {
       _statusLab = [UILabel new];
       _statusLab.font = [UIFont gs_fontNum:16];
       _statusLab.textColor = [UIColor getOrangeColor];
       _statusLab.textAlignment = NSTextAlignmentRight;
//       _statusLab.backgroundColor = [UIColor <#Color#>];
   }
   return _statusLab;
}

@end
