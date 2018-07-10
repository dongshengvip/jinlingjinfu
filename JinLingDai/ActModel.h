//
//  ActModel.h
//  JinLingDai
//
//  Created by 001 on 2017/8/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActModel : NSObject

@property(nonatomic, copy) NSString *end_time;//	活动结束时间	string
@property(nonatomic, copy) NSString *id;//		活动id	string
@property(nonatomic, copy) NSString *jump_url;//		活动跳转页面	string
@property(nonatomic, copy) NSString *name;//		活动名称	string
@property(nonatomic, copy) NSString *pic;//	活动图片	string
@property(nonatomic, copy) NSString *start_time;//		活动开始时间	string
@end
