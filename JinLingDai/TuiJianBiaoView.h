//
//  TuiJianBiaoView.h
//  JinLingDai
//
//  Created by 001 on 2017/8/16.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowModel.h"


@interface TuiJianBiaoView : UIView
@property (nonatomic, copy) void(^biaoClickedBlock)(NSString *BorrowId);
- (void)setBiaoContenView:(ListModel *)item;
@end

