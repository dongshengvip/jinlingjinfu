//
//  GSCollectionVc.m
//  BaseProject
//
//  Created by HDS on 17/7/14.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "GSValidate.h"


@implementation GSValidate

/*
 *验证是否是空字符
 *string 要验证的字符串
 */
+(BOOL)validateIsBlankString:(NSString *)string
{
    if (string == nil) {
        
        return YES;
    }
    
    if (string == NULL) {
        
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return YES;
    }
    
    return NO;
}

/*
 *过滤掉特殊字符
 *string 要验证的字符串
 */
+(NSString *)filteringCharactersWithString:(NSString *)string
{
    //过滤掉特殊字符
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\f" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\\/" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}


/*
 *验证字符串是否达到指定的长度
 *string 要验证的字符串
 * minLong 指定的最小长度
 */
+(BOOL)validateStringLong:(NSString *)string requireMinLong:(NSInteger)minLong
{
    if(string.length<minLong){
        
        return NO;
    }else{
        
        return YES;
    }
    
    return NO;
}


/*
 *验证字符串是否达到某种类型
 *string 要验证的字符串
 * type 指定的类型
 */
+(BOOL)validateString:(NSString *)string withRequireType:(RequireStringType)type
{
    BOOL result = NO;

    if(type == RequireTypeIsPhone){
        //是否是座机
        return result = [GSValidate isValidateTel:string];
        
    }else if (type == RequireTypeIsMobile){
        
        // 是否是手机号
        return  result = [GSValidate isValidateMobile:string];

    }else if (type == RequireTypeIsEmail){
        // 是否是email
        
        return  result = [GSValidate isValidateEmail:string];
        
    }else if (type == RequireTypeZipCode){
        //是否是邮编
        
        return  result = [GSValidate isVaildZipCode:string];
        
    }else if (type == RequireTypeIsNumber){
        //是否是数字
        
        return result = [GSValidate isValidateNumber:string];
        
    }else if (type == RequireTypeMoney){
        
        //是否是金钱
        return result = [GSValidate isValidateMoney:string];
    }else if (type == RequireTypeIP){
        //是否是ip地址
        return result = [GSValidate isValidateIP:string];

        
    }else if (type == RequireTypeDomain){
        //是否是域名
        return result = [GSValidate isValidateDomain:string];
        
    }else if (type == RequireTypePort){
        
        return result = [GSValidate isValidatePort:string];

    }else if (type == RequireTypePositive){
        
        return result = [GSValidate isValidatePositive:string];
        
    }else if (type == RequireTypeInt){
        
        return result = [GSValidate isValidateInt:string];

    }else if (type == RequireTypeFloat){
        
        return result  = [GSValidate isValidateFloat:string];
        
    }else if (type == RequireTypeDate){
        
        return result  = [GSValidate isValidateDate:string];

    }else if (type == RequireTypeIdentityCard){
        
        //身份证
        return result = [GSValidate chk18PaperId:string];
    }
    
    return NO;
}

/*
 *判断端口号
*/
+(BOOL)isValidatePort:(NSString *)text
{
    NSString *reg = @"^([1-9]\\d{0,3}|[1-5]\\d{4}|6[0-5]{2}[0-3][0-5])(-([1-9]\\d{0,3}|[1-5]\\d{4}|6[0-5]{2}[0-3][0-5]))?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [predicate evaluateWithObject:text];
}


/*
 *判断域名
 */

+(BOOL)isValidateDomain:(NSString *)text{
    NSString *reg = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [predicate evaluateWithObject:text];
}





/*
 *判断IP
 */

+(BOOL)isValidateIP:(NSString *)text{
    NSString *reg = @"(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [predicate evaluateWithObject:text];
}


/*
 *判断金钱
 */
+(BOOL)isValidateMoney:(NSString *)text{
//    NSString *reg = @"\\d+(\\.\\d*)?$";
    NSString *reg = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,7}(([.]\\d{0,2})?)))?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [predicate evaluateWithObject:text];
}


/*
 *验证座机
 */
+(BOOL) isValidateTel:(NSString *)tel
{
    NSString *telRegex = @"^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",telRegex];
    return [telTest evaluateWithObject:tel];
    
}


/*
 *验证邮编
 
 */
+(BOOL)isVaildZipCode:(NSString *)value
{
    const char *cvalue = [value UTF8String];
    long len = strlen(cvalue);
    if(len!=6){
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}


/*
 *验证邮箱
 
 */
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

/*
 *验证手机号
 
 */
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以 13 18 15 17  开头
    NSString *phoneRegex = @"^1[0-9][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


/*
 *验证数字
 
 */
+(BOOL)isValidateNumber:(NSString *)text
{
    NSString *reg = @"\\d+(\\d*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [predicate evaluateWithObject:text];
}


/*
 验证数据是否大于0
  
 */

+(BOOL)isValidatePositive:(NSString *)text
{
    NSInteger count = [text integerValue];
    if(count>=0){
        return YES;
    }
    return NO;
}

/*
 判断数据是否是整数
 
 */
+(BOOL)isValidateInt:(NSString*)string
{
    NSString *reg = @"/^\\d+(\\.{0,1}\\d+){0,1}$/";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return [predicate evaluateWithObject:string];

}

/*
 判断是否为浮点形：
 
 */

+(BOOL)isValidateFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

/*
 验证是否是时间格式
 
 */

+(BOOL)isValidateDate:(NSString *)string
{
    NSString *reg = @"^(?:\\d{4}(0[1-9]|[1][0-2])([1-9]|[0][1-9]|[1-2]\\d|3[0-1]))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return [predicate evaluateWithObject:string];

}

/*
 
 验证身份证是否合法
 
 */

+(BOOL)chk18PaperId:(NSString *) sPaperId

{
    
    //判断位数
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    
    long lSumQT =0;
    
    //加权因子
    
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    
    if ([sPaperId length] == 15) {
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
            
        {
            
            p += (pid[i]-48) * R[i];
            
        }
        
        int o = p%11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
        
    }
    
    //判断地区码
    
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![GSValidate areaCode:sProvince]) {
        
        return NO;
        
    }
    
    //判断年月日是否有效
    //年份
    int strYear = [[GSValidate getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[GSValidate getStringWithRange:carid Value1:10 Value2:2] intValue];
    
    //日
    int strDay = [[GSValidate getStringWithRange:carid Value1:12 Value2:2] intValue];
    

    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        
        return NO;
        
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    
    if( 18 != strlen(PaperId)) return -1;
    
    //校验数字
    
    for (int i=0; i<18; i++)
        
    {
        
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
            
        {
            
            return NO;
            
        }
        
    }
    
    //验证最末的校验码
    
    for (int i=0; i<=16; i++)
        
    {
        
        lSumQT += (PaperId[i]-48) * R[i];
        
    }
    
    if (sChecker[lSumQT%11] != PaperId[17] )
        
    {
        
        return NO;
        
    }
    return YES;
    
}


/**
 
 * 功能:判断是否在地区码内
 * 参数:地区码
 
 */

+(BOOL)areaCode:(NSString *)code

{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
        
    }
    
    return YES;
    
}


+(NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger )value1 Value2:(NSInteger )value2;

{
    
    return [str substringWithRange:NSMakeRange(value1,value2)];
    
}


@end
