//
//  AnnouceCell.h
//  JinLingDai
//
//  Created by 001 on 2017/8/15.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnouceModel.h"
/**
 公告cell
 */
@interface AnnouceCell : UITableViewCell
- (void)setContenView:(AnnouceModel *)item;
@end
