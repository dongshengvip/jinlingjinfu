//
//  RedBagCell.h
//  JinLingDai
//
//  Created by 001 on 2017/7/8.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedBagCell : UITableViewCell
@property (nonatomic, copy) void(^redBagSlectedBlock)(NSInteger index);
- (void)setContenView:(NSArray *)redBags click:(BOOL)canClick;
//- (void)setContenView:(NSArray *)redBags click:(BOOL)canClick;
@end

@interface RedBagImgModel : NSObject
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, assign) BOOL isUsed;
@property (nonatomic, assign) BOOL isSelected;
@end
