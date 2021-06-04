//
//  SocketManager.h
//  yutong
//
//  Created by Gao Haiming on 16/3/2.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncSocket.h"

@interface SocketManager : AsyncSocket

+ (SocketManager *)instanse;

@end
