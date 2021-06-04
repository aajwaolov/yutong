//
//  Comm.m
//  yutong
//
//  Created by iOS01iMac on 16/1/23.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "Comm.h"

@implementation Comm

+ (__kindof UIViewController*)viewControllerId:(NSString*)identifier storyboard:(NSString*)storyboard
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:storyboard bundle:[NSBundle mainBundle]];
    return mainStoryboard ? [mainStoryboard instantiateViewControllerWithIdentifier:identifier] : nil;
}

+ (UIImage*)imageName:(NSString*)imageName
{
    if(/* DISABLES CODE */ (0))
    {
        return [UIImage imageNamed:imageName];
    }
    else
    {
        imageName = [NSString stringWithFormat:@"%@_en", imageName];
        return [UIImage imageNamed:imageName];
    }
}
@end
