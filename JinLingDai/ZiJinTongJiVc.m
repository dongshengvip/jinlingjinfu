//
//  ZiJinTongJiVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/6.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ZiJinTongJiVc.h"
#import "JLRingChart.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#import "TongJiCell.h"
#import "ThreeAttrLabInTongJiCell.h"
#import <YYKit.h>
#import "XiangMuZiChanCell.h"
#import "ASPickerView.h"
#import "NSMutableAttributedString+contentText.h"
#import "UIImage+Comment.h"

#import "NSTextAttachment+Util.h"
#import "NSString+formatFloat.h"
#import <objc/runtime.h>

#import "JHRingChart.h"
#import "JHChart.h"


@interface ZiJinTongJiVc () <UITableViewDelegate,UITableViewDataSource,ASPickerViewDelegate>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UIView *monthBillView;
@property (nonatomic, strong) JLRingChart *circelView;

@property (nonatomic, strong) UIView *TitleBgView;//圆环的部分
@property (nonatomic, strong) UITextView *waitBenJinLab;
@property (nonatomic, strong) UITextView *waitShouYiLab;
@property (nonatomic, strong) UITextView *waitJiangLiLab;
@property (nonatomic, strong) UITextView *dongjieLab;
@property (nonatomic, strong) NSArray *getinArr;//项目收益列表
@property (nonatomic, strong) NSMutableArray *BaiFenBiArr;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) ASPickerView *pickerView;//选择权
@property (nonatomic, strong) NSMutableArray *getinNameArr;
@property (nonatomic, strong) JHRingChart *ringView;
@end

#define SectionTitle @[@"资金总览", @"账户资产信息", @"项目收益"]

//十个自带颜色
#define colorArr(R) @[kColor(204, 40, 44, R),kColor(242, 144, 75, R),kColor(255, 211, 57, R),kColor(112, 184, 71, R),kColor(0, 164, 171, R),kColor(0, 121, 176, R),kColor(49, 58, 134, R),kColor(139, 42, 125, R),kColor(228, 55, 117, R),kColor(45, 103, 51, R)]

@implementation ZiJinTongJiVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"资金统计";
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.separatorColor = [UIColor clearColor];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.sectionFooterHeight = ChangedHeight(0.01);
    self.myTab.rowHeight = ChangedHeight(46);
//    [self.myTab registerClass:[ThreeAttrLabInTongJiCell class] forCellReuseIdentifier:@"ThreeAttrLabInTongJiCell"];
    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"conten"];
    [self.myTab registerClass:[TongJiCell class] forCellReuseIdentifier:@"tongji"];
    [self.myTab registerClass:[XiangMuZiChanCell class] forCellReuseIdentifier:@"XiangMuZiChanCell"];
    
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadGetinvestorData];

    
    _ringView = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 0, K_WIDTH, ChangedHeight(180))];
    /*        background color         */
    _ringView.backgroundColor = [UIColor whiteColor];
    
    
    
//    _circelView = [[JLRingChart alloc]init];
////    _circelView.center = CGPointMake(200, 300);
//    //传入的显示数值，注意总和应等于100%
////    _circelView.valueDataArr = self.BaiFenBiArr;//必须有
//    //设置圆环的宽度
//    _circelView.ringWidth = 10;
//    //设置圆环的中间点显示角度
//    _circelView.angle = 0;
//    //间隔必须放画图前边
//    _circelView.hasSpace = NO;
//    //传入所需值后开始画图层
//    [_circelView startToDrawLayer];//必须有
//    [_circelView annomationMoveTo:3];

    self.pickerView = [[ASPickerView alloc]initWithParentViewController:self];
    self.pickerView.delegate = self;
    
    self.getinNameArr = [[NSMutableArray alloc] init];
}


- (UIView *)TitleBgView{
    if (!_TitleBgView) {
        _TitleBgView = [UIView new];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor newSeparatorColor];
        [_TitleBgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_TitleBgView).offset(ChangedHeight(10));
            make.top.right.equalTo(_TitleBgView);
            make.height.mas_equalTo(1);
        }];
        
