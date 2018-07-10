//
//  ChuJieXiangQingVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/10.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ChuJieXiangQingVc.h"
#import "SectionHeadValue1View.h"
#import "ChuJieXiangMuCell.h"
#import "RedBagCell.h"
#import "UIImage+Comment.h"
#import "MBProgressHUD+NetWork.h"
#import <YYKit.h>
#import "NSMutableAttributedString+contentText.h"
#import "NoMoreDataView.h"
#import "TitleBarView.h"
#import "BorrowModel.h"
#import "RedBagAleartView.h"
#import "UseableRedbagModel.h"
#import "JiaoYiMoneyView.h"
//#import <WebKit/WebKit.h>
//#import "OSCPhotoGroupView.h"


@interface ChuJieXiangQingVc ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UIScrollView *webScroll;
    CGFloat interest_rate;
    UIButton *btn;
}

@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *contenView;//出借的金额收益等内容
@property (nonatomic, assign) CGFloat moneyNum;//金钱
@property (nonatomic, strong) UITextField *moneytext;//出借的金钱lab
@property (nonatomic, strong) UILabel *shouyiLab;//收益lab
@property (nonatomic, strong) UILabel *remainMoneyLab;//剩余lab
@property (nonatomic, strong) UIButton *totolSelectBtn;//全投的btn

@property (nonatomic, strong) NSArray *redbagArr;//红包
@property (nonatomic, assign) NSInteger redIndex;//所选红包在数组的位置
@property (nonatomic, assign) BOOL resetRedCell;//重置红包cell
@property (nonatomic, assign) BOOL hasVerifiered;//定向标验证以后
//@property (nonatomic, assign) BOOL hasCheckPassword;//重置红包cell
@property (nonatomic, strong) JiaoYiMoneyView *jiaoyiAlert;
@property (nonatomic, copy) NSString *password;//所输入支付密码

@property (nonatomic, strong) TitleBarView *H5TitleView;//H5的title
@property (nonatomic, strong) UIWebView *web;;//H5的页面
@property (nonatomic, strong) UIView *webBGView;;//H5的底部页面
@property (nonatomic, strong) NSMutableDictionary *H5Dic;//H5存放的字典
@property (nonatomic, assign) BOOL hasLoadContent;//H5已经加载

@property (nonatomic, strong) ListModel *borrowModel;;//model
@end
@implementation ChuJieXiangQingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.redIndex = -1;
    self.title = @"出借详情";
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor infosBackViewColor];
    
    self.scroll = [[UIScrollView alloc]init];
    self.scroll.scrollEnabled = NO;
    self.scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scroll];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, ChangedHeight(70), 0));
    }];
    
    UIView *tabBGview = [UIView new];
    [self.scroll addSubview:tabBGview];
    [tabBGview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.scroll);
        make.height.equalTo(self.view).offset(ChangedHeight(- 70) -StatusBarHeight - 44);
        make.width.equalTo(self.view);
    }];
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    [self.myTab registerClass:[ChuJieXiangMuCell class] forCellReuseIdentifier:@"ChuJieXiangMuCell"];
    [self.myTab registerClass:[RedBagCell class] forCellReuseIdentifier:@"RedBagCell"];
    [self.myTab registerClass:[SectionHeadValue1View class] forHeaderFooterViewReuseIdentifier:@"SectionHead"];
    [tabBGview addSubview:self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tabBGview);
    }];
    
    NoMoreDataView *footerView = [NoMoreDataView new];
    [footerView setTipText:@"上拉查看详情"];
    self.myTab.tableFooterView = footerView;
    
    
    //下部分的助手
    UIView *helpView = [UIView new];
    [self.scroll addSubview:helpView];
    [helpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scroll);
        make.height.equalTo(self.view).offset(ChangedHeight(- 70) );
        make.width.equalTo(self.view);
        make.top.equalTo(tabBGview.mas_bottom);
    }];
    webScroll = [[UIScrollView alloc]init];
    webScroll.delegate = self;
    webScroll.scrollEnabled = NO;
    webScroll.backgroundColor = [UIColor infosBackViewColor];
    [helpView addSubview:webScroll];
    [webScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(helpView).insets(UIEdgeInsetsMake(StatusBarHeight + 44, 0, 0, 0));
    }];
    _webBGView = [UIView new];
    [webScroll addSubview:_webBGView];
    [_webBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(webScroll);
        make.height.equalTo(helpView).offset(-StatusBarHeight - 44);
        make.width.equalTo(self.view).multipliedBy(4.0);
    }];
    
    self.H5TitleView = [[TitleBarView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 44, K_WIDTH, ChangedHeight(40))];

    [helpView addSubview:self.H5TitleView];
    [self.H5TitleView reloadAllButtonsOfTitleBarWithTitles:@[@"项目信息",@"相关资料",@"出借记录",@"还款记录"]];
    self.H5TitleView.currentCollor = [UIColor getOrangeColor];
    __weak typeof(self) weakMine = self;
    self.H5TitleView.titleButtonClicked = ^(NSUInteger index) {
        [weakMine setContentViewAtindex:index];
    };

    self.H5Dic = [[NSMutableDictionary alloc]init];
    
    [self setContentViewAtindex:0];
    
