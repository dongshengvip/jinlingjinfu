//
//  UserInfoView.h
//  JinLingDai
//
//  Created by 001 on 2017/6/29.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
//#import "<#header#>"
@interface UserInfoView : UIView


@property (nonatomic, copy) void(^messageClickedBlock)();//个人消息
@property (nonatomic, copy) void(^extractBtnClickedBlock)();//提现
@property (nonatomic, copy) void(^rechargeBtnClickedBlock)();//充值
@property (nonatomic, copy) void(^userHeadClickedBlock)();//点击头像
- (void)layoutContent:(UserModel *)item;
- (void)layoutMoneyContent:(UserMoneyModel *)item;
- (void)setRedMessageShow:(BOOL)show;
@end
