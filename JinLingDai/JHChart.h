//
//  JHChart.h
//  JinLingDai
//
//  Created by 001 on 2017/10/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHChart : UIView
#define P_M(x,y) CGPointMake(x, y)

#define weakSelf(weakSelf)  __weak typeof(self) weakself = self;
#define XORYLINEMAXSIZE CGSizeMake(CGFLOAT_MAX,30)

/**
 *  The margin value of the content view chart view
 *  图表的边界值
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;


/**
 *  The origin of the chart is different from the meaning of the origin of the chart.
 As a pie chart and graph center ring. The line graph represents the origin.
 *  图表的原点值（如果需要）
 */
@property (assign, nonatomic)  CGPoint chartOrigin;


/**
 *  Name of chart. The name is generally not displayed, just reserved fields
 *  图表名称
 */
@property (copy, nonatomic) NSString * chartTitle;


/**
 *  The fontsize of Y line text.Default id 8;
 */
@property (nonatomic,assign) CGFloat yDescTextFontSize;

/*!
 * if animationDuration <= 0,this chart will display without animation.Default is 2.0;
 */
@property (nonatomic , assign)NSTimeInterval animationDuration;

/**
 *  The fontsize of X line text.Default id 8;
 */
@property (nonatomic,assign) CGFloat xDescTextFontSize;


/**
 *  X, Y axis line color
 */
@property (nonatomic, strong) UIColor * xAndYLineColor;


/**
 *  Start drawing chart.
 */
- (void)showAnimation;

/**
 *  Clear current chart when refresh
 */
- (void)clear;




/**
 Draw a line according to the conditions
 
 @param context context
 @param start start
 @param end end
 @param isDotted isDotted
 @param color color
 */
- (void)drawLineWithContext:(CGContextRef )context
               andStarPoint:(CGPoint )start
                andEndPoint:(CGPoint)end
            andIsDottedLine:(BOOL)isDotted
                   andColor:(UIColor *)color;


/**
 *  Draw a piece of text at a point
 *  @param point：Draw position
 *  @param color：TextColor
 *  @param fontSize：Text font size
 */


/**
 Draw a piece of text at a point
 
 @param text text
 @param context context
 @param point point
 @param color color
 @param fontSize fontSize
 */
- (void)drawText:(NSString *)text
      andContext:(CGContextRef )context
         atPoint:(CGPoint )point
       WithColor:(UIColor *)color
     andFontSize:(CGFloat)fontSize;



/**
 *  Similar to the above method
 *
 */
- (void)drawText:(NSString *)text
         context:(CGContextRef )context
         atPoint:(CGRect )rect
       WithColor:(UIColor *)color
            font:(UIFont*)font;



/**
 *  Determine the width of a certain segment of text in the default font.
 */
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text;



/**
 *  Draw a rectangle at a point
 *  p:Draw position
 *
 */
- (void)drawQuartWithColor:(UIColor *)color
             andBeginPoint:(CGPoint)p
                andContext:(CGContextRef)contex;


/**
 Draw a circle at a point
 
 @param redius Circle redius
 @param color Circle color
 @param p Draw position
 @param contex Circle contex
 */
- (void)drawPointWithRedius:(CGFloat)redius
                   andColor:(UIColor *)color
                   andPoint:(CGPoint)p
                 andContext:(CGContextRef)contex;




/**
 According to the relevant conditions to determine the width of the text
 
 @param maxSize Maximum range of text
 @param fontSize Text font
 @param aimString Text that needs to be measured
 @return CGSize
 */
- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize
                         textFont:(CGFloat)fontSize
                        aimString:(NSString *)aimString;
@end