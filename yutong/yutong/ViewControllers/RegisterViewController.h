//
//  RegisterViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/24.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"
#import "AsyncSocket.h"
#import "GPickerView.h"

@interface RegisterViewController : BaseViewController<UITextFieldDelegate, GPickViewDelegate>
{
    AsyncSocket* _asyncSocket;
    
}

@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UITextField *userTypeText;
@property (weak, nonatomic) IBOutlet UITextField *pwText;
@property (weak, nonatomic) IBOutlet UITextField *rePwText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *deviceText;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollBg;

@property (strong, nonatomic) NSString* deviceId;

@property (weak, nonatomic) IBOutlet UIButton *changerUserTypeBtn;

@property (weak, nonatomic) IBOutlet UIView *registerBg;
@property (weak, nonatomic) IBOutlet UITextField *registerCodeText;

@property (weak, nonatomic) IBOutlet UIImageView *registerCodeBg;
@property (assign) NSInteger userType;

@end