//        self.waitBenJinLab
//        self.waitBenJinLab = [UILabel new];
//        self.waitBenJinLab.textColor = [UIColor titleColor];
        [_TitleBgView addSubview:self.waitBenJinLab];
        [self.waitBenJinLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_TitleBgView).offset(ChangedHeight(10));
            make.height.mas_equalTo(ChangedHeight(30));
            make.left.equalTo(_TitleBgView).offset(ChangedHeight(10));
            make.width.equalTo(_TitleBgView).dividedBy(2.0).offset(ChangedHeight(-15));
        }];
        [_TitleBgView addSubview:self.waitJiangLiLab];
        [self.waitJiangLiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.centerY.equalTo(self.waitBenJinLab);
            make.left.equalTo(_TitleBgView.mas_centerX).offset(ChangedHeight(10));
        }];
        [_TitleBgView addSubview:self.waitShouYiLab];
        [self.waitShouYiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.left.equalTo(self.waitBenJinLab);
            make.top.equalTo(self.waitBenJinLab.mas_bottom).offset(ChangedHeight(10));
        }];
        [_TitleBgView addSubview:self.dongjieLab];
        [self.dongjieLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.centerY.equalTo(self.waitShouYiLab);
            make.left.equalTo(self.waitJiangLiLab);
        }];
        [self setContenUiAndText];
    }
    
    return _TitleBgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            return ChangedHeight(40);
        }else
            return ChangedHeight(140);
    }else{
        if (indexPath.row == 0) {
            return ChangedHeight(65);
        }else
            return ChangedHeight(265);
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ChangedHeight(5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        TongJiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tongji"];
        cell.titleLab.text = SectionTitle[indexPath.section];
       
        [cell setMoney:indexPath.section==0?[UserManager shareManager].money.total_balance:@"" tip:indexPath.section==0?@"资金总额":@""];
        return cell;
    }else{
        if (indexPath.section == 1) {

            XiangMuZiChanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XiangMuZiChanCell"];
            if (self.getinArr.count) {
                [cell setContenView:self.getinArr[self.selectedIndex]];
            }
            __weak typeof(self) weakSelf = self;
            cell.changedXiangMuBlock = ^{

                if (weakSelf.getinArr.count) {
                    [weakSelf.pickerView setDataSource:weakSelf.getinNameArr selected:@(self.selectedIndex)];
                    [weakSelf.pickerView showPickerView];
                }
                
            };
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conten"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section == 0) {
                [cell.contentView addSubview:self.TitleBgView];
                
                [cell.contentView addSubview:_ringView];
//
                
                [_ringView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.width.equalTo(cell.contentView);
                    make.bottom.equalTo(cell.contentView).offset(ChangedHeight(- 5));
                    make.height.mas_equalTo(ChangedHeight(170));
                }];
                
                [self.TitleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(cell.contentView);
                    make.height.mas_equalTo(ChangedHeight(90));
                }];
                
                [_circelView reloadDatas];//必须有
            }
            return cell;
        }
        
    }
}

- (void)setContenUiAndText{
    UserMoneyModel *model = [UserManager shareManager].money;
    CGFloat active_balance = [model.active_balance doubleValue];
    CGFloat coming_captial = [model.coming_captial doubleValue];
    CGFloat coming_interest = [model.coming_interest doubleValue];
    CGFloat coming_freeze = [model.money_freeze doubleValue];
//    CGFloat active_balance = 0.25;
//    CGFloat coming_captial = 0.25;
//    CGFloat coming_interest = 0.25;
//    CGFloat coming_freeze = 0.25;
    CGFloat totalMoney = active_balance + coming_captial + coming_interest + coming_freeze;
    self.BaiFenBiArr = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"%f",coming_captial/totalMoney],[NSString stringWithFormat:@"%f",coming_interest/totalMoney],[NSString stringWithFormat:@"%f",coming_freeze/totalMoney],[NSString stringWithFormat:@"%f",active_balance/totalMoney]]];
    //传入的显示数值，注意总和应等于100%
    /*        Data source array, only the incoming value, the corresponding ratio will be automatically calculated         */
    _ringView.valueDataArr = self.BaiFenBiArr;
    /*         Width of ring graph        */
    _ringView.ringWidth = 35.0;
    /*        Fill color for each section of the ring diagram         */
    _ringView.fillColorArray = RING_COLOR_ARR(0.8);
    [_ringView showAnimation];
    
    self.waitBenJinLab.textAlignment = self.waitShouYiLab.textAlignment = self.waitJiangLiLab.textAlignment = NSTextAlignmentCenter;
    self.waitBenJinLab.attributedText = [self getAttr:[NSString stringWithFormat:@" 待收本金 ￥ %@元",[UserManager shareManager].money.coming_captial] grayColorText:[UserManager shareManager].money.coming_captial imageColor:RING_COLOR_ARR(1)[0]];
    self.waitShouYiLab.attributedText = [self getAttr:[NSString stringWithFormat:@" 待收利息 ￥ %@元",[UserManager shareManager].money.coming_interest] grayColorText:[UserManager shareManager].money.coming_interest imageColor:RING_COLOR_ARR(1)[1]];
    self.waitJiangLiLab.attributedText = [self getAttr:[NSString stringWithFormat:@" 账户余额 ￥ %@元",[UserManager shareManager].money.active_balance] grayColorText:[UserManager shareManager].money.active_balance imageColor:RING_COLOR_ARR(1)[3]];
    self.dongjieLab.attributedText = [self getAttr:[NSString stringWithFormat:@" 冻结金额 ￥ %@元",[UserManager shareManager].money.money_freeze] grayColorText:[UserManager shareManager].money.money_freeze imageColor:RING_COLOR_ARR(1)[2]];
    
}

