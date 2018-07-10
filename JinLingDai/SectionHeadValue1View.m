//
//  SectionHeadValue1View.m
//  JinLingDai
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "SectionHeadValue1View.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#import "NSDate+Formatter.h"
@interface SectionHeadValue1View ()

@end
@implementation SectionHeadValue1View

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedSection)]];
        self.icon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
        self.timeLab = [UILabel new];
        self.timeLab.lineBreakMode = NSLineBreakByTruncatingTail;
        self.timeLab.textAlignment = NSTextAlignmentRight;
        self.timeLab.textColor = [UIColor getOrangeColor];
        self.timeLab.font = [UIFont gs_fontNum:14];
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.icon);
//            make.width.equalTo(self.contentView).dividedBy(2.0);
            make.height.equalTo(self.contentView);
        }];
        
        self.titleLab = [UILabel new];
        self.titleLab.font = [UIFont gs_fontNum:14];
        self.titleLab.textColor = [UIColor titleColor];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(7);
            make.centerY.equalTo(self.icon);
            make.height.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.timeLab.mas_left);
        }];
        
        
        self.greenHandsImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新手标"]];
        self.greenHandsImg.hidden = YES;
        [self.contentView addSubview:self.greenHandsImg];
        [self.greenHandsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(30));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)clickedSection{
    if (_SectionHeadClickedBlock) {
        _SectionHeadClickedBlock();
    }
}

- (void)setcontentView:(ListModel *)item{
    if (!item) {
        return;
    }
    
//    self.icon.image = [UIImage imageNamed:@"时间图标"];
//    NSString  *durationStr = [item.borrow_duration containsString:Nilstr2Space(item.duration_unit)] ? item.borrow_duration : [NSString stringWithFormat:@"%@%@",item.borrow_duration,Nilstr2Space(item.duration_unit)];
    NSString *str =  [NSString stringWithFormat:@"%@(%@#)",item.borrow_name,item.id];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
//    NSRange range =  [str rangeOfString:durationStr];
//    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor getBlueColor]  range:range];
//    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:10] range:NSMakeRange([str rangeOfString:@"-"].location, str.length - [str rangeOfString:@"-"].location)];
    self.titleLab.attributedText = attr;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item.expired_time longLongValue]];
//    self.timeLab.text = [NSString stringWithFormat:@"%@ 到期",[date dateWithFormat:@"yyyy-MM-dd"]];
    self.timeLab.hidden = YES;
}

@end
