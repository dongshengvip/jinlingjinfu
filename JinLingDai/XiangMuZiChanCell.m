//
//  XiangMuZiChanCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "XiangMuZiChanCell.h"
#import "NSMutableAttributedString+contentText.h"
@interface XiangMuZiChanCell ()

@property (nonatomic, strong) UILabel *xiangMuLab;
@property (nonatomic, strong) UIImageView *arowImg;
//@property (nonatomic, strong) UILabel *yesterdayLab;
//@property (nonatomic, strong) UILabel *weekLab;
//@property (nonatomic, strong) UILabel *weekLiLvLab;
@property (nonatomic, strong) UILabel *monthLab;
@property (nonatomic, strong) UILabel *monthLiLvLab;
@end
@implementation XiangMuZiChanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *nameView = [UIView new];
        [nameView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showXiangMu)]];
        nameView.layer.borderWidth = 1;
        nameView.layer.borderColor = [UIColor newSecondTextColor].CGColor;
        [self.contentView addSubview:nameView];
        [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(50));
            make.top.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(ChangedHeight(160), ChangedHeight(25)));
        }];
        UILabel *tipLab = [UILabel new];
        tipLab.textColor = [UIColor titleColor];
        tipLab.font = [UIFont gs_fontNum:13];
        tipLab.text = @"项目";
        [self.contentView addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameView);
            make.right.equalTo(nameView.mas_left).offset(ChangedHeight(- 7));
        }];
        
        self.xiangMuLab = [UILabel new];
        self.xiangMuLab.textColor = [UIColor titleColor];
        self.xiangMuLab.font = [UIFont gs_fontNum:13];
        self.xiangMuLab.text = @"项目名称";
        [nameView addSubview:self.xiangMuLab];
        [self.xiangMuLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameView);
            make.left.equalTo(nameView).offset(ChangedHeight(5));
        }];
        
//        self.yesterdayLab = [UILabel new];
//        [self.contentView addSubview:self.yesterdayLab];
//        [self.yesterdayLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(tipLab);
//            make.top.equalTo(nameView.mas_bottom).offset(ChangedHeight(20));
//        }];
        
//        self.weekLab = [UILabel new];
//        [self.contentView addSubview:self.weekLab];
//        [self.weekLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.yesterdayLab);
//            make.top.equalTo(self.yesterdayLab.mas_bottom).offset(ChangedHeight(15));
//            
//        }];
//        
//        self.weekLiLvLab = [UILabel new];
//        [self.contentView addSubview:self.weekLiLvLab];
//        [self.weekLiLvLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.weekLab);
//            make.left.equalTo(self.contentView.mas_centerX).offset(ChangedHeight(20));
//        }];
        
        self.monthLab = [UILabel new];
        [self.contentView addSubview:self.monthLab];
        [self.monthLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLab).offset(ChangedHeight(10));
            make.top.equalTo(nameView.mas_bottom).offset(ChangedHeight(30));
            
        }];
        
        self.monthLiLvLab = [UILabel new];
        [self.contentView addSubview:self.monthLiLvLab];
        [self.monthLiLvLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.monthLab);
            make.left.equalTo(self.contentView.mas_centerX).offset(ChangedHeight(30));
        }];
        
       
        
        [self setUIAndText];
    }
    return self;
}

- (void)setUIAndText{
//    self.yesterdayLab.textColor = [UIColor titleColor];
//    self.yesterdayLab.font = [UIFont gs_fontNum:13];
    
    self.monthLab.numberOfLines = 2;
    self.monthLiLvLab.numberOfLines = self.monthLab.numberOfLines;
    self.monthLiLvLab.textColor = self.monthLab.textColor = [UIColor titleColor];
    self.monthLab.font = self.monthLiLvLab.font = [UIFont gs_fontNum:13];
    
}
- (void)setContenView:(GetinvestorModel *)item{
    self.xiangMuLab.text = item.borrow_name;;

    self.monthLiLvLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"总收益\n%.2f",[item.total_interest floatValue]] Font:[UIFont gs_fontNum:13] Color:[UIColor tipTextColor] grayText:item.total_interest TextAligment:NSTextAlignmentLeft LineSpace:ChangedHeight(15)];
    self.monthLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"月收益（元）\n%.2f",[item.every_interest floatValue]] Font:[UIFont gs_fontNum:13] Color:[UIColor tipTextColor] grayText:item.every_interest TextAligment:NSTextAlignmentLeft LineSpace:ChangedHeight(15)];
}


- (void)showXiangMu{
    if (_changedXiangMuBlock) {
        _changedXiangMuBlock();
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
