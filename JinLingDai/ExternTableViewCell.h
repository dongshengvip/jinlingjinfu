//
//  ExternTableViewCell.h
//  JinLingDai
//
//  Created by 001 on 2017/7/7.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouZiModel.h"
@interface ExternTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *firstLabInSecondView;
@property (nonatomic, strong) UILabel *secondLabInSecondView;
@property (nonatomic, strong) UILabel *thirdLabInSecondView;

@property (nonatomic, copy) void(^footerhidenChangedBlock)(BOOL isHiden);
-(void)hiddenFooterViews:(NSInteger)num;
-(void)showFooterViews:(NSInteger)num;

-(void)showListwithTime:(NSArray*)times;
-(void)hidenListwithTime:(NSArray*)times;


- (void)setContenView:(TouZiModel *)item;
@end
