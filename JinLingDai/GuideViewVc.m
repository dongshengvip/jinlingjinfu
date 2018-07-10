//
//  GuideViewVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/13.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "GuideViewVc.h"
#import "GuideView.h"
@interface GuideViewVc ()
@property (nonatomic, strong) UIScrollView *scroll;
@end

@implementation GuideViewVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    GuideView *leadView = [GuideView share];
//    __weak
    leadView.overGuidViewBlock = ^{
        if (_liuLangWanCheng) {
            _liuLangWanCheng();
        }
    };
    [self.view addSubview:leadView];
    [leadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopBtn setTitle:@"跳过" forState:UIControlStateNormal];
    stopBtn.titleLabel.font = [UIFont gs_fontNum:14];
    stopBtn.alpha = 0.5;
    stopBtn.layer.cornerRadius = 6;
    stopBtn.layer.borderWidth = 1;
    stopBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(overLead) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ChangedHeight(20));
        make.right.equalTo(self.view).offset(ChangedHeight(- 25));
        make.size.mas_equalTo(CGSizeMake(ChangedHeight(40), ChangedHeight(25)));
    }];
}

- (void)overLead{
    if (_liuLangWanCheng) {
        _liuLangWanCheng();
    }
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