//    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    //设置下边的按钮
    btn = [UIButton new];
    [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"出借" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont gs_fontNum:15];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor getOrangeColor];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(- 35));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(ChangedHeight(-25));
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    
    self.jiaoyiAlert = [[JiaoYiMoneyView alloc]init];
    
    __weak typeof(self) weakSelf = self;
    self.jiaoyiAlert.inputPassEndBlock = ^(NSString *password) {
        [weakSelf.jiaoyiAlert hidenAlertType];
        weakSelf.password = password;
        [weakSelf borrowMoneyToUs];
    };
    
//    [self selectedAllMoney:self.totolSelectBtn];
}


#pragma mark - web设置（最好是用一个web，但是前端给了四个没办法才这样）
/**
 设置4个h5

 @param index 顺讯
 */
- (void)setContentViewAtindex:(NSInteger)index{
    [webScroll setContentOffset:CGPointMake(K_WIDTH * index, 0)];
    if (self.H5Dic[[NSString stringWithFormat:@"%@",@(index)]]) {
        return;
    }
    
    UIWebView *webview = [[UIWebView alloc]init];
    webview.scrollView.delegate = self;
//    webview.navigationDelegate = self;
//    webview.UIDelegate = self;
//    webview.userInteractionEnabled = NO;
    webview.tag = index;
    [webScroll addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_webBGView);
        make.top.equalTo(self.H5TitleView.mas_bottom);
        make.width.equalTo(self.view);
        if (index == 3) {
            make.right.equalTo(_webBGView);
        }else{
            make.left.equalTo(_webBGView).offset(K_WIDTH * index);
        }
       
    }];
    

    [self.H5Dic setValue:webview forKey:[NSString stringWithFormat:@"%@",@(index)]];
    
    if (!self.borrowModel) {
        return ;
    }
    switch (index) {
        case 0:{
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.borrow_info]]];
        }
            
            break;
        case 1:
        {
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.file_info]]];
        }
            break;
        case 2:
        {
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.borrow_log]]];
        }
            break;
            
        default:{
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.investor_log]]];
        }
            break;
    }
    
    
}
- (void)setUIAndText{
//    CGFloat interest_rate = 0;
    if ([self.borrowModel.duration_unit containsString:@"天"]) {
        interest_rate = ([self.borrowModel.borrow_interest_rate doubleValue] + [self.borrowModel.reward doubleValue])/100/365 * [self.borrowModel.borrow_duration integerValue];
    }else{
        interest_rate = ([self.borrowModel.borrow_interest_rate doubleValue] + [self.borrowModel.reward doubleValue])/100/12 * [self.borrowModel.borrow_duration integerValue];
    }

    
    if (self.contenView) {
//        self.moneytext.text = self.borrowModel.borrow_min;
//        self.moneyNum = [self.borrowModel.borrow_min doubleValue];
        [self selectedAllMoney:self.totolSelectBtn];
        self.shouyiLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"预期收益：%.2f元",self.moneyNum * interest_rate] Font:[UIFont gs_fontNum:18] Color:[UIColor getOrangeColor] grayText:[NSString stringWithFormat:@"%.2f",self.moneyNum * interest_rate] TextAligment:NSTextAlignmentCenter LineSpace:1.f];
        NSString *moneyStr = [UserManager shareManager].money?[UserManager shareManager].money.active_balance:@"0.00";
        self.remainMoneyLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"账户余额：%@元",moneyStr] Font:[UIFont gs_fontNum:18] Color:[UIColor getOrangeColor] grayText:moneyStr TextAligment:NSTextAlignmentCenter LineSpace:1.f];
    }
    if ([[UserManager shareManager].money.active_balance doubleValue] < _moneyNum) {
        [btn setTitle:@"余额不足，请充值" forState:UIControlStateNormal];
    }else
        [btn setTitle:@"出借" forState:UIControlStateNormal];
    if ([self.borrowModel.progress floatValue]/100 == 1) {
        [btn setTitle:@"已满标" forState:UIControlStateNormal];
        btn.enabled = NO;
        self.moneytext.enabled = NO;
        self.totolSelectBtn.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UserManager shareManager] loadMewModel:^(BOOL succ) {
        
    }];
    [self loadBorrowData];
}
/**
 出借详情的金额预期收入等

 @return contenView
 */
