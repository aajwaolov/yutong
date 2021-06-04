//
//  GPickerView.m
//  TestFramwork
//
//  Created by iOS01iMac on 1/30/16.
//  Copyright © 2016 ghm. All rights reserved.
//

#import "GPickerView.h"
#import "CommonDefine.h"

@implementation GPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSInteger viewHeight = CGRectGetHeight(frame);
//        _pickBg = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                           viewHeight - 240,
//                                                           kMainScreenWidth,
//                                                           240)];
        
//        _pickBg = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                           kMainScreenHeight - 240,
//                                                           kMainScreenWidth,
//                                                           240)];
        _pickBg = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           viewHeight,
                                                           kMainScreenWidth,
                                                           240)];
        
        _pickBg.backgroundColor = [UIColor clearColor];
        [self addSubview:_pickBg];

        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 200)];
        _pickView.multipleTouchEnabled = NO;
        _pickView.backgroundColor = [UIColor whiteColor];
//        _pickView.layer.borderColor = kLayerBorderColor.CGColor;
//        _pickView.layer.borderWidth = 1.0f;
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.autoresizingMask = UIViewAutoresizingNone;
        _pickView.showsSelectionIndicator = YES;
        [_pickBg addSubview:_pickView];

        UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        toolBar.backgroundColor = [UIColor grayColor];
//        toolBar.layer.borderColor = kLayerBorderColor.CGColor;
//        toolBar.layer.borderWidth = 1.0f;
        [_pickBg addSubview:toolBar];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [finishBtn setTitleColor:kLayerBorderColor forState:UIControlStateNormal];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        finishBtn.frame = CGRectMake(kMainScreenWidth-80, 0, 60, 40);
        [toolBar addSubview:finishBtn];
        [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *CancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CancelBtn.tag  = 101;
        CancelBtn.frame = CGRectMake(20, 0, 60, 40);
        [CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        leftBtn.transform = CGAffineTransformMakeRotation(M_PI);
        [toolBar addSubview:CancelBtn];
        [CancelBtn addTarget:self action:@selector(CancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) show
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    _pickBg.frame = CGRectMake(0, kMainScreenHeight - 240, kMainScreenWidth, 240);
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
//    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void) hide
{
    NSInteger viewHeight = kMainScreenHeight;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    _pickBg.frame = CGRectMake(0, viewHeight, kMainScreenWidth, 240);
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (void) animationFinished
{
    [self removeFromSuperview];
}

- (void) finishBtnClick: (UIButton*) btn
{
    NSMutableArray* selectArray = [NSMutableArray arrayWithCapacity:1];
    for(int i =0; i < _ComponentCount; i++)
    {
        NSInteger selectId = [_pickView selectedRowInComponent:i];
        
        [selectArray addObject:[NSNumber numberWithInteger: selectId]];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(pickResult:)])
    {
        [self.delegate pickResult:selectArray];
    }
    
    [self hide];
//    [self removeFromSuperview];
}

- (void) CancelBtnClick: (UIButton*) btn
{
//    [self removeFromSuperview];
    [self hide];
}

#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
    {
//        [self.delegate pickerView:self didSelectRow:row inComponent:component];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(numberOfComponentsInPickerView:)])
    {
        _ComponentCount = [self.delegate numberOfComponentsInPickerView:self];
        return _ComponentCount;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)])
    {
        return [self.delegate pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)])
    {
        return [self.delegate pickerView:self titleForRow:row forComponent:component];
    }
    return nil;
}

- (void) setDelegate:(id<GPickViewDelegate>)delegate1
{
    _delegate = delegate1;
}
@end
