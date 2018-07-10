//
//  UserManager.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "UserManager.h"
#import "JLDTabBarController.h"
#import "FengXianRistVc.h"
#import "BankGiftImageView.h"
//#import "RistResultVc.h"
#import <YYKit.h>
static NSString *userstr = @"usermodelstr";
static NSString *moneystr = @"usermoneylstr";
// 引入JPush功能所需头文件
#import "JPUSHService.h"
@implementation UserManager

+ (instancetype)shareManager{
    static dispatch_once_t oncetoken;
    static UserManager *userManager = nil  ;
    dispatch_once(&oncetoken, ^{
        userManager = [[UserManager alloc]init];
    });
    return userManager;
}

- (UserModel*)user{
    if (!_user) {
        _user = [UserModel modelWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userstr]];
        if(!_user) _user = nil;
    }
    return _user;
}

- (UserMoneyModel*)money{
    if (!_money) {
        _money = [UserMoneyModel modelWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:moneystr]];
        if(!_money) _money = nil;
    }
    return _money;
}

- (void)loadMewModel:(void(^)(BOOL succ))success{
    if (!self.user) {
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/userinfo",postUrl]
      withParameters:@{
                       @"token":self.userId
                       }
             ShowHUD:NO
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if ([responseObject[@"status"] integerValue] == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UserModel *user = [UserModel modelWithJSON:responseObject[@"data"]];
                         [[UserManager shareManager] saveUserModel:user];
                         success(YES);
                     });
                     
                 }else
                     success([responseObject[@"status"] integerValue] == 200);
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 success(NO);
             }];
}

- (void)loadNewMoneyModel:(void(^)(BOOL succ))success{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:[NSString stringWithFormat:@"%@user/fundinfo",postUrl]
          withParameters:@{
                           @"token":[UserManager shareManager].userId
                           }
                 ShowHUD:YES
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                     if ([responseObject[@"status"] integerValue] == 200) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             UserMoneyModel *userMoney = [UserMoneyModel modelWithDictionary:responseObject[@"data"]];
                             [self saveUserMoney:userMoney];
                             success(YES);
                         });
                     }else
                         success(NO);
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     success(NO);
                 }];
}

- (void)saveUserModel:(UserModel *)model{
    if (!model) {
        return;
    }
    self.user = model;
    NSDictionary *modelData = (NSDictionary *)[model modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:modelData forKey:userstr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveUserMoney:(UserMoneyModel *)model{
    if (!model) {
        return;
    }
    self.money = model;
    NSDictionary *modelData = (NSDictionary *)[model modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:modelData forKey:moneystr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [JPUSHService setAlias:[UserManager shareManager].user.uid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
}

- (void)logoutUsr{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:self.userId];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
    self.user = nil;
    self.money = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:userstr];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:moneystr];
    //极光推送alias
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
}

- (void)logoutMoney{
    self.money = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:moneystr];
}

- (NSString *)urlUserId{
    if (self.user) {
        return self.user.uid;
    }
    return @"";
}
- (NSString *)userId{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        return @"";
    }
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

- (BOOL)hasGuanLianTel{
    if (![Nilstr2Zero(self.user.tel) integerValue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未绑定手机号，修改交易密码需要先绑定手机号" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                
                UIViewController *vc = [[NSClassFromString(@"CheckUserIDVc") alloc] init];
                JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
                [((UINavigationController *)tab.selectedViewController) pushViewController:vc animated:YES];
            }]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        
        return NO;
    }
    return YES;
}

- (BOOL)canExtractMoney{
    if ([self hasGuanLianTel]) {
        
        if (Nilstr2Space(self.user.platcust).length == 0 || [Nilstr2Zero(self.user.bind_status) integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未开通银行存管账户，请开通存管后继续操作!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                if (DeviceVersion >= 8.3) {
                    [cancelAction setValue:[UIColor tipTextColor] forKey:@"titleTextColor"];
                }
            [alert addAction:[UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UIViewController *vc = [[NSClassFromString(@"ManageOfBankVc") alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
                [((UINavigationController *)tab.selectedViewController) pushViewController:vc animated:YES];
            }]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window.rootViewController presentViewController:alert animated:YES completion:^{
                    BankGiftImageView *giftview = [BankGiftImageView shareManage];
                    if (!giftview.hidden) {
                        [window insertSubview:giftview atIndex:1];
                    }
                }];
            });
            return NO;
        }
    }else if([Nilstr2Zero(self.user.bind_status) integerValue] == 3){
        dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您绑定银行卡的请求正在审核中!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alert animated:YES completion:^{
                BankGiftImageView *giftview = [BankGiftImageView shareManage];
                if (!giftview.hidden) {
                    [window insertSubview:giftview atIndex:1];
                }
            }];
        });
        return NO;
    }
    return YES;
}

- (BOOL)hadRiskFengxian{
    if ([self.user.risk_switch integerValue]) {
        return YES;
    }
    if ([Nilstr2Space(self.user.risk_level) isEqualToString:@"未测评"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有进行风险评估，点击下方按钮进行\"风险等级评测\"!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃出借" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            if (DeviceVersion >= 8.3) {
                [cancelAction setValue:[UIColor tipTextColor] forKey:@"titleTextColor"];
            }
            [alert addAction:[UIAlertAction actionWithTitle:@"做评测" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                FengXianRistVc *vc = [[FengXianRistVc alloc] init];
                NSString *postUrl ;
                kAppPostHost(postUrl);
                vc.H5Url = [NSString stringWithFormat:@"%@page/dangerquestion?src=%@",postUrl,self.urlUserId];
                vc.isChuJie = YES;
                vc.hidesBottomBarWhenPushed = YES;
                JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
                [((UINavigationController *)tab.selectedViewController) pushViewController:vc animated:YES];
            }]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alert animated:YES completion:^{
                BankGiftImageView *giftview = [BankGiftImageView shareManage];
                if (!giftview.hidden) {
                    [giftview.giftImage stopAnimating];
                    giftview.hidden = YES;
                }
            }];
        });
        return NO;
    }
    //}
    return YES;
}

- (BOOL)Risk_levelIsOk{
    if ([self.user.risk_switch integerValue]) {
        return YES;
    }
    if ([Nilstr2Space(self.user.risk_level) isEqualToString:@"保守型"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您\"保守型\"投资人，未达到出借要求，您可以重新进行\"风险等级评测\"!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃出借" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            if (DeviceVersion >= 8.3) {
                [cancelAction setValue:[UIColor tipTextColor] forKey:@"titleTextColor"];
            }
            
            [alert addAction:[UIAlertAction actionWithTitle:@"做评测" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                FengXianRistVc *vc = [[FengXianRistVc alloc] init];
                NSString *postUrl ;
                kAppPostHost(postUrl);
                vc.isChuJie = YES;
                vc.H5Url = [NSString stringWithFormat:@"%@page/dangerquestion?src=%@",postUrl,self.urlUserId];
                vc.hidesBottomBarWhenPushed = YES;
                JLDTabBarController *tab = (JLDTabBarController *)window.rootViewController;
                [((UINavigationController *)tab.selectedViewController) pushViewController:vc animated:YES];
            }]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alert animated:YES completion:^{
                BankGiftImageView *giftview = [BankGiftImageView shareManage];
                if (!giftview.hidden) {
                    [giftview.giftImage stopAnimating];
                    giftview.hidden = YES;
                }
            }];
        });
        return NO;
    }
    //}
    return YES;
}

@end
