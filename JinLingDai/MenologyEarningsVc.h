//
//  MenologyEarningsVc.h
//  JinLingDai
//
//  Created by 001 on 2017/7/5.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ViewController.h"

@class MonthModel;
@interface MenologyEarningsVc : ViewController

@end

//CollectionViewHeader
@interface CalendarHeaderView : UICollectionReusableView
@end

//UICollectionViewCell
@interface CalendarCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *dayLabel;
@property (nonatomic, strong) UIView *bgView;
@property (strong, nonatomic) MonthModel *monthModel;
@end

//存储模型
@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;
@property (assign, nonatomic) BOOL isEarningDay;
@end
