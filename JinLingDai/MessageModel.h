//
//  MessageModel.h
//  JinLingDai
//
//  Created by 001 on 2017/7/20.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *id;//	消息id	string
@property (nonatomic, strong) NSString *msg;//	消息内容	string
@property (nonatomic, strong) NSString *send_time;//	发送时间	string
@property (nonatomic, strong) NSString *status;//	是否已读	string	状态：0代表未读；1代表已读；
@property (nonatomic, strong) NSString *title;//	消息标题	string
@end
