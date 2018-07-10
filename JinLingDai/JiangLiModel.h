//
//  JiangLiModel.h
//  JinLingDai
//
//  Created by 001 on 2017/7/17.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RedBagModel;

@interface JiangLiModel : NSObject
@property (nonatomic, strong) NSArray <RedBagModel *>*list;

@property (nonatomic, strong) NSString *type;//	类型	string
@property (nonatomic, strong) NSString *uid;//	用户ID	string
@end

@interface RedBagModel : NSObject
@property (nonatomic, strong) NSString *add_rate_day;//加息天数
@property (nonatomic, strong) NSString *imgStr;//	自己加的
@property (nonatomic, strong) NSString *detail;//	说明	string
@property (nonatomic, strong) NSString *end_date;//	结束日期	string
@property (nonatomic, strong) NSString *money;//	金额	string
@property (nonatomic, strong) NSString *start_date;//	开始使用日期	string
@property (nonatomic, strong) NSString *status;//	状态	string
@property (nonatomic, strong) NSString *name;//	标题	string
@property (nonatomic, strong) NSString *invest_money;//	投资金额	string
@property (nonatomic, strong) NSString *min_borrow_duration;//	最小出借期限
@end
