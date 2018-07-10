//
//  UserInfoView.m
//  JinLingDai
//
//  Created by 001 on 2017/6/29.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "UserInfoView.h"
#import <YYKit.h>
#import "UIImageView+Radius.h"
#import "UIView+Masonry.h"
#import "UIColor+Util.h"
#import "UserManager.h"
#define UserHeadHeigth 55
@interface UserInfoView ()
@property (nonatomic, strong) UIImageView *userHeadView;//头像
@property (nonatomic, strong) UILabel *userNickLab;//昵称
@property (nonatomic, strong) UIButton *messageBtn;//消息按钮
@property (nonatomic, strong) UILabel *totolMoneyLab;//总资产
@property (nonatomic, strong) UIButton *changeHidenBtn;//眼睛按钮
@property (nonatomic, strong) UILabel *balanceLab;//余额
@property (nonatomic, strong) UILabel *earningsLab;//收益
@property (nonatomic, strong) UILabel *yesterdayBalanceLab;//昨日收益
@property (nonatomic, copy)  NSString *moneyStr;
@property (nonatomic, strong) UIView *bootomBGView;//
@property (nonatomic, strong) UIView *VerLine;//
@property (nonatomic, strong) UIButton *extractBtn;//提现
@property (nonatomic, strong) UIButton *rechargeBtn;//充值
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) UserMoneyModel *moneyModel;
@end
@implementation UserInfoView

- (instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor =[UIColor colorWithHex:0x5d4459] ;
        
        self.userHeadView = [[UIImageView alloc]init];
        self.userHeadView.userInteractionEnabled = YES;
        self.userHeadView.image = [UIImage imageNamed:@"默认头像"];
        [self.userHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userLogoClicked)]];

        [self addSubview:self.userHeadView];
        
        self.userNickLab = [UILabel new];
        self.userNickLab.textAlignment = NSTextAlignmentCenter;
        self.userNickLab.textColor = [UIColor whiteColor];
        self.userNickLab.font = [UIFont gs_fontNum:13];
        [self addSubview:self.userNickLab];
        
        self.messageBtn = [UIButton new];
        [self.messageBtn addTarget:self action:@selector(messageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.messageBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
        [self addSubview:self.messageBtn];
        
        self.redView = [UIView new];
        self.redView.backgroundColor = [UIColor redColor];
        self.redView.layer.cornerRadius = 2;
        [self.messageBtn addSubview:self.redView];
        
        self.totolMoneyLab = [UILabel new];
        self.totolMoneyLab.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.totolMoneyLab.textColor = [UIColor whiteColor];
        self.totolMoneyLab.numberOfLines = 0;
        self.totolMoneyLab.textAlignment = NSTextAlignmentCenter;
        self.totolMoneyLab.font = [UIFont gs_fontNum:13 weight:UIFontWeightSemibold];
        [self addSubview:self.totolMoneyLab];
        
        self.changeHidenBtn = [UIButton new];
        [self.changeHidenBtn setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
        [self.changeHidenBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected];
        [self.changeHidenBtn addTarget:self action:@selector(changeMoneyLabSecurity:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.changeHidenBtn];
        
        self.balanceLab = [UILabel new];
        self.balanceLab.numberOfLines = 0;
        self.balanceLab.textColor = [UIColor whiteColor];
        self.balanceLab.font = [UIFont gs_fontNum:13];
        self.balanceLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.balanceLab];
        
        self.earningsLab = [UILabel new];
        self.earningsLab.numberOfLines = 0;
        self.earningsLab.textColor = [UIColor whiteColor];
        self.earningsLab.font = [UIFont gs_fontNum:13];
        self.earningsLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.earningsLab];
        
        self.yesterdayBalanceLab = [UILabel new];
        self.yesterdayBalanceLab.numberOfLines = 0;
        self.yesterdayBalanceLab.textColor = [UIColor whiteColor];
        self.yesterdayBalanceLab.font = [UIFont gs_fontNum:13];
        self.yesterdayBalanceLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.yesterdayBalanceLab];
        
        self.bootomBGView = [UIView new];
        self.bootomBGView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bootomBGView];
        
        self.VerLine = [UIView new];
        self.VerLine.backgroundColor = [UIColor newSeparatorColor];
        [self addSubview:self.VerLine];
        
        self.extractBtn = [UIButton new];
        [self.extractBtn setTitle:@"提现" forState:UIControlStateNormal];
         [self.extractBtn addTarget:self action:@selector(extractMoney) forControlEvents:UIControlEventTouchUpInside];
        [self.extractBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
        [self addSubview:self.extractBtn];
        
        self.rechargeBtn = [UIButton new];
        [self.rechargeBtn setTitleColor:[UIColor getOrangeColor] forState:UIControlStateNormal];
        [self.rechargeBtn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchUpInside];
        [self.rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [self addSubview:self.rechargeBtn];
        
        UIView *verLine1 = [UIView new];
        verLine1.backgroundColor = [UIColor borderColor];
        [self addSubview:verLine1];
        [verLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerY.height.equalTo(self.balanceLab);
//            make.bottom.equalTo(self).offset(ChangedHeight(5));
        }];
        
        UIView *verLine2 = [UIView new];
        verLine2.backgroundColor = [UIColor borderColor];
        [self addSubview:verLine2];
        [verLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerY.height.equalTo(self.balanceLab);
        }];
        [self distributeSpacingHorizontallyWith:@[verLine1,verLine2]];
        self.redView.hidden = YES;
        [self addSubview:self.loginBtn];
        [self layoutMasonry];
        
        
    }
    return self;
}

