//
//  ShutDownViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/24.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"

#import "SocketManager.h"

@interface ShutDownViewController : BaseViewController
{
    NSInteger _deviceStatus;
    NSInteger _seconds;
    
     SocketManager* _asyncSocket;
}

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (strong, nonatomic) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (assign, nonatomic) NSInteger val1;
@property (assign, nonatomic) NSInteger val2;
@property (assign, nonatomic) NSInteger val3;
@property (assign, nonatomic) NSInteger status;

@property (assign, nonatomic) NSInteger requestType;
@property (weak, nonatomic) IBOutlet UIImageView *logoimage;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@property (assign, nonatomic) NSInteger value3;
@property (assign, nonatomic) NSInteger value4;

@end
