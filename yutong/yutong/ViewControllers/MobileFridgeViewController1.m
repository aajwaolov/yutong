//
//  MobileFridgeViewController1.m
//  yutong
//
//  Created by iOS01iMac on 16/2/25.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "MobileFridgeViewController1.h"
#import "CommonDefine.h"
#import "ShutDownViewController.h"
#import "ModifyInfoViewController.h"
#import "ContactUsViewController.h"
#import "CurveViewController.h"
#import "Comm.h"
#import "Global.h"

#import "CommonNetworkDefine.h"


@interface MobileFridgeViewController1 ()

@end

@implementation MobileFridgeViewController1

const static NSInteger kLeftItemsWidth = 160;

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideMoreFucView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bgView = [[UIView alloc]init];
    _bgView.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight);
    _bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgView];
    _firstFlag = YES;
    
    //    Global* global = [Global instanse];
    //
    //    if(global.userType == 1)
    //    {
    //    [self initRightItems];
    //    }
    //    else
    //    {
    [self initRightItems1];
    //    }
    
    //    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getStatus) userInfo:nil repeats:NO];
    
    //    [self getStatus];
    
    [self setLanguageImage];
}

- (void) initRightItems
{
    _moreFucBg = [[UIImageView alloc]init];
    _moreFucBg.frame = CGRectMake(kMainScreenWidth, 0, kLeftItemsWidth, kMainScreenHeight);
    _moreFucBg.image = [UIImage imageNamed:@"fuc_bg"];
    _moreFucBg.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:_moreFucBg];
    
    UILabel* leftItemTitle = [[UILabel alloc]init];
    
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
    
    [fucSettingBtn addTarget:self
                      action:@selector(enterFucSettingView)
            forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [lookCurveBtn addTarget:self
                     action:@selector(enterCurveViewController)
           forControlEvents:UIControlEventTouchUpInside];
    
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
    image.image = [UIImage imageNamed:@"modify"];
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
                  action:@selector(enterModifyInfoView)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIView* lineView3 = [[UIView alloc]init];
    lineView3.backgroundColor = [UIColor whiteColor];
    lineView3.frame = CGRectMake(leftMargin, 64 + 20 + 5*6 + 30*4, kLeftItemsWidth - leftMargin*2, 1);
    [_moreFucBg addSubview:lineView3];
    
    UIButton* contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.backgroundColor = [UIColor clearColor];
    contactBtn.frame = CGRectMake(leftMargin, 64 + 20 + 5*7 + 30*4, kLeftItemsWidth - leftMargin*2, 30);
    [_moreFucBg addSubview:contactBtn];
    
    image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"contact"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [contactBtn addSubview:image];
    
    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    
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
    
    label.frame = CGRectMake(30, 5, 115, 20);
    [contactBtn addSubview:label];
    
    [contactBtn addTarget:self
                   action:@selector(enterContactUsView)
         forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(hideMoreFucView)];
    [self.view addGestureRecognizer:tap];

}


- (void) initRightItems1
{
    _moreFucBg = [[UIImageView alloc]init];
    _moreFucBg.frame = CGRectMake(kMainScreenWidth, 0, kLeftItemsWidth, kMainScreenHeight);
    _moreFucBg.image = [UIImage imageNamed:@"fuc_bg"];
    _moreFucBg.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:_moreFucBg];
    
    UILabel* leftItemTitle = [[UILabel alloc]init];
    leftItemTitle.text = @"更多功能";
    leftItemTitle.textAlignment = NSTextAlignmentCenter;
    leftItemTitle.font = [UIFont boldSystemFontOfSize:16];
    leftItemTitle.frame = CGRectMake(20, 64, kLeftItemsWidth - 20*2, 20);
    leftItemTitle.textColor = [UIColor whiteColor];
    [_moreFucBg addSubview:leftItemTitle];
    
    UIView* lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [UIColor whiteColor];
    lineView1.frame = CGRectMake(20, 64 + 20, kLeftItemsWidth - 20*2, 1);
    [_moreFucBg addSubview:lineView1];
    
    UIButton* modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.backgroundColor = [UIColor clearColor];
    modifyBtn.frame = CGRectMake(20, 64 + 20 + 5, kLeftItemsWidth - 40, 30);
    [_moreFucBg addSubview:modifyBtn];
    
    UIImageView* image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"modify"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [modifyBtn addSubview:image];
    
    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"修改信息";
    label.frame = CGRectMake(30, 5, 90, 20);
    [modifyBtn addSubview:label];
    
    [modifyBtn addTarget:self
                  action:@selector(enterModifyInfoView)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* modifyBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn1.backgroundColor = [UIColor clearColor];
    modifyBtn1.frame = CGRectMake(20, 64 + 20 + 5*2 + 30, kLeftItemsWidth - 40, 30);
    [_moreFucBg addSubview:modifyBtn1];
    
    image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"modify"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [modifyBtn1 addSubview:image];
    
    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"修改信息";
    label.frame = CGRectMake(30, 5, 90, 20);
    [modifyBtn1 addSubview:label];
    
    [modifyBtn1 addTarget:self
                   action:@selector(enterModifyInfoView)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIView* lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.frame = CGRectMake(20, 64 + 20 + 5*3 + 30*2, kLeftItemsWidth - 20*2, 1);
    [_moreFucBg addSubview:lineView2];
    
    UIButton* contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.backgroundColor = [UIColor clearColor];
    contactBtn.frame = CGRectMake(20, 64 + 20 + 5*4 + 30*2, kLeftItemsWidth - 40, 30);
    [_moreFucBg addSubview:contactBtn];
    
    image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"contact"];
    image.frame = CGRectMake(5, 5, 20, 20);
    [contactBtn addSubview:image];
    
    label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"联系我们";
    label.frame = CGRectMake(30, 5, 90, 20);
    [contactBtn addSubview:label];
    
    [contactBtn addTarget:self
                   action:@selector(enterContactUsView)
         forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(hideMoreFucView)];
    [self.view addGestureRecognizer:tap];
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

    _statusImage.image = [Comm imageName:@"ensbyxzt"];
    [_moreBtn setImage:[Comm imageName:@"more"] forState:UIControlStateNormal];
}


- (void) enterCurveViewController
{
    CurveViewController* vc = [[CurveViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [self hideMoreFucView];
}
- (void) enterContactUsView
{
    ContactUsViewController* vc =
    (ContactUsViewController*)[Comm viewControllerId:@"ContactUsViewController" storyboard:@"Main"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [self hideMoreFucView];
}

- (void) enterModifyInfoView
{
    ModifyInfoViewController* vc =
    (ModifyInfoViewController*)[Comm viewControllerId:@"ModifyInfoViewController" storyboard:@"Main"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [self hideMoreFucView];
}

- (void) enterFucSettingView
{
    [self hideMoreFucView];
    
}

- (void) enterShutDownView
{
    ShutDownViewController* vc =
    (ShutDownViewController*)[Comm viewControllerId:@"ShutDownViewController" storyboard:@"Main"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [self hideMoreFucView];
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
