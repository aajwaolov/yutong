//
//  GPickerView.h
//  TestFramwork
//
//  Created by iOS01iMac on 1/30/16.
//  Copyright © 2016 ghm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPickerView;

@protocol GPickViewDelegate <NSObject>

@optional

//- (void)pickerView:(GPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (void) pickResult:(NSArray*) pickerArray;

- (NSInteger)numberOfComponentsInPickerView:(GPickerView *)pickerView;

- (NSInteger)pickerView:(GPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(GPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;


@end

@interface GPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView* pickView;
@property (nonatomic, strong) UIView* pickBg;

@property (nonatomic, assign) id<GPickViewDelegate>delegate;

@property (nonatomic, assign) NSInteger ComponentCount;


-(void) show;

@end
