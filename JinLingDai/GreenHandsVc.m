//
//  GreenHandsVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/13.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "GreenHandsVc.h"
#import "NSMutableAttributedString+contentText.h"
#import "UserManager.h"
#import "UIView+Masonry.h"
@interface GreenHandsVc ()

/**
 //开户
 //首投
 //复投
 */
//@property (nonatomic, strong) UILabel *bankLab;
//@property (nonatomic, strong) UILabel *firstLab;
//@property (nonatomic, strong) UILabel *secondLab;
//@property (nonatomic, strong) UIButton *bankBtn;
//@property (nonatomic, strong) UIButton *firstTouBtn;
//@property (nonatomic, strong) UIButton *secondTouBtn;
//@property (nonatomic, strong) UIImageView *bankImg;
//@property (nonatomic, strong) UIImageView *firstTouImg;
//@property (nonatomic, strong) UIImageView *secondTouImg;
@property (nonatomic, strong) UserModel *user;//用户
@property (nonatomic, assign) NSInteger stepOfUser;//用户脚步
@property (nonatomic, strong) UIButton *DoNownBtn;//点击
@end
#define JumpClassArr @[@"LogingVc", @"ManageOfBankVc", @"", @""]
@implementation GreenHandsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"新手福利";
    UIScrollView *scroll = [[UIScrollView alloc] init];
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    UIImage *img = [UIImage imageNamed:@"greenHand"];
//    UIImageView *greenHandImag = [[UIImageView alloc] initWithImage:img];
//    greenHandImag.userInteractionEnabled = YES;
//    [scroll addSubview:greenHandImag];
//    [greenHandImag mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scroll);
//        make.width.equalTo(self.view);
//        make.height.mas_equalTo(ChangedHeight(img.size.height));
//    }];
    
    
    UIImage *tipHead = [UIImage imageNamed:@"福利头部"];
    UIImageView *tipHeadImag = [[UIImageView alloc] initWithImage:tipHead];
//    tipHeadImag.userInteractionEnabled = YES;
    [scroll addSubview:tipHeadImag];
    [tipHeadImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(scroll);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(ChangedHeight(tipHead.size.height));
    }];
    
    UIImage *fuliRedBag = [UIImage imageNamed:@"福利红包"];
    UIImageView *fuliRedBagImag = [[UIImageView alloc] initWithImage:fuliRedBag];
//    tipHeadImag.userInteractionEnabled = YES;
    [scroll addSubview:fuliRedBagImag];
    [fuliRedBagImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipHeadImag.mas_bottom);
        make.left.right.equalTo(scroll);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(ChangedHeight(fuliRedBag.size.height));
    }];

