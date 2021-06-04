//
//  DBManager.h
//  yutong
//
//  Created by iOS01iMac on 16/2/24.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

@interface DBManager : NSObject


@property (strong,nonatomic) FMDatabase *db;

+ (DBManager *)instanse;

- (void) initDataBase;

- (BOOL) insertDevice: (NSString*)deviceId;

- (BOOL) upDateDevice: (NSString*)deviceType DeviceId:(NSString*) deviceId;

- (BOOL) deleteDevice:(NSString*) deviceId;

- (NSMutableArray*) devices;

@end
