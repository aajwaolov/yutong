//
//  Global.h
//  Pet
//
//  Created by GHM on 13-7-29.
//  Copyright (c) 2013年 GHM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Global : NSObject

@property (assign, nonatomic) NSInteger deviceType;
@property (assign, nonatomic) NSInteger userType;

@property (strong, nonatomic) NSMutableDictionary* deviceDic;

+ (Global *)instanse;

+(AppDelegate*)AppDelegate;
//+ (NSDate*) lastMonth:(NSDate*) now;
//+ (NSInteger) numberOfDaysInMonth:(NSDate*) date;
//+ (BOOL) CheckIdentityCardNo:(NSString*)cardNo;

@end