- (UIView *)contenView{
    if (!_contenView) {
        _contenView = [UIView new];
        UILabel *tipLab = [UILabel new];
        tipLab.text = @"出借金额（元）";
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.font = [UIFont gs_fontNum:12];
        tipLab.textColor = [UIColor newSecondTextColor];
        [_contenView addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contenView);
            make.top.equalTo(_contenView).offset(ChangedHeight(15));
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor newSeparatorColor];
        [_contenView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_contenView);
            make.width.mas_equalTo(ChangedHeight(80));
            make.top.equalTo(_contenView).offset(ChangedHeight(63));
            make.height.mas_equalTo(ChangedHeight(1));
        }];
//        KeyBordToolView *toolView = [KeyBordToolView shareManager];
//        toolView.DoneBlock = ^{
//            [self.view endEditing:YES];
//        };
        self.moneytext = [UITextField new];
//        self.moneytext.inputAccessoryView = toolView;
        self.moneytext.textColor = [UIColor getOrangeColor];
        self.moneytext.delegate = self;
        self.moneytext.keyboardType = UIKeyboardTypeNumberPad;
        self.moneytext.textAlignment = NSTextAlignmentCenter;
        self.moneytext.font = [UIFont gs_fontNum:18 weight:UIFontWeightBold];
        [_contenView addSubview:self.moneytext];
        [self.moneytext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(line);
            make.bottom.equalTo(line);
            make.height.mas_equalTo(ChangedHeight(35));
        }];
        
        UIButton *reduceBtn = [UIButton new];
        [reduceBtn setImage:[UIImage imageNamed:@"-"] forState:UIControlStateNormal];
        [reduceBtn addTarget:self action:@selector(reduceMoney:) forControlEvents:UIControlEventTouchUpInside];
        [_contenView addSubview:reduceBtn];
        [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.moneytext);
            make.right.equalTo(line.mas_left);
            make.width.height.mas_equalTo(ChangedHeight(35));
        }];
        
        UIButton *addBtn = [UIButton new];
        [addBtn setImage:[UIImage imageNamed:@"+"]  forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addMoney:) forControlEvents:UIControlEventTouchUpInside];
        [_contenView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.moneytext);
            make.left.equalTo(line.mas_right);
            make.width.height.mas_equalTo(ChangedHeight(35));
        }];
        
        
        self.shouyiLab = [UILabel new];
        self.shouyiLab.textColor = [UIColor newSecondTextColor];
        self.shouyiLab.textAlignment = NSTextAlignmentCenter;
        self.shouyiLab.font = [UIFont gs_fontNum:12];
        [_contenView addSubview:self.shouyiLab];
        [self.shouyiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contenView);
            make.top.equalTo(line.mas_bottom).offset(ChangedHeight(15));
        }];
        
        self.remainMoneyLab = [UILabel new];
        self.remainMoneyLab.textColor = [UIColor newSecondTextColor];
        self.remainMoneyLab.textAlignment = NSTextAlignmentCenter;
        self.remainMoneyLab.font = [UIFont gs_fontNum:12];
        [_contenView addSubview:self.remainMoneyLab];
        [self.remainMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contenView).offset(ChangedHeight(10));
            make.bottom.equalTo(_contenView);
            make.height.mas_equalTo(ChangedHeight(35));
        }];
        
        self.totolSelectBtn = [UIButton new];
        [self.totolSelectBtn addTarget:self action:@selector(selectedAllMoney:) forControlEvents:UIControlEventTouchUpInside];
        

        [self.totolSelectBtn setImage:[UIImage imageNamed:@"全投选中状态"] forState:UIControlStateSelected];
        [self.totolSelectBtn setImage:[UIImage imageNamed:@"通知管理"] forState:UIControlStateNormal];
        
        [_contenView addSubview:self.totolSelectBtn];
        [self.totolSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.remainMoneyLab);
            make.right.equalTo(_contenView);
            make.width.equalTo(self.totolSelectBtn.mas_height);
        }];
        
        UILabel *toLab = [UILabel new];
        toLab.textColor = [UIColor newSecondTextColor];
        toLab.font = [UIFont gs_fontNum:12];
        toLab.text = @"全投";
        [_contenView addSubview:toLab];
        [toLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.totolSelectBtn);
            make.right.equalTo(self.totolSelectBtn.mas_left);
        }];
        
        UIView *hengLine = [UIView new];
        hengLine.backgroundColor = [UIColor newSeparatorColor];
        [_contenView addSubview:hengLine];
        [hengLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contenView);
            make.top.equalTo(self.remainMoneyLab).offset(ChangedHeight(- 1));
            make.height.mas_equalTo(1);
        }];
    }
    return _contenView;
}



