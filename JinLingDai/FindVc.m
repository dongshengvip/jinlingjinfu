//
//  ThirdVc.m
//  JinLingDai
//
//  Created by 001 on 2017/6/27.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "FindVc.h"
//#import "ADVPageView.h"
#import "UpAndDownButton.h"
#import "CompanyInfoView.h"
#import "HTMLVC.h"
#import "UIView+Radius.h"
#import "HTMLVC.h"
#import <YYKit.h>
#import "ADVPageView.h"
@interface FindVc ()<ADVPageViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ADVPageView *advView;
@property (nonatomic, copy) NSArray *ADVImgArr;
@property (nonatomic, strong) UIScrollView *myScroll;
@property (nonatomic, strong) UIView *optionsBtnView;
@property (nonatomic, strong) CompanyInfoView *companyView;
//@property (nonatomic, assign) BOOL isAnimat;
@end
#define SudokuArr @[@[@"新手引导", @"公司理念", @"安全保障"],@[@"媒体报道", @"关于我们", @"招贤纳士"]]
#define SudoH5Url @[@[@"8", @"5", @"1"],@[@"7", @"2", @"10"]]
@implementation FindVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [self setNavBlackColor];
    _companyView = [[CompanyInfoView alloc] init];
    //点击查看公司详情
    NSString *postUrl ;
    kAppPostHost(postUrl);
    __weak typeof(self) weakSealf = self;
    _companyView.moreTahnBtnBlock = ^{
        HTMLVC *vc = [[HTMLVC alloc]init];
        vc.H5Url = [NSString stringWithFormat:@"%@Page/showinfomation?type=4",postUrl];
        vc.title = @"公司简介";
        [vc setShareBtn];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSealf.navigationController pushViewController:vc animated:YES];
    };
    
    _advView = [ADVPageView new];
    _advView.delegate = self;
    _advView.height = ChangedHeight(170);
    
    self.myScroll = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.myScroll.backgroundColor = [UIColor infosBackViewColor];
    [self.view addSubview:self.myScroll];
    [self.myScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(StatusBarHeight, 0, 0, 0));
    }];
    
    [self.myScroll addSubview:self.advView];
    [self.advView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.myScroll);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(ChangedHeight(170));
    }];

    [self.myScroll addSubview:self.optionsBtnView];
    [self.optionsBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advView.mas_bottom).offset(-15);
        make.left.equalTo(self.advView).offset(15);
        make.right.equalTo(self.advView).offset(-15);
        make.height.mas_equalTo(ChangedHeight(180));
//        make.height.mas_equalTo(self.optionsBtnView.mas_width).dividedBy(2.0).of;
    }];
    
    [self.myScroll addSubview:self.companyView];
    [self.companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.myScroll);
        make.top.equalTo(self.optionsBtnView.mas_bottom).offset(10);
        make.height.mas_equalTo(ChangedHeight(180));
    }];
    
//    [self loadBaner];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.ADVImgArr || !self.ADVImgArr.count) {
        [self loadBaner];
    }
}

- (void)loadBaner{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@page/discovery",postUrl]
          withParameters:@{
                           @"user_from":@"4"
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     if ([responseObject[@"status"] integerValue] == 200) {
                         self.ADVImgArr = responseObject[@"data"][@"list"];
                         NSMutableArray *arr = [NSMutableArray array];
                         if ([self.ADVImgArr isKindOfClass:[NSArray class]]) {
                             [self.ADVImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 [arr addObject:obj[@"pic"]];
                             }];
                         }
                        
                         [self.advView setItems:arr andTimeInterval:5.f];
                     }
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
}


- (UIView*)optionsBtnView{
    if (!_optionsBtnView) {
        _optionsBtnView = [UIView new];
        _optionsBtnView.layer.masksToBounds = YES;
        _optionsBtnView.layer.cornerRadius = 5;
        _optionsBtnView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 2; i ++) {
            UIView *lastView = nil;
            for (int k = 0; k < 3; k ++) {
                UpAndDownButton *btn = [UpAndDownButton new];
                btn.icon.image = [UIImage imageNamed:SudokuArr[i][k]];
                
                btn.titleLab.text = SudokuArr[i][k];
                btn.tag = i * 3 + k;
                [btn setTitleColor:[UIColor getColor:81 G:82 B:82] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(collectionBtnsClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_optionsBtnView addSubview:btn];
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(_optionsBtnView).dividedBy(2.0);
                    if (i == 0) {
                        make.top.equalTo(_optionsBtnView);
                    }else{
                        make.bottom.equalTo(_optionsBtnView);
                    }
                    if(k > 0){
                        make.left.equalTo(lastView.mas_right);
                    }else{
                        make.left.equalTo(_optionsBtnView);
                    }
                    if (k == 2) {
                        make.right.equalTo(_optionsBtnView);
                    }
                    if (lastView) {
                        make.width.equalTo(lastView);
                    }
                    
                }];
                lastView = btn;
            }
        }
    }
    return _optionsBtnView;
}
- (void)collectionBtnsClicked:(UIButton *)sender{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    HTMLVC *vc= [[HTMLVC alloc] init];
    vc.H5Url = [NSString stringWithFormat:@"%@Page/showinfomation?type=%@",postUrl,SudoH5Url[sender.tag/3][sender.tag%3]];
    vc.title = SudokuArr[sender.tag/3][sender.tag%3];
    [vc setShareBtn];
    vc.hidesBottomBarWhenPushed = YES;
    self.isAnimat = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)pageView:(ADVPageView *)pageView didSelected:(NSInteger)index{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    if(self.ADVImgArr.count > index){
        NSString *jumpUrlStr = self.ADVImgArr[index][@"jump_url"];
        if (Nilstr2Space(jumpUrlStr).length <= postUrl.length) {
            return;
        }
        HTMLVC *vc= [[HTMLVC alloc] init];
        NSString *urlStr = self.ADVImgArr[index][@"jump_url"];
        vc.H5Url = [urlStr containsString:@"?"]?[urlStr stringByAppendingString:[NSString stringWithFormat:@"&src=%@",[UserManager shareManager].urlUserId]]:[urlStr stringByAppendingString:[NSString stringWithFormat:@"?src=%@",[UserManager shareManager].urlUserId]];
        [vc setShareBtn];
        vc.title = self.ADVImgArr[index][@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        self.isAnimat = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