/**
 设置约束
 */
- (void)layoutMasonry{
    [self.userHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(ChangedHeight(15));
        make.size.mas_equalTo(CGSizeMake(ChangedHeight(UserHeadHeigth), ChangedHeight(UserHeadHeigth)));
    }];
    
    [self.userHeadView.superview layoutIfNeeded];
    [self.userHeadView setCornerRadiusAdvance:self.userHeadView.width/2];
    
    [self.userNickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.userHeadView);
        make.top.equalTo(self.userHeadView.mas_bottom).offset(ChangedHeight(5));
    }];
    
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.height.mas_equalTo(ChangedHeight(30));
    }];
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageBtn).offset(ChangedHeight(-10));
        make.size.mas_equalTo(CGSizeMake(4, 4));
        make.top.equalTo(self.messageBtn).offset(ChangedHeight(9));
    }];
    [self.totolMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.userNickLab.mas_bottom).offset(ChangedHeight(10));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.totolMoneyLab);
        make.width.mas_equalTo(ChangedHeight(80));
        make.height.mas_equalTo(40);
    }];
    [self.changeHidenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.userNickLab.mas_centerY);
        make.width.mas_equalTo(ChangedHeight(40));
        make.height.mas_equalTo(ChangedHeight(20));
    }];
    
    
    [self.balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(ChangedHeight(-45));
        make.width.equalTo(self).dividedBy(3.0);
        make.left.equalTo(self);
    }];
    
    [self.earningsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.balanceLab);
        make.width.equalTo(self).dividedBy(3.0);
        make.left.equalTo(self.balanceLab.mas_right);
    }];
    
    [self.yesterdayBalanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.balanceLab);
        make.width.equalTo(self).dividedBy(3.0);
        make.left.equalTo(self.earningsLab.mas_right);
        make.right.equalTo(self);
    }];
    
    [self.bootomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    
    [self.VerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.bootomBGView).dividedBy(2.0);
        make.width.mas_equalTo(1);
        make.centerX.centerY.equalTo(self.bootomBGView);
    }];
    
    [self.extractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bootomBGView);
        make.width.equalTo(self.bootomBGView).dividedBy(2.0).offset(- 1);
    }];
    
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bootomBGView);
        make.width.equalTo(self.bootomBGView).dividedBy(2.0).offset(- 1);
    }];
}

- (NSAttributedString *)getMoneyAttr{
    
    NSString *moneyStr = self.changeHidenBtn.selected? @"*****":[NSString stringWithFormat:@"%.2f",[self.moneyStr doubleValue]];
    NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"资产总额：%@元",moneyStr]];
    if (self.changeHidenBtn.selected) {
        //隐藏money时设置偏移量
        [moneyAttr addAttribute:NSBaselineOffsetAttributeName value:@-10 range:[moneyAttr.string rangeOfString:moneyStr]];
    }
    [moneyAttr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:22] range:[moneyAttr.string rangeOfString:moneyStr]];
    
    return moneyAttr;
}
- (void)setRedMessageShow:(BOOL)show{
    self.redView.hidden = !show;
}
/**
 设置内容

 @param item model
 */
