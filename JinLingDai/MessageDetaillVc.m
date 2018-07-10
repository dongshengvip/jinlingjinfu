//
//  MessageDetaillVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/4.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MessageDetaillVc.h"
#import "NSDate+Formatter.h"
#import "UIColor+Util.h"
#import <Masonry.h>
@interface MessageDetaillVc ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIWebView *contenView;
@end

@implementation MessageDetaillVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"消息详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.scrollEnabled = NO;
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *helperView =[UIView new];
    [scroll addSubview:helperView];
    [helperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(-64);
    }];
    
    UIView *titleBGView = [UIView new];
    titleBGView.backgroundColor = [UIColor whiteColor];
    [helperView addSubview:titleBGView];
    [titleBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(helperView).offset(ChangedHeight(3));
        make.left.right.equalTo(helperView);
        make.height.mas_equalTo(ChangedHeight(80));
    }];
    
    self.titleLab = [UILabel new];
    self.titleLab.font = [UIFont gs_fontNum:17];
    self.titleLab.numberOfLines = 0;
    [titleBGView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBGView).offset(ChangedHeight(10));
        make.right.equalTo(titleBGView).offset(-10);
        make.top.equalTo(titleBGView).offset(ChangedHeight(10));
    }];
    
    self.timeLab = [UILabel new];
    self.timeLab.font = [UIFont gs_fontNum:12];
    self.timeLab.textColor = [UIColor getBlueColor];
    [titleBGView addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.mas_bottom).offset(ChangedHeight(5));
    }];
    
    self.contenView = [[UIWebView alloc]init];
    [helperView addSubview:self.contenView];
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(helperView);
        make.top.equalTo(titleBGView.mas_bottom).offset(1);
    }];
   
}


- (void)setCententView{
    self.titleLab.text = self.messageModel.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.messageModel.send_time longLongValue]];
    self.timeLab.text = [date dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.contenView loadHTMLString:self.messageModel.msg baseURL:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCententView];
    if ([self.messageModel.status integerValue] == 1) {
        return;
    }
    [self loadMessageData];
    
    
}

- (void)loadMessageData{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/change_msg_status",postUrl]
                      withParameters:@{
                                       @"mid":self.messageModel.id,//	消息id	number	0表示全部标记为已读
                                       @"token":[UserManager shareManager].userId//	用户id	number
                                       }
     ShowHUD:YES 
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 
                             }];
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
