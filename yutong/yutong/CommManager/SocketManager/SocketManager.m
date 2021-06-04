//
//  SocketManager.m
//  yutong
//
//  Created by Gao Haiming on 16/3/2.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "SocketManager.h"

@implementation SocketManager

+ (SocketManager *)instanse
{
    static SocketManager *_sharedClient = nil;
    static dispatch_once_t onceTokens;
    dispatch_once(&onceTokens, ^{
        _sharedClient = [[SocketManager alloc] init];
    });
    
    return _sharedClient;
}

@end
