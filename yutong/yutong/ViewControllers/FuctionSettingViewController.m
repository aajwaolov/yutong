//
//  FuctionSettingViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/27.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "FuctionSettingViewController.h"
#import "CommonNetworkDefine.h"
#import "Comm.h"

#pragma clang diagnostic ignored "-Wformat"
@interface FuctionSettingViewController ()

@end

@implementation FuctionSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLanguageImage];
    
    [_ChangeTemperatureUnitBtn setTitle:@"℃" forState:UIControlStateNormal];
    
    _slider1.minimumValue = -18;
    _slider1.maximumValue = 10;
    _slider1.value = 0;
    [_slider1 setThumbImage:[UIImage imageNamed:@"seek"] forState:UIControlStateNormal];
    [_slider1 addTarget:self action:@selector(temperature1Changer) forControlEvents:UIControlEventValueChanged];
    _currentTemperature1.text = [NSString stringWithFormat:@"%ld℃", (long)_slider1.value];
    
    _slider2.minimumValue = -18.0f;
    _slider2.maximumValue = 10.0f;
    _slider2.value = 0;
    [_slider2 setThumbImage:[UIImage imageNamed:@"seek"] forState:UIControlStateNormal];
    [_slider2 addTarget:self action:@selector(temperature2Changer) forControlEvents:UIControlEventValueChanged];
    _currentTemperature2.text = [NSString stringWithFormat:@"%ld℃", (long)_slider2.value];
    
    _slider3.minimumValue = 0.0f;
    _slider3.maximumValue = 2.0f;
    _slider3.value = 1.0f;
    [_slider3 setThumbImage:[UIImage imageNamed:@"seek"] forState:UIControlStateNormal];
    [_slider3 addTarget:self action:@selector(volatChanger) forControlEvents:UIControlEventValueChanged];
    
    _unitType = 0;
    [self startRequest];
    _requestType = 1;
}

- (void) setLanguageImage
{
    UIView* titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, 200, 30);
    
    UIImageView* titleImage = [[UIImageView alloc]init];
    titleImage.image = [Comm imageName:@"setting"];
    titleImage.frame = CGRectMake(70, 5, 60, 20);
    
    [titleView addSubview:titleImage];
    
    self.navigationItem.titleView = titleView;
    
    _temperatureImage.image = [Comm imageName:@"temperature"];
    _setTemperatureImage.image = [Comm imageName:@"set_temperature"];
    _voltage.image = [Comm imageName:@"voltage"];
    
    _temperature_unit_bg.image = [Comm imageName:@"temperature_unit"];
    
    [_saveBtn setImage:[Comm imageName:@"save"] forState:UIControlStateNormal];
}


- (void) volatChanger
{
    CGFloat tempValue = _slider3.value;
    if(tempValue < 1)
    {
        if((1 - tempValue) > tempValue)
        {
            _slider3.value = 0.0f;
            [_slider3 setValue:0.0f animated:YES];
        }
        else
        {
            _slider3.value = 1.0f;
            [_slider3 setValue:1.0f animated:YES];
        }
    }
    else
    {
        if((2 - tempValue) > (tempValue - 1))
        {
            _slider3.value = 1.0f;
            [_slider3 setValue:1.0f animated:YES];
        }
        else
        {
            _slider3.value = 2.0f;
            [_slider3 setValue:2.0f animated:YES];
        }
    }
    
    _dydj = _slider3.value;
    
}

- (void) temperature1Changer
{
    if(_unitType == 0)
    {
        _currentTemperature1.text = [NSString stringWithFormat:@"%ld℃", (long)_slider1.value];
        _value1 = (NSInteger)_slider1.value;
    }
    else
    {
        _currentTemperature1.text = [NSString stringWithFormat:@"%ld℉", (long)_slider1.value];
        _value1 = (((NSInteger)_slider1.value)-32)*5/9;
    }
}

- (void) temperature2Changer
{
    if(_unitType == 0)
    {
        _currentTemperature2.text = [NSString stringWithFormat:@"%ld℃", (long)_slider2.value];
        _value2 = (NSInteger)_slider2.value;
    }
    else
    {
        _currentTemperature2.text = [NSString stringWithFormat:@"%ld℉", (long)_slider2.value];
        
        _value2 = (((NSInteger)_slider2.value)-32)*5/9;;
    }
}
- (IBAction)ChangeTemperatureUnit:(id)sender
{
    GPickerView* pickerView = [[GPickerView alloc]initWithFrame:self.view.frame];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    
    [pickerView show];
}

- (IBAction)save:(id)sender
{
    _requestType = 2;
    
    [self startRequest];
}

- (void) startRequest
{
//    if(!_asyncSocket)
//    {
    _asyncSocket = [SocketManager instanse];
    [_asyncSocket disconnect];
    _asyncSocket.delegate = self;
    
//        _asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
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
//    }
//    else
//    {
//        [_asyncSocket readDataWithTimeout:-1 tag:0];
//    }
}

