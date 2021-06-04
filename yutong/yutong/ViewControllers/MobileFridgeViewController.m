//
//  MobileFridgeViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/27.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "MobileFridgeViewController.h"
#import "CommonDefine.h"
#import "FuctionSettingViewController.h"
#import "ShutDownViewController.h"
#import "ModifyInfoViewController.h"
#import "ContactUsViewController.h"
#import "CurveViewController.h"
#import "Comm.h"
#import "Global.h"
#import "UpgradeViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"

#import "CommonNetworkDefine.h"

@interface MobileFridgeViewController ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MobileFridgeViewController

const NSInteger kLeftItemsWidth = 160;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _bgView = [[UIView alloc]init];
    _bgView.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight);
    _bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgView];
    firstFlag = YES;



    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(getStatus) userInfo:nil repeats:YES];

    [self setLanguageImage];

    if([Global instanse].deviceType == 1) {
        self.view4.hidden = YES;
    } else {
        self.view1.hidden = YES;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //1专业用户 0普通用户
    if([Global instanse].userType == 0) {
        [self initRightItemsNormal];
    } else {
        [self initRightItemsSpecial];
    }
}

- (void) initRightItemsNormal
{
    _moreFucBg = [[UIImageView alloc]init];
    _moreFucBg.frame = CGRectMake(kMainScreenWidth, 0, kLeftItemsWidth, kMainScreenHeight);
    _moreFucBg.image = [UIImage imageNamed:@"fuc_bg"];
    _moreFucBg.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:_moreFucBg];

    UILabel* leftItemTitle = [[UILabel alloc]init];
    leftItemTitle.text = @"More";
    leftItemTitle.textAlignment = NSTextAlignmentCenter;
    leftItemTitle.font = [UIFont boldSystemFontOfSize:16];
    leftItemTitle.frame = CGRectMake(20, 64, kLeftItemsWidth - 20*2, 20);
    leftItemTitle.textColor = [UIColor whiteColor];
    [_moreFucBg addSubview:leftItemTitle];

    UIView* lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [UIColor whiteColor];
    lineView1.frame = CGRectMake(10, 64 + 20, kLeftItemsWidth - 10*2, 1);
    [_moreFucBg addSubview:lineView1];

    UIButton* openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.backgroundColor = [UIColor clearColor];
    openBtn.frame = CGRectMake(10, 64 + 20 + 5, kLeftItemsWidth - 20, 30);
    [_moreFucBg addSubview:openBtn];

    UIImageView* image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"open_close"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [openBtn addSubview:image];

    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"On/Off";
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(30, 5, 90, 20);
    [openBtn addSubview:label];

    [openBtn addTarget:self
                action:@selector(enterShutDownView)
      forControlEvents:UIControlEventTouchUpInside];

    UIButton* upgradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upgradeBtn.backgroundColor = [UIColor clearColor];
    upgradeBtn.frame = CGRectMake(10, 64 + 20 + 5*2 + 30, kLeftItemsWidth - 20, 30);
    [_moreFucBg addSubview:upgradeBtn];

    image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"upgrade"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [upgradeBtn addSubview:image];

    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"Account Upgrade";
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(30, 5, 100, 20);
    [upgradeBtn addSubview:label];

    [upgradeBtn addTarget:self
                   action:@selector(enterUpgraderView)
         forControlEvents:UIControlEventTouchUpInside];

    //    UIView* lineView2 = [[UIView alloc]init];
    //    lineView2.backgroundColor = [UIColor whiteColor];
    //    lineView2.frame = CGRectMake(20, 64 + 20 + 5*3 + 30*2, kLeftItemsWidth - 20*2, 1);
    //    [_moreFucBg addSubview:lineView2];

    UIButton* contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.backgroundColor = [UIColor clearColor];
    contactBtn.frame = CGRectMake(10, 64 + 20 + 5*4 + 30*2, kLeftItemsWidth - 20, 30);
    [_moreFucBg addSubview:contactBtn];

    image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"back_device_list"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [contactBtn addSubview:image];

    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"Fridge Selection";
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(30, 5, 100, 20);
    [contactBtn addSubview:label];

    [contactBtn addTarget:self action:@selector(enterFridgeSelection) forControlEvents:UIControlEventTouchUpInside];

    UIView* lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.frame = CGRectMake(10, 64 + 20*2 + 5*4 + 30*3, kLeftItemsWidth - 10*2, 1);
    [_moreFucBg addSubview:lineView2];

    UILabel* addressLabel = [[UILabel alloc]init];
    addressLabel.frame = CGRectMake(0, 64 + 20*3 + 5*4 + 30*3, kLeftItemsWidth, 20);
    addressLabel.text = @"www.evakool.com";
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.textColor = [UIColor whiteColor];

    [_moreFucBg addSubview:addressLabel];

    UIImageView* logoImage =[[UIImageView alloc]init];

    logoImage.frame = CGRectMake(20, 64 + 20*5 + 5*4 + 30*3, 100, 60);
    logoImage.image = [UIImage imageNamed:@"logo_white"];
    [_moreFucBg addSubview:logoImage];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(hideMoreFucView)];
    [self.view addGestureRecognizer:tap];
}

