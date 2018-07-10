//
//  RistResultVc.m
//  JinLingDai
//
//  Created by 001 on 2018/3/9.
//  Copyright © 2018年 JLD. All rights reserved.
//

#import "RistResultVc.h"
#import "UIView+Radius.h"
#import "NSDate+Formatter.h"
#import "FengXianRistVc.h"
#import "HTMLVC.h"
#import "JLDShareManager.h"
#import "ResultViewToShare.h"
@interface RistResultVc ()
@property (nonatomic, strong) UIImageView *logoImagr;
@property (nonatomic, strong) UILabel *levelLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UIButton *reRistBtn;
@end

@implementation RistResultVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"测评说明" style:UIBarButtonItemStylePlain target:self action:@selector(ristLevelInfo)];
    
    self.title = @"风险等级测评";
    
    [self.view addSubview:self.logoImagr];
    [self.logoImagr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(ChangedHeight(20) + 44 + StatusBarHeight);
//        make.width.height.mas_equalTo(ChangedHeight(80));
    }];
    
    [self.view addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImagr.mas_bottom).offset(ChangedHeight(20));
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 10, 10));
        
    }];
    UIView *line = [UIView drawDashLineWidth:K_WIDTH - 20 lineLength:5 lineSpacing:1 lineColor:[UIColor newSeparatorColor]];
    
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 0, 10));;
        make.height.mas_equalTo(1);
        make.top.equalTo(self.timeLab.mas_bottom).offset(ChangedHeight(20));
    }];
    
    [self.view addSubview:self.infoLab];
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line).insets(UIEdgeInsetsMake(0, 5, 0, 5));
        make.top.equalTo(line.mas_bottom).offset(ChangedHeight(20));
        
    }];
    
    [self.view addSubview:self.reRistBtn];
    [self.reRistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0 , *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(ChangedHeight(-10));
        }else make.bottom.equalTo(self.view.mas_bottom).offset(ChangedHeight(-10));
        make.left.right.equalTo(self.infoLab).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.height.mas_equalTo(ChangedHeight(40));
    }];
    if (self.isRefreshUser) {
//        __weak typeof(self) weakSelf = self;
        [[UserManager shareManager] loadMewModel:^(BOOL succ) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setRistInfo];
            });
        }];
    }else{
        [self setRistInfo];
    }
}

- (void)setIsRefreshUser:(BOOL)isRefreshUser{
    _isRefreshUser = isRefreshUser;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"riskHadRefresh" object:nil];
    });
}

- (void)setIsChuJie:(BOOL)isChuJie{
    _isChuJie = isChuJie;
}

/**
 测评说明
 */
