//
//  ResultViewToShare.m
//  JinLingDai
//
//  Created by 001 on 2018/6/9.
//  Copyright © 2018年 JLD. All rights reserved.
//

#import "ResultViewToShare.h"
#import "UIView+Radius.m"
@interface ResultViewToShare()
@property (nonatomic, strong) UIImageView *logoImagr;
@property (nonatomic, strong) UILabel *levelLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UIImageView *BarImage;
@end
@implementation ResultViewToShare

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.logoImagr];
        [self.logoImagr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(ChangedHeight(20));
            //        make.width.height.mas_equalTo(ChangedHeight(80));
        }];
        
        [self addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logoImagr.mas_bottom).offset(ChangedHeight(20));
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 10, 10));
            
        }];
        UIView *line = [UIView drawDashLineWidth:K_WIDTH - 20 lineLength:5 lineSpacing:1 lineColor:[UIColor newSeparatorColor]];
        
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));;
            make.height.mas_equalTo(1);
            make.top.equalTo(self.timeLab.mas_bottom).offset(ChangedHeight(20));
        }];
        
        [self addSubview:self.infoLab];
        [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(line).insets(UIEdgeInsetsMake(0, 5, 0, 5));
            make.top.equalTo(line.mas_bottom).offset(ChangedHeight(20));
            
        }];
        [self addSubview:self.BarImage];
        [self.BarImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(line).insets(UIEdgeInsetsMake(0, 5, 0, 5));
//            make.top.equalTo(line.mas_bottom).offset(ChangedHeight(20));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-20);
            
        }];
        [self setRistInfo];
    }
    return self;
}

/**
 设置数据
 */
- (void)setRistInfo{
    self.logoImagr.image = [UIImage imageNamed:Nilstr2Space([UserManager shareManager].user.risk_level)];
    
    self.timeLab.text = [UserManager shareManager].user.risk_time_string;
    self.infoLab.text = [UserManager shareManager].user.risk_info;
    
}
- (UIImage *)getShareResultView{
//    self.hidden = NO;
    CGSize s = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    self.hidden = YES;;
    return image;
}

- (UIImageView *)BarImage {
   if (!_BarImage) {
       _BarImage = [UIImageView new];
       _BarImage.contentMode = UIViewContentModeScaleAspectFit;
       _BarImage.image = [UIImage imageNamed:@"LOGO"];
   }
   return _BarImage;
}

- (UIImageView *)logoImagr {
    if (!_logoImagr) {
        _logoImagr = [UIImageView new];
        _logoImagr.contentMode = UIViewContentModeScaleAspectFit;
        //       _logoImagr.image = [UIImage imageNamed:@"江苏"];//@"风险等级"
        //       _logoImagr
    }
    return _logoImagr;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont gs_fontNum:12];
        _timeLab.textColor = [UIColor newSecondTextColor];
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [UILabel new];
        _infoLab.font = [UIFont gs_fontNum:14];
        _infoLab.textColor = [UIColor newSecondTextColor];
        _infoLab.numberOfLines = 0;
    }
    return _infoLab;
}
@end
