//
//  MonthBillVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/6.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MonthBillVc.h"
//#import "SHLineGraphView.h"
//#import "SHPlot.h"
#import "TongJiCell.h"

#import "UIColor+Util.h"
#import <Masonry.h>
#import <YYKit.h>
#import <MJRefresh.h>
@interface MonthBillVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTab;
//@property (nonatomic, strong) SHLineGraphView *lineView;
@property (nonatomic, strong) UILabel *billTitleLab;

@property (nonatomic, strong) UIView *ziChanView;//资产信息
@property (nonatomic, strong) UILabel *shouYiLab;//本月收益
@property (nonatomic, strong) UILabel *huiKuanLab;//本月回款
@property (nonatomic, strong) UILabel *YuELab;//账户余额
@property (nonatomic, strong) UIView *ShouYiView;//收益
@property (nonatomic, strong) UILabel *zhiTouLab;//直投收益
@property (nonatomic, strong) UILabel *zhaiZhuanLab;//债转收益
@property (nonatomic, strong) UILabel *yueShouYiLab;//余额收益
@end

@implementation MonthBillVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"月度账单";
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.sectionFooterHeight = ChangedHeight(0.01);
    self.myTab.rowHeight = ChangedHeight(46);
    self.myTab.tableHeaderView = [self getTabHeadView];
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"bill"];
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"conten"];
    [self.myTab registerClass:[TongJiCell class] forCellReuseIdentifier:@"tongji"];
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self performSelector:@selector(drawLines) withObject:nil afterDelay:1.f];
}

- (UIView *)getTabHeadView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.height = ChangedHeight(80);
    UILabel *tipLab = [UILabel new];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = [UIColor titleColor];
    tipLab.text = @"欢迎查看金陵金服月度账单";
    tipLab.font = [UIFont gs_fontNum:14];
    [view addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view).offset(ChangedHeight(5));
        make.height.equalTo(view).multipliedBy(0.6);
    }];
    
    self.billTitleLab = [UILabel new];
    self.billTitleLab.textColor = [UIColor newSecondTextColor];
    self.billTitleLab.textAlignment = NSTextAlignmentCenter;
    self.billTitleLab.font = [UIFont gs_fontNum:12];
    [view addSubview:self.billTitleLab];
    [self.billTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.bottom.equalTo(view).offset(ChangedHeight(- 5));
        make.height.equalTo(view).multipliedBy(0.4);
    }];
    
    self.billTitleLab.text = @"2017年06月（6.1-6.30）";
    return view;
}

/**
 创建资产的三个lab

 @return 返回资产view
 */
- (UIView *)ziChanView{
    if (!_ziChanView) {
        _ziChanView = [UIView new];
        self.shouYiLab = [UILabel new];
        [_ziChanView addSubview:self.shouYiLab];
        [self.shouYiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_ziChanView);
        }];
        self.huiKuanLab = [UILabel new];
        [_ziChanView addSubview:self.huiKuanLab];
        [self.huiKuanLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_ziChanView);
            make.left.equalTo(self.shouYiLab.mas_right);
            make.width.equalTo(self.shouYiLab);
        }];
        self.YuELab = [UILabel new];
        [_ziChanView addSubview:self.YuELab];
        [self.YuELab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_ziChanView);
            make.left.equalTo(self.huiKuanLab.mas_right);
            make.width.equalTo(self.shouYiLab);
        }];
        self.YuELab.numberOfLines = self.huiKuanLab.numberOfLines = self.shouYiLab.numberOfLines = 0;
    }
    return _ziChanView;
}

/**
 创建收益的三个lab

 @return 返回收益view
 */
