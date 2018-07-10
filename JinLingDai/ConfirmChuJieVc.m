//
//  ConfirmChuJieVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ConfirmChuJieVc.h"
#import "HuanKuanCell.h"
#import "TwoLabAndRightAlmentLeftCell.h"
#import "ThreeLabAndRightLabAllmentLfetCell.h"
#import "UserManager.h"
#import "JiaoYiMoneyView.h"
@interface ConfirmChuJieVc ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) JiaoYiMoneyView *aleart;
@end
#define HuanKuanTitleArr @[@"序号", @"还款日期", @"本金", @"利息"]
@implementation ConfirmChuJieVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"出借确认";
    self.view.backgroundColor = [UIColor infosBackViewColor];
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;

    [self.myTab registerClass:[HuanKuanCell class] forCellReuseIdentifier:@"HuanKuanCell"];
    [self.myTab registerClass:[TwoLabAndRightAlmentLeftCell class] forCellReuseIdentifier:@"TwoLabAndRightAlmentLeftCell"];
    [self.myTab registerClass:[ThreeLabAndRightLabAllmentLfetCell class] forCellReuseIdentifier:@"ThreeLabAndRightLabAllmentLfetCell"];

    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 5;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return ChangedHeight(40);
    }
    return ChangedHeight(5);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 3) {
        UIView *last = nil;
        for (NSInteger i = 0; i < HuanKuanTitleArr.count; i ++) {
            UILabel *lab = [UILabel new];
            lab.textColor = [UIColor titleColor];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont gs_fontNum:14];
            lab.text = HuanKuanTitleArr[i];
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(view);
                if (i == 0) {
                    make.left.equalTo(view);
                }else{
                    make.left.equalTo(last.mas_right);
                    make.width.equalTo(last);
                }
                if (i == HuanKuanTitleArr.count - 1) {
                    make.right.equalTo(view);
                }
            }];
            last = lab;
        }
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return ChangedHeight(95);
    }
    return ChangedHeight(0.1);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 3) {
        [self setTabFooterView:view];
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        case 2:
            return ChangedHeight(40);
            break;
        case 1:
            return ChangedHeight(70);
            break;
        default:return ChangedHeight(45);
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            TwoLabAndRightAlmentLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabAndRightAlmentLeftCell"];
            [cell setContenView:nil];
            return cell;
        }
            break;
        case 1:
        {
            ThreeLabAndRightLabAllmentLfetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThreeLabAndRightLabAllmentLfetCell"];
            [cell setContenView:nil];
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"labCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *lab = [UILabel new];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = [UIColor getOrangeColor];
                lab.font = [UIFont gs_fontNum:16];
                lab.text = @"还款计划";
                [cell.contentView addSubview:lab];
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell.contentView);
                }];
            }
            return cell;
        }
            break;
        default:{
            HuanKuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuanKuanCell"];
            [cell setContenView:nil];
            return cell;
        }
            break;
    }
}

- (UIView *)setTabFooterView:(UIView *)view{
    UILabel *totolLab = [UILabel new];
    totolLab.text = @"合计 ：";
    [view addSubview:totolLab];
    [totolLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(ChangedHeight(20));
        make.top.equalTo(view).offset(ChangedHeight(10));
        make.width.equalTo(view).multipliedBy(0.5).offset(ChangedHeight(- 20));
    }];
    
    UILabel *moneyLab = [UILabel new];
    moneyLab.text = @"0";
    [view addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totolLab.mas_right);
        make.top.equalTo(totolLab);
        make.width.equalTo(view).multipliedBy(0.25);
    }];
    
    UILabel *lixiLab = [UILabel new];
    lixiLab.text = @"0";
    [view addSubview:lixiLab];
    [lixiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLab.mas_right);
        make.top.equalTo(totolLab);
        make.width.equalTo(moneyLab);
    }];
    
    totolLab.font = moneyLab.font = lixiLab.font = [UIFont gs_fontNum:15];
    totolLab.textColor = moneyLab.textColor = [UIColor titleColor];
    lixiLab.textColor = [UIColor getOrangeColor];
//
    moneyLab.textAlignment = lixiLab.textAlignment = NSTextAlignmentCenter;
    //设置下边的按钮
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(confirmChuJie) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认出借" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont gs_fontNum:17];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor getOrangeColor];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(ChangedHeight(35));
        make.right.equalTo(view).offset(ChangedHeight(- 35));
        make.centerX.equalTo(view);
        make.bottom.equalTo(view).offset(ChangedHeight(-10));
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    return view;
}
/**
 确认出借
 */
- (void)confirmChuJie{
    _aleart = [[JiaoYiMoneyView alloc]init];
    _aleart.titleStr = @"请输入交易密码";
    _aleart.moneyStr = @"2000";
    [_aleart showAlertType];
    
    __weak typeof(self) weakMine = self;
    _aleart.inputPassEndBlock = ^(NSString *password) {
        [weakMine.aleart hidenAlertType];
        UserModel *model = [UserManager shareManager].user;
        
        model.invest_count = [NSString stringWithFormat:@"%@",@([model.invest_count integerValue] + 1)];
        [[UserManager shareManager] saveUserModel:model];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RefreshUser];
    };
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
