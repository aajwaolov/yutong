//
//  Comm.h
//  yutong
//
//  Created by iOS01iMac on 16/1/23.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Comm : NSObject

+ (__kindof UIViewController*)viewControllerId:(NSString*)identifier storyboard:(NSString*)storyboard;

+ (UIImage*)imageName:(NSString*)imageName;
@end
