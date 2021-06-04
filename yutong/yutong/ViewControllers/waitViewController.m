//
//  waitViewController.m
//  yutong
//
//  Created by Gao Haiming on 16/6/19.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "waitViewController.h"
#import "LoginViewController.h"

#import "Comm.h"

@interface waitViewController ()

@end

@implementation waitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* image = [[UIImageView alloc]init];
    image.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    image.image = [UIImage imageNamed:@"pic"];
    [self.view addSubview:image];
    
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(enterNextView) userInfo:nil repeats:NO];
    [timer fire];
}

- (void) enterNextView
{
    LoginViewController* vc =
        (LoginViewController*)[Comm viewControllerId:@"LoginViewController" storyboard:@"Main"];

    vc.deviceDic = _deviceDic;
    [self.navigationController pushViewController:vc animated:YES];
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
