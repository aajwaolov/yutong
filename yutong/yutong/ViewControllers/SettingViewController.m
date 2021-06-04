//
//  SettingViewController.m
//  yutong
//
//  Created by Gao Haiming on 16/6/19.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "SettingViewController.h"
#import "CommonDefine.h"
#import "SocketManager.h"
#import "Global.h"
#import "CommonNetworkDefine.h"
#import "UIView+SDAutoLayout.h"
#import "LoginViewController.h"


#pragma clang diagnostic ignored "-Wformat"
@interface SettingViewController ()

@end

const static CGFloat kNavHeight = 64;
const static CGFloat kLogoWidth = 100;
const static CGFloat kLeftMargin = 20;

const static CGFloat kTemperatureWidth = 100;
const static CGFloat kSetTemperatureWidth = 120;
const static CGFloat kTemperatureHeight = 20;
const static CGFloat kCBtnHeight = 30;

const static CGFloat kSaveBtnWidth = 80;
const static CGFloat kSaveBtnHeight = 30;

@interface SettingViewController()

@property (assign, nonatomic) NSInteger requestType;

@property (assign, nonatomic) NSInteger value1;
@property (assign, nonatomic) NSInteger value2;
@property (assign, nonatomic) NSInteger value3;

@property (assign, nonatomic) NSInteger unitType;
@property (assign, nonatomic) NSInteger dydj;

@property (assign, nonatomic) CGFloat defaultMinValue;

