//
//  RecommendCell.h
//  JinLingDai
//
//  Created by 001 on 2017/8/16.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecommendCell : UITableViewCell
@property (nonatomic, copy) void(^GoToBorrowBlock)(NSString *borrowId);
- (void)setListItem:(NSArray *)items;
@end
