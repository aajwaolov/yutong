//
//  MobileFridgeViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/27.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"
#import "SocketManager.h"

@interface MobileFridgeViewController : BaseViewController
{
    SocketManager* _asyncSocket;
    BOOL firstFlag;
    
    NSInteger _requestType;
}

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (strong, nonatomic) UIImageView* moreFucBg;
@property (strong, nonatomic) UIView* bgView;
@property (weak, nonatomic) IBOutlet UILabel *device1Status;
@property (weak, nonatomic) IBOutlet UILabel *device2Status;
@property (weak, nonatomic) IBOutlet UILabel *voltage;

//@property (weak, nonatomic) IBOutlet UILabel *deviceStatus;
//@property (weak, nonatomic) IBOutlet UILabel *voletStatus;
@property (weak, nonatomic) IBOutlet UILabel *errorCode;
@property (weak, nonatomic) IBOutlet UIImageView *ensbyxztBg;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *labelup;
@property (weak, nonatomic) IBOutlet UILabel *labelMidlle;
@property (weak, nonatomic) IBOutlet UILabel *labeldown;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelRight;

@end
