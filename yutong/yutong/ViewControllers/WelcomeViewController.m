//
//  WelcomeViewController.m
//  yutong
//
//  Created by iOS01iMac on 16/1/23.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "WelcomeViewController.h"
#import "CommonDefine.h"
#import "AddDeviceViewController.h"
#import "LoginViewController.h"
#import "Comm.h"
#import "ShutDownViewController.h"
#import "ModifyInfoViewController.h"
#import "ModifyPasswordViewController.h"
#import "RegisterViewController.h"
#import "MobileFridgeViewController.h"

#import "waitViewController.h"
#import "Global.h"

#import "GPickerView.h"
#import "UIView+SDAutoLayout.h"
#import "DBManager.h"


@implementation WelcomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"deviceArray = %lu", (unsigned long)[_deviceArray count]);
    
    DBManager* db = [DBManager instanse];
    _deviceArray = [db devices];
    
    [_deviceList reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLanguageImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBManager* db = [DBManager instanse];
    
    _deviceArray = [NSMutableArray arrayWithCapacity:1];
    _deviceArray = [db devices];
    
//    CGRect rect = _deviceListBg.frame;
    _deviceList = [[UITableView alloc]init];
    [_deviceListBg addSubview:_deviceList];

    _deviceList.dataSource = self;
    _deviceList.delegate = self;
    _deviceList.backgroundColor = [UIColor clearColor ];
    _deviceList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deviceList.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f));

    
    _deviceListBg.userInteractionEnabled = YES;

}

- (void) setLanguageImage
{
    UIView* titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, 200, 30);
    
    UIImageView* titleImage = [[UIImageView alloc]init];
    titleImage.image = [Comm imageName:@"welcome"];
    titleImage.frame = CGRectMake(50, 5, 100, 20);
    
    [titleView addSubview:titleImage];
    
    self.navigationItem.titleView = titleView;
    
    _deviceListImage.image = [Comm imageName:@"device_list_text"];

}

- (IBAction)ChangeLanguage:(id)sender
{
    GPickerView* pickerView = [[GPickerView alloc]initWithFrame:self.view.frame];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    
    [pickerView show];
}

#pragma mark -- GPickviewDelegate

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
            return @"中文";
        }
        case 1:
        {
            return @"English";
        }
            
        default:
            break;
    }
    return nil;
}

- (void) pickResult:(NSArray*) pickerArray
{
    NSNumber* num = [pickerArray objectAtIndex:0];
    
    switch (num.intValue)
    {
        case 0:
        {
            [_setLanguageBtn setTitle:@"中文" forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            [_setLanguageBtn setTitle:@"English" forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)addDevice:(id)sender
{
    AddDeviceViewController* vc =
        [Comm viewControllerId:@"AddDeviceViewController" storyboard:@"Main"];
//    vc.deviceArray = _deviceArray;
    
    [self.navigationController pushViewController:vc animated:YES];
    
//    ShutDownViewController* vc =
//    [Comm viewControllerId:@"ShutDownViewController" storyboard:@"Main"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
//    ModifyInfoViewController* vc =
//        [Comm viewControllerId:@"ModifyInfoViewController" storyboard:@"Main"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
//    MobileFridgeViewController* vc =
//    [Comm viewControllerId:@"MobileFridgeViewController" storyboard:@"Main"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)search:(id)sender
{
    
}

#pragma mark -- tableViewDelegate
// UITableViewController specifics
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_deviceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"deviceList";
    UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel* deviceIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
        deviceIdLabel.font = [UIFont systemFontOfSize:14];
        deviceIdLabel.textAlignment = NSTextAlignmentLeft;
        deviceIdLabel.text = @"DevID：";
        
        UILabel* deviceId= [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 150, 20)];
        deviceId.text = [[_deviceArray objectAtIndex:indexPath.row] objectForKey:kDeviceId];
        deviceId.tag = 1;
        deviceId.font = [UIFont systemFontOfSize:12];
        
        UILabel* deviceIdTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 70, 20)];
        deviceIdTypeLabel.font = [UIFont systemFontOfSize:14];
        deviceIdTypeLabel.text = @"DevType：";
        deviceIdTypeLabel.textAlignment = NSTextAlignmentLeft;
        
        
        UILabel* deviceIdType = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 150, 20)];
        if([[[_deviceArray objectAtIndex:indexPath.row] objectForKey:kDeviceType] integerValue] == 1)
        {
            deviceIdType.text = @"Double Zone";
        }
        else if([[[_deviceArray objectAtIndex:indexPath.row] objectForKey:kDeviceType] integerValue] == 2)
        {
            deviceIdType.text = @"Sigle Zone";
        }
        deviceIdType.font = [UIFont systemFontOfSize:12];
        deviceIdType.tag = 2;
        
        [cell.contentView addSubview:deviceIdLabel];
        [cell.contentView addSubview:deviceIdTypeLabel];
        
        [cell.contentView addSubview:deviceId];
        [cell.contentView addSubview:deviceIdType];
        
        UIButton* delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(CGRectGetWidth(tableView.frame) - 50.0f , 18, 30, 24);
        [delBtn setBackgroundImage:ImageWithName(@"alarm_delete_1") forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delDevice:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:delBtn];
        
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.frame = CGRectMake(0, 59, CGRectGetWidth(tableView.frame), 1);
        [cell.contentView addSubview:lineView];
    }
    else
    {
        UILabel* deviceId = [(UILabel*) cell.contentView viewWithTag:1];
        deviceId.text = [[_deviceArray objectAtIndex:indexPath.row] objectForKey:kDeviceId];
        
        UILabel* deviceType = [(UILabel*) cell.contentView viewWithTag:2];
        if([[[_deviceArray objectAtIndex:indexPath.row] objectForKey:kDeviceType] integerValue] == 1)
        {
            deviceType.text = @"Double Zone";
        }
        else if([[[_deviceArray objectAtIndex:indexPath.row] objectForKey:kDeviceType] integerValue] == 2)
        {
            deviceType.text = @"Sigle Zone";
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LoginViewController* vc =
//        (LoginViewController*)[Comm viewControllerId:@"LoginViewController" storyboard:@"Main"];
//    
//    vc.deviceDic = [_deviceArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    
    waitViewController* vc = [[waitViewController alloc]init];
    [Global instanse].deviceDic = [_deviceArray objectAtIndex:indexPath.row];
    vc.deviceDic = [_deviceArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) delDevice:(UIButton*) btn
{
    UITableViewCell* cell = (UITableViewCell*)[[btn superview]superview];
    NSIndexPath* index = [_deviceList indexPathForCell:cell];
    delIndex = index.row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Confirm delete the device"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"YES",nil];
    [alert show];
}

- (void) delete
{
    DBManager* db = [DBManager instanse];
    [db deleteDevice: [[_deviceArray objectAtIndex:delIndex]objectForKey:kDeviceId]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self delete];
        [_deviceArray removeObjectAtIndex:delIndex];
        NSIndexPath* index = [NSIndexPath indexPathForRow:delIndex inSection:0];
        [_deviceList deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        
    }
}

@end
