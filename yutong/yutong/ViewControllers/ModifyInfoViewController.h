//
//  ModifyInfoViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/27.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UITextField *oldPwText;
@property (weak, nonatomic) IBOutlet UITextField *pwText;
@property (weak, nonatomic) IBOutlet UITextField *rePwText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end