#pragma mark - scroll代理，来处理拖动手势

/**
 scroll的代理 用来处理拖动

 @param scrollView scroll
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.myTab]) {
//滑动表的时候
        CGFloat offsetY = CGRectGetMaxY(self. myTab.bounds);
        if (offsetY - 70 > self.myTab.contentSize.height) {
            [UIView animateWithDuration:1.f animations:^{
                [self.scroll setContentOffset:CGPointMake(0, K_HEIGHT -StatusBarHeight - 44 - ChangedHeight(70))];
            }];
            
            if (!self.hasLoadContent) {
                self.hasLoadContent = YES;
                UIWebView *web = self.H5Dic[@"0"];
                [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.borrow_info]]];
            }
        }
    }else{
        //滑动web时候
        if (scrollView.contentOffset.y < -100) {
            [UIView animateWithDuration:1.f animations:^{
                [self.scroll setContentOffset:CGPointMake(0, -StatusBarHeight - 44)];
            }];
        }
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:webScroll]) {
        NSInteger idex = (NSInteger)scrollView.contentOffset.x/K_WIDTH;
        [self.H5TitleView scrollToCenterWithIndex:idex];
        [self setContentViewAtindex:idex];
    }
}




#pragma mark — tabview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return ChangedHeight(150);
            break;
        case 1:
            return ChangedHeight(150);
            break;
        default:{
            if (self.redbagArr && self.redbagArr.count) {
                return ChangedHeight(100);
            }else
                return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ChuJieXiangMuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChuJieXiangMuCell"];
        [cell setContenView:self.borrowModel];
        return cell;
    }else if (indexPath.section == 2){
        RedBagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagCell"];

        __weak typeof(self) weakSelf = self;
        cell.redBagSlectedBlock = ^(NSInteger index) {
            weakSelf.redIndex = index;
        };
        if (self.redbagArr) {
            if (self.resetRedCell) {
                [cell setContenView:self.redbagArr click:YES];
                self.resetRedCell = NO;
            }
        }
        
        return  cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectionCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView addSubview:self.contenView];
        [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        if (section == 2) {
            return ChangedHeight(25);
        }
        return ChangedHeight(5);
    }
    return ChangedHeight(35);
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    if (section == 2) {
        if (!self.redbagArr || self.redbagArr.count == 0) {
            return ChangedHeight(50);
        }else{
            return ChangedHeight(15);
        }
    }
    return ChangedHeight(4);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *view = [UIView new];
        if (section == 2) {
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [UILabel new];
            lab.text = self.redbagArr && self.redbagArr.count?@"可用红包":@"暂无可用红包";
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, ChangedHeight(10), 0, 0));
            }];
            UILabel *tipLab = [UILabel new];
            tipLab.text = self.redbagArr && self.redbagArr.count?@"温馨提示：勾选后才可以使用哦":@"";
            tipLab.font = [UIFont gs_fontNum:13];
            tipLab.textColor = [UIColor getOrangeColor];
            tipLab.textAlignment = NSTextAlignmentRight;
            [view addSubview:tipLab];
            [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).offset(ChangedHeight(- 10));
                make.centerY.equalTo(lab);
            }];
        }
        return view;
    }
    SectionHeadValue1View *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionHead"];
    [headView setcontentView:self.borrowModel];    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 2) {
        view.backgroundColor = [UIColor whiteColor];
        if (!self.redbagArr || self.redbagArr.count == 0) {
            
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NoQuanUse"]];
            [view addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(view.mas_centerX).offset(-15);
            }];
            
            UILabel *lab = [UILabel new];
            lab.text = @"暂无可用红包";
            lab.textColor = [UIColor tipTextColor];
            lab.font = [UIFont gs_fontNum:15];
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(img.mas_right).offset(ChangedHeight(5));
                make.centerY.equalTo(img);
            }];
        }else{
            UILabel *lab = [UILabel new];
            lab.textColor = [UIColor tipTextColor];
            lab.font = [UIFont gs_fontNum:9];
            lab.text = @"温馨提示：每次只能使用一个红包";
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, ChangedHeight(10), 0, 0));
            }];
        }
    }
    
    
    return view;
}
#pragma mark- 金钱变动
/**
 减

 @param sender 100
 */
