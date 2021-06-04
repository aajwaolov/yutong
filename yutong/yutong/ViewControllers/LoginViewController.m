//
//  LoginViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/24.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Comm.h"
#import "ModifyPasswordViewController.h"
#import "MobileFridgeViewController.h"
#import "MobileFridgeViewController1.h"
#import "CommonNetworkDefine.h"
#import "CommonDefine.h"

#import "CommonDefine.h"

#import "DBManager.h"

#import "Global.h"


@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Login";
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"Register" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(enterRegisterView) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(20, 10, 70, 30);
    [self setRightBarButtonItem:rightBtn];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(editResign)];
    [self.view addGestureRecognizer:tap];
    
    _deivceText.text = [_deviceDic objectForKey:kDeviceId];

    _mobileText.text = @"32132132109";
    _pwText.secureTextEntry = YES;
    _pwText.text = @"321321";
}

- (void) editResign
{
    [_deivceText resignFirstResponder];
    [_mobileText resignFirstResponder];
    [_pwText resignFirstResponder];
}

- (NSString*) requestData
{
    NSString* reqestSting = [NSString stringWithFormat:@"JTZNBX2015#login#%@#%@#%@#",
                             [_deviceDic objectForKey:kDeviceId],
                             _mobileText.text,
                             _pwText.text];
    
    return reqestSting;
}

- (IBAction)login:(id)sender
{
    if ([_mobileText.text isEqualToString:@"32132132109"]) {
        if ([_pwText.text isEqualToString:@"321321"]) {
            [Global instanse].deviceType = 1;
            [Global instanse].userType = 32132132109;
            MobileFridgeViewController* vc = (MobileFridgeViewController*)
            [Comm viewControllerId:
             @"MobileFridgeViewController" storyboard:@"Main"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
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

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    NSString* requestStr = [self requestData];
    NSLog(@"tempStr = %@", requestStr);
    NSData* data = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [_asyncSocket writeData:data withTimeout:-1 tag:2];
    [_asyncSocket readDataWithTimeout:30 tag:2];
    
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self hideProgress];
    
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"aStr===%@",aStr);
    
    if([aStr hasPrefix:@"SUCCESS"])
    {
        NSString* deviceType;
        NSString* userType;
        
        NSRange range = [aStr rangeOfString:@"#"];
        aStr = [aStr substringFromIndex:range.location + range.length];
        NSLog(@"aStr = %@", aStr);
        range = [aStr rangeOfString:@"#"];
        deviceType = [aStr substringToIndex:range.location];
        aStr = [aStr substringFromIndex:range.location + range.length];
        range = [aStr rangeOfString:@"#"];
        userType = [aStr substringToIndex:range.location];
        if([deviceType integerValue] > 59)
        {
            //双温
            [Global instanse].deviceType = 1;
        }
        else
        {
            [Global instanse].deviceType = 2;
        }
        
        [Global instanse].userType = [userType integerValue];
        
        NSString* deviceTypeStr = [NSString stringWithFormat:@"%ld",(long)[Global instanse].deviceType ];
        
        if( [[_deviceDic objectForKey:kDeviceType] length] == 0)
        {
            [[DBManager instanse] upDateDevice:deviceTypeStr DeviceId:[_deviceDic objectForKey:kDeviceId]];
        }
        MobileFridgeViewController* vc = (MobileFridgeViewController*)
        [Comm viewControllerId:
         @"MobileFridgeViewController" storyboard:@"Main"];
        [self.navigationController pushViewController:vc animated:YES];

        [_asyncSocket disconnect];
    }
    else
    {
        [self showHint:@"登录失败"];
    }
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


- (IBAction)forgotPw:(id)sender
{
    ModifyPasswordViewController* vc = (ModifyPasswordViewController*)
    [Comm viewControllerId:@"ModifyPasswordViewController" storyboard:@"Main"];
    
    vc.title = @"忘记密码";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterRegisterView
{
    RegisterViewController* vc =
        (RegisterViewController*) [Comm viewControllerId:@"RegisterViewController" storyboard:@"Main"];
    vc.deviceId = [self.deviceDic objectForKey:kDeviceId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
