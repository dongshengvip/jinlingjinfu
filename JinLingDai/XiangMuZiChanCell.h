//
//  XiangMuZiChanCell.h
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetinvestorModel.h"
@interface XiangMuZiChanCell : UITableViewCell

@property (nonatomic, copy) void(^changedXiangMuBlock)();
- (void)setContenView:(GetinvestorModel *)item;
@end
