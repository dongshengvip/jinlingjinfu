//
//  ChoseBankCartVc.h
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ViewController.h"

@interface ChoseBankCartVc : ViewController
@property (nonatomic, copy) void(^BanckBlock)(NSString *banckId,NSString *bankName);
@end
