//
//  XiangMuDetailVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/7.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "XiangMuDetailVc.h"
#import "ExternTableViewCell.h"
#import "NSMutableAttributedString+contentText.h"
#import "HTMLVC.h"
#import "ChuJieInfoHTML.h"
#import "MBProgressHUD+NetWork.h"
@interface XiangMuDetailVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,strong) NSMutableArray *isShowListArr;
@end

@implementation XiangMuDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    
    self.title = @"项目详情";
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.backgroundColor = [UIColor infosBackViewColor];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
//    self.myTab.rowHeight = ChangedHeight(110);
    
    [self.myTab registerClass:[ExternTableViewCell class] forCellReuseIdentifier:@"ExternTableViewCell"];
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defultCell"];
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    self.dataArr = [NSMutableArray array];
    self.isShowListArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 6; i ++) {
//        [self.dataArr addObject:@"0"];
        [self.isShowListArr addObject:@"0"];
    }
}

- (void)setModel:(TouZiModel *)model{
    _model = model;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:
        {
            if ([self.isShowListArr[indexPath.row] isEqualToString:@"1"]) {
                if (indexPath.row == 0) {
                    return ChangedHeight(185);
                }
                return ChangedHeight(115);
            }
            return ChangedHeight(45);
        }
            break;

        default:return ChangedHeight(45);
            break;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 2:{
            if ([self.model.investor_status integerValue] != 2) {
                //6=>还款中，7=>已还款
                return 2;
            }else{
                return 1;
            }
        }
            break;
            
        default:return 2;
            break;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"value1Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"value1Cell"];
                cell.textLabel.textColor = [UIColor titleColor];
                cell.detailTextLabel.textColor = [UIColor getOrangeColor];
                cell.textLabel.font =  cell.detailTextLabel.font = [UIFont gs_fontNum:14];
                cell.selectionStyle = UITableViewCellEditingStyleNone;
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            cell.textLabel.text = self.model.borrow_title;
            cell.detailTextLabel.text = self.model.investor_status;
            return cell;
        }
            break;
        case 1:
        {
            ExternTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExternTableViewCell"];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            __weak typeof(cell) weakCell = cell;
            cell.footerhidenChangedBlock = ^(BOOL isHiden) {
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                NSArray * times = indexPath.row == 0?@[@.3,@.3]:@[@0.3];
                
                if (isHiden) {
                    [weakCell showListwithTime:times];
                    [self.isShowListArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                }else{
                    [weakCell hidenListwithTime:times];
                    [self.isShowListArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
                }
                __block float animaTime = 0.f;
                [times enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    animaTime += [obj floatValue];
                }];
                [UIView animateWithDuration:animaTime animations:^{
                    
                    [tableView beginUpdates];
                    [tableView endUpdates];
                    
                } completion:nil];
            } ;
            //判断是否隐藏
            if ([self.isShowListArr[indexPath.row] isEqualToString:@"1"]) {
                [cell showFooterViews:indexPath.row == 0? 2:1];
                self.isShowListArr[indexPath.row] = @"1";
            }else{
                self.isShowListArr[indexPath.row] = @"0";
                [cell hiddenFooterViews:2];
            }if (indexPath.row == 0) {
                [cell setContenView:self.model];
            }else{
                cell.titleLab.text = @"回款详情";
                cell.firstLabInSecondView.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"已收金额\n%@",self.model.received_money] Font:[UIFont gs_fontNum:14] Color:[UIColor newSecondTextColor] grayText:[NSString stringWithFormat:@"已收金额\n%@",self.model.received_money] TextAligment:NSTextAlignmentCenter LineSpace:7];
                cell.secondLabInSecondView.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"待收金额\n%@",self.model.unreceived_money] Font:[UIFont gs_fontNum:14] Color:[UIColor newSecondTextColor] grayText:[NSString stringWithFormat:@"待收金额\n%@",self.model.unreceived_money] TextAligment:NSTextAlignmentCenter LineSpace:7];
                cell.thirdLabInSecondView.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"剩余本金\n%@",self.model.unreceived_capital] Font:[UIFont gs_fontNum:14] Color:[UIColor newSecondTextColor] grayText:[NSString stringWithFormat:@"剩余本金\n%@",self.model.unreceived_capital] TextAligment:NSTextAlignmentCenter LineSpace:7];
            }
            
            return cell;
        }
            break;

        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defultCell"];
            cell.textLabel.textColor = [UIColor titleColor];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            [cell setSeparatorInset:UIEdgeInsetsZero];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont gs_fontNum:14];
            cell.textLabel.text = indexPath.row == 0? @"项目信息":@"项目合同";

            
            return cell;
        }
            break;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            NSString *postUrl ;
            kAppPostHost(postUrl);
            HTMLVC *vc = [[HTMLVC alloc]init];
            vc.title = @"项目合同";
            vc.ignoreBetween = YES;
            vc.H5Url = [NSString stringWithFormat:@"%@agreement/downfile?token=%@&borrow_id=%@",postUrl,[UserManager shareManager].userId,self.model.borrow_id];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ChuJieInfoHTML *vc= [[ChuJieInfoHTML alloc] init];
            vc.borrowModel = self.model;
            vc.title = @"项目信息";
            [self.navigationController pushViewController:vc animated:YES];
        }
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
