//
//  TitleBarView.h
//  框架整理demo
//
//  Created by 1 on 2017/1/6.
//  Copyright © 2017年 HDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleBarView : UIScrollView

@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, assign) NSUInteger currentIndex;//所选标题键位
@property (nonatomic,assign) BOOL isNeedScroll;//能否滑动
@property (nonatomic, strong) UIColor *currentCollor;//所选中颜色
@property (nonatomic, strong) void (^titleButtonClicked)(NSUInteger index);//标题点击回调

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray*)titles;
/*isNeedScroll用处不大，常用No值，当数据多时本身就是可以滑动，Yes多用于数据少时本身不滑动但要求有滑动的弹簧效果时*/
-(instancetype)initWithFrame:(CGRect)frame
                   andTitles:(NSArray *)titles
               andNeedScroll:(BOOL)isNeedScroll;

- (void)setTitleButtonsColor;

- (void)scrollToCenterWithIndex:(NSInteger)index;

/**重置所有的btn*/
-(void)reloadAllButtonsOfTitleBarWithTitles:(NSArray *)titles;
/**重置所有的btn(上边图片下标题)*/
- (void)reloadAllUpAndDownButtonsOfTitleBarWithTitles:(NSArray *)titles;
@end
