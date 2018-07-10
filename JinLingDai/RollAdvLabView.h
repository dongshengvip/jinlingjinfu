//
//  RollAdvLabView.h
//  JinLingDai
//
//  Created by 001 on 2017/7/22.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnouceModel.h"
@interface RollAdvLabView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, copy) void(^GongGaoBlock)(NSInteger IdStr);
//@property (nonatomic, strong) UILabel *titleLab;
//@property (nonatomic, strong) UILabel *timeLab;
- (void)setcontentView:(NSArray *)item;
@end
