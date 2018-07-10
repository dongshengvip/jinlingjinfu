//
//  BorrowModel.h
//  JinLingDai
//
//  Created by 001 on 2017/7/18.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ListModel;
@interface BorrowModel : NSObject
@property (nonatomic, copy)  NSArray <ListModel *>*list;//		array<object>
@property (nonatomic, copy)  NSArray <ListModel *>*nlist;//		array<object>	当用户为新手的时候显示新手标

@end


@interface ListModel : NSObject
@property (nonatomic, copy)  NSString *borrow_duration;//	项目期限	string
@property (nonatomic, copy)  NSString *borrow_interest_rate;//	出借款年化利率	string
@property (nonatomic, copy)  NSString *reward;//赠送出借款年化利率	string
@property (nonatomic, copy)  NSString *borrow_min;//	最小投资额	string
@property (nonatomic, copy)  NSString *borrow_max;//	最大投资额	string
@property (nonatomic, copy)  NSString *borrow_money;//	出借金额	string
@property (nonatomic, copy)  NSString *borrow_name;//	借款标题	string
@property (nonatomic, copy)  NSString *borrow_status;//	借款状态	string
/*0代表初审待审核；1代表初审未通过；2代表初审通过，借款中；3代表标未满，结束，流标；4代表标满，复审中；5代表复审未通过，结束；6代表复审通过，还款中；7代表正常完成；8代表已逾期；9代表网站代还完成；10代表会员在网站代还后，逾期还款
 */
@property (nonatomic, copy)  NSString *borrow_id;
@property (nonatomic, copy)  NSString *borrow_uid;//	借款用户id	string
@property (nonatomic, copy)  NSString *expire_time;//	到期时间	string
@property (nonatomic, copy)  NSString *have_borrowed_money;//	已借到金额	string
@property (nonatomic, copy)  NSString *id;//	借款id	string
@property (nonatomic, copy)  NSString *is_xinshou;//是否新手标    string 0、1
@property (nonatomic, copy)  NSString *borrow_tip;//产品列表提示   string 新手、定向
@property (nonatomic, copy)  NSString *is_tuijian;//	是否推荐标	string
@property (nonatomic, copy)  NSString *password;//    md5    string
@property (nonatomic, copy)  NSString *duration_unit;//	单位月或天
@property (nonatomic, copy)  NSString *progress;//	借款进度	string
@property (nonatomic, copy)  NSString *rest_borrow_money;//	剩余金额	string

@property (nonatomic, copy)  NSString *huankuan_type;//	还款方式	string

@property (nonatomic, copy)  NSString *borrow_info;//	项目信息	string
@property (nonatomic, copy)  NSString *borrow_log;//	出借记录	string

@property (nonatomic, copy)  NSString *expired_time;//	到期时间	string
@property (nonatomic, copy)  NSString *file_info;//	相关资料	string
@property (nonatomic, copy)  NSString *investor_log;//	还款记录	string

@property (nonatomic, copy)  NSString *rate_type;//	计息方式	string	1=>即投计息，2=》满标计息
@property (nonatomic, copy)  NSString *repayment_type;//	还款方式	string	1代表按天到期还款；2代表按月分期还款； 3代表按季分期还款；4代表每月还息到期还本
@end
