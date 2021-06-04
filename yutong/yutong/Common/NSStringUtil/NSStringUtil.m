//
//  NSStringUtil.m
//  TarBar
//
//  Created by 刘 勇斌 on 13-4-14.
//  Copyright (c) 2013年 刘 勇斌. All rights reserved.
//

#import "NSStringUtil.h"
#import <MapKit/MapKit.h>

@implementation NSStringUtil
+(BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(BOOL)str1IsEqualToStr2:(NSString *)str1 string2:(NSString *)str2{
    if (str1==nil || str2==nil) {
        return NO;
    }
    return [str1 isEqualToString:str2];
}
//判定用户之前是否已经选择了重复周期
+(BOOL)containString:(NSString *)allString childString:(NSString *) childString{
    if (allString && childString) {
        if ([allString rangeOfString:childString].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

+(double)distanceBetweenOrderBy:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2{
//    double dd = M_PI/180;
//    double x1=lat1*dd,x2=lat2*dd;
//    double y1=lng1*dd,y2=lng2*dd;
//    double R = 6371004;
//    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
//    //返回 m
//    return distance/1000;
    
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    
    NSLog(@"%f lat1", lat1);
    NSLog(@"%f lng1", lng1);
    
    NSLog(@"%f lat2", lat2);
    NSLog(@"%f lng2", lng2);
    
    NSLog(@"%f distance", distance);

    return distance/1000;
}

/*密码验证 MODIFIED BY HELENSONG 密码必须大于7位  而且包含字母*/
+(BOOL)isValidatePassword:(NSString *)password
{
    NSString *passwordRegex = @"(.*[a-zA-Z]+.*[0-9]+.*)|(.*[0-9]+.*[a-zA-Z]+.*)";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:password];
}

/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,2,5-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

//+(NSString *)getXingzuo:(NSString *)dateString{
//    //计算星座
//    NSDate *inDate = [NSDateUtils dateFromString:dateString];
//    NSString *retStr=@"";
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"MM"];
//    int monthInt=0;
//    NSString *theMonth = [dateFormat stringFromDate:inDate];
//    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
//        monthInt = [[theMonth substringFromIndex:1] intValue];
//    }else{
//        monthInt = [theMonth intValue];
//    }
//    
//    [dateFormat setDateFormat:@"dd"];
//    int dayInt=0;
//    NSString *theDay = [dateFormat stringFromDate:inDate];
//    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
//        dayInt = [[theDay substringFromIndex:1] intValue];
//    }else{
//        dayInt = [theDay intValue];
//    }
//    /*
//     摩羯座 12月22日------1月19日
//     水瓶座 1月20日-------2月18日
//     双鱼座 2月19日-------3月20日
//     白羊座 3月21日-------4月19日
//     金牛座 4月20日-------5月20日
//     双子座 5月21日-------6月21日
//     巨蟹座 6月22日-------7月22日
//     狮子座 7月23日-------8月22日
//     处女座 8月23日-------9月22日
//     天秤座 9月23日------10月23日
//     天蝎座 10月24日-----11月21日
//     射手座 11月22日-----12月21日
//     */
//    if (monthInt == 1) {
//        if (dayInt > 0 && dayInt < 20) {
//            retStr=@"摩羯座";
//        }
//        if (dayInt > 21 &&dayInt < 31) {
//            retStr=@"水瓶座";
//        }
//        return retStr;
//    }
//    if (monthInt == 2) {
//        if (dayInt > 0 && dayInt < 19) {
//            retStr=@"水瓶座";
//        }
//        if (dayInt > 20 && dayInt < 30) {
//            retStr=@"双鱼座";
//        }
//        return retStr;
//    }
//    if (monthInt == 3) {
//        if (dayInt > 0 && dayInt < 21) {
//            retStr=@"双鱼座";
//        }
//        if (dayInt > 20 && dayInt < 32) {
//            retStr=@"白羊座";
//        }
//        return retStr;
//    }
//    if (monthInt == 4) {
//        if (dayInt > 0 && dayInt < 20) {
//            retStr=@"白羊座";
//        }
//        if (dayInt > 19 && dayInt < 31) {
//            retStr=@"金牛座";
//        }
//        return retStr;
//    }
//    if (monthInt == 5) {
//        if (dayInt > 0 && dayInt < 21) {
//            retStr=@"金牛座";
//        }
//        if (dayInt > 22 && dayInt < 32) {
//            retStr=@"双子座";
//        }
//        return retStr;
//    }
//    if (monthInt == 6) {
//        if (dayInt > 0 && dayInt < 22) {
//            retStr=@"双子座";
//        }
//        if (dayInt > 21 && dayInt < 31) {
//            retStr=@"巨蟹座";
//        }
//        return retStr;
//    }
//    if (monthInt == 7) {
//        if (dayInt > 0 && dayInt < 23) {
//            retStr=@"巨蟹座";
//        }
//        if (dayInt > 22 && dayInt < 32) {
//            retStr=@"狮子座";
//        }
//        return retStr;
//    }
//    if (monthInt == 8) {
//        if (dayInt > 0 && dayInt < 23) {
//            retStr=@"狮子座";
//        }
//        if (dayInt > 22 && dayInt < 32) {
//            retStr=@"处女座";
//        }
//        return retStr;
//    }
//    if (monthInt == 9) {
//        if (dayInt > 1 && dayInt < 23) {
//            retStr=@"处女座";
//        }
//        if (dayInt > 22 && dayInt < 31) {
//            retStr=@"天平座";
//        }
//        return retStr;
//    }
//    if (monthInt == 10) {
//        if (dayInt > 0 && dayInt < 24) {
//            retStr=@"天平座";
//        }
//        if (dayInt > 23 && dayInt < 32) {
//            retStr=@"天蝎座";
//        }
//        return retStr;
//    }
//    if (monthInt == 11) {
//        if (dayInt > 0 && dayInt < 22) {
//            retStr=@"天蝎座";
//        }
//        if (dayInt > 21 && dayInt < 31) {
//            retStr=@"摩羯座";
//        }
//        return retStr;
//    }
//    if (monthInt == 12) {
//        if (dayInt > 1 && dayInt < 22) {
//            retStr=@"水瓶座";
//        }
//        if (dayInt > 21 && dayInt < 32) {
//            retStr=@"摩羯座";
//        }
//        return retStr;
//    }
//    return  retStr;
//}

+(NSString *)convertToString:(NSArray *)array{
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i=0; i<[array count]; i++) {
        NSString *str1 = [array objectAtIndex:i];
        [str appendFormat:@"%@",str1];
        if (i<[array count]-1) {
            [str appendString:@","];
        }
    }
    return str;
}
+(NSMutableArray *)convertToArray:(NSString *)arrayString{
    if ([self isBlankString:arrayString]) {
        return [[NSMutableArray alloc]init];
    }
    return [NSMutableArray arrayWithArray:[arrayString componentsSeparatedByString:NSLocalizedString(@",", nil)]];
}
@end







