//
//  ProductChildVc.h
//  JinLingDai
//
//  Created by 001 on 2017/7/19.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductChildVc : UIViewController
@property (nonatomic, copy) void(^RuboToBuyBlock)(NSString *productid);
@property (nonatomic, copy) NSString *status;
//2=>融资中，6=>还款中，7=>已还款，非必需
- (void)loadDingQiData:(NSString *)status;
@end