//    UILabel *subTitleLab = [UILabel new];
//    subTitleLab.textAlignment = NSTextAlignmentCenter;
//    subTitleLab.text = @"新人红包 注册即享";
//    subTitleLab.textColor = [UIColor getOrangeColor];
//    subTitleLab.font = [UIFont gs_fontNum:15];
//    [greenHandImag addSubview:subTitleLab];
//    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(greenHandImag);
//        make.top.equalTo(tipHeadImag.mas_bottom).offset(ChangedHeight(15));
//    }];
//
//    [greenHandImag addSubview:self.bankLab];
//    [greenHandImag addSubview:self.firstLab];
//    [greenHandImag addSubview:self.secondLab];
//
//    UIView *line = [UIView new];
//    line.backgroundColor = [UIColor getOrangeColor];
//    [greenHandImag addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(greenHandImag).offset(ChangedHeight(10));
//        make.right.equalTo(greenHandImag).offset(ChangedHeight(-10));
//        make.height.mas_equalTo(1);
//        make.top.equalTo(self.bankLab.mas_bottom).offset(ChangedHeight(15));
//    }];
//
//    [greenHandImag addSubview:self.bankBtn];
//    [greenHandImag addSubview:self.firstTouBtn];
//    [greenHandImag addSubview:self.secondTouBtn];
//
//
//    [greenHandImag addSubview:self.bankImg];
//    [greenHandImag addSubview:self.firstTouImg];
//    [greenHandImag addSubview:self.secondTouImg];
//
//    [self.bankImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bankBtn.mas_bottom).offset(ChangedHeight(8));
//    }];
//    [self.firstTouImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bankImg);
//    }];
//    [self.secondTouImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bankImg);
//    }];
//    [greenHandImag distributeSpacingHorizontallyWith:@[self.bankImg,self.firstTouImg,self.secondTouImg]];
//
//    [self.bankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(line);
//        make.centerX.equalTo(self.bankImg);
//        make.size.mas_equalTo(CGSizeMake(ChangedHeight(17), ChangedHeight(17)));
//    }];
//
//    [self.firstTouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(line);
//        make.centerX.equalTo(self.firstTouImg);
//        make.size.mas_equalTo(CGSizeMake(ChangedHeight(17), ChangedHeight(17)));
//    }];
//    [self.secondTouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(line);
//        make.centerX.equalTo(self.secondTouImg);
//        make.size.mas_equalTo(CGSizeMake(ChangedHeight(17), ChangedHeight(17)));
//    }];
//
//    [self.bankLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.bankImg);
//        make.top.equalTo(subTitleLab.mas_bottom).offset(ChangedHeight(20));
//    }];
//
//    [self.firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.firstTouImg);
//        make.top.equalTo(self.bankLab);
//    }];
//
//    [self.secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.secondTouImg);
//        make.top.equalTo(self.bankLab);
//    }];
    self.DoNownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.DoNownBtn setBackgroundImage:[UIImage imageNamed:@"doNown"] forState:UIControlStateNormal];
    [self.DoNownBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    self.DoNownBtn.backgroundColor = [UIColor getOrangeColor];
    self.DoNownBtn.titleLabel.font = [UIFont gs_fontNum:14];
    self.DoNownBtn.layer.cornerRadius = 5;
//    [self.DoNownBtn setTitleEdgeInsets:UIEdgeInsetsMake(-ChangedHeight(12), 0, 0, 0)];
    [self.DoNownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scroll addSubview:self.DoNownBtn];
    [self.DoNownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fuliRedBagImag.mas_bottom).offset(ChangedHeight(25));
        make.width.equalTo(self.view).offset(ChangedHeight(-100));
        make.height.mas_equalTo(ChangedHeight(35));
        make.centerX.equalTo(scroll);
    }];
    UILabel *tipLab = [UILabel new];
    tipLab.font = [UIFont gs_fontNum:12];
    tipLab.textColor = [UIColor tipTextColor];
    tipLab.textAlignment = NSTextAlignmentRight;
    tipLab.text = @"活动解释权归金陵金服所有";
    [scroll addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(scroll).offset(ChangedHeight(- 20));
        make.bottom.equalTo(scroll).offset(ChangedHeight(-25));
    }];
    
    UILabel *lab = [UILabel new];
    lab.numberOfLines = 0;
    lab.font = [UIFont gs_fontNum:12];
    lab.textColor = [UIColor newSecondTextColor];
    
    lab.attributedText = [NSMutableAttributedString getAttributedString:@"使用规则：\n1.活动时间：2017年07月25日—2018年07月25日\n2.有效期：红包38元，50元有效期为7天；红包100元有效期为15天，200元有效期为1个月\n3.红包在“我的账户--奖励”或者app端“我的--奖励”查看\n4.一次只能使⽤一个红包，⽤户可⾃主决定选择使⽤\n5.老用户已领过红包的不予重复领取" Font:[UIFont gs_fontNum:15] Color:[UIColor titleColor] grayText:@"使用规则：" TextAligment:NSTextAlignmentLeft LineSpace:ChangedHeight(5)];
    [scroll addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.DoNownBtn.mas_bottom).offset(ChangedHeight(25));
        make.left.equalTo(scroll).offset(ChangedHeight(20));
        make.right.equalTo(scroll).offset(ChangedHeight(- 20));
        make.bottom.equalTo(tipLab.mas_top).offset(ChangedHeight(-10));
    }];
//
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.user = [UserManager shareManager].user;
    [self setGreenHandsLeve];
    
}


- (void)setGreenHandsLeve{
    if (!self.user) {
        [self.DoNownBtn addTarget:self action:@selector(registUserModel) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        if (!Nilstr2Space(self.user.platcust).length) {
            [self checkName];
        }else if ([self.user.invest_count integerValue] == 0) {
            [self firstTouZi];
        }else if ([self.user.invest_count integerValue] >= 1) {
            [self secondTouZi];
        
        }
        
    }
}

- (void)registUserModel{
    UIViewController *vc = [[NSClassFromString(JumpClassArr[self.stepOfUser]) alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)checkName{
    self.stepOfUser = 1;
    [self.DoNownBtn setTitle:@"立即开户" forState:UIControlStateNormal];
    [self.DoNownBtn addTarget:self action:@selector(doNowJumpToClass) forControlEvents:UIControlEventTouchUpInside];
}



- (void)firstTouZi{
    self.stepOfUser = 2;
    [self.DoNownBtn setTitle:@"立即首投" forState:UIControlStateNormal];
    [self.DoNownBtn addTarget:self action:@selector(doNowJumpToClass) forControlEvents:UIControlEventTouchUpInside];
}

- (void)secondTouZi{
    self.stepOfUser = 3;
    [self.DoNownBtn setTitle:@"立即复投" forState:UIControlStateNormal];
    [self.DoNownBtn addTarget:self action:@selector(doNowJumpToClass) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doNowJumpToClass{
    UIViewController *vc = [[NSClassFromString(JumpClassArr[self.stepOfUser]) alloc] init];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.tabBarController setSelectedIndex:1];
        [self.navigationController popToRootViewControllerAnimated:NO];
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
