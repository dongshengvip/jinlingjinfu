//
//  MenologyEarningsVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/5.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "MenologyEarningsVc.h"
#import "NSDate+Formatter.h"
#import <Masonry.h>
#import "UIColor+Util.h"
#import <YYKit.h>
//#import "ShouYiHuiZongView.h"
@interface MenologyEarningsVc ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (strong, nonatomic) NSDate *tempDate;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (nonatomic, strong) MonthModel *lastModel;
@property (nonatomic, strong) NSIndexPath *lasIndex;
//@property (nonatomic, strong) ShouYiHuiZongView *shouyiView;
//@property (nonatomic, strong) UIButton *nextMonthBtn;

@property (nonatomic, strong) UILabel *yearLab;
@property (nonatomic, strong) UILabel *monthLab;
@end

@implementation MenologyEarningsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBlackColor];
    self.title = @"收益日历";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *lastYearBtn = [UIButton new];
    [lastYearBtn setTitle:@"<" forState:UIControlStateNormal];
    [lastYearBtn setTitleColor:[UIColor newSecondTextColor] forState:UIControlStateNormal];
    [lastYearBtn addTarget:self action:@selector(lastYear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastYearBtn];
    [lastYearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ChangedHeight(12));
        make.left.equalTo(self.view).offset(ChangedHeight(25));
        make.height.mas_equalTo(ChangedHeight(20));
        make.width.mas_equalTo(ChangedHeight(30));
    }];
    
    self.yearLab = [UILabel new];
    self.yearLab.textColor = [UIColor newSecondTextColor];
    self.yearLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.yearLab];
    [self.yearLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastYearBtn.mas_right);
        make.centerY.equalTo(lastYearBtn);
        make.width.mas_equalTo(ChangedHeight(75));
    }];
    
    
    UIButton *nextYearBtn = [UIButton new];
    [nextYearBtn setTitle:@">" forState:UIControlStateNormal];
    [nextYearBtn setTitleColor:[UIColor newSecondTextColor] forState:UIControlStateNormal];
    [nextYearBtn addTarget:self action:@selector(nextYear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextYearBtn];
    [nextYearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yearLab.mas_right);
        make.centerY.equalTo(lastYearBtn);
        make.height.mas_equalTo(ChangedHeight(20));
        make.width.mas_equalTo(ChangedHeight(30));
    }];
    
    UIButton *lastMonthBtn = [UIButton new];
    [lastMonthBtn setTitle:@"<" forState:UIControlStateNormal];
    [lastMonthBtn setTitleColor:[UIColor newSecondTextColor] forState:UIControlStateNormal];
    [lastMonthBtn addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastMonthBtn];
    [lastMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lastYearBtn);
                make.left.equalTo(nextYearBtn.mas_right).offset(ChangedHeight(2));
                make.height.mas_equalTo(ChangedHeight(20));
                make.width.mas_equalTo(ChangedHeight(30));
    }];
    
    self.monthLab = [UILabel new];
    self.monthLab.textAlignment = NSTextAlignmentCenter;
    self.monthLab.textColor = [UIColor newSecondTextColor];
    [self.view addSubview:self.monthLab];
    [self.monthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastMonthBtn.mas_right);
        make.centerY.equalTo(lastMonthBtn);
        make.width.mas_equalTo(ChangedHeight(75));
    }];
    
    UIButton *nextMonthBtn = [UIButton new];
    [nextMonthBtn setTitle:@">" forState:UIControlStateNormal];
    [nextMonthBtn setTitleColor:[UIColor newSecondTextColor] forState:UIControlStateNormal];
    [nextMonthBtn addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextMonthBtn];
    [nextMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monthLab.mas_right);
        make.centerY.equalTo(lastMonthBtn);
        make.height.mas_equalTo(ChangedHeight(20));
        make.width.mas_equalTo(ChangedHeight(30));
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastMonthBtn.mas_bottom);
        make.left.equalTo(self.view).offset(ChangedHeight(30));
        make.right.equalTo(self.view).offset(ChangedHeight(- 30));
//        make.bottom.equalTo(self.view);
        make.height.mas_equalTo((K_WIDTH - ChangedHeight(60)) / 7 * 6 + 30);
    }];
    
    self.tempDate = [NSDate date];
    self.yearLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.yyyyByDate];
    self.monthLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.MMByDate];
    [self getDataDayModel:self.tempDate];
    
//    self.shouyiView = [ShouYiHuiZongView new];
    