- (void)reduceMoney:(UIButton *)sender{
    if ([self.borrowModel.progress floatValue]/100 == 1) {
        return;
    }
    if (self.moneyNum > 100) {
        self.moneyNum -= 100;
    }
    
}

/**
 加

 @param sender 100
 */
- (void)addMoney:(UIButton *)sender{
    if ([self.borrowModel.progress floatValue]/100 == 1) {
        return;
    }
    CGFloat restMoney = [self.borrowModel.borrow_max floatValue] > [self.borrowModel.rest_borrow_money floatValue] ? [self.borrowModel.rest_borrow_money floatValue]: [self.borrowModel.borrow_max floatValue];
    
    if ([self.borrowModel.borrow_max floatValue] == 0){
        if (_moneyNum +100> [self.borrowModel.rest_borrow_money floatValue]) {
            [MBProgressHUD showError:@"出借金额不得大于最大出借或剩余金额"];
            return;
        }
    }else{
        if (_moneyNum + 100> restMoney) {
            [MBProgressHUD showError:@"出借金额不得大于最大出借或剩余金额"];
            return;
        }
    }
    
    if (self.moneyNum  + 100 > [[UserManager shareManager].money.active_balance doubleValue]) {
        return;
    }
    self.moneyNum += 100;

}

- (void)setMoneyNum:(CGFloat)moneyNum{
    _moneyNum = moneyNum;
    if (moneyNum < [self MaxToPayManoy]) {
        self.totolSelectBtn.selected = NO;
    }
    if (_moneyNum < 100) {
        _moneyNum = 100;
    }
    self.moneytext.text = [NSString stringWithFormat:@"%.f",_moneyNum];
    self.shouyiLab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"预期收益：%.2f元",_moneyNum * interest_rate] Font:[UIFont gs_fontNum:18] Color:[UIColor getOrangeColor] grayText:[NSString stringWithFormat:@"%.2f",_moneyNum * interest_rate] TextAligment:NSTextAlignmentCenter LineSpace:1.f];
    if ([self.borrowModel.progress floatValue]/100 == 1) {
        [btn setTitle:@"已满标" forState:UIControlStateNormal];
    }else{
        if ([[UserManager shareManager].money.active_balance doubleValue] < _moneyNum) {
            [btn setTitle:@"余额不足，请充值" forState:UIControlStateNormal];
        }else
            [btn setTitle:@"出借" forState:UIControlStateNormal];
        [self loadRedBagListData];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return [self canUseMoney];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if(textField.text.length){
        long long money = [textField.text longLongValue];
        if (money%100) {
            [MBProgressHUD showError:@"请输入100的整数倍"];
            textField.text = [NSString stringWithFormat:@"%.f",self.moneyNum];
        }else{
            if ([self.borrowModel.borrow_max floatValue] == 0) {
                if (money > [self.borrowModel.rest_borrow_money floatValue]){
                    [MBProgressHUD showError:@"输入的金额大于最大剩余额度"];
                    textField.text = [NSString stringWithFormat:@"%.f",self.moneyNum];
                }else
                    self.moneyNum = money;
            }else{
                if (money > [self.borrowModel.borrow_max floatValue]) {
                    [MBProgressHUD showError:@"输入的金额大于最大出借额度"];
                    textField.text = [NSString stringWithFormat:@"%.f",self.moneyNum];
                }else if (money > [self.borrowModel.rest_borrow_money floatValue]){
                    [MBProgressHUD showError:@"输入的金额大于最大剩余额度"];
                    textField.text = [NSString stringWithFormat:@"%.f",self.moneyNum];
                }else
                    self.moneyNum = money;
            }
            
        }
    }else
        self.moneyNum = [self.borrowModel.borrow_min doubleValue];
    return YES;
}
#pragma mark - 全选金额
- (void)selectedAllMoney:(UIButton *)sender{
    if (![UserManager shareManager].user) {
        self.moneyNum = [self MaxToPayManoy];
        return;
    }
    sender.selected = !sender.selected;
    if (!sender.selected) {
        return;
    }
    self.moneyNum = [self MaxToPayManoy];
    
}

