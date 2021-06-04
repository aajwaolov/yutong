//
//  SettingSlider.h
//  yutong
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingSliderType)
{
    SettingSliderTypeC = 0,
    SettingSliderTypeF
};

typedef void (^SettingSliderBlock)(CGFloat value);

@interface SettingSlider : UIView

@property (assign, nonatomic) SettingSliderType type;
@property (assign, nonatomic) CGFloat minValue;
@property (assign, nonatomic) CGFloat maxValue;
@property (assign, nonatomic) CGFloat value;

@property (copy, nonatomic) SettingSliderBlock block;

@end
