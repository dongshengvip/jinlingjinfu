//
//  FriendsCell.m
//  JinLingDai
//
//  Created by 001 on 2017/8/21.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "FriendsCell.h"
#import "NSDate+Formatter.h"
#import <YYKit.h>
#import "UIView+Radius.h"
@interface FriendsCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *telLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *desLab;
@end
@implementation FriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor infosBackViewColor];
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(ChangedHeight(10), ChangedHeight(10), 0, ChangedHeight(10)));
        }];
        
        
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView).offset(ChangedHeight(10));
//            make.height.equalTo(self.contentView).multipliedBy(5/8.0);
            make.width.height.mas_offset(ChangedHeight(50));
        }];
        
       
        [bgView addSubview:self.telLab];
        [self.telLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon);
            make.bottom.equalTo(self.icon.mas_centerY);
            make.left.equalTo(self.icon.mas_right).offset(5);
//            make.height.equalTo(self.contentView).multipliedBy(5/8.0);
//            make.width.equalTo(self.icon.mas_height);
        }];
        
        [bgView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.telLab);
//            make.height.equalTo(self.contentView).multipliedBy(5/8.0);
            make.right.equalTo(bgView).offset(ChangedHeight(-10));
        }];
        
        [bgView addSubview:self.desLab];
        [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_centerY);
            make.bottom.equalTo(self.icon);
            make.left.equalTo(self.telLab);
        }];
//        [bgView.superview layoutIfNeeded];
//        [bgView setCornerRadiusAdvance:5];
        bgView.layer.cornerRadius = 5;
        
        [self.icon.superview layoutIfNeeded];
        //    self.icon.layer.cornerRadius =  self.icon.width/2;//ChangedHeight(25);
        [self.icon setCornerRadiusAdvance:self.icon.width/2];
    }
    return self;
}

- (void)setContenView:(FriendsinfoModel *)item{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.head_img] placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.icon.image = [UIImage imageNamed:@"默认头像"];
        }
    }];

    self.telLab.text = item.user_name;
    self.timeLab.text = [[NSDate dateWithTimeIntervalSince1970:[item.reg_time longLongValue]] dateWithFormat:@"yyyy-MM-dd"];
//    NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"好友投资总额：%@元",@([item.total integerValue])]];
//
//    [moneyAttr addAttribute:NSForegroundColorAttributeName value:[UIColor getOrangeColor]range:[moneyAttr.string rangeOfString:[NSString stringWithFormat:@"%@元",@([item.total integerValue])]]];
//    [moneyAttr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:20] range:[moneyAttr.string rangeOfString:[NSString stringWithFormat:@"%@元",@([item.total integerValue])]]];
    self.desLab.text = @"邀请好友成功获得88元红包";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)icon {
   if (!_icon) {
       _icon = [UIImageView new];
       _icon.contentMode = UIViewContentModeScaleAspectFit;
//       _icon.image = [UIImage imageNamed:<#(nonnull NSString *)#>];
   }
   return _icon;
}

- (UILabel *)telLab {
   if (!_telLab) {
       _telLab = [UILabel new];
       _telLab.font = [UIFont gs_fontNum:14];
       _telLab.textColor = [UIColor titleColor];
//       _telLab.textAlignment = <#NSTextAlignment#>;
//       _telLab.backgroundColor = [UIColor <#Color#>];
   }
   return _telLab;
}

- (UILabel *)timeLab {
   if (!_timeLab) {
       _timeLab = [UILabel new];
       _timeLab.font = [UIFont gs_fontNum:14];
       _timeLab.textColor = [UIColor newSecondTextColor];
       _timeLab.textAlignment = NSTextAlignmentRight;
//       _timeLab.backgroundColor = [UIColor <#Color#>];
   }
   return _timeLab;
}

- (UILabel *)desLab {
   if (!_desLab) {
       _desLab = [UILabel new];
       _desLab.font = [UIFont gs_fontNum:14];
       _desLab.textColor = [UIColor newSecondTextColor];
//       _desLab.textAlignment = <#NSTextAlignment#>;
//       _desLab.backgroundColor = [UIColor <#Color#>];
   }
   return _desLab;
}

@end
