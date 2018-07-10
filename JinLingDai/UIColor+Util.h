//
//  UIColor+Util.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

//+ (UIColor *)themeColor;
//+ (UIColor *)nameColor;
#pragma  mark - 主颜色
+ (UIColor *)titleColor;
#pragma mark - 分割线
+ (UIColor *)separatorColor;
//+ (UIColor *)cellsColor;
//+ (UIColor *)titleBarColor;
//+ (UIColor *)selectTitleBarColor;
//+ (UIColor *)navigationbarColor;
//+ (UIColor *)selectCellSColor;
//+ (UIColor *)labelTextColor;
//+ (UIColor *)teamButtonColor;
#pragma mark - 背景色
+ (UIColor *)infosBackViewColor;
//+ (UIColor *)lineColor;

//+ (UIColor *)contentTextColor;
//全局的浅颜色
+ (UIColor *)borderColor;
//+ (UIColor *)refreshControlColor;

/* 新版颜色 */
/* 新 cell.contentView 背景色*/
+ (UIColor *)newCellColor;
/* 新“综合”页面cell.titleLable 标题字体颜色*/
//+ (UIColor *)newTitleColor;
/* 新section 问答 按钮选中颜色*/
//+ (UIColor *)newSectionButtonSelectedColor;
/* 新 分割线*/
+ (UIColor *)newSeparatorColor;
/* 次要文字颜色 */
#pragma mark - 次要文字
+ (UIColor *)newSecondTextColor;
/* 辅助文字颜色 */
#pragma mark - 提示性文字
+ (UIColor *)tipTextColor;
/*根据GRB获取颜色*/
+ (UIColor *)getColor:(CGFloat)R G:(CGFloat)G B:(CGFloat)B;
/*获取主要的橘黄颜色*/
+ (UIColor *)getOrangeColor;
/*获取主要的蓝颜色*/
+ (UIColor *)getBlueColor;
@end