- (void)loadGetinvestorData{
    
    dispatch_group_t group = dispatch_group_create();
    NSString *postUrl ;
    kAppPostHost(postUrl);
    dispatch_group_enter(group);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/getinvestor",postUrl]
      withParameters:@{
                       @"token":[UserManager shareManager].userId
                       }
     ShowHUD:YES
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 dispatch_group_leave(group);
                 if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                 self.getinArr = [NSArray modelArrayWithClass:[GetinvestorModel class] json:responseObject[@"data"][@"list"]];
                                 
                                 [self.getinArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                     GetinvestorModel *model = obj;
                                     [self.getinNameArr addObject:model.borrow_name];
                                 }];
                             }
                     });
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 dispatch_group_leave(group);
             }];
    dispatch_group_enter(group);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/fundinfo",postUrl]
          withParameters:@{
                           @"token":[UserManager shareManager].userId
                           }
     ShowHUD:YES 
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     dispatch_group_leave(group);
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             UserMoneyModel *money = [UserMoneyModel modelWithJSON:responseObject[@"data"]];
                             [[UserManager shareManager] saveUserMoney:money];
                         });
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     dispatch_group_leave(group);
                 }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self setContenUiAndText];
        [self.myTab reloadData];
    });
}

- (NSAttributedString *)getAttr:(NSString *)str grayColorText:(NSString *)grayStr imageColor:(UIColor *)imgColor{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setAlignment:NSTextAlignmentCenter];
    style.lineSpacing = 6;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor getOrangeColor] range:[str rangeOfString:grayStr]];
    
    
    UIImage *image = [UIImage createImageWithColor:imgColor imageRect:CGRectMake(0, 0, ChangedHeight(10), ChangedHeight(10))];
    
    NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:[self getIconImg:image]];

    NSRange range = NSMakeRange(0, 0);
    [attr replaceCharactersInRange:range withAttributedString:emojiAttributedString];
    return attr;
}

- (NSTextAttachment *)getIconImg:(UIImage *)imag{
    NSTextAttachment *textAttachment = [NSTextAttachment new];
    textAttachment.image = imag;
    [textAttachment adjustY:-1.5];
    
//    objc_setAssociatedObject(textAttachment, @"emoji", [NSString stringWithFormat:@"tip-%@",@(index)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return textAttachment;
}

#pragma mark - 
- (void)asPickerViewDidSelected:(ASPickerView *)picker{
    self.selectedIndex = [picker.picker selectedRowInComponent:0];
    
    [self.myTab reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
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




- (UITextView *)waitBenJinLab {
   if (!_waitBenJinLab) {
       _waitBenJinLab = [UITextView new];
       _waitBenJinLab.font = [UIFont gs_fontNum:15];
       _waitBenJinLab.textColor = [UIColor titleColor];
       _waitBenJinLab.userInteractionEnabled = NO;
   }
   return _waitBenJinLab;
}

- (UITextView *)waitShouYiLab {
   if (!_waitShouYiLab) {
       _waitShouYiLab = [UITextView new];
       _waitShouYiLab.font = [UIFont gs_fontNum:15];
       _waitShouYiLab.textColor = [UIColor titleColor];
       _waitShouYiLab.userInteractionEnabled = NO;
   }
   return _waitShouYiLab;
}

- (UITextView *)waitJiangLiLab {
   if (!_waitJiangLiLab) {
       _waitJiangLiLab = [UITextView new];
       _waitJiangLiLab.font = [UIFont gs_fontNum:15];
       _waitJiangLiLab.textColor = [UIColor titleColor];
       _waitJiangLiLab.userInteractionEnabled = NO;
   }
   return _waitJiangLiLab;
}

- (UITextView *)dongjieLab {
   if (!_dongjieLab) {
       _dongjieLab = [UITextView new];
       _dongjieLab.font = [UIFont gs_fontNum:15];
       _dongjieLab.textColor = [UIColor titleColor];
       _dongjieLab.userInteractionEnabled = NO;
   }
   return _dongjieLab;
}

@end
