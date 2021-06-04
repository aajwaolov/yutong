//
//  UpgradeViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/27.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "UpgradeViewController.h"
#import "SocketManager.h"
#import "CommonNetworkDefine.h"
#import "Global.h"
#import "CommonStr_en.h"

@interface UpgradeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation UpgradeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)beginUpgrade:(id)sender
{
    NSString *phone = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *code = [self.codeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (phone.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"please input phoneNumber!";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;

        [hud hide:YES afterDelay:2];
        return;
    }
    if (code.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"please input codeNumber!";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;

        [hud hide:YES afterDelay:2];
        return;
    }

    [SocketManager instanse].delegate = self;

    NSError *err = nil;
    [[SocketManager instanse] disconnect];
    if(![[SocketManager instanse] connectToHost:ROUTER_TCP_IP onPort:ROUTER_TCP_Port error:&err]) {
        NSLog(@"Error: %@", err);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

        [self hideProgress];

        return;
    }
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSString *phone = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *code = [self.codeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);

    NSString* requestStr = [NSString stringWithFormat:@"JTZNBX2015#update#%@#%@#792205299@qq.com#%@#", phone, code, [[Global instanse].deviceDic objectForKey:kDeviceId]];
    NSLog(@"tempStr = %@", requestStr);
    NSData* data = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [[SocketManager instanse] writeData:data withTimeout:-1 tag:2];
    [[SocketManager instanse] readDataWithTimeout:30 tag:2];
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* aStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] lowercaseString];
    if ([aStr containsString:@"error"]) {
        [self hideProgress];
        [self showHint:@"code error!"];
    } else {

        [Global instanse].userType = 1;
        [self hideProgress];
        [self showHint:@"SUCCESS"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:2.0f];
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

@end
