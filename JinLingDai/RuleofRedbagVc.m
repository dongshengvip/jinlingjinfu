//
//  RuleofRedbagVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/26.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RuleofRedbagVc.h"
#import "UIView+Radius.h"
#import "NSDate+Formatter.h"
#import "NSMutableAttributedString+contentText.h"
@interface RuleofRedbagVc ()
@property (nonatomic, strong) UILabel *redbagTitleLab;//标题
@property (nonatomic, strong) UILabel *validTimeLab;//有效期
@property (nonatomic, strong) UILabel *ruleLab;//规则
@property (nonatomic, strong) UIView *bgView;//头部beijing
@property (nonatomic, strong) UIImageView *checkImg;//以使用
@property (nonatomic, strong) UIButton *tuUseBtn;
@end

@implementation RuleofRedbagVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    
    self.title = @"红包详情";
    self.view.backgroundColor = [UIColor infosBackViewColor];
    UIScrollView *scroll = [[UIScrollView alloc]init];
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *helperView = [UIView new];
    [scroll addSubview:helperView];
    [helperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(-64);
    }];
    
    UIView *ContenView = [UIView new];
    ContenView.backgroundColor = [UIColor whiteColor];
    [helperView addSubview:ContenView];
    [ContenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(helperView).insets(UIEdgeInsetsMake(ChangedHeight(10), ChangedHeight(10), ChangedHeight(100), ChangedHeight(10)));
    }];
    
    self.bgView = [UIView new];
    [ContenView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(ContenView);
        make.height.mas_equalTo(ChangedHeight(100));
    }];
    
    UIView *line = [UIView drawDashLineWidth:K_WIDTH lineLength:8 lineSpacing:3 lineColor:[UIColor blackColor]];
    [ContenView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(ContenView);
        make.top.equalTo(self.bgView.mas_bottom).offset(1);
        make.height.mas_equalTo(1);
    }];
    
    self.redbagTitleLab = [UILabel new];
    self.redbagTitleLab.font = [UIFont gs_fontNum:16];
    [self.bgView addSubview:self.redbagTitleLab];
    [self.redbagTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
    }];
    
    self.validTimeLab = [UILabel new];
    self.validTimeLab.font = [UIFont gs_fontNum:12];
    [self.bgView addSubview:self.validTimeLab];
    [self.validTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.redbagTitleLab.mas_bottom);
        make.height.equalTo(self.redbagTitleLab);
        make.bottom.equalTo(self.bgView);
    }];
    
    self.ruleLab = [UILabel new];
    self.ruleLab.textColor = [UIColor tipTextColor];
    self.ruleLab.font = [UIFont gs_fontNum:12];
    self.ruleLab.numberOfLines = 0;
    [ContenView addSubview:self.ruleLab];
    [self.ruleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ContenView).offset(ChangedHeight(15));
        make.top.equalTo(line.mas_bottom).offset(ChangedHeight(30));
        make.right.equalTo(ContenView).offset(ChangedHeight(-15));
    }];
    
    [ContenView.superview layoutIfNeeded];
    
    [ContenView setCornerRadiusAdvance:20 rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    [self.bgView.superview layoutIfNeeded];
    [self.bgView setCornerRadiusAdvance:20 rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    self.redbagTitleLab.textColor = self.validTimeLab.textColor = [UIColor whiteColor];
    self.redbagTitleLab.textAlignment = self.validTimeLab.textAlignment = NSTextAlignmentCenter;
    
    self.checkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已使用"]];
    [ContenView addSubview:self.checkImg];
    self.checkImg.hidden = YES;
    [self.checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ContenView);
        make.width.height.equalTo(ContenView.mas_width).multipliedBy(0.5);
    }];
    
    self.tuUseBtn.hidden = YES;
    [ContenView addSubview:self.tuUseBtn];
    [self.tuUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ContenView);
        make.bottom.equalTo(ContenView).offset(ChangedHeight(-15));
        make.width.equalTo(ContenView).dividedBy(2.0);
        make.height.mas_equalTo(40);
    }];
    [self.tuUseBtn.superview layoutIfNeeded];
    [self.tuUseBtn setCornerRadiusAdvance:5];
}

- (void)setBagModel:(RedBagModel *)bagModel{
    _bagModel = bagModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.checkImg.hidden = [self.bagModel.status integerValue] != 4;
    switch ([self.bagModel.status integerValue]) {
        case 1:{//可用
            self.tuUseBtn.hidden = NO;
        }
        case 4://已用
        {
            self.bgView.backgroundColor = [UIColor redColor];
            self.redbagTitleLab.textColor = self.validTimeLab.textColor = [UIColor colorWithHex:0xfbf300];
        }
            break;
        case 2://过期
            self.bgView.backgroundColor = [UIColor grayColor];
            break;

        default:
            break;
    }
    [self setUIText];
}

- (void)setUIText{
    self.redbagTitleLab.text = [NSString stringWithFormat:@"%@元%@红包",self.bagModel.money,self.bagModel.name];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.bagModel.end_date longLongValue]];
    self.validTimeLab.text = [NSString stringWithFormat:@"有效期至%@",[date dateWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
    
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    
    style.alignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 6;
    
    style2 .alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"使用规则\n1.%@",self.bagModel.detail]];
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, 5)];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:14] range:NSMakeRange(0, 5)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor newSecondTextColor] range:NSMakeRange(0, 5)];
    [attr addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(5, self.bagModel.detail.length)];
    self.ruleLab.attributedText = attr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIButton *)tuUseBtn {
   if (!_tuUseBtn) {
       _tuUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _tuUseBtn.titleLabel.font = [UIFont gs_fontNum:15];
       [_tuUseBtn setTitle:@"立即使用" forState:UIControlStateNormal];
       _tuUseBtn.backgroundColor = [UIColor redColor];
       [_tuUseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [_tuUseBtn addTarget:self action:@selector(toUesRedBag) forControlEvents:UIControlEventTouchUpInside];
   }
   return _tuUseBtn;
}

- (void)toUesRedBag{
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
