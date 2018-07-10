//
//  UserManager.h
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface UserManager : NSObject

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) UserMoneyModel *money;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *urlUserId;
+ (instancetype)shareManager;
- (void)saveUserModel:(UserModel *)model;
- (void)saveUserMoney:(UserMoneyModel *)model;
- (void)logoutUsr;
- (void)logoutMoney;

- (void)loadMewModel:(void(^)(BOOL succ))success;
- (void)loadNewMoneyModel:(void(^)(BOOL succ))success;
- (BOOL)hasGuanLianTel;
- (BOOL)canExtractMoney;
- (BOOL)hadRiskFengxian;
- (BOOL)Risk_levelIsOk;
@end