- (void)ristLevelInfo{
    HTMLVC *vc = [[HTMLVC alloc]init];
    vc.title = @"测评说明";
    NSString *postUrl ;
    kAppPostHost(postUrl);
    vc.H5Url = [NSString stringWithFormat:@"%@page/dangerexplain",postUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 重新测评
 */
- (void)reRistLevel{
    if (![[UserManager shareManager].user.risk_level isEqualToString:@"保守型"]) {
        if (self.isChuJie) {
            [self.navigationController popViewControllerAnimated:YES];
            [self JLDShare];
            return;
        }else if (self.isRefreshUser){
//            [self JLDShare];
            [self.tabBarController setSelectedIndex:1];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    
    NSString *postUrl ;
    kAppPostHost(postUrl);
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [arr removeLastObject];
    FengXianRistVc *vc = [[FengXianRistVc alloc]init];
    vc.H5Url = [NSString stringWithFormat:@"%@page/dangerquestion?src=%@",postUrl,[UserManager shareManager].urlUserId];
    vc.isChuJie = self.isChuJie;
    [arr addObject:vc];
    [self.navigationController setViewControllers:arr animated:YES];
}

/**
 设置数据
 */
- (void)setRistInfo{
    self.logoImagr.image = [UIImage imageNamed:Nilstr2Space([UserManager shareManager].user.risk_level)];
    if (self.isChuJie || self.isRefreshUser) {
        if (![[UserManager shareManager].user.risk_level isEqualToString:@"保守型"]) {
            [self.reRistBtn setTitle:@"去投资" forState:UIControlStateNormal];
        }
    }
    self.timeLab.text = [UserManager shareManager].user.risk_time_string;
    self.infoLab.text = [UserManager shareManager].user.risk_info;
    
}

- (void)JLDShare{
    ResultViewToShare *shareView = [[ResultViewToShare alloc]initWithFrame:self.view.bounds];
    shareView.backgroundColor = [UIColor whiteColor];
//    shareView.hidden = YES;
    [self.view addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //    shareView.frame = self.view.boun];ds;
    UIImage *shareImage = [shareView getShareResultView];
    [shareView removeFromSuperview];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:shareImage];
//    [self.view addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    if ([JLDShareManager canShareToFriendds]) {
//        VideoImageView *image = [self.visibleImageViews anyObject];
//        VideoListModel *videoModel = self.videoUrlArr[image.tag];
        ShareModel *model = [[ShareModel alloc] init];
        model.title =  @"图片分享";
        model.logoImage = [UIImage imageNamed:@"LOGO"];
//        model.descString = videoModel.content;
        
//        if ([videoModel.type integerValue] == 2) {
//            model.type = VideoShareType;
//            model.videoStreamUrl = videoModel.url[0];
//        }else{
            model.type = ImageShareType;
            model.shareImage = shareImage;
//        }
        
        model.isImag = YES;
        [[JLDShareManager shareManager] showShareBoardWithModel:model];
        
    }else{
        UIAlertController *warmTip = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未安装社交软件来分享消息" preferredStyle:UIAlertControllerStyleAlert];
        [warmTip addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:warmTip animated:YES completion:nil];
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

- (UIImageView *)logoImagr {
   if (!_logoImagr) {
       _logoImagr = [UIImageView new];
       _logoImagr.contentMode = UIViewContentModeScaleAspectFit;
//       _logoImagr.image = [UIImage imageNamed:@"江苏"];//@"风险等级"
//       _logoImagr
   }
   return _logoImagr;
}

- (UILabel *)timeLab {
   if (!_timeLab) {
       _timeLab = [UILabel new];
       _timeLab.font = [UIFont gs_fontNum:12];
       _timeLab.textColor = [UIColor newSecondTextColor];
       _timeLab.textAlignment = NSTextAlignmentCenter;
   }
   return _timeLab;
}

- (UILabel *)infoLab {
   if (!_infoLab) {
       _infoLab = [UILabel new];
       _infoLab.font = [UIFont gs_fontNum:14];
       _infoLab.textColor = [UIColor newSecondTextColor];
       _infoLab.numberOfLines = 0;
   }
   return _infoLab;
}

- (UIButton *)reRistBtn {
   if (!_reRistBtn) {
       _reRistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _reRistBtn.titleLabel.font = [UIFont gs_fontNum:15];
       [_reRistBtn setTitle:@"重新测评" forState:UIControlStateNormal];
       [_reRistBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       _reRistBtn.layer.cornerRadius = 5;
       _reRistBtn.backgroundColor = [UIColor getOrangeColor];
       [_reRistBtn addTarget:self action:@selector(reRistLevel) forControlEvents:UIControlEventTouchUpInside];
   }
   return _reRistBtn;
}

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}
//- (UILabel *)levelLab {
//   if (!_levelLab) {
//       _levelLab = [UILabel new];
//       _levelLab.font = [UIFont systemFontOfSize:<#(CGFloat)#>];
//       _levelLab.textColor = <#Color#>;
//       _levelLab.textAlignment = <#NSTextAlignment#>;
//       _levelLab.backgroundColor = [UIColor <#Color#>];
//   }
//   return _levelLab;
//}

@end
