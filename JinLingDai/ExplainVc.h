//
//  ExplainVc.h
//  JinLingDai
//
//  Created by 001 on 2017/7/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ViewController.h"
typedef NS_ENUM(NSInteger,NSExplainType) {
    NSExplainChongZhi,
    NSExplainTiXian
};
@interface ExplainVc : ViewController

@property (nonatomic, assign) NSExplainType type;
@end
