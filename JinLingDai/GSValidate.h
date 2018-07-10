//
//  GSValidate.h
//  BaseProject
//
//  Created by HDS on 17/7/14.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *字符的枚举类型
 */

typedef NS_ENUM(NSUInteger, RequireStringType) {
    RequireTypeIsPhone,// 电话
    RequireTypeIsEmail,//email
    RequireTypeIsMobile,//手机
    RequireTypeIsNumber,//数字
    RequireTypeZipCode,//邮政编码
    RequireTypeMoney,//金钱
    RequireTypeIP,//ip地址
    RequireTypeDomain,//域名
    RequireTypePort,//端口号
    RequireTypePositive,//大于0
    RequireTypeInt,//整数
    RequireTypeFloat,//浮点数
    RequireTypeDate,//时间格式
    RequireTypeIdentityCard,//身份证
};


/**
 *封装的检测类
 *将测字符串是否有效
 *过滤字符串中的非法字符，如 空格字符 回车字符
 */

@interface GSValidate : NSObject

/*
 *检查是否有效字符d
 *string 需要判断的字符
 */
+(BOOL)validateIsBlankString:(NSString *)string;

/*
 *过滤特殊字符
 *string 需要判断的字符
 */
+(NSString *)filteringCharactersWithString:(NSString *)string;

/*
 *判断字符是否达到指定的长度
 *string 需要判断的字符
 */

+(BOOL)validateStringLong:(NSString *)string requireMinLong:(NSInteger)minLong;


/*
 *判断字符是否是指定的类型
 *string 需要判断的字符
 *指定的字符类型
 */

+(BOOL)validateString:(NSString *)string withRequireType:(RequireStringType)type;

/*
 验证是否是时间格式
 */

+(BOOL)isValidateDate:(NSString *)string;


@end
