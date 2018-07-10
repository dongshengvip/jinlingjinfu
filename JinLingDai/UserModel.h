//
//  UserModel.h
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,UserLeveType) {
    UserLeveDefult,//未开户
    UserLeve2,//开户
    UserLeve3,//首投
    UserLeve4//复投
};
@class bankModel;

@interface UserModel : NSObject
//我定义的
@property (nonatomic, assign) BOOL HidenMoney;//隐金钱
@property (nonatomic, assign) BOOL hadGester;//设置手势
@property (nonatomic, assign) BOOL gesterOn;//打开手势
//@property (nonatomic, assign) BOOL shakeOn;//打开摇一摇
@property (nonatomic, assign) UserLeveType userLeve;
 
@property (nonatomic, copy) NSString *shake_status;    //摇一摇开启状态    string    0未开启，1已开启
@property (nonatomic, copy) NSString *bind_status;//用户绑卡状态    string    0：未绑卡，1：已绑卡，3：审核中（企业用户）
@property (nonatomic, copy) NSString *code;//用户邀请
@property (nonatomic, copy) NSString *real_name;//用户真实姓名
@property (nonatomic, copy) NSString *username;	//用户名
@property (nonatomic, copy) NSArray<bankModel *>*bank_data;
@property (nonatomic, copy) NSString *is_setpinpass;//是否设置交易密码
@property (nonatomic, copy) NSString *head;	//用户头像
@property (nonatomic, copy) NSString *idcard;	//用户身份证号
@property (nonatomic, copy) NSString *is_borrow;	//能否发布借款		0=>否，1=》能
@property (nonatomic, copy) NSString *is_verify;	//是否实名		0=>否，1=》能
@property (nonatomic, copy) NSString *tel;	//用户手机号
@property (nonatomic, copy) NSString *uid;	//用户ID
@property (nonatomic, copy) NSString *invest_count;	//投资次数
@property (nonatomic, copy) NSString *platcust;//	存管客户编号	string	未开户则为空
@property (nonatomic, copy) NSString *risk_level; //测评等级,
@property (nonatomic, copy) NSString *risk_time; //0,
@property (nonatomic, copy) NSString *risk_info; //介绍,
@property (nonatomic, copy) NSString *risk_switch; //介绍,
- (NSString *)getIdCartString;
- (NSString *)risk_time_string;
@end

@interface UserMoneyModel : NSObject
@property (nonatomic, copy) NSString *active_balance;	//账户可用余额	string
@property (nonatomic, copy) NSString *coming_captial;	//待收本金	string
@property (nonatomic, copy) NSString *coming_interest;	//待收利息	string
@property (nonatomic, copy) NSString *expand_count;	//红包个数	string
@property (nonatomic, copy) NSString *total_balance;	//账户总额	string
@property (nonatomic, copy) NSString *total_interest;	//总收益	string
@property (nonatomic, copy) NSString *money_freeze;    //冻结    string
@property (nonatomic, copy) NSString *uid;	//用户ID
@end

@interface bankModel : NSObject
@property (nonatomic, copy) NSString *bank_name;	//银行名称
@property (nonatomic, copy) NSString *UseableBankName;	//修改后银行名称
@property (nonatomic, copy) NSString *bank_num;	//银行卡号
@property (nonatomic, copy) NSString *bank_address;//	开户行支行	string
@property (nonatomic, copy) NSString *bank_city;//	开户行市
@property (nonatomic, copy) NSString *bank_province;//	开户行省份	string
@property (nonatomic, copy) NSString *bank_img;    //图片
- (NSString *)bankNumText;
@end
