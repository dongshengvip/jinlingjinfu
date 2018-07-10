//
//  AppDelegate+LoadNewVerson.m
//  JinLingDai
//
//  Created by 001 on 2017/11/30.
//  Copyright © 2017年 JLD. All rights reserved.
//
#import "JLDTabBarController.h"
#import "HTMLVC.h"
#import "BankGiftImageView.h"
#import "ManageOfBankVc.h"
#import <YYKit.h>
#import "JLDActAlertView.h"
#import "ActModel.h"
#import "AppDelegate+LoadNewVerson.h"
#import "RistResultVc.h"
#import "FengXianRistVc.h"
//@interface AppDelegate(LoadNewVerson)
//@property (nonatomic, strong) JLDActAlertView *act;
//@property (nonatomic, strong) ActModel *actModel;
//@end
static ActModel *actModel;
static JLDActAlertView *act;
@implementation AppDelegate (LoadNewVerson)

- (void)loadNewVer{
    dispatch_main_async_safe((^{
        act = [JLDActAlertView shareManager];
        act.confirmBtnBlock = ^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            HTMLVC *vc= [[HTMLVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = actModel.name;
            [vc setShareBtn];
            vc.H5Url = [actModel.jump_url stringByAppendingString:[NSString stringWithFormat:@"?src=%@",[UserManager shareManager].urlUserId]];
            [nav pushViewController:vc animated:YES];
        };
        act.cancelBtnBlock = ^{
            UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
            JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
            BankGiftImageView *bankView = [BankGiftImageView shareManage];
            bankView.hidden  = NO;
            [bankView.giftImage startAnimating];
            bankView.frame = CGRectMake(K_WIDTH - 100, K_HEIGHT - tab.tabBar.height - 37, 100, 37);
            [window insertSubview:bankView atIndex:1];
        };
        act.ristBlock= ^{
            NSString *postUrl ;
            kAppPostHost(postUrl);
            FengXianRistVc *vc = [[FengXianRistVc alloc]init];
            vc.title = @"风险测评";
            vc.H5Url = [NSString stringWithFormat:@"%@page/dangerquestion?src=%@",postUrl,[UserManager shareManager].urlUserId];
            vc.hidesBottomBarWhenPushed = YES;
            UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
            JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            [nav pushViewController:vc animated:YES];
        };
        act.bankBlock = ^{
            UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
            JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            ManageOfBankVc *vc = [[ManageOfBankVc alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        };
    }));
    
//        [self LoadActModel];
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@app/version",postUrl]
withParameters:@{
               @"system":@"ios"
               }
     ShowHUD:NO
     success:^(NSURLSessionDataTask *task, id responseObject) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([responseObject[@"status"] integerValue] == 200) {
                 if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                     NSString *verStr = responseObject[@"data"][@"version"];
                     //isOnLineStatues
                     NSString *online_version = responseObject[@"data"][@"online_status"];
                     if (![online_version isKindOfClass:[NSNull class]]) {
                         self.isGotoH5 = [Nilstr2Zero(online_version) integerValue] == 1;
                     }
                     
                     if ([verStr compare:kAppVersion options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
                         
                         UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"data"][@"update_desc"] preferredStyle:UIAlertControllerStyleAlert];
                         [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                             NSString *lowestVerStr = responseObject[@"data"][@"lowest_version"];
                             if ([lowestVerStr compare:kAppVersion options:NSCaseInsensitiveSearch] == NSOrderedDescending){
                                     [UIView animateWithDuration:0.5f animations:^{
                                         [act hidenAlertType];
                                         UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                         window.alpha = 0;
                                         window.frame = CGRectMake(window.frame.size.width/2, window.frame.size.height/2, 0, 0);
                                     } completion:^(BOOL finished) {
                                         exit(0);
                                     }];
                             }
                         }]];
                         [alert addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             //
                             if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppDownLoadUrl] options:@{} completionHandler:^(BOOL success) {
                                     
                                 }];
                             }else
                                 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:kAppDownLoadUrl]];
                             
                             NSString *lowestVerStr = responseObject[@"data"][@"lowest_version"];
                             if ([lowestVerStr compare:kAppVersion options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
                                 [UIView animateWithDuration:0.5f animations:^{
                                     [act hidenAlertType];
                                     UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                     window.alpha = 0;
                                     window.frame = CGRectMake(window.frame.size.width/2, window.frame.size.height/2, 0, 0);
                                 } completion:^(BOOL finished) {
                                     exit(0);
                                 }];
                             }
                         }]];
                         //                                         [[GuideManager shared] showStarView];
                         //                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
                         JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
                         if (tab.presentVc) {
                             [tab.presentVc presentViewController:alert animated:YES completion:nil];
                         }else
                             [window.rootViewController presentViewController:alert animated:YES completion:nil];
                         //                                         });
                         
                     }
                 }
             }
         });
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
     }];
        
//    });
}

- (void)actAlerShow{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:Activity]) {
        actModel = [ActModel modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"actmodel"]];
        if (actModel) {//
            if ([[NSDate date] compare:[NSDate dateWithTimeIntervalSince1970:[actModel.end_time longLongValue]]] == NSOrderedAscending && [[NSDate date] compare:[NSDate dateWithTimeIntervalSince1970:[actModel.start_time longLongValue]]] == NSOrderedDescending) {
                [act.tipView sd_setImageWithURL:[NSURL URLWithString:actModel.pic] placeholderImage:[UIImage imageNamed:@"公告alert"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        act.tipView.image = [UIImage imageNamed:@"公告alert"];
                        
                    }else{
                        [act.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.center.equalTo(act);
                            make.width.mas_equalTo(K_WIDTH - ChangedHeight(40));
                            make.height.mas_equalTo((K_WIDTH - ChangedHeight(40)) * image.size.height /image.size.width);
                        }];
                        
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [act showAlertType:ActivityType toView:[UIApplication sharedApplication].windows.firstObject];
//                        });
                    });
                    
                }];

            }else
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"actmodel"];
        }
    }
}
- (void)LoadActModel{
    //    NSString *st
//    BOOL rigst = Nilstr2Space([UserManager shareManager].user.risk_level).length && [[UserManager shareManager].user.risk_level isEqualToString:@"未测评"];
    BOOL bank = !Nilstr2Space([UserManager shareManager].user.platcust).length || [Nilstr2Zero([UserManager shareManager].user.bind_status) integerValue] == 0;
//    if (rigst) {
//        [self bankManagerViewShow:RistShowType];
//    }else
        if ( ![UserManager shareManager].user || !bank) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *postUrl ;
            kAppPostHost(postUrl);
            [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@activity/index",postUrl]
          withParameters:@{}
             ShowHUD:NO
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     ActModel *model = [ActModel modelWithJSON:responseObject[@"data"]];
                     [[NSUserDefaults standardUserDefaults] setObject:[model modelToJSONData] forKey:@"actmodel"];
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Activity];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     if (![[NSUserDefaults standardUserDefaults] boolForKey:@"jpushNotificationCenter"]) {
                         [self actAlerShow];
                         
                     }
                     
                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"jpushNotificationCenter"];
                     
                 });
                 
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
             }];
        });
        
    }else{
        [self bankManagerViewShow:BankShowType];
    }
}

/**
 放出银行存
 */
- (void)bankManagerViewShow:(lertType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            BankGiftImageView *bankView = [BankGiftImageView shareManage];
//            bankView.hidden = YES;
//            [bankView.giftImage stopAnimating];
            [act showAlertType:type toView:[UIApplication sharedApplication].windows.firstObject];
        });
    });
    

}
@end