- (void) initRightItemsSpecial
{
    _moreFucBg = [[UIImageView alloc]init];
    _moreFucBg.frame = CGRectMake(kMainScreenWidth, 0, kLeftItemsWidth, kMainScreenHeight);
    _moreFucBg.image = [UIImage imageNamed:@"fuc_bg"];
    _moreFucBg.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:_moreFucBg];

    UILabel* leftItemTitle = [[UILabel alloc] init];

    if(/* DISABLES CODE */ (!0))
    {
        leftItemTitle.text = @"More";
    }
    else
    {
        leftItemTitle.text = @"更多功能";
    }

    CGFloat leftMargin = 10.0f;

    leftItemTitle.textAlignment = NSTextAlignmentCenter;
    leftItemTitle.font = [UIFont boldSystemFontOfSize:16];
    leftItemTitle.frame = CGRectMake(leftMargin, 64, kLeftItemsWidth - leftMargin*2, 20);
    leftItemTitle.textColor = [UIColor whiteColor];
    [_moreFucBg addSubview:leftItemTitle];

    UIView* lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [UIColor whiteColor];
    lineView1.frame = CGRectMake(leftMargin, 64 + 20, kLeftItemsWidth - leftMargin*2, 1);
    [_moreFucBg addSubview:lineView1];

    UIButton* fucSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fucSettingBtn.backgroundColor = [UIColor clearColor];
    fucSettingBtn.frame = CGRectMake(leftMargin, 64 + 20 + 5, kLeftItemsWidth - leftMargin*2, 30);
    [_moreFucBg addSubview:fucSettingBtn];

    [fucSettingBtn addTarget:self action:@selector(enterFucSettingView) forControlEvents:UIControlEventTouchUpInside];

    UIImageView* image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"fuc_setting"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [fucSettingBtn addSubview:image];

    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];

    if(/* DISABLES CODE */ (!0))
    {
        label.text = @"Settings";
    }
    else
    {
        label.text = @"功能设置";
    }
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(30, 5, 90, 20);
    [fucSettingBtn addSubview:label];

    UIButton* lookCurveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookCurveBtn.backgroundColor = [UIColor clearColor];
    lookCurveBtn.frame = CGRectMake(leftMargin, 64 + 20 + 5*2 + 30, kLeftItemsWidth - leftMargin*2, 30);
    [_moreFucBg addSubview:lookCurveBtn];

    image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"look_curve"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [lookCurveBtn addSubview:image];

    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];

    if(/* DISABLES CODE */ (!0))
    {
        label.text = @"Graph";
    }
    else
    {
        label.text = @"曲线查看";
    }
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(30, 5, 90, 20);
    [lookCurveBtn addSubview:label];

    [lookCurveBtn addTarget:self action:@selector(enterCurveViewController) forControlEvents:UIControlEventTouchUpInside];

    UIView* lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.frame = CGRectMake(leftMargin, 64 + 20 + 5*3 + 30*2, kLeftItemsWidth - leftMargin*2, 1);
    [_moreFucBg addSubview:lineView2];

    UIButton* openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.backgroundColor = [UIColor clearColor];
    openBtn.frame = CGRectMake(leftMargin, 64 + 20 + 5*4 + 30*2, kLeftItemsWidth - leftMargin*2, 30);
    [_moreFucBg addSubview:openBtn];

    image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"open_close"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [openBtn addSubview:image];

    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];

    if(/* DISABLES CODE */ (!0))
    {
        label.text = @"On/Off";
    }
    else
    {
        label.text = @"开/关机";
    }
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(30, 5, 90, 20);
    [openBtn addSubview:label];

    [openBtn addTarget:self
                action:@selector(enterShutDownView)
      forControlEvents:UIControlEventTouchUpInside];

    UIButton* modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.backgroundColor = [UIColor clearColor];
    modifyBtn.frame = CGRectMake(leftMargin, 64 + 20 + 5*5 + 30*3, kLeftItemsWidth - leftMargin*2, 30);
    [_moreFucBg addSubview:modifyBtn];

    image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"back_device_list"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [modifyBtn addSubview:image];

    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];

    if(/* DISABLES CODE */ (!0))
    {
        label.text = @"Fridge Selection";
    }
    else
    {
        label.text = @"修改信息";
    }
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(30, 5, 110, 20);
    [modifyBtn addSubview:label];

    [modifyBtn addTarget:self
                  action:@selector(enterFridgeSelection)
        forControlEvents:UIControlEventTouchUpInside];

    UIView* lineView3 = [[UIView alloc]init];
    lineView3.backgroundColor = [UIColor whiteColor];
    lineView3.frame = CGRectMake(leftMargin, 64 + 20 + 5*6 + 30*4, kLeftItemsWidth - leftMargin*2, 1);
    [_moreFucBg addSubview:lineView3];

    UIButton* contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.backgroundColor = [UIColor clearColor];
    contactBtn.frame = CGRectMake(leftMargin, 64 + 20 + 5*7 + 30*4, kLeftItemsWidth - leftMargin*2, 30);
    [_moreFucBg addSubview:contactBtn];

    //    image = [[UIImageView alloc]init];
    //    image.image = [UIImage imageNamed:@"contact"];
    //    image.frame = CGRectMake(5, 5, 20, 20);
    //    [contactBtn addSubview:image];

    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    if(/* DISABLES CODE */ (!0))
    {
        label.text = @"www.evakool.com";
        label.font = [UIFont systemFontOfSize:13];
    }
    else
    {
        label.text = @"联系我们";
        label.font = [UIFont systemFontOfSize:14];
    }



    label.frame = CGRectMake(20, 5, 115, 20);
    [contactBtn addSubview:label];

    [contactBtn addTarget:self action:@selector(enterContactUsView) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(hideMoreFucView)];
    [self.view addGestureRecognizer:tap];

    UIImageView* logoImage =[[UIImageView alloc]init];

    logoImage.frame = CGRectMake(20, 64 + 20 + 5*7 + 30*6, 100, 60);
    logoImage.image = [UIImage imageNamed:@"logo_white"];
    [_moreFucBg addSubview:logoImage];

}

