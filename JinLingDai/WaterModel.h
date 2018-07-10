//
//  WaterModel.h
//  JinLingDai
//
//  Created by 001 on 2017/7/20.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterModel : NSObject
@property (nonatomic, strong) NSString *balance;//	金额	string
@property (nonatomic, strong) NSString *date_time;//	时间	string
@property (nonatomic, strong) NSString *type;//	类型	string
@property (nonatomic, strong) NSString *is_return;
@property (nonatomic, strong) NSString *account_money;//充值资金存放池_可用余额
@end
