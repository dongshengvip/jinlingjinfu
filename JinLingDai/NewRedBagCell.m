//
//  NewRedBagCell.m
//  JinLingDai
//
//  Created by 001 on 2017/8/18.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "NewRedBagCell.h"
#import "NSMutableAttributedString+contentText.h"
#import "NSDate+Formatter.h"
@interface NewRedBagCell ()

@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UILabel *contextLab;
@property (nonatomic, strong) UILabel *tiptextLab;
@property (nonatomic, strong) UIImageView *stateImg;
@end

@implementation NewRedBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.logoImg = [[UIImageView alloc]init];
        //        self.logoImg.backgroundColor = [UIColor getOrangeColor];
        [self.contentView addSubview:self.logoImg];
        [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(ChangedHeight(15), ChangedHeight(15), ChangedHeight(15), ChangedHeight(15)));
            make.left.equalTo(self.contentView).offset(ChangedHeight(15));
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(self.contentView).multipliedBy(0.45);
        }];
        
        self.contextLab = [UILabel new];
        self.contextLab.font = [UIFont gs_fontNum:13];
        self.contextLab.textColor = [UIColor newSecondTextColor];
        self.contextLab.numberOfLines = 3;
        [self.contentView addSubview:self.contextLab];
        [self.contextLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImg.mas_right).offset(ChangedHeight(10));
            make.centerY.equalTo(self.logoImg);
            make.right.equalTo(self.contentView).offset(ChangedHeight(- 10));
            //            make
        }];
        
        self.tiptextLab = [UILabel new];
        self.tiptextLab.textAlignment = NSTextAlignmentCenter;
        self.tiptextLab.font = [UIFont gs_fontNum:16];
        self.tiptextLab.textColor = [UIColor whiteColor];
//        self.tiptextLab.numberOfLines = 3;
        [self.contentView addSubview:self.tiptextLab];
        [self.tiptextLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.logoImg);
            make.centerY.equalTo(self.logoImg).offset(ChangedHeight(5));
        }];
        
        
        self.stateImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"已使用"]];
        self.stateImg.hidden = YES;
        [self.contentView addSubview:self.stateImg];
        [self.stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.logoImg);
            make.height.equalTo(self.logoImg).offset(ChangedHeight(- 15 ));
            make.width.equalTo(self.stateImg.mas_height);
        }];
        
    }
    return  self;
}
- (void)setContenView:(RedBagModel *)item{
    self.stateImg.hidden = [item.status integerValue] != 4;
    
    self.logoImg.image = [UIImage imageNamed:[item.status integerValue] == 2?@"已过期红包":@"未用红包"];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元起投\n%@月标以上可用\n到期时间：%@",item.invest_money,item.min_borrow_duration,[[NSDate dateWithTimeIntervalSince1970:[item.end_date longLongValue]] dateWithFormat:@"yyyy-MM-dd"]]];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = ChangedHeight(10);
    [attr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attr.string.length)];
    self.contextLab.attributedText = attr;
    self.tiptextLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"%@元  %@",@([item.money integerValue]),item.name] Font:[UIFont gs_fontNum:20 weight:UIFontWeightBold] Color:[item.status integerValue] == 2?[UIColor grayColor]:[UIColor colorWithHex:0xfbf300] grayText:[NSString stringWithFormat:@"%@元",@([item.money integerValue])] TextAligment:NSTextAlignmentCenter LineSpace:ChangedHeight(13)];
    if ([item.status integerValue] == 4) {
        [self.contentView bringSubviewToFront:self.stateImg];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
