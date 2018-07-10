//
//  SectionHeadValue1View.h
//  JinLingDai
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowModel.h"
//一图片，左右各一个lab
@interface SectionHeadValue1View : UITableViewHeaderFooterView
@property (nonatomic, copy) void(^SectionHeadClickedBlock)();
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *greenHandsImg;
- (void)setcontentView:(ListModel *)item;
@end
