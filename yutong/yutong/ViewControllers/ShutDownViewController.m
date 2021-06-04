//
//  ShutDownViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/24.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "ShutDownViewController.h"
#import "CommonDefine.h"
#import "Comm.h"

#import "CommonNetworkDefine.h"
#import "CommonDefine.h"

#pragma clang diagnostic ignored "-Wformat"
@interface ShutDownViewController ()<UIAlertViewDelegate>

@end

@implementation ShutDownViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Status";
    
    [self setLanguageImage];
    
    [self getDeviceStatus];

}

- (void) getDeviceStatus
{
    _requestType = 1;
    
    [self start];
}


- (void) setLanguageImage
{
    
    /*UIView* titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, 200, 30);
    
    UIImageView* titleImage = [[UIImageView alloc]init];
    
    titleImage.frame = CGRectMake(70, 5, 60, 20);
    titleImage.image = [Comm imageName:@"home"];
    
    [titleView addSubview:titleImage];

    self.navigationItem.titleView = titleView;*/
//    
//    //等待关机状态
//    if(_status)
//    {
//        if(!0)
//        {
//            titleImage.image = [Comm imageName:@"close_title"];
//        }
//        else
//        {
//            
//        }
//    }
//    else
//    {
//        if(!0)
//        {
//            titleImage.image = [Comm imageName:@"open"];
//        }
//        else
//        {
//            
//        }
//    }
////    _deviceListImage.image = [Comm imageName:@"device_list_text"];
////    
//    [_cancelBtn setImage:[Comm imageName:@"cancel"] forState:UIControlStateNormal];
}


- (NSString*) requestData
{
    NSString* reqestSting;
    
    //1 为获取devcie当前状态
    if(_requestType == 1)
    {
        reqestSting = @"JTZNBX2015#read_state#";
    }
    else if(_requestType == 2)//
    {

        reqestSting = [NSString stringWithFormat: @"JTZNBX2015#setconfig#%ld#%ld#%ld#", _val1 + 50,_val2 + 50, _status];

    }
    
    return reqestSting;
}

- (void)start
{
    _asyncSocket = [SocketManager instanse];
    [_asyncSocket disconnect];
    _asyncSocket.delegate = self;
    //    _asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
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
    
    if(_requestType == 1)
    {
        if([aStr hasPrefix:@"SUCCESS"])
        {
            NSLog(@"aStr===%@",aStr);
            
            if(_requestType == 1)
            {
                _requestType = 0;
                
                NSArray* array = [aStr componentsSeparatedByString:@"#"];
                
                NSInteger temp1 = ((NSString*)[array objectAtIndex:7]).integerValue;
                _value3 = ((NSString*)[array objectAtIndex:3]).integerValue;
                _value4 = ((NSString*)[array objectAtIndex:4]).integerValue;
                
                if((temp1&0x18)==0)
                {
                    _statusImage.image = [UIImage imageNamed:@"close_hint"];
//                    [_cancelBtn setTitle:@"Turn On" forState:UIControlStateNormal];
                    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"turn_on"] forState:UIControlStateNormal];
                    
                    _status = temp1|(0x01<<3);
                }
                else if((((temp1&0x18)==0x08)||((temp1&0x18)==0x18)))
                {
                    _status=_status&(~(0x03<<3));
                    
                    _hintLabel.text = @"The Fridge is On";
                    _statusImage.image = [UIImage imageNamed:@"open_hint"];
                    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"turn_off"] forState:UIControlStateNormal];
                }
                else if((temp1&0x18)==0x10)
                {
                    //提示 equipment state error 返回主界面
                }
            }
        }
        else
        {
            [self showHint:@"登录失败"];
        }
    }
    else
    {
        if([aStr hasPrefix:@"SUCCESS"])
        {
            NSLog(@"aStr===%@",aStr);
            
            //提示操作成功
            
            [self.navigationController popViewControllerAnimated:YES];
        }
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

- (IBAction)ChangeDeiceStatus:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Are you sure?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"confirm", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        _requestType = 2;
        [self start];
    }
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
