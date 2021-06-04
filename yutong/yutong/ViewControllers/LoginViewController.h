//
//  LoginViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/24.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"
#import "SocketManager.h"



@interface LoginViewController : BaseViewController
{
    SocketManager* _asyncSocket;

}

@property (weak, nonatomic) IBOutlet UITextField *deivceText;
@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UITextField *pwText;

@property (strong, nonatomic) NSMutableDictionary* deviceDic;


@end
