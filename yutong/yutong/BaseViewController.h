//
//  BaseViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/22.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController<MBProgressHUDDelegate>
{
        MBProgressHUD *_HUD;
}

- (void) setLeftBarButtonItem:(UIView*) view;
- (void) setRightBarButtonItem:(UIView*) view;

- (void) showHint: (NSString*) hint;
- (void) showProgress;
- (void) hideProgress;
- (void)hudWasHidden:(MBProgressHUD *)hud;

@end
