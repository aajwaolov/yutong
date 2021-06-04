//
//  DBManager.m
//  yutong
//
//  Created by iOS01iMac on 16/2/24.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "DBManager.h"

#import "CommonDefine.h"


const static NSString* kDeviceTableName = @"device_table";
const static NSString* kID = @"ID";
const static NSString* kDBDeviceID = @"device_id";
const static NSString* kDBDeviceType = @"device_type";


@implementation DBManager

+ (DBManager *)instanse
{
    static DBManager *_sharedClient = nil;
    static dispatch_once_t onceTokens;
    dispatch_once(&onceTokens, ^{
        _sharedClient = [[DBManager alloc] init];
    });
    
    return _sharedClient;
}

- (void) initDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    
    NSLog(@"dbPath = %@", dbPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    _db = [FMDatabase databaseWithPath:dbPath] ;
    
    if(![fileManager fileExistsAtPath:dbPath]) //如果不存在
    {
        if (![_db open])
        {
            NSLog(@"Could not open db.");
            return ;
        }
        
        [self CreateTables];
    }
    else
    {
        if (![_db open])
        NSLog(@"Could not open db.");
    }
}

- (void) CreateTables
{
    [self CreateDeviceTable];
}

- (void) CreateDeviceTable
{
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT UNIQUE NOT NULL, '%@' TEXT)",kDeviceTableName,kID,kDBDeviceID,kDBDeviceType];
    BOOL res = [_db executeUpdate:sqlCreateTable];
    if (!res)
    {
        NSLog(@"error when creating db table");
    }
    else
    {
        NSLog(@"success to creating db table");
    }
}

- (BOOL) insertDevice: (NSString*)deviceId
{
    NSString* sqlInsertSql= [NSString stringWithFormat:
                           @"INSERT INTO '%@' ('%@') VALUES ('%@')",
                           kDeviceTableName, kDBDeviceID, deviceId];
    BOOL res = [_db executeUpdate: sqlInsertSql];
    
    if (!res)
    {
        NSLog(@"error when insert db table");
    }
    else
    {
        NSLog(@"success to insert db table");
    }
    
    return res;
}

- (BOOL) upDateDevice: (NSString*)deviceType DeviceId:(NSString*) deviceId
{
    NSString* sqlInsertSql= [NSString stringWithFormat:
                             @"UPDATE '%@' SET %@ = '%@' WHERE %@ = '%@'",
                             kDeviceTableName, kDBDeviceType, deviceType, kDBDeviceID, deviceId];
//    BOOL res = [_db executeUpdate: sqlInsertSql];
    NSError *error = nil;
    [_db executeUpdate:sqlInsertSql values:nil error:&error];
    if (error) {
        NSLog(@"error when insert db table");
        return NO;
    } else {
        NSLog(@"success to insert db table");
        return YES;
    }
}

- (BOOL) deleteDevice:(NSString*) deviceId
{
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from %@ where %@ = '%@'",
                           kDeviceTableName, kDBDeviceID, deviceId];
    BOOL res = [_db executeUpdate:deleteSql];
    
    if (!res)
    {
        NSLog(@"error when delete db table");
    }
    else
    {
        NSLog(@"success to delete db table");
    }
    return res;
}

- (NSMutableArray*) devices
{
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@",kDeviceTableName];
    FMResultSet * rs = [_db executeQuery:sql];
    
    NSMutableArray* deviceArray = [NSMutableArray arrayWithCapacity:1];
    while ([rs next])
    {
        NSMutableDictionary* deviceDic = [NSMutableDictionary dictionaryWithCapacity:1];
        NSString * deviceId = [rs stringForColumn:(NSString*)kDBDeviceID];
        NSString * deviceType = [rs stringForColumn:(NSString*)kDBDeviceType];
        
        [deviceDic setObject:deviceId forKey:kDeviceId];
        if([deviceType length] > 0)
        {
            [deviceDic setObject:deviceType forKey:kDeviceType];
        }
        else
        {
            [deviceDic setObject:@"" forKey:kDeviceType];
        }
        [deviceArray addObject:deviceDic];
    }
    
    return deviceArray;
}

- (void) dealloc
{
    [_db close];
}

@end
