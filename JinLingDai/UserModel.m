//
//  UserModel.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//
#import "NSDate+Formatter.h"
#import "UserModel.h"
#define BankNameArr @[@"中国银行", @"上海银行", @"建设银行", @"工商银行", @"北京银行", @"光大银行", @"广发银行", @"华夏银行",@"交通银行", @"民生银行", @"农业银行",@"平安银行",@"浦发银行",@"兴业银行",@"招商银行",@"中信银行",@"邮政储蓄"]
#define BankTextNameArr @[@"中国银行", @"上海银行", @"建设", @"工商", @"北京", @"光大", @"广发", @"华夏",@"交通", @"民生", @"农业",@"平安",@"浦发",@"兴业",@"招商",@"中信",@"邮"]
@implementation bankModel
- (NSString *)bankNumText{
    NSMutableString *numText = [[NSMutableString alloc]initWithString:_bank_num];
    [numText replaceCharactersInRange:NSMakeRange(0, _bank_num.length - 4) withString:@"**** **** ****"];
    return numText;
}
- (NSString *)UseableBankName{
    [BankTextNameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = obj;
        if ([self.bank_name containsString:name]) {
            _UseableBankName = BankNameArr[idx];
            return ;
        }
    }];
    return Nilstr2Space(_UseableBankName);
}
@end
@implementation UserModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"bank_data" : [bankModel class],
             };
}
- (NSString *)getIdCartString{
    if (Nilstr2Space(_idcard).length == 0) {
        return @"";
    }
    NSMutableString *idStr = [NSMutableString stringWithString:_idcard];
    [idStr replaceCharactersInRange:NSMakeRange(0, idStr.length - 4) withString:@"**** **** ****"];
    return idStr;
}
- (NSString *)risk_time_string{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[UserManager shareManager].user.risk_time longLongValue]];
    return [NSString stringWithFormat:@"测评时间:%@",[date dateWithFormat:@"yyyy-MM-dd"]];
}
//- (NSString *)idcard{
//    if (Nilstr2Space(_idcard).length == 0) {
//        return @"";
//    }
//    NSMutableString *idStr = [NSMutableString stringWithString:_idcard];
//    [idStr replaceCharactersInRange:NSMakeRange(0, idStr.length - 4) withString:@"**** **** ****"];
//    return idStr;
//}
- (UserLeveType)userLeve{
    _userLeve = UserLeveDefult;
    if (Nilstr2Space(self.platcust).length) {    
        _userLeve = UserLeve2;
    }
    if ([self.invest_count integerValue] == 1) {
        _userLeve = UserLeve3;
    }
    if ([self.invest_count integerValue] > 1) {
        _userLeve = UserLeve4;
    }
    return _userLeve;
}
@end
@implementation UserMoneyModel

- (NSString *)expand_count{
    return Nilstr2Space(_expand_count);
}

- (NSString *)coming_captial{
    _coming_captial = Nilstr2Space(_coming_captial);
    if (!_coming_captial || [_coming_captial isKindOfClass:[NSNull class]] || [_coming_captial doubleValue] <= 0) {
        _coming_captial = @"0.00";
    }
    return [NSString stringWithFormat:@"%.2f",[_coming_captial doubleValue]];
}
- (NSString *)total_balance{
    if (!_total_balance || [_total_balance isKindOfClass:[NSNull class]] || [_total_balance doubleValue] <= 0) {
        _total_balance = @"0.00";
    }
    return [NSString stringWithFormat:@"%.2f",[_total_balance doubleValue]];
}
- (NSString *)total_interest{
    if (!_total_interest || [_total_interest isKindOfClass:[NSNull class]] || [_total_interest floatValue] <= 0) {
        _total_interest = @"0.00";
    }
    return [NSString stringWithFormat:@"%.2f",[_total_interest doubleValue]];
}
- (NSString *)active_balance{
    
    if (!_active_balance || [_active_balance isKindOfClass:[NSNull class]] || [_active_balance floatValue] <= 0) {
        _active_balance = @"0.00";
    }
    return [NSString stringWithFormat:@"%.2f",[_active_balance doubleValue]];
}
- (NSString *)coming_interest{
    if (!_coming_interest || [_coming_interest isKindOfClass:[NSNull class]] || [_coming_interest floatValue] <= 0) {
        _coming_interest = @"0.00";
    }
    return [NSString stringWithFormat:@"%.2f",[_coming_interest doubleValue]];
}
- (NSString *)money_freeze{
    if (!_money_freeze || [_money_freeze isKindOfClass:[NSNull class]] || [_money_freeze floatValue] <= 0) {
        _money_freeze = @"0.00";
    }
    return [NSString stringWithFormat:@"%.2f",[_money_freeze doubleValue]];
}

@end
