//
//  BaseViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/22.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonDefine.h"

@implementation BaseViewController

- (void) setLeftBarButtonItem:(UIView*) view
{
    UIBarButtonItem* backBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backBarItem;
    self.navigationItem.backBarButtonItem = nil;
}

- (void) setRightBarButtonItem:(UIView*) view
{
    UIBarButtonItem* rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void) setDefaultLeftBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, 30, 30);
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBarButtonItem: button];
}

- (void) setToolbarView:(UIView*) view
{
    [self.view addSubview:view];
}

- (void) setDefaulToolbarView
{
    UIImageView*  toolBarImage = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"foot"]];
    toolBarImage.frame = CGRectMake(0,
                                    kMainScreenHeight - kToolBarHieght,
                                    kMainScreenWidth,
                                    kToolBarHieght);

    UILabel* toolBarLabel = [[UILabel alloc]init];
    toolBarLabel.frame = CGRectMake(0, 0, kMainScreenWidth, kToolBarHieght);
    toolBarLabel.text = @"www.evakool.com";
    toolBarLabel.textAlignment = NSTextAlignmentCenter;
    toolBarLabel.textColor = [UIColor whiteColor];
    
    [toolBarImage addSubview:toolBarLabel];
    
    [self setToolbarView:toolBarImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName,
                                [UIFont systemFontOfSize:20],
                                NSFontAttributeName,
                                nil];
     [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"foot"]forBarMetrics:UIBarMetricsDefault];

    NSLog(@"self.navigationController.topViewController= %@", self.navigationController.viewControllers[0]);
    if(self != self.navigationController.viewControllers[0])
    {
        [self setDefaultLeftBarButtonItem];
    }
    
    [self setDefaulToolbarView];
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showHint: (NSString*) hint
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}

- (void) hideProgress
{
    [_HUD hide:YES];
}

- (void) showProgress
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.delegate = self;
    [_HUD show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    _HUD = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
