//
//  ModifyPasswordViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/27.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mobileText.delegate = self;
    _emailText.delegate = self;
    _checkCodeText.delegate = self;
    _pwText.delegate = self;
    _reNewPwText.delegate = self;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(editResign)];
    [self.view addGestureRecognizer:tap];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if((textField == _checkCodeText) || (textField == _pwText))
    {
        [_scrollBg setContentOffset:CGPointMake(0, 160) animated:YES];
    }
    
    if(textField == _reNewPwText)
    {
        [_scrollBg setContentOffset:CGPointMake(0, 260) animated:YES];
    }
    return YES;
}

- (void) editResign
{
    [_mobileText resignFirstResponder];
    [_emailText resignFirstResponder];
    [_checkCodeText resignFirstResponder];
    [_pwText resignFirstResponder];
    [_reNewPwText resignFirstResponder];
    
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
