//
//  NSStringUtil.h
//  TarBar
//
//  Created by 刘 勇斌 on 13-4-14.
//  Copyright (c) 2013年 刘 勇斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringUtil : NSObject
/*
 判断字符串是否为空
 */
+(BOOL) isBlankString:(NSString *)string;
/*
 判断字符串是否相等
 */
+(BOOL)str1IsEqualToStr2:(NSString *)str1 string2:(NSString *)str2;
+(BOOL)containString:(NSString *)allString childString:(NSString *) childString;
+(double)distanceBetweenOrderBy:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL) isValidateMobile:(NSString *)mobile;
+(BOOL)isValidatePassword:(NSString *)password;
//+(NSString *)getXingzuo:(NSString *)dateString;
+(NSString *)convertToString:(NSArray *)array;
+(NSMutableArray *)convertToArray:(NSString *)arrayString;
@end
