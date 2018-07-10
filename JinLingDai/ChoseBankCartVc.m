//
//  ChoseBankCartVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ChoseBankCartVc.h"

@interface ChoseBankCartVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;

@end


#define BankArr @[@"中信银行", @"招商银行", @"兴业银行", @"浦发银行", @"平安银行", @"邮政储蓄", @"农业银行",@"民生银行", @"交通银行", @"华夏银行", @"广发银行", @"光大银行", @"北京银行", @"工商银行",@"建设银行", @"上海银行", @"中国银行"]
@implementation ChoseBankCartVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"选择银行卡";
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.rowHeight = ChangedHeight(45);
    
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cartCell"];
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return BankArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    cell.imageView.image = [UIImage imageNamed:BankArr[indexPath.row]];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.textLabel.text = BankArr[indexPath.row];
    cell.textLabel.textColor = [UIColor titleColor];
    cell.textLabel.font = [UIFont gs_fontNum:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_BanckBlock) {
        
        _BanckBlock([NSString stringWithFormat:@"%@",@(indexPath.row)],BankArr[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
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
