//
//  SettingViewController.h
//  yutong
//
//  Created by Gao Haiming on 16/6/19.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"
#import "SettingSlider.h"

@interface SettingViewController : BaseViewController


@property (strong, nonatomic) UIButton* cBtn;

@property (strong, nonatomic) UIButton* fBtn;


@property (strong, nonatomic) UIButton* lBtn;
@property (strong, nonatomic) UIButton* mBtn;
@property (strong, nonatomic) UIButton* hBtn;

@property (strong, nonatomic) SettingSlider *slider1;
@property (strong, nonatomic) SettingSlider *slider2;

@property (strong, nonatomic) UILabel* leftTemperature;
@property (strong, nonatomic) UILabel* rightTemperature;

@end
