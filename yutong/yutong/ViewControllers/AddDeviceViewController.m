//
//  AddDeviceViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/23.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "AddDeviceViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>

#import "DBManager.h"
#import "Comm.h"

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLanguageImage];
    
    _deviceIdTextField.delegate = self;
    
    UITapGestureRecognizer *recognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleTapped)];
    [self.view addGestureRecognizer:recognizer];
    
    _deviceIdTextField.text = [self getWifiName];
}

- (void) setLanguageImage
{
    UIView* titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, 200, 30);
    
    UIImageView* titleImage = [[UIImageView alloc]init];
    titleImage.image = [Comm imageName:@"add_title"];
    titleImage.frame = CGRectMake(80, 5, 40, 20);
    
    [titleView addSubview:titleImage];
    
    self.navigationItem.titleView = titleView;
    
    _device_bg.image = [Comm imageName:@"device_id"];
    
    [_addBtn setImage:[Comm imageName:@"add_btn"] forState:UIControlStateNormal];
//    _deviceListImage.image = [Comm imageName:@"device_list_text"];
//    
//    [_addBtn setImage:[Comm imageName:@"add_device_btn"] forState:UIControlStateNormal];
    
    
}

- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    
    wifiName = [wifiName substringFromIndex: wifiName.length - 6];
    return wifiName;
}

- (IBAction)addDevice:(id)sender
{
    if(![self checkData])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请输入六位的设备ID"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定",nil];
        [alert show];
        return;
    }
    
    
    
    if([[DBManager instanse] insertDevice:_deviceIdTextField.text])
    {
//        [_deviceArray addObject: _deviceIdTextField.text];
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"设备ID 已经存在"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定",nil];
        [alert show];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) checkData
{
    if([_deviceIdTextField.text length] != 6)
    {
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _deviceIdTextField)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6)
        {
            return NO;
        }
    }
    return YES;
}

//- (void)textFieldDidChange:(UITextField *)textField
//{
//    if (textField == _deviceIdTextField)
//    {
//        if (textField.text.length > 6)
//        {
//            textField.text = [textField.text substringToIndex:6];
//        }
//    }
//}

- (void) handleTapped
{
    [_deviceIdTextField resignFirstResponder];
}

@end