@property (assign, nonatomic) CGFloat defaultMaxValue;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* logoImage = [[UIImageView alloc]init];
    logoImage.image = [UIImage imageNamed:@"logo"];
    logoImage.frame = CGRectMake(0.0f, 0.0f, kLogoWidth, logoImage.image.size.height * kLogoWidth / logoImage.image.size.width);
    logoImage.center = self.view.center;
    CGRect frame = logoImage.frame;
    frame.origin.y = kNavHeight + 10.0f;
    logoImage.frame = frame;

    [self.view addSubview:logoImage];
    
    UIImageView* temperature = [[UIImageView alloc]init];
    temperature.image = [UIImage imageNamed:@"temperature_en"];
    temperature.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(logoImage.frame), kTemperatureWidth, kTemperatureHeight);
    [self.view addSubview:temperature];
    
    CGFloat cBtnY = CGRectGetMaxY(temperature.frame);
    CGFloat cBtnWidth = (kMainScreenWidth - kLeftMargin*2)/2;
    
    _cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cBtn.frame = CGRectMake(kLeftMargin, cBtnY, cBtnWidth, kCBtnHeight);
    [self.view addSubview:_cBtn];
    _cBtn.tag = 1;
    _cBtn.selected = YES;
    [_cBtn setBackgroundImage:[UIImage imageNamed:@"highlight_c"] forState:UIControlStateNormal];
    [_cBtn addTarget:self action:@selector(SetTemperatureType:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _fBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fBtn.frame = CGRectMake(kLeftMargin + cBtnWidth, cBtnY, cBtnWidth, kCBtnHeight);
    [self.view addSubview:_fBtn];
    _fBtn.tag = 2;
    _fBtn.selected = NO;
    [_fBtn setBackgroundImage:[UIImage imageNamed:@"normal_f"] forState:UIControlStateNormal];
    [_fBtn addTarget:self action:@selector(SetTemperatureType:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* setTemperature = [[UIImageView alloc]init];
    
    setTemperature.frame = CGRectMake(kLeftMargin, cBtnY + kCBtnHeight + 10, kSetTemperatureWidth, kTemperatureHeight);
    setTemperature.image = [UIImage imageNamed:@"set_temperature_en"];
    [self.view addSubview:setTemperature];
    
    
    UIImageView* leftView = [[UIImageView alloc]init];
    leftView.image = [UIImage imageNamed:@"lefttmp"];
    leftView.frame = CGRectMake(50, cBtnY + kCBtnHeight + 40, 80, 60);
    [self.view addSubview:leftView];
    
    _leftTemperature = [[UILabel alloc]init];
    _leftTemperature.frame = CGRectMake(0, 20, 80, 40);
    _leftTemperature.textAlignment = NSTextAlignmentCenter;
    _leftTemperature.textColor = [UIColor whiteColor];
    _leftTemperature.font = [UIFont systemFontOfSize:14];
    
    [leftView addSubview:_leftTemperature];
    
    UIImageView* rightView = [[UIImageView alloc]init];
    rightView.image = [UIImage imageNamed:@"righttmp"];
    rightView.frame = CGRectMake(kMainScreenWidth - 50.0f - 80.0f, cBtnY + kCBtnHeight + 40, 80, 60);
    [self.view addSubview:rightView];
    
    _rightTemperature = [[UILabel alloc]init];
    _rightTemperature.frame = CGRectMake(0, 20, 80, 40);
    _rightTemperature.textAlignment = NSTextAlignmentCenter;
    _rightTemperature.textColor = [UIColor whiteColor];
    _rightTemperature.font = [UIFont systemFontOfSize:14];
    
    [rightView addSubview:_rightTemperature];
    

    self.slider1 = [[SettingSlider alloc] init];
    self.slider1.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(leftView.frame) + 10.0f, kMainScreenWidth - 2.0f * kLeftMargin, kCBtnHeight);
    __weak typeof(self) weakSelf = self;
    self.slider1.block = ^(CGFloat value){
        if(_unitType == 0)
        {
            weakSelf.leftTemperature.text = [NSString stringWithFormat:@"%d℃", (NSInteger)floorf(value)];
            weakSelf.value1 = value;
        }
        else
        {
            weakSelf.leftTemperature.text = [NSString stringWithFormat:@"%d℉", (NSInteger)floorf(value)];
            weakSelf.value1 = (value-32)*5/9;
        }
    };
    [self.view addSubview:self.slider1];

    self.slider2 = [[SettingSlider alloc] init];
    self.slider2.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(self.slider1.frame) + 10.0f, kMainScreenWidth - 2.0f * kLeftMargin, kCBtnHeight);
    self.slider2.block = ^(CGFloat value){
        if(_unitType == 0)
        {
            weakSelf.rightTemperature.text = [NSString stringWithFormat:@"%d℃", (NSInteger)floorf(value)];
            weakSelf.value2 = value;
        }
        else
        {
            weakSelf.rightTemperature.text = [NSString stringWithFormat:@"%d℉", (NSInteger)floorf(value)];
            weakSelf.value2 = (value-32)*5/9;
        }
    };
    [self.view addSubview:self.slider2];

    UIView *lastSlider = self.slider2;

    if ([Global instanse].deviceType != 1) {

        leftView.image = [UIImage imageNamed:@"zonetmp"];
        leftView.center = self.view.center;
        CGRect frame = leftView.frame;
        frame.origin.y = cBtnY + kCBtnHeight + 40;
        leftView.frame = frame;

        self.slider1.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(leftView.frame) + 10.0f, kMainScreenWidth - 2.0f * kLeftMargin, kCBtnHeight);

        rightView.hidden = YES;
        self.slider2.hidden = YES;
        lastSlider = self.slider1;
    }

    UIImageView* batteryProtectionImage = [[UIImageView alloc]init];
    
    batteryProtectionImage.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(lastSlider.frame) + 10.0f, kSetTemperatureWidth, kTemperatureHeight);
    batteryProtectionImage.image = [UIImage imageNamed:@"battrypro"];
    [self.view addSubview:batteryProtectionImage];
    
    
    CGFloat batteryBtnY = CGRectGetMaxY(batteryProtectionImage.frame) + 10.0f;
    CGFloat batterYBtnWidth = (kMainScreenWidth - kLeftMargin*2)/3;
    
    _lBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lBtn.frame = CGRectMake(kLeftMargin, batteryBtnY, batterYBtnWidth, kCBtnHeight);
    [self.view addSubview:_cBtn];
    _lBtn.tag = 11;
    _lBtn.selected = YES;
    [_lBtn setBackgroundImage:[UIImage imageNamed:@"highlight_l"] forState:UIControlStateNormal];
    [_lBtn addTarget:self action:@selector(setBatteryProtection:) forControlEvents:UIControlEventTouchUpInside];
    
    _mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mBtn.frame = CGRectMake(kLeftMargin + batterYBtnWidth, batteryBtnY, batterYBtnWidth, kCBtnHeight);
    [self.view addSubview:_cBtn];
    _mBtn.tag = 12;
    _mBtn.selected = NO;
    [_mBtn setBackgroundImage:[UIImage imageNamed:@"normal_m"] forState:UIControlStateNormal];
    [_mBtn addTarget:self action:@selector(setBatteryProtection:) forControlEvents:UIControlEventTouchUpInside];
    
    _hBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hBtn.frame = CGRectMake(kLeftMargin + batterYBtnWidth*2, batteryBtnY, batterYBtnWidth, kCBtnHeight);
    [self.view addSubview:_cBtn];
    _hBtn.tag = 13;
    _hBtn.selected = NO;
    [_hBtn setBackgroundImage:[UIImage imageNamed:@"normal_h"] forState:UIControlStateNormal];
    [_hBtn addTarget:self action:@selector(setBatteryProtection:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_lBtn];
    [self.view addSubview:_mBtn];
    [self.view addSubview:_hBtn];
    [self.view addSubview:_cBtn];
    
    
    
    UIButton* saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake((kMainScreenWidth - kSaveBtnWidth) / 2.0f, CGRectGetMaxY(_hBtn.frame) + 20.0f, kSaveBtnWidth, kSaveBtnHeight);
    saveBtn.selected = YES;
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];

    if ([Global instanse].userType == 32132132109) {
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"reset"] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    }

    NSString *deviceId = [[Global instanse].deviceDic objectForKey:kDeviceId];
    if (deviceId.length >= 2) {
        NSInteger number = [[deviceId substringToIndex:2] integerValue];
        if ((number >= 40 && number <= 49) || (number >= 70 && number <= 79)) {
            self.defaultMinValue = -18.0f;
            self.defaultMaxValue = 10.0f;
        } else {
            self.defaultMinValue = -22.0f;
            self.defaultMaxValue = 10.0f;
        }
    }
    _unitType = 0;
    [self startRequest];
    _requestType = 1;

}

