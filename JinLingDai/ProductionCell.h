//
//  ProductionCell.h
//  JinLingDai
//
//  Created by 001 on 2017/6/29.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowModel.h"
@interface ProductionCell : UITableViewCell
@property (nonatomic, copy) void(^robBuyBtnClick)();

- (void)layoutViewsItem:(ListModel *)item;
@end
