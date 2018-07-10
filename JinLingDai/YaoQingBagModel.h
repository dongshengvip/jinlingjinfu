//
//  YaoQingBagModel.h
//  JinLingDai
//
//  Created by 001 on 2017/8/22.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YaoQingBagModel : NSObject

@property (nonatomic, strong) NSString *invest_money;//	投资金额	string
@property (nonatomic, strong) NSString *min_borrow_duration;//	最小出借期限	string
@property (nonatomic, strong) NSString *money;//	红包金额	string
@property (nonatomic, strong) NSString *reward_duration;//	期限	string
@property (nonatomic, strong) NSString *status;//	状态	string	未使用，已过期，已使用
@property (nonatomic, strong) NSString *type;//	红包类型	string
@end
