//
//  RegisterViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/24.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "RegisterViewController.h"
#import "CommonNetworkDefine.h"
#import "NSStringUtil.h"
#import "SocketManager.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *currentField;
@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Register";
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(editResign)];
    [self.view addGestureRecognizer:tap];

    _mobileText.delegate = self;
    _pwText.delegate = self;
    _rePwText.delegate = self;
    _addressText.delegate = self;
    _registerCodeText.delegate = self;
    _emailText.delegate = self;
    _deviceText.delegate = self;
    _deviceText.enabled = NO;
    _deviceText.text = _deviceId;
    
    _userType = 1;
//    [_changerUserTypeBtn setTitle:@"Average User" forState:UIControlStateNormal];
}

- (IBAction)changeUserType:(id)sender
{
    if (self.currentField) {
        [self.currentField resignFirstResponder];
    }
    GPickerView* pickerView = [[GPickerView alloc]initWithFrame:self.view.frame];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    
    [pickerView show];
}

#pragma mark -- GPickviewDelegate

- (NSInteger)numberOfComponentsInPickerView:(GPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(GPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(GPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row)
    {
        case 0:
        {
            return @"Average user";
        }
            
        case 1:
        {
            return @"Specialized users";
        }
            
        default:
            break;
    }
    return nil;
}

- (void) pickResult:(NSArray*) pickerArray
{
    NSNumber* num = [pickerArray objectAtIndex:0];
    
    switch (num.intValue)
    {
        case 0:
        {
            _registerCodeBg.alpha = 0;
            _userType = 0;
            [_changerUserTypeBtn setTitle:@"Average user" forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            _registerCodeBg.alpha = 1;
            _userType = 1;
            [_changerUserTypeBtn setTitle:@"Specialized users" forState:UIControlStateNormal];
            
//            _registerCodeBg.alpha = 1;
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)beginRegister:(id)sender
{
    _asyncSocket = [SocketManager instanse];
    [_asyncSocket disconnect];
    _asyncSocket.delegate = self;
    NSError *err = nil;
    [self showProgress];
    if(![_asyncSocket connectToHost:ROUTER_TCP_IP onPort:ROUTER_TCP_Port error:&err])
    {
        NSLog(@"Error: %@", err);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"网络连接失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        [self hideProgress];
        
        return;
    }
}

- (NSString*) requestData
{
    NSString* reqestSting;
    
    if(_userType == 1)
    {
        reqestSting = [NSString stringWithFormat:@"JTZNBX2015#register#%@#%@#%@#%@#%@#%@#",
                                 _mobileText.text,
                                 @"1111",
                                 _registerCodeText.text,
                                 _pwText.text,
                                 _emailText.text,
                                 _deviceId];
    }
    else
    {
        reqestSting = [NSString stringWithFormat:@"JTZNBX2015#register#%@#%@#%@#%@#%@#%@#",
                       _mobileText.text,
                       @"0",
                       @"1111",
                       _pwText.text,
                       _emailText.text,
                       _deviceId];
    }
    
    return reqestSting;
}

- (BOOL) checkData
{
    [self hideProgress];
    if(![NSStringUtil isValidateMobile:_mobileText.text])
    {
        [self showHint:@"Please enter right mobile phone!"];
        return NO;
    }
    
    if(_userType == 1)
    {
        if([NSStringUtil isBlankString:_registerCodeText.text])
        {
            [self showHint:@"Please enter register code!"];
            return NO;
        }
    }
    
    if([_pwText.text length] != 6)
    {
        [self showHint:@"Please enter the 6 digit password!"];
        return NO;
    }
    
    if(![_pwText.text isEqualToString:_rePwText.text])
    {
        [self showHint:@"两次密码不一致!"];
        return NO;
    }
    
    if(![NSStringUtil isValidateEmail:_emailText.text])
    {
        [self showHint:@"邮件格式不对!"];
        return NO;
    }
    return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);

    if ([self checkData]) {
        NSString* requestStr = [self requestData];
        NSLog(@"tempStr = %@", requestStr);
        NSData* data = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
        [_asyncSocket writeData:data withTimeout:-1 tag:2];
        [_asyncSocket readDataWithTimeout:30 tag:2];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_HUD hide:YES];
        });
    }
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"aStr===%@",aStr);
    
    [_HUD hide:YES];
    
    if([aStr isEqualToString:@"SUCCESS"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self hideProgress];
        [self showHint:@"register failed!"];
    }
    [_asyncSocket disconnect];
}

- (void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"thread(%@,onSocket:%p didWriteDataWithTag:%ld", @"gggg",sock,tag);
}

- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
    NSLog(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"connect error!";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
    [_HUD hide:YES];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //断开连接了
    NSLog(@"onSocketDidDisconnect:%p", sock);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    if((textField == _pwText) || (textField == _registerCodeText))
    {
        [_scrollBg setContentOffset:CGPointMake(0, 130) animated:YES];
    }
    
    if((textField == _rePwText) || (textField == _emailText) || (textField == _addressText))
    {
        [_scrollBg setContentOffset:CGPointMake(0, 260) animated:YES];
    }
    return YES;
}

- (void) editResign
{
    [_mobileText resignFirstResponder];
    [_userTypeText resignFirstResponder];
    [_pwText resignFirstResponder];
    [_rePwText resignFirstResponder];
    [_addressText resignFirstResponder];
    [_registerCodeText resignFirstResponder];
    [_emailText resignFirstResponder];
    [_deviceText resignFirstResponder];
    
    [_scrollBg setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
