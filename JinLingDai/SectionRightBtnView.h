//
//  SectionRightBtnView.h
//  JinLingDai
//
//  Created by 001 on 2017/6/29.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionRightBtnView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) void(^robBuyBtnClick)();
@end
