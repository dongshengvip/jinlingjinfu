//
//  WaterBillCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/6.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "WaterBillCell.h"
#import "UIView+Radius.h"
#import "NSDate+Formatter.h"
#import <YYKit.h>
@interface WaterBillCell ()
@property (nonatomic, strong) UILabel *timeLab;//时间
@property (nonatomic, strong) UIImageView *logoImg;//
@property (nonatomic, strong) UILabel *typeLab;//
@property (nonatomic, strong) UILabel *changeMoneyLab;//
//撤销
@property (nonatomic, strong) WaterModel *myModel;
@property (nonatomic, strong) UIButton *returnBtn;
@property (nonatomic, strong) UIImageView *tipImg;//标期背景
@end
@implementation WaterBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellEditingStyleNone;
        self.backgroundColor = [UIColor infosBackViewColor];
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 4;
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(ChangedHeight(10), ChangedHeight(10), 0, ChangedHeight(10)));
        }];
        self.timeLab = [UILabel new];
        self.timeLab.font = [UIFont gs_fontNum:14];
        self.timeLab.textColor = [UIColor titleColor];
        [bgView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(ChangedHeight(5));
            make.top.equalTo(bgView);
            make.height.mas_equalTo(ChangedHeight(40));
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor newSeparatorColor];
        [bgView addSubview:line ];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(bgView);
            make.height.mas_equalTo(1);
            make.top.equalTo(self.timeLab.mas_bottom);
        }];
        
        self.logoImg = [[UIImageView alloc]init];
//        self.logoImg.backgroundColor = [UIColor getOrangeColor];
        [bgView addSubview:self.logoImg];
        [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLab);
            make.top.equalTo(line.mas_bottom).offset(ChangedHeight(8));
            make.width.height.mas_equalTo(ChangedHeight(30));
        }];
        [self.logoImg layoutIfNeeded];
        [self.logoImg setCornerRadiusAdvance:self.logoImg.width/2];
//        [self.logoImg.superview layoutIfNeeded];
//        [self.logoImg setCornerRadiusAdvance:self.logoImg.width/2];
        
        self.typeLab = [UILabel new];
        self.typeLab.textColor = [UIColor titleColor];
        self.typeLab.font = [UIFont gs_fontNum:14];
        [bgView addSubview:self.typeLab];
        [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImg.mas_right).offset(ChangedHeight(10));
            make.centerY.equalTo(self.logoImg);
        }];
        
        self.changeMoneyLab = [UILabel new];
        self.changeMoneyLab.textColor = [UIColor getOrangeColor];
        self.changeMoneyLab.font = [UIFont gs_fontNum:14];
        [bgView addSubview:self.changeMoneyLab];
        [self.changeMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLab);
            make.bottom.equalTo(bgView).offset(ChangedHeight(- 10));
        }];
        
        
//        [self.contentView addSubview:self.returnBtn];
//        [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(bgView).offset(ChangedHeight(- 10));
//            make.centerY.equalTo(self.timeLab);
//            make.width.mas_equalTo(ChangedHeight(80));
//            make.height.mas_equalTo(ChangedHeight(30));
//        }];
//        
//        [self.returnBtn.superview layoutIfNeeded];
//        [self.returnBtn setCornerRadiusAdvance:self.returnBtn.height/2];
        
        self.tipImg = [[UIImageView alloc]init];
        //        self.logoImg.backgroundColor = [UIColor getOrangeColor];
        self.tipImg.image = [UIImage imageNamed:@"标签-(3)"];
        [bgView addSubview:self.tipImg];
        [self.tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(ChangedHeight(-5));
            make.top.equalTo(line.mas_bottom);
//            make.width.height.mas_equalTo(ChangedHeight(30));
        }];
        UILabel *tiplab = [UILabel new];
        tiplab.textColor = [UIColor whiteColor];
        tiplab.text = @"出\n借";
        tiplab.textAlignment = NSTextAlignmentCenter;
        tiplab.numberOfLines = 2;
        tiplab.font = [UIFont gs_fontNum:10];
        [self.tipImg addSubview:tiplab];
        [tiplab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.tipImg).insets(UIEdgeInsetsMake(0, 0, 3, 0));
        }];
    }
    return self;
}

- (void)setConten:(WaterModel *)item{
    self.myModel = [item modelCopy];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item.date_time longLongValue]];
    self.timeLab.text = [date dateWithFormat:@"yyyy/MM/dd HH:mm:ss"];
    self.typeLab.text = item.type;
    self.changeMoneyLab.text = item.balance;//@"+10000";
//    self.remainLab.text = [NSString stringWithFormat:@"账户余额:%@",item.account_money];
    self.tipImg.hidden = ![item.type isEqualToString:@"出借"];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"组-%@",item.type]];
    if ([item.type containsString:@"冻结"]) {
        img = [UIImage imageNamed:@"组-冻结"];
    }else if ([item.type containsString:@"充值"]){
        img = [UIImage imageNamed:@"组-充值"];
    }else if ([item.type containsString:@"投标成功本金"] || [item.type containsString:@"出借"]){
        img = [UIImage imageNamed:@"组-出借"];
    }else if ([item.type containsString:@"提现"]){
        img = [UIImage imageNamed:@"组-提现"];
    }
    self.logoImg.image = img ? img : KDefaultImg;
//    self.returnBtn.hidden = [item.is_return integerValue] != 1;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (UIButton *)returnBtn {
//   if (!_returnBtn) {
//       _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//       _returnBtn.titleLabel.font = [UIFont gs_fontNum:14];
//       [_returnBtn setTitle:@"撤销提现" forState:UIControlStateNormal];
////       [_returnBtn setTitleColor:[UIColor getOrangeColor] forState:UIControlStateNormal];
//       _returnBtn.backgroundColor = [UIColor getOrangeColor];
//       [_returnBtn addTarget:self action:@selector(removeTiXian) forControlEvents:UIControlEventTouchUpInside];
//   }
//   return _returnBtn;
//}

- (void)removeTiXian{
    
}
@end
