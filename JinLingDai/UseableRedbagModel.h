//
//  UseableRedbagModel.h
//  JinLingDai
//
//  Created by 001 on 2017/7/21.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UseableRedbagModel : NSObject
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, copy) NSString *imgName;//添加的 可用：不可用

@property(nonatomic, copy) NSString *id;//	红包id	string
@property(nonatomic, copy) NSString *money;//	红包金额	string
@property(nonatomic, copy) NSString *name;//	红包名称	string
@property(nonatomic, copy) NSString *reward_type;//	红包类型1:红包，2:加息券	string
@end
