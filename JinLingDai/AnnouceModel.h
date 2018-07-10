//
//  AnnouceModel.h
//  JinLingDai
//
//  Created by 001 on 2017/8/4.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouceModel : NSObject

@property (nonatomic, strong) NSString *link;//	链接	string
@property (nonatomic, strong) NSString *click_status;//	是否可点击	string
@property (nonatomic, strong) NSString *id;//	id	string
@property (nonatomic, strong) NSString *info;//	简介	string
@property (nonatomic, strong) NSString *keyword;//	关键字	string
@property (nonatomic, strong) NSString *title;//	标题	string
@property (nonatomic, strong) NSString *iconName;//	icon	string
@property (nonatomic, strong) NSString *add_time;
@end