//    [self.view addSubview:self.shouyiView];
//    [self.shouyiView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.collectionView.mas_bottom);
//        make.bottom.equalTo(self.view);
//    }];
}

- (void)lastYear{
    self.tempDate = [self getLastYear:self.tempDate];
    self.yearLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.yyyyByDate];
    self.monthLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.MMByDate];
    [self getDataDayModel:self.tempDate];
}

- (void)nextYear{
    self.tempDate = [self getNextYear:self.tempDate];
    self.yearLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.yyyyByDate];
    self.monthLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.MMByDate];
    [self getDataDayModel:self.tempDate];
}

- (void)lastMonth{
    self.tempDate = [self getLastMonth:self.tempDate];
    self.yearLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.yyyyByDate];
    self.monthLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.MMByDate];
    [self getDataDayModel:self.tempDate];
}

- (void)nextMonth{
    self.tempDate = [self getNextMonth:self.tempDate];
    self.yearLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.yyyyByDate];
    self.monthLab.text = [NSString stringWithFormat:@"%@年",self.tempDate.MMByDate];
    [self getDataDayModel:self.tempDate];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((K_WIDTH - ChangedHeight(60)) / 7, (K_WIDTH - ChangedHeight(60)) / 7);
        flowLayout.headerReferenceSize = CGSizeMake(K_WIDTH, 30);
//        flowLayout.footerReferenceSize = CGSizeMake(K_WIDTH, ChangedHeight(170));
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
//        _collectionView.headv
    }
    return _collectionView;
}

- (void)getDataDayModel:(NSDate *)date{
    NSUInteger days = [self numberOfDaysInMonth:date];
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
            }
            
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayModelArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    cell.dayLabel.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = [UIColor newSecondTextColor];
    cell.bgView.hidden = YES;
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        cell.monthModel = (MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerView" forIndexPath:indexPath];
//        [footerView addSubview:self.shouyiView];
//        [self.shouyiView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(footerView);
//        }];
        return footerView;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.lastModel) {
        self.lastModel.isEarningDay = NO;
    }
    
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        ((MonthModel *)mon).isEarningDay = YES;
        self.lastModel = (MonthModel *)mon;
//        [self.shouyiView setConten:self.lastModel];
    }
    
    [collectionView reloadData];
    
}

#pragma mark -Private
- (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
}

- (NSDate *)firstDateOfMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    comps.day = 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    return comps.weekday;
}

- (NSDate *)getLastYear:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.year -= 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getNextYear:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.year += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getLastMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month -= 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getNextMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)dateOfDay:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


@implementation CalendarHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        UILabel *lastLab = nil;
        for (int i=0; i<weekArray.count; i++) {
            UILabel *weekLabel = [[UILabel alloc] init];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.textColor = [UIColor grayColor];
            weekLabel.font = [UIFont systemFontOfSize:13.f];
            weekLabel.text = weekArray[i];
            [self addSubview:weekLabel];
            [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.width.equalTo(self).dividedBy(weekArray.count * 1.0);
                if (lastLab) {
                    make.left.equalTo(lastLab.mas_right);
                    make.width.equalTo(lastLab);
                }else
                    make.left.equalTo(self);
                
            }];
            lastLab = weekLabel;
        }
    }
    return self;
}
@end

@interface CalendarCell ()

@end
@implementation CalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.bgView = [UIView new];
        self.bgView.layer.cornerRadius = 8;
        self.bgView.hidden = YES;
        self.bgView.layer.borderColor = [UIColor getOrangeColor].CGColor;
        self.bgView.layer.borderWidth = 1;
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(3, 3, 3, 3));
        }];
        
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.layer.masksToBounds = YES;
        self.dayLabel.textColor = [UIColor newSecondTextColor];
        [self.contentView addSubview:self.dayLabel];
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
        [self.dayLabel.superview layoutIfNeeded];
        self.dayLabel.layer.cornerRadius = self.dayLabel.width/2;
        
    }
    return self;
}




- (void)setMonthModel:(MonthModel *)monthModel{
    
    _monthModel = monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld",monthModel.dayValue];
    if (monthModel.isEarningDay) {
        self.dayLabel.backgroundColor = [UIColor redColor];
        self.dayLabel.textColor = [UIColor whiteColor];
    }
    self.bgView.hidden = !monthModel.isSelectedDay;
}
@end


@implementation MonthModel

@end
