//
//  ImgTitleRightLabCell.h
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
typedef NS_ENUM(NSInteger,CellStyle) {
    NSCellDefulet,
    NSCellValue1,
};

@interface ImgTitleRightLabCell : UITableViewCell

@property (nonatomic, assign) CellStyle CellType;
@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *rightLab;

- (void)layoutContent:(MessageModel *)item;
@end
