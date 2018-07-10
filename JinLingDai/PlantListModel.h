//
//  PlantListModel.h
//  JinLingDai
//
//  Created by 001 on 2017/7/20.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlantListModel : NSObject

@property (nonatomic, strong) NSString *capital;//	所得本金	string
@property (nonatomic, strong) NSString *date;//	预计收益日期	string
@property (nonatomic, strong) NSString *interest;//	所得利息	string
@property (nonatomic, strong) NSString *status;//	状态	string	0=>未获得，1=》已获得
@end