- (NSString*) requestData
{
    NSString* reqestSting;
    if(_requestType == 1)
    {
        reqestSting = @"JTZNBX2015#read_state#";
    }
    else
    {
        if(_dydj == 0)
        {
            _value3 = _value3&(~0x03);
        }
        else if(_dydj == 1)
        {
            _value3 = _value3&(~0x03);
            _value3 = _value3|0x01;
        }
        else if(_dydj == 2)
        {
            _value3 = _value3&(~0x03);
            _value3 = _value3|0x02;
        }
        
        if(_unitType == 0)
        {
            _value3 = _value3&(~0x04);
        }
        else if(_unitType == 1)
        {
            _value3 = _value3&(~0x04);
            _value3 = _value3|(0x04);
        }
        
        reqestSting = [NSString stringWithFormat:@"JTZNBX2015#setconfig#%ld#%ld#%ld#",_value1 + 50, _value2 + 50, (long)_value3];
    }
    
    return reqestSting;
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
            NSArray* array = [aStr componentsSeparatedByString:@"#"];
            _value1 = ((NSString*)[array objectAtIndex:3]).intValue;
            _value2 = ((NSString*)[array objectAtIndex:4]).intValue;
            _value3 = ((NSString*)[array objectAtIndex:7]).intValue;
            
            NSInteger wdUnit;
            NSInteger power;
            
            if((_value3&0x3) == 0)
            {
                _dydj = 0;
            }
            else if((_value3&0x3) == 1)
            {
                _dydj = 1;
            }
            else if((_value3&0x3) == 2)
            {
                _dydj = 2;
            }
            
            [_slider3 setValue:_dydj animated:YES];
            
            if((_value3&0x4) == 0)
            {
                wdUnit = 0;
            }
            else if((_value3&0x4) != 0)
            {
                wdUnit = 1;
            }
            
            if(wdUnit == 0)
            {
                _unitType = 0;
                [self setUnitType:_unitType];
            }
            else
            {
                _unitType = 1;
                
                [self setUnitType:_unitType];
    //            _temperature1Min.text = [NSString stringWithFormat:@"%.1f℉", (-18.0 * 9)/5 + 32];
    //            _temperature1Max.text = [NSString stringWithFormat:@"%.1f℉", (10.0 * 9)/5 + 32];
    //            
    //            _slider2.minimumValue = _slider1.minimumValue;
    //            _slider2.maximumValue = _slider1.maximumValue;
    //            
    //            _temperature2Min.text = _temperature1Min.text;
    //            _temperature2Max.text = _temperature1Max.text;
    //            
    //            _currentTemperature1.text = [NSString stringWithFormat:@"%.1f℃",(CGFloat) (_value1 * 9)/5 + 32];
    //            _currentTemperature2.text = [NSString stringWithFormat:@"%.1f℃", (CGFloat) (_value2 * 9)/5 + 32];
    //            
    //            _slider1.value = (_value1 * 9)/5 + 32;
    //            _slider2.value = (_value2 * 9)/5 + 32;
            }
            
            if((_value3&0x14) == 0)
            {
                power = 0;
            }
            else if((_value3&0x4) == 0x18)
            {
                power = 1;
            }
            else if((_value3&0x4) != 0x10)
            {
                power = 2;
            }
        }
        else
        {
            [self showHint:@"登录失败"];
        }
    }
    else
    {
        
    }
    
//    if([Global instanse].deviceType == 1)
//    {
//        MobileFridgeViewController* vc = (MobileFridgeViewController*)
//        [Comm viewControllerId:
//         @"MobileFridgeViewController" storyboard:@"Main"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else
//    {
//        MobileFridgeViewController1* vc = (MobileFridgeViewController1*)
//        [Comm viewControllerId: @"MobileFridgeViewController1" storyboard:@"Main"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    //    if([aStr isEqual:@"Nothing"]|| [aStr isEqualToString:@"0"])
    //    {
    //        return;
    //    }
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
            return @"℃";
        }
        case 1:
        {
            return @"℉";
        }
            
        default:
            break;
    }
    return nil;
}

- (void) pickResult:(NSArray*) pickerArray
{
    NSNumber* num = [pickerArray objectAtIndex:0];
    
    _unitType = num.integerValue;
    
    [self setUnitType:_unitType];
}

- (void) setUnitType:(NSInteger) unit
{
    switch (unit)
    {
        case 0:
        {
            
            [_ChangeTemperatureUnitBtn setTitle:@"℃" forState:UIControlStateNormal];
            _slider1.minimumValue = -18.0f;
            _slider1.maximumValue = 10.0f;
            
            _temperature1Min.text = @"-18℃";
            _temperature1Max.text = @"10℃";
            
            _slider2.minimumValue = -18.0f;
            _slider2.maximumValue = 10.0f;
            
            _temperature2Min.text = @"-18℃";
            _temperature2Max.text = @"10℃";
            
            _currentTemperature1.text = [NSString stringWithFormat:@"%ld℃",(long) _value1];
            _currentTemperature2.text = [NSString stringWithFormat:@"%ld℃", (long) _value2];
            
            _slider1.value = _value1;
            _slider2.value = _value2;
            
            break;
        }
        case 1:
        {
            [_ChangeTemperatureUnitBtn setTitle:@"℉" forState:UIControlStateNormal];
            
            _slider1.minimumValue = (-18.0 * 9)/5 + 32;
            _slider1.maximumValue = (10.0 * 9)/5 + 32;
            
            _temperature1Min.text = [NSString stringWithFormat:@"%ld℉", (NSInteger)(-18.0 * 9)/5 + 32];
            _temperature1Max.text = [NSString stringWithFormat:@"%ld℉", (NSInteger)(10.0 * 9)/5 + 32];
            
            _slider2.minimumValue = _slider1.minimumValue;
            _slider2.maximumValue = _slider1.maximumValue;
            
            _temperature2Min.text = _temperature1Min.text;
            _temperature2Max.text = _temperature1Max.text;
            
            _currentTemperature1.text = [NSString stringWithFormat:@"%ld℉",(NSInteger) (_value1 * 9)/5 + 32];
            _currentTemperature2.text = [NSString stringWithFormat:@"%ld℉", (NSInteger) (_value2 * 9)/5 + 32];
            
            _slider1.value = (_value1 * 9)/5 + 32;
            _slider2.value = (_value2 * 9)/5 + 32;
            break;
        }
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
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
