//
//  JHRingChart.h
//  JinLingDai
//
//  Created by 001 on 2017/10/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "JHChart.h"
#define k_Width_Scale  (self.frame.size.width / [UIScreen mainScreen].bounds.size.width)

@interface JHRingChart : JHChart

/**
 *  Data source Array
 */
@property (nonatomic, strong) NSArray * valueDataArr;


/**
 *  An array of colors in the loop graph
 */
@property (nonatomic, strong) NSArray * fillColorArray;


/**
 *  Ring Chart width
 */
@property (nonatomic, assign) CGFloat ringWidth;
@end