- (CGFloat)MaxToPayManoy{
    CGFloat moneyNum = [[UserManager shareManager].money.active_balance doubleValue] - [[UserManager shareManager].money.active_balance integerValue]%100;
    
    if ([self.borrowModel.borrow_max floatValue] == 0) {
        if (moneyNum > [self.borrowModel.rest_borrow_money floatValue]) {
            return  [self.borrowModel.rest_borrow_money floatValue] - (long)[self.borrowModel.rest_borrow_money floatValue]%100;
        }else
            return  (long)moneyNum - (long)moneyNum%100;
    }else{
        
        CGFloat restMoney = [self.borrowModel.borrow_max floatValue] > [self.borrowModel.rest_borrow_money floatValue] ? [self.borrowModel.rest_borrow_money floatValue]: [self.borrowModel.borrow_max floatValue];
        if (moneyNum > restMoney) {
            return  (long)restMoney - (long)restMoney%100;
        }else
            return  (long)moneyNum - (long)moneyNum%100;
    }
}
#pragma mark- 出借金额的数据处理
/**
 出借
 */
- (void)logout:(UIButton *)sender{
    
    if (![UserManager shareManager].user) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未登录账号，请先登录账户!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"先逛逛" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UIViewController *vc = [[NSClassFromString(@"LogingVc") alloc] init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [window.rootViewController presentViewController:nav animated:YES completion:nil];
            }]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        return;
    }
    
    if (![[UserManager shareManager] canExtractMoney]) {
        return;
    }
    
    if ([[UserManager shareManager].user.is_setpinpass integerValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未设置交易密码，请先设置交易密码！" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"先逛逛" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UIViewController *vc = [[NSClassFromString(@"ExchangePasswordVc") alloc] init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [window.rootViewController presentViewController:nav animated:YES completion:nil];
            }]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        return;
    }
    if (![[UserManager shareManager] hadRiskFengxian] || ![[UserManager shareManager] Risk_levelIsOk]) {
        return ;
    }
    if (![self canUseMoney]) {
        sender.selected = YES;
        return;
    }
    if (self.moneyNum < [self.borrowModel.borrow_min doubleValue]) {
        [MBProgressHUD showError:@"所输入金额少于最低投资金额"];
        return;
    }
    if ([self.borrowModel.borrow_max floatValue] == 0) {
        if (self.moneyNum > [self.borrowModel.rest_borrow_money floatValue]) {
            [MBProgressHUD showError:@"所输入金额不得大于最大投资金额"];
            return;
        }
    }else{
        
        CGFloat restMoney = [self.borrowModel.borrow_max floatValue] > [self.borrowModel.rest_borrow_money floatValue] ? [self.borrowModel.rest_borrow_money floatValue]: [self.borrowModel.borrow_max floatValue];
        if (self.moneyNum > restMoney) {
            [MBProgressHUD showError:@"所输入金额不得大于最大投资或剩余金额"];
            return;
        }
    }
    UserMoneyModel *moneyModel = [UserManager shareManager].money;
    if ([moneyModel.active_balance doubleValue] < self.moneyNum) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"余额少于所输入的投资金额，是否要进行充值" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIViewController *vc = [[NSClassFromString(@"RechargeVc") alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        });
        return;
    }
    
    if (((NSInteger)self.moneyNum)%100) {
        [MBProgressHUD showError:@"所输入金额必须是100的整倍数"];
        return;
    }
    self.jiaoyiAlert.titleStr = @"请输入交易密码";
    self.jiaoyiAlert.moneyStr = [NSString stringWithFormat:@"%.f元",self.moneyNum];
    
    [self.jiaoyiAlert showAlertType];
    
  
}
/**
 定向标验证的
 
 @return 能否出借
 */
