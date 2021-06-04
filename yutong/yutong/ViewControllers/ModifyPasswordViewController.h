//
//  ModifyPasswordViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/27.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyPasswordViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeText;
@property (weak, nonatomic) IBOutlet UITextField *pwText;
@property (weak, nonatomic) IBOutlet UITextField *reNewPwText;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollBg;

@end
