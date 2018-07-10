//
//  AnnouceCell.m
//  JinLingDai
//
//  Created by 001 on 2017/8/15.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "AnnouceCell.h"
#import "NSMutableAttributedString+contentText.h"
#import "NSDate+Formatter.h"
@interface AnnouceCell()
@property (nonatomic, strong) UIView *sectionHeadView;//类似区头的view
@property (nonatomic, strong) UIImageView *iconImg;//类似区头的view
@property (nonatomic, strong) UILabel *timeLab;//类似区头的view
@property (nonatomic, strong) UILabel *titleLab;//类似区头的view
//@property (nonatomic, strong) UILabel *infoLab;//类似区头的view
@end
@implementation AnnouceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.sectionHeadView.clipsToBounds = YES;
        [self.contentView addSubview:self.sectionHeadView];
        [self.sectionHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(self.contentView).multipliedBy(1/3.0);
        }];
        
        [self.sectionHeadView addSubview:self.iconImg];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sectionHeadView).offset(2);
            make.left.equalTo(self.sectionHeadView).offset(ChangedHeight(10));
        }];
        
        [self.sectionHeadView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.sectionHeadView);
            make.right.equalTo(self.sectionHeadView).offset(ChangedHeight(-8));
        }];
        self.titleLab.numberOfLines = 2;
        self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(ChangedHeight(10));
            make.right.equalTo(self.contentView).offset(ChangedHeight(-10));
            make.height.equalTo(self.contentView).multipliedBy(2/3.0);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContenView:(AnnouceModel *)item{
    self.iconImg.image = [UIImage imageNamed:item.iconName];
    self.timeLab.text = [[NSDate dateWithTimeIntervalSince1970:[item.add_time longLongValue]] dateWithFormat:@"yyyy年MM月dd日"];

    self.titleLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"[平台公告] %@\n%@",Nilstr2Space(item.title),Nilstr2Space(item.info)] Font:[UIFont gs_fontNum:14 weight:UIFontWeightBold] Color:[UIColor titleColor] grayText:[NSString stringWithFormat:@"[平台公告] %@",Nilstr2Space(item.title)] TextAligment:NSTextAlignmentLeft LineSpace:ChangedHeight(5)];
}

- (UIView *)sectionHeadView {
   if (!_sectionHeadView) {
       _sectionHeadView = [UIView new];
       _sectionHeadView.backgroundColor = [UIColor infosBackViewColor];
   }
   return _sectionHeadView;
}

- (UIImageView *)iconImg {
   if (!_iconImg) {
       _iconImg = [UIImageView new];
       _iconImg.contentMode = UIViewContentModeScaleAspectFit;
//       _iconImg.image = [UIImage imageNamed:<#(nonnull NSString *)#>];
   }
   return _iconImg;
}

- (UILabel *)timeLab {
   if (!_timeLab) {
       _timeLab = [UILabel new];
       _timeLab.font = [UIFont gs_fontNum:14];
       _timeLab.textColor = [UIColor titleColor];
       _timeLab.textAlignment = NSTextAlignmentRight;
//       _timeLab.backgroundColor = [UIColor <#Color#>];
   }
   return _timeLab;
}

- (UILabel *)titleLab {
   if (!_titleLab) {
       _titleLab = [UILabel new];
       _titleLab.font = [UIFont gs_fontNum:14];
       _titleLab.textColor = [UIColor newSecondTextColor];
//       _titleLab.textAlignment = <#NSTextAlignment#>;
//       _titleLab.backgroundColor = [UIColor <#Color#>];
   }
   return _titleLab;
}

//- (UILabel *)infoLab {
//   if (!_infoLab) {
//       _infoLab = [UILabel new];
//       _infoLab.font = [UIFont gs_fontNum:14];
//       _infoLab.textColor = [UIColor newSecondTextColor];
////       _infoLab.textAlignment = <#NSTextAlignment#>;
////       _infoLab.backgroundColor = [UIColor <#Color#>];
//   }
//   return _infoLab;
//}

@end
