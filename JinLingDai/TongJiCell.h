//
//  TongJiCell.h
//  JinLingDai
//
//  Created by 001 on 2017/7/6.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TongJiCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLab;
- (void) setMoney:(NSString *)money tip:(NSString *)tip;
@end