- (UIView *)ShouYiView{
    if (!_ShouYiView) {
        _ShouYiView = [UIView new];
        self.zhiTouLab = [UILabel new];
        [_ShouYiView addSubview:self.zhiTouLab];
        [self.zhiTouLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_ShouYiView);
        }];
        self.zhaiZhuanLab = [UILabel new];
        [_ShouYiView addSubview:self.zhaiZhuanLab];
        [self.zhaiZhuanLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_ShouYiView);
            make.left.equalTo(self.zhiTouLab.mas_right);
            make.width.equalTo(self.zhiTouLab);
        }];
        self.yueShouYiLab = [UILabel new];
        [_ShouYiView addSubview:self.yueShouYiLab];
        [self.yueShouYiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_ShouYiView);
            make.left.equalTo(self.zhaiZhuanLab.mas_right);
            make.width.equalTo(self.zhaiZhuanLab);
        }];
        
        self.yueShouYiLab.numberOfLines = self.zhaiZhuanLab.numberOfLines = self.zhiTouLab.numberOfLines = 0;
    }
    return  _ShouYiView;
}
//- (SHLineGraphView *)lineView{
//    if (!_lineView) {
//        _lineView = [SHLineGraphView new];
//        NSDictionary *_themeAttributes = @{
//                                           kXAxisLabelColorKey : [UIColor redColor],
//                                           kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:9],
//                                           kYAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
//                                           kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
//                                           kYAxisLabelSideMarginsKey : @0,
//                                           kPlotBackgroundLineColorKye : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4]
//                                           };
//        _lineView.themeAttributes = _themeAttributes;
//        
//       
//        _lineView.yAxisRange = @(98);
//        
//        
//        _lineView.yAxisSuffix = @"K";
//        
//       
//        _lineView.xAxisValues = @[@"JAN", @"FEB", @"MAR", @"APR", @"MAY", @"JUN", @"JUL", @"AUG", @"SEP", @"OCT", @"NOV", @"DEC"
//                                   ];
//        
//        SHPlot *_plot1 = [[SHPlot alloc] init];
//        
//       
//        _plot1.plottingValues = @[@20,@0,@30,@0,@40,@0,@50,@0,@60,@0,@70,@80,@0,@70,@80];
//        
//        NSDictionary *_plotThemeAttributes = @{
//                                               kPlotFillColorKey : [UIColor clearColor],
//                                               kPlotStrokeWidthKey : @1,
//                                               kPlotStrokeColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
//                                               kPlotPointFillColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
//                                               kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
//                                               };
//        
//        _plot1.plotThemeAttributes = _plotThemeAttributes;
//        [_lineView addPlot:_plot1];
//    }
//    return _lineView;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return ChangedHeight(50);
    }else{
        if (indexPath.row == 0) {
            return ChangedHeight(45);
        }else{
            switch (indexPath.section) {
                case 0:
                    return ChangedHeight(65);
                    break;
                case 1:
                    return ChangedHeight(245);
                    break;

                default:return ChangedHeight(140);
                    break;
            }
    }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bill"];
        cell.textLabel.textColor = [UIColor getOrangeColor];
        cell.textLabel.font = [UIFont gs_fontNum:13];
        cell.textLabel.text = @"本期交易明细";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if(indexPath.row == 0){
        TongJiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tongji"];
        cell.titleLab.font = [UIFont gs_fontNum:13];
        switch (indexPath.section) {
            case 0:
                cell.titleLab.text = @"账户资产信息";
                break;
            case 1:
                cell.titleLab.text = @"收益走势";
                break;
                
            default:cell.titleLab.text = @"8月回款计划";
                break;
        }
        return cell;
    }else{
        return [self setContentCell:indexPath];
    }
    
}

- (UITableViewCell *)setContentCell:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.myTab dequeueReusableCellWithIdentifier:@"conten"];
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.ziChanView];
        [self.ziChanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }else if (indexPath.section == 1){
//        [cell.contentView addSubview:self.lineView];
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.equalTo(cell.contentView).offset(ChangedHeight(15));
//            make.right.equalTo(cell.contentView).offset(ChangedHeight(- 15));
//            make.height.mas_equalTo(ChangedHeight(170));
//        }];
//        
//        [cell.contentView addSubview:self.ShouYiView];
//        [self.ShouYiView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(cell.contentView);
//            make.top.equalTo(self.lineView.mas_bottom).offset(ChangedHeight(5));
//        }];
        
    }else{
        
    }
    return cell;
}

/**
 画图
 */
- (void)drawLines{
    self.shouYiLab.attributedText = [self setAttributedString:@"本月收益" money:@"0.00"];
    self.huiKuanLab.attributedText = [self setAttributedString:@"本月回款" money:@"0.00"];
    self.YuELab.attributedText = [self setAttributedString:@"账户余额" money:@"0.00"];
    self.zhiTouLab.attributedText = [self setAttributedString:@"直投收益" money:@"0.00"];
    self.zhaiZhuanLab.attributedText = [self setAttributedString:@"债转收益" money:@"0.00"];
    self.yueShouYiLab.attributedText = [self setAttributedString:@"余额收益" money:@"0.00"];
//    [_lineView setupBaseView];
//    [_lineView setupTheView];
}

- (NSMutableAttributedString *)setAttributedString:(NSString *)tip money:(NSString *)money{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = ChangedHeight(5);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",money,tip]];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor getOrangeColor] range:[attr.string rangeOfString:money]];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:11] range:[attr.string rangeOfString:money]];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:13] range:[attr.string rangeOfString:tip]];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor titleColor] range:[attr.string rangeOfString:tip]];
    [attr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attr.string.length)];
    return attr;
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
