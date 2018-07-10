//
//  MyCapitalVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/4.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MyCapitalVc.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#define TitleArr @[@"定期项目", @"债券认购", @"债券管理", @"账户流水"]
@interface MyCapitalVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;

@end

@implementation MyCapitalVc

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBlackColor];
    
    self.title = @"我的资产";
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.sectionFooterHeight = 0.1;
    self.myTab.rowHeight = ChangedHeight(45);
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    //
    [self.view addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor getColor:84 G:85 B:86];
    cell.textLabel.text = TitleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            UIViewController *vc = [[NSClassFromString(@"DingQiXiangMuVc") alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            UIViewController *vc = [[NSClassFromString(@"RunningWaterVc") alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            UIViewController *vc = [[NSClassFromString(@"RunningWaterVc") alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:{
            UIViewController *vc = [[NSClassFromString(@"RunningWaterVc") alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
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
