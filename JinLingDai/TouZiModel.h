//
//  TouZiModel.h
//  JinLingDai
//
//  Created by 001 on 2017/7/17.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouZiModel : NSObject <NSCopying>

@property (nonatomic, copy) NSString *add_time;//	时间
@property (nonatomic, copy) NSString *investor_status;//	还款状态	string
@property (nonatomic, copy) NSString *expired_time;

@property (nonatomic, copy) NSString *all_income;//	预期收益	string
@property (nonatomic, copy) NSString *borrow_info;//		项目信息	string
@property (nonatomic, copy) NSString *file_info;
@property (nonatomic, copy) NSString *borrow_log;
@property (nonatomic, copy) NSString *investor_log;
@property (nonatomic, copy) NSString *reward;//使用优惠
@property (nonatomic, copy) NSString *borrow_id;//	项目id	string
@property (nonatomic, copy) NSString *borrow_interest_rate;//	n年化利率	string
@property (nonatomic, copy) NSString *rate_type;//	计息方式	string	1投即计息2满标记息
@property (nonatomic, copy) NSString *duration_unit;//	期限单位	string	0：天，1：月（其他的也代表月）
@property (nonatomic, copy) NSString *borrow_title;//	项目标题	string
@property (nonatomic, copy) NSString *investor_capital;//	出借金额	string
@property (nonatomic, copy) NSString *investor_duration;//	项目期限	string
@property (nonatomic, copy) NSString *received_money;//	已收金额	string
@property (nonatomic, copy) NSString *unreceived_capital;//	剩余本金	string
@property (nonatomic, copy) NSString *unreceived_money;//	待收金额	string
@end
