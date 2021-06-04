//
//  FuctionSettingViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/27.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"
#import "GPickerView.h"
#import "SocketManager.h"

@interface FuctionSettingViewController : BaseViewController<GPickViewDelegate>
{
    SocketManager* _asyncSocket;
    NSInteger _requestType;
    
    NSInteger _value1;
    NSInteger _value2;
    NSInteger _value3;
    
    NSInteger _unitType;
    NSInteger _dydj;
    
}

@property (weak, nonatomic) IBOutlet UIButton *ChangeTemperatureUnitBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;
@property (weak, nonatomic) IBOutlet UISlider *slider3;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperature1;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperature2;
@property (weak, nonatomic) IBOutlet UILabel *temperature1Min;
@property (weak, nonatomic) IBOutlet UILabel *temperature1Max;
@property (weak, nonatomic) IBOutlet UILabel *temperature2Min;
@property (weak, nonatomic) IBOutlet UILabel *temperature2Max;

@property (weak, nonatomic) IBOutlet UIImageView *temperatureImage;
@property (weak, nonatomic) IBOutlet UIImageView *setTemperatureImage;

@property (weak, nonatomic) IBOutlet UIImageView *voltage;
@property (weak, nonatomic) IBOutlet UIImageView *temperature_unit_bg;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