- (BOOL)canUseMoney{
    if (Nilstr2Space(self.borrowModel.password).length) {
        if (self.hasVerifiered) {
            return YES;
        }
        NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[UserManager shareManager].userId];
        if (arr && [arr containsObject:self.borrow_id]) {
            return YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"定向标密码" message:@"该标为定向标，需输入该定向标密码后才可投资" preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.textAlignment = NSTextAlignmentCenter;
                textField.placeholder = @"请输入定向标密码";
            }];
            //            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *textf = alert.textFields.firstObject;
                if (textf.text.length) {
                    [self dingxiangbiaoPasswordCheck:textf.text];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        return NO;
    }
    return YES;
}
- (void)dingxiangbiaoPasswordCheck:(NSString *)pssword{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@borrow/verifypwd",postUrl]
              withParameters:@{
                               @"borrow_id":self.borrow_id ,//标id    string
                               @"password": pssword ,//密码    string
                               @"token": [UserManager shareManager].userId   //令牌    string
                               }
                     ShowHUD:YES
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         if ([responseObject[@"status"] integerValue] == 200) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 self.hasVerifiered = YES;
                                 if ([[NSUserDefaults standardUserDefaults] objectForKey:[UserManager shareManager].userId]) {
                                     NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[UserManager shareManager].userId];
                                     NSMutableArray *listrr = [NSMutableArray arrayWithArray:arr];
                                     [listrr addObject:self.borrow_id];
                                     [[NSUserDefaults standardUserDefaults] setObject:listrr forKey:[UserManager shareManager].userId];
                                 }else{
                                     [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithObject:self.borrow_id] forKey:[UserManager shareManager].userId];
                                 }
                                 
                                 if (btn.selected) {
                                     [self logout:btn];
                                 }else{
                                     [self.moneytext becomeFirstResponder];
                                 }
                             });
                         }
                         
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.navigationController popViewControllerAnimated:YES];
                         });
                     }];
}
/**
 出借验证交易密码
 */
