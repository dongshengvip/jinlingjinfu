//
//  ExplainVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ExplainVc.h"

@interface ExplainVc ()
@property (nonatomic, strong) UILabel *contenLab;

@end

@implementation ExplainVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor infosBackViewColor];
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.scrollEnabled = NO;
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIView *helperView = [UIView new];
    [scroll addSubview:helperView];
    [helperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(- StatusBarHeight - 40);
    }];
    
    self.contenLab = [UILabel new];
    self.contenLab.numberOfLines = 0;
    self.contenLab.textColor = [UIColor tipTextColor];
    self.contenLab.font = [UIFont gs_fontNum:14];
    [helperView addSubview:self.contenLab];
    [self.contenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(helperView).offset(ChangedHeight(20));
        make.top.equalTo(helperView).offset(ChangedHeight(10));
        make.right.equalTo(helperView).offset(ChangedHeight(-10));
    }];
}

- (void)setType:(NSExplainType)type{
    _type = type;
//    if (_type == NSExplainChongZhi) {
//        
//    }else{
//        
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = ChangedHeight(10);
    
    
    NSString *string = @"";
    if (_type == NSExplainChongZhi) {
        string = @"1.金陵金服充值过程不收取任何手续费。\n2.APP充值是通过第三方支付渠道支付，需要投资人绑定一张本人名下的快捷充值卡。\n3.金陵金服在收取支付的扣款通知后，将对应金额充入您的账户，具体到账时间以银行扣款成功时间为主。\n4.APP充值单笔及单日充值限额会根据银行通知有所波动如您再充值过程中遇到任何问题，可随时咨询金陵金服人工客服。";
    }else{
        string = @"1.每日提现次数：每日可进行10次提现操作（含失败次数）。\n2.手续费：每成功提现一笔，您需要支付1.6元手续费（平台为会员提供的免费提现次数依然生效）\n3.额度限制：单笔提现最高20万元。\n4.到账时间：实时到账，提现后2小时未到账可致电金陵金服客服进行咨询。";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:string];
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    self.contenLab.attributedText = attr;
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

@end
