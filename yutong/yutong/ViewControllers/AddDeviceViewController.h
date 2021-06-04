//
//  AddDeviceViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/23.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"

@interface AddDeviceViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *deviceIdTextField;

//@property (strong, nonatomic) NSMutableArray* deviceArray;
@property (weak, nonatomic) IBOutlet UIImageView *device_bg;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