- (void)borrowMoneyToUs{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/verifytradepwd",postUrl]
  withParameters:@{
                   @"trade_pwd":self.password,//	支付密码	string
                   @"token":[UserManager shareManager].userId//	用户id	string
                   }
         ShowHUD:YES
         success:^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject[@"status"] integerValue] == 200) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self passwordRightAndBorrowMoney];
                     
                 });
                 
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
         }];
}

- (void)passwordRightAndBorrowMoney{
    UseableRedbagModel *model ;
    if (self.redIndex >= 0) {
        model = self.redbagArr[self.redIndex];
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/invest",postUrl]
      withParameters:@{
                       @"borrow_id":self.borrow_id,//	项目id	number
                       @"coupon_id":model?model.id:@"",//	红包id	number	(可选)
                       @"invest_money":[NSString stringWithFormat:@"%.f",self.moneyNum],//	投资金额	number
                       @"token":[UserManager shareManager].userId//	用户id	number
                       }
             ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UserMoneyModel *moneyModel = [UserManager shareManager].money;
                         moneyModel.active_balance = [NSString stringWithFormat:@"%.2f",[moneyModel.active_balance doubleValue] - self.moneyNum];
                         if (model) {
                             moneyModel.active_balance = [NSString stringWithFormat:@"%.2f",[moneyModel.active_balance doubleValue] + [model.money doubleValue]];
                         }
                         [[UserManager shareManager] saveUserMoney:moneyModel];
                         
                         
                         self.borrowModel.rest_borrow_money = [NSString stringWithFormat:@"%.2f",[self.borrowModel.rest_borrow_money doubleValue] - self.moneyNum];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RefreshUser];//刷用户
                         
                         [self setUIAndText];//重新设置
                         if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                             RedBagAleartView *alertView = [[RedBagAleartView alloc]init];
                             alertView.redBagType = RedBagUsedNow;
                             NSString *money = responseObject[@"data"][@"reward_money"];
                             NSString *rateNum = responseObject[@"data"][@"add_rate_num"];
                             if ([Nilstr2Zero(money) integerValue]) {
                                 money = [money stringByAppendingString:@"元红包"];
                             }else
                                 money = @"";
                             if ([Nilstr2Zero(rateNum) integerValue]) {
                                 rateNum = [rateNum stringByAppendingString:@"张加息券"];
                             }else
                                 rateNum = @"";
                             [alertView aleartWithTip:[NSString stringWithFormat:@"%@%@",money,rateNum] Message:[NSString stringWithFormat:@"恭喜您获得%@\n奖励",responseObject[@"data"][@"reward_name"]] Thanks:@"感谢你对金陵贷的支持～" Cancel:nil Confirm:@"立即使用"];
                             [alertView showAlertType];
                             alertView.confirmBtnBlock = ^{
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                             };
                         }else{
                             [MBProgressHUD showSuccess:@"恭喜您已投资成功"];
                         }
                         
                     });
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
             }];
}
/**
 获取出借详情
 */
- (void)loadBorrowData{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@borrow/detailinfo",postUrl]
      withParameters:@{
                       @"borrow_id":self.borrow_id
                       }
     ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.borrowModel = [ListModel modelWithJSON:responseObject[@"data"]];
                         
                         [self setUIAndText];
                         [self.myTab reloadData];
                     });
                     
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
             }];
    
    
}

/**
 获取可用红包
 */
- (void)loadRedBagListData{
    if (![UserManager shareManager].user) {
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@reward/activelists",postUrl]
              withParameters:@{
                               @"invest_id":self.borrow_id,
                               @"invest_money":[NSString stringWithFormat:@"%.f",self.moneyNum],//	投资金额	number
                               @"token":[UserManager shareManager].userId	//用户id	number
                               }
                     ShowHUD:NO
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         if ([responseObject[@"status"] integerValue] == 200) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 self.redbagArr = [NSArray  modelArrayWithClass:[UseableRedbagModel class] json:responseObject[@"data"]];
//                                 if (self.redbagArr.count) {
                                     self.resetRedCell = YES;
//                                 }
                                 self.redIndex = self.redbagArr.count - 1;
                                 [self.myTab reloadData];
                             });
                             
                         }
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