- (void) setLanguageImage
{
    UIView* titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, 200, 30);

    UIImageView* titleImage = [[UIImageView alloc]init];
    titleImage.image = [Comm imageName:@"home"];
    titleImage.frame = CGRectMake(70, 5, 60, 20);

    [titleView addSubview:titleImage];

    self.navigationItem.titleView = titleView;

    //    _deviceListImage.image = [Comm imageName:@"device_list_text"];
    //
    _statusImage.image = [Comm imageName:@"ensbyxzt"];
    [_moreBtn setImage:[Comm imageName:@"more"] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.timer setFireDate:[NSDate date]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer setFireDate:[NSDate distantFuture]];
    [self hideMoreFucView];
}

- (void) getStatus
{
    _asyncSocket = [SocketManager instanse];
    [_asyncSocket disconnect];
    _asyncSocket.delegate = self;
    _requestType = 1;
    //    _asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *err = nil;

    if(firstFlag)
    {
        [self showProgress];
    }

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

    NSString* reqestSting = @"JTZNBX2015#read_state#";

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
        _requestType = 0;

        NSArray* array = [aStr componentsSeparatedByString:@"#"];

        NSString* temp1 = ((NSString*)[array objectAtIndex:5]);
        NSString* temp2 = ((NSString*)[array objectAtIndex:6]);

        NSString* volatStr = [NSString stringWithFormat:@"%@.%@V", temp1, temp2];
        NSInteger temp7 = ((NSString*)[array objectAtIndex:7]).integerValue;
        NSInteger status;
        if((temp7&0X04) == 0)
        {
            //摄氏度
            status = 0;
        }
        else
        {
            status = 1;
        }

        NSString* wenDu1;
        NSString* wenDu2;
        if (status == 0)
        {
            wenDu1 = [NSString stringWithFormat:@"%@℃", (NSString*)[array objectAtIndex:1] ];
            wenDu2 = [NSString stringWithFormat:@"%@℃", (NSString*)[array objectAtIndex:2] ];
        }
        else
        {
            NSInteger wenDuInt = ((NSString*)[array objectAtIndex:1]).integerValue*9/5 + 32;
            wenDu1 =  [NSString stringWithFormat:@"%ld℉", (long)wenDuInt];

            wenDuInt = ((NSString*)[array objectAtIndex:2]).integerValue*9/5 + 32;
            wenDu2 =  [NSString stringWithFormat:@"%ld℉", (long)wenDuInt];
        }

        NSInteger temp8 = ((NSString*)[array objectAtIndex:8]).integerValue;


        if(temp7&0x18 == 0)
        {
            //中
            _labelup.text = @"";
            _labelMidlle.text = @"Fridge is off!";
            _labeldown.text = @"";
            _device1Status.text = @"ERR1";
            _labelLeft.text = @"ERR1";
            _device2Status.text = @"ERR1";
        }
        else
        {
            NSInteger dyOK = 1;
            NSInteger wd1OK = 1;
            NSInteger wd2OK = 1;

            _device1Status.text = wenDu1;
            _labelLeft.text = wenDu1;

            _device2Status.text = wenDu2;

            _voltage.text = volatStr;
            _labelRight.text = volatStr;

            if(temp8*0x01 == 0x01)
            {
                dyOK = 0;
                _labelup.text = @"Battery voltage protection";
            }
            else if(temp8*0x02 == 0x02)
            {
                dyOK = 0;
                _labelup.text = @"External fan over-current protection";
            }
            else if(temp8*0x03 == 0x03)
            {
                dyOK = 0;
                _labelup.text = @"Compressor fails to start";
            }
            else if(temp8*0x04 == 0x04)
            {
                dyOK = 0;
                _labelup.text = @"Minimum speed error";
            }
            else if(temp8*0x05 == 0x05)
            {
                dyOK = 0;
                _labelup.text = @"Frequency controller overheating protection";
            }
            else
            {
                dyOK = 1;
                _labelup.text = @"";
            }

            if((temp8&(0x01<<4))==(0x01<<4))
            {
                _labelMidlle.text = @"Temperature Sensor 1 open-circuit";
                _device1Status.text = @"ERR1";
                _labelLeft.text = @"ERR1";
                wd1OK = 0;
            }
            else if((temp8&(0x02<<4))==(0x02<<4))
            {
                _labelMidlle.text = @"Temperature Sensor 1 short-circuit";
                _device1Status.text = @"ERR2";
                _labelLeft.text = @"ERR2";
                wd1OK = 0;
            }
            else
            {
                _labelMidlle.text = @"";
                wd1OK = 1;
            }

            if((temp8&(0x01<<6))==(0x01<<6))
            {
                _labeldown.text = @"Temperature Sensor 2 open-circuit";
                _device2Status.text = @"ERR1";
                wd2OK = 0;
            }
            else if((temp8&(0x02<<6))==(0x02<<6))
            {
                _labeldown.text = @"Temperature Sensor 2 short-circuit";
                _device2Status.text = @"ERR2";
                wd2OK = 0;
            }
            else
            {
                _labeldown.text = @"";
                wd2OK = 1;
            }

            if(dyOK*wd2OK*wd2OK == 1)
            {
                _labelMidlle.text = @"Equipment working properly";
            }
            else
            {
                //警报
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
    if(firstFlag)
    {
        firstFlag = NO;
        [self hideProgress];
    }

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
    if(firstFlag)
    {
        firstFlag = NO;
        [self hideProgress];
    }

    //断开连接了
    NSLog(@"onSocketDidDisconnect:%p", sock);
}

- (void) enterCurveViewController
{
    CurveViewController* vc = [[CurveViewController alloc]init];

    [self.navigationController pushViewController:vc animated:YES];

    [self hideMoreFucView];
}

- (void) enterContactUsView
{
//    ContactUsViewController* vc =
//    (ContactUsViewController*)[Comm viewControllerId:@"ContactUsViewController" storyboard:@"Main"];
//
//    [self.navigationController pushViewController:vc animated:YES];
//
//    [self hideMoreFucView];
}

- (void) enterFucSettingView
{
    SettingViewController* vc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self hideMoreFucView];
}

- (void)enterUpgraderView
{
    UpgradeViewController* vc =
    (UpgradeViewController*)[Comm viewControllerId:@"UpgradeViewController" storyboard:@"Main"];
    [self.navigationController pushViewController:vc animated:YES];
    [self hideMoreFucView];
}

- (void)enterFridgeSelection
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

- (void) enterShutDownView
{
    ShutDownViewController* vc =
    (ShutDownViewController*)[Comm viewControllerId:@"ShutDownViewController" storyboard:@"Main"];

    [self.navigationController pushViewController:vc animated:YES];

    [self hideMoreFucView];
}

- (IBAction)moreFuc:(id)sender
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    _moreFucBg.frame = CGRectMake(kMainScreenWidth - kLeftItemsWidth,
                                  0,
                                  kLeftItemsWidth,
                                  kMainScreenHeight);

    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (void) hideMoreFucView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    _moreFucBg.frame = CGRectMake(kMainScreenWidth,
                                  0,
                                  kLeftItemsWidth,
                                  kMainScreenHeight);

    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished1)];
    [UIView commitAnimations];
}

- (void) animationFinished1
{
    _bgView.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight);
}

- (void) animationFinished
{
    _bgView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
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