- (void)layoutContent:(UserModel *)item{
    
    self.changeHidenBtn.hidden = item == nil;
    self.userNickLab.hidden = self.totolMoneyLab.hidden = self.changeHidenBtn.hidden;
    self.loginBtn.hidden = item != nil;
    self.user = item;
    
    if (item) {
        self.changeHidenBtn.selected = item.HidenMoney;
//        [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
//                                     forHTTPHeaderField:@"Accept"];
        [self.userHeadView sd_setImageWithURL:[NSURL URLWithString:item.head] placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@",error);
        }];
    }else
        self.userHeadView.image = [UIImage imageNamed:@"默认头像"];
    
//    self.userNickLab.text = self.changeHidenBtn.hidden?@"未登录":item.username;

}

- (void)layoutMoneyContent:(UserMoneyModel *)item{
    self.moneyModel = item;
    self.moneyStr = item == nil?@"--":item.total_balance;
    
    self.totolMoneyLab.attributedText = [self getMoneyAttr];
    
    if (!item) {
        self.balanceLab.text = @"--\n可用余额";
        self.earningsLab.text = @"--\n累计收益";
        self.yesterdayBalanceLab.text = @"--\n待收收益";
    }else{
        self.balanceLab.text = [NSString stringWithFormat:@"%@\n可用余额",self.changeHidenBtn.selected? @"*****":[NSString stringWithFormat:@"%.2f",[item.active_balance doubleValue]]];
        
        
        self.earningsLab.text = [NSString stringWithFormat:@"%@\n累计收益",self.changeHidenBtn.selected? @"*****":[NSString stringWithFormat:@"%.2f",[item.total_interest doubleValue]]];
        
        
        self.yesterdayBalanceLab.text = [NSString stringWithFormat:@"%@\n待收收益",self.changeHidenBtn.selected? @"*****":[NSString stringWithFormat:@"%.2f",[item.coming_interest doubleValue]]];
    }
   
}
/**
 点击头像
 */
- (void)userLogoClicked{
    if (_userHeadClickedBlock) {
        _userHeadClickedBlock();
    }
}
/**
 查看消息
 */
- (void)messageBtnClicked{
    if (_messageClickedBlock) {
        _messageClickedBlock();
    }
}

/**
 提现
 */
- (void)extractMoney{
    if (_extractBtnClickedBlock) {
        _extractBtnClickedBlock();
    }
}
/**
 充值
 */
- (void)rechargeMoney{
    if (_rechargeBtnClickedBlock) {
        _rechargeBtnClickedBlock();
    }
}
/**
 改变资产可见状态
 */
- (void)changeMoneyLabSecurity:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.user.HidenMoney = sender.selected;
    [[UserManager shareManager] saveUserModel:self.user];
    
    self.totolMoneyLab.attributedText = [self getMoneyAttr];
    
    self.balanceLab.text = [NSString stringWithFormat:@"%@\n可用余额",self.changeHidenBtn.selected? @"*****":_moneyModel.active_balance];
    
    
    self.earningsLab.text = [NSString stringWithFormat:@"%@\n累计收益",self.changeHidenBtn.selected? @"*****":_moneyModel.coming_interest];
    
    
    self.yesterdayBalanceLab.text = [NSString stringWithFormat:@"%@\n待收收益",self.changeHidenBtn.selected? @"*****":_moneyModel.coming_interest];
    
    
    
}

- (UIButton *)loginBtn {
   if (!_loginBtn) {
       _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _loginBtn.hidden = YES;
       _loginBtn.layer.masksToBounds = YES;
       _loginBtn.layer.cornerRadius = 5;
       _loginBtn.layer.borderWidth = 1;
       _loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
       _loginBtn.titleLabel.font = [UIFont gs_fontNum:14];
       [_loginBtn setTitle:@"请点击登录" forState:UIControlStateNormal];
       [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [_loginBtn addTarget:self action:@selector(userLogoClicked) forControlEvents:UIControlEventTouchUpInside];
   }
   return _loginBtn;
}

@end