- (void) setBatteryProtection:(UIButton*) btn
{
    if(btn.tag == 11)
    {
        if (!_lBtn.isSelected) {
            _lBtn.selected = YES;
            _mBtn.selected = NO;
            _hBtn.selected = NO;
            self.dydj = 0;

            [_lBtn setBackgroundImage:[UIImage imageNamed:@"highlight_l"] forState:UIControlStateNormal];
            [_mBtn setBackgroundImage:[UIImage imageNamed:@"normal_m"] forState:UIControlStateNormal];
            [_hBtn setBackgroundImage:[UIImage imageNamed:@"normal_h"] forState:UIControlStateNormal];
        }
    }
    else if(btn.tag == 12)
    {
        if (!_mBtn.isSelected) {
            _lBtn.selected = NO;
            _mBtn.selected = YES;
            _hBtn.selected = NO;
            self.dydj = 1;

            [_lBtn setBackgroundImage:[UIImage imageNamed:@"normal_l"] forState:UIControlStateNormal];
            [_mBtn setBackgroundImage:[UIImage imageNamed:@"highlight_m"] forState:UIControlStateNormal];
            [_hBtn setBackgroundImage:[UIImage imageNamed:@"normal_h"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if (!_hBtn.isSelected) {
            _lBtn.selected = NO;
            _mBtn.selected = NO;
            _hBtn.selected = YES;
            self.dydj = 2;

            [_lBtn setBackgroundImage:[UIImage imageNamed:@"normal_l"] forState:UIControlStateNormal];
            [_mBtn setBackgroundImage:[UIImage imageNamed:@"normal_m"] forState:UIControlStateNormal];
            [_hBtn setBackgroundImage:[UIImage imageNamed:@"highlight_h"] forState:UIControlStateNormal];
        }
        
    }
    
}

- (void) SetTemperatureType:(UIButton*) btn
{
    if(btn.tag == 1)
    {
        if (!_cBtn.isSelected) {
            _cBtn.selected = YES;
            _fBtn.selected = NO;

            [_cBtn setBackgroundImage:[UIImage imageNamed:@"highlight_c"] forState:UIControlStateNormal];
            [_fBtn setBackgroundImage:[UIImage imageNamed:@"normal_f"] forState:UIControlStateNormal];

            _unitType = 0;
            [self setUnitType:_unitType];
        }
    }
    else
    {
        if (!_fBtn.isSelected) {
            _cBtn.selected = NO;
            _fBtn.selected = YES;

            [_cBtn setBackgroundImage:[UIImage imageNamed:@"normal_c"] forState:UIControlStateNormal];
            [_fBtn setBackgroundImage:[UIImage imageNamed:@"highlight_f"] forState:UIControlStateNormal];

            _unitType = 1;
            [self setUnitType:_unitType];
        }
    }
    
}

- (void)setDydj:(NSInteger)dydj
{
    _dydj = dydj;
    if (dydj == 0) {
        [self setBatteryProtection:_lBtn];
    } else if (dydj == 1) {
        [self setBatteryProtection:_mBtn];
    } else if (dydj == 2) {
        [self setBatteryProtection:_hBtn];
    }
}

- (void) startRequest
{
    [[SocketManager instanse] disconnect];
    [SocketManager instanse].delegate = self;
    NSError *err = nil;

    [self showProgress];
    if(![[SocketManager instanse] connectToHost:ROUTER_TCP_IP onPort:ROUTER_TCP_Port error:&err])
    {
        NSLog(@"Error: %@", err);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    [[SocketManager instanse] writeData:data withTimeout:-1 tag:2];
    [[SocketManager instanse] readDataWithTimeout:30 tag:2];

}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
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
                self.dydj = 0;
            }
            else if((_value3&0x3) == 1)
            {
                self.dydj = 1;
            }
            else if((_value3&0x3) == 2)
            {
                self.dydj = 2;
            }


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
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LoginViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
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

- (NSString*) requestData
{
    NSString* reqestSting;
    if(_requestType == 1)
    {
        reqestSting = @"JTZNBX2015#read_state#";
    } else if(_requestType == 2){
        if(self.dydj == 0)
        {
            _value3 = _value3&(~0x03);
        }
        else if(self.dydj == 1)
        {
            _value3 = _value3&(~0x03);
            _value3 = _value3|0x01;
        }
        else if(self.dydj == 2)
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

    #pragma clang diagnostic ignored "-Wformat"
        reqestSting = [NSString stringWithFormat:@"JTZNBX2015#setconfig#%d#%d#%ld#",_value1 + 50, _value2 + 50, (long)_value3];
    } else {
        reqestSting = @"JTZNBX2015#reset#";
    }

    return reqestSting;
}

- (void)save
{
    _requestType = 2;

    [self startRequest];
}

- (void)reset
{
    _requestType = 3;
    [self startRequest];
}

- (void) setUnitType:(NSInteger) unit
{
    switch (unit)
    {
        case 0:
        {
            [self SetTemperatureType:_cBtn];
            _slider1.type = SettingSliderTypeC;

            _slider1.minValue = self.defaultMinValue;
            _slider1.maxValue = self.defaultMaxValue;


            _slider2.type = SettingSliderTypeC;
            _slider2.minValue = self.defaultMinValue;
            _slider2.maxValue = self.defaultMaxValue;

            _leftTemperature.text = [NSString stringWithFormat:@"%ld℃",(long) _value1];
            _rightTemperature.text = [NSString stringWithFormat:@"%ld℃", (long) _value2];
            _slider1.value = _value1;
            _slider2.value = _value2;

            break;
        }
        case 1:
        {
            [self SetTemperatureType:_fBtn];

            _slider1.type = SettingSliderTypeF;
            _slider1.minValue = (self.defaultMinValue * 9)/5 + 32;
            _slider1.maxValue = (self.defaultMaxValue * 9)/5 + 32;

            _slider2.type = SettingSliderTypeF;
            _slider2.minValue = _slider1.minValue;
            _slider2.maxValue = _slider1.maxValue;


            _leftTemperature.text = [NSString stringWithFormat:@"%d℉",(NSInteger) (_value1 * 9)/5 + 32];
            _rightTemperature.text = [NSString stringWithFormat:@"%d℉", (NSInteger) (_value2 * 9)/5 + 32];

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
}


@end
