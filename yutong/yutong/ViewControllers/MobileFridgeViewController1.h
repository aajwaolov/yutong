//
//  MobileFridgeViewController1.h
//  yutong
//
//  Created by iOS01iMac on 16/2/25.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"
#import "AsyncSocket.h"

@interface MobileFridgeViewController1 : BaseViewController
{
    AsyncSocket* _asyncSocket;
    BOOL _firstFlag;
}

@property (strong, nonatomic) UIView* bgView;
@property (strong, nonatomic) UIImageView* moreFucBg;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
