//
//  SettingSlider.m
//  yutong
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "SettingSlider.h"
#import "UIView+SDAutoLayout.h"

@interface SettingSlider()
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;

@end

@implementation SettingSlider

#pragma clang diagnostic ignored "-Wformat"
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
        self.minValue = -10;
        self.maxValue = 10;
    }
    return self;
}

- (void)initView
{
    self.leftImageView.contentMode = self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"seekbj"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 60.0f, 1.0f, 60.0f) resizingMode:UIImageResizingModeStretch]];
    self.slider = [[UISlider alloc] init];
    [self.slider setThumbImage:[UIImage imageNamed:@"fang"] forState:UIControlStateNormal];
    [self sd_addSubviews:@[self.backView, self.slider, self.leftView, self.rightView]];
    [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _leftLabel;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left2"]];
    }
    return _leftImageView;
}

- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        [_leftView sd_addSubviews:@[self.leftLabel, self.leftImageView]];
    }
    return _leftView;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _rightLabel;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right2"]];
    }
    return _rightImageView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        [_rightView sd_addSubviews:@[self.rightLabel, self.rightImageView]];
    }
    return _rightView;
}

- (void)addAutoLayout
{
    self.backView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.leftView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .heightRatioToView(self, 1.0f)
    .topSpaceToView(self, 0.0f);

    self.leftLabel.sd_layout
    .centerYEqualToView(self.leftView)
    .leftSpaceToView(self.leftView, 2.0f)
    .heightRatioToView(self.leftView, 1.0f);

    self.leftImageView.sd_layout
    .leftSpaceToView(self.leftLabel, 2.0f)
    .centerYEqualToView(self.leftView)
    .heightRatioToView(self.leftView, 0.6f)
    .widthEqualToHeight();

    [self.leftLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];

    [self.leftView setupAutoWidthWithRightView:self.leftImageView rightMargin:2.0f];

    self.rightView.sd_layout
    .rightSpaceToView(self, 0.0f)
    .heightRatioToView(self, 1.0f)
    .topSpaceToView(self, 0.0f);

    self.rightImageView.sd_layout
    .leftSpaceToView(self.rightView, 2.0f)
    .centerYEqualToView(self.rightView)
    .heightRatioToView(self.rightView, 0.6f)
    .widthEqualToHeight();

    self.rightLabel.sd_layout
    .centerYEqualToView(self.rightView)
    .leftSpaceToView(self.rightImageView, 2.0f)
    .heightRatioToView(self.rightView, 1.0f);
    [self.rightLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];

    [self.rightView setupAutoWidthWithRightView:self.rightLabel rightMargin:2.0f];

    self.slider.sd_layout
    .leftSpaceToView(self.leftView, 0.0f)
    .rightSpaceToView(self.rightView, 0.0f)
    .topSpaceToView(self, 0.0f)
    .heightRatioToView(self, 1.0f);
}

- (void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    self.slider.minimumValue = minValue;
    if (self.type == SettingSliderTypeC) {
        self.leftLabel.text = [NSString stringWithFormat:@"%d℃", (NSInteger)floorf(minValue)];
    } else {
        self.leftLabel.text = [NSString stringWithFormat:@"%d℉", (NSInteger)floorf(minValue)];
    }
    [self.leftView updateLayout];
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    self.slider.maximumValue = maxValue;
    if (self.type == SettingSliderTypeC) {
        self.rightLabel.text = [NSString stringWithFormat:@"%d℃", (NSInteger)floorf(maxValue)];
    } else {
        self.rightLabel.text = [NSString stringWithFormat:@"%d℉", (NSInteger)floorf(maxValue)];
    }
    [self.rightView updateLayout];
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    self.slider.value = value;
}

- (void)valueChanged:(UISlider *)slider
{
    if (self.block) {
        self.block(slider.value);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end
