//
//  Global.m
//  Pet
//
//  Created by GHM on 13-7-29.
//  Copyright (c) 2013年 GHM. All rights reserved.
//

#import "Global.h"

@implementation Global

+ (Global *)instanse
{
    static Global *_sharedClient = nil;
    static dispatch_once_t onceTokens;
    dispatch_once(&onceTokens, ^{
        _sharedClient = [[Global alloc] init];
    });
    
    return _sharedClient;
}

//打开一个网址
+ (void) OpenUrl:(NSString *)inUrl
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:inUrl]];
}

+(AppDelegate*)AppDelegate
{
    AppDelegate *app=[[UIApplication sharedApplication] delegate];
    return app;
}

+(BOOL)CheckIdentityCardNo:(NSString*)cardNo
{
    
    if(cardNo.length == 15)
    {
        NSString *emailRegex = @"^[0-9]*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:cardNo];
        
        if(sfzNo)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if(cardNo.length == 18)
    {
        NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
        NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
        
        NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
        
        int val;
        BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
        if (!isNum)
        {
            return NO;
        }
        int sumValue = 0;
        
        for (int i =0; i<17; i++)
        {
            sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
        }
        
        NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
        
        if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]])
        {
            return YES;
        }
    }
    return  NO;
}

- (void)setUserType:(NSInteger)userType
{
    _userType = userType;
}
////获取上个月当天
//+ (NSDate*) lastMonth:(NSDate*) date
//{   
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSDateComponents *components = [calendar components:unitFlags fromDate:date];    
//    [components setMonth:([components month] - 1)];
//    NSDate *lastMonth = [calendar dateFromComponents:components];
//    
//    //begin test=====================================
//    NSLog(@"preMonth = %@", lastMonth);
//    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"YYYY-MM-dd"];
//    NSString* str = [formater stringFromDate:lastMonth];
//    NSLog(@"preMonth = %@", str);
//    //end test=====================================
//    
//    return lastMonth;
//}
//
////获取一个月的天数
//+ (NSInteger) numberOfDaysInMonth:(NSDate*) date
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSRange range =[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate: date];
//    NSUInteger numberOfDaysInMonth = range.length;
//    return numberOfDaysInMonth;
//}
//
////获取一周的第一天
//+ (NSDate*) firstDayOfWeek:(NSDate*) date
//{
//
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate *today = [[NSDate alloc] init];
//
//    NSDate *beginningOfWeek = nil;
//
//    [gregorian rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek interval:NULL forDate: today];
//    
//    return beginningOfWeek;
//}
//
////获取年份
//+ (NSInteger) getYear:(NSDate*) date
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
//    NSInteger iCurYear = [components year];
//    
//    return iCurYear;
//}
//
////获取月份
//+ (NSInteger) getMonth:(NSDate*) date
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
//    NSInteger iCurMonth = [components month];    
//    return iCurMonth;
//}
//
////获取号
//+ (NSInteger) getDay:(NSDate*) date
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
//    NSInteger iCurDay = [components day];  
//    return iCurDay;
//}

@end
