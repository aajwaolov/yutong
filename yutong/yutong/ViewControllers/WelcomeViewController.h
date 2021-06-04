//
//  WelcomeViewController.h
//  yutong
//
//  Created by iOS01iMac on 16/1/23.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import "BaseViewController.h"
#import "GPickerView.h"

@interface WelcomeViewController : BaseViewController<UIPickerViewDataSource,
                                                      UIPickerViewDelegate,
                                                      UIActionSheetDelegate,
                                                      UITableViewDelegate,
                                                      UITableViewDataSource,
                                                      GPickViewDelegate>
{
    NSInteger delIndex;
}

@property (strong, nonatomic) NSMutableArray* deviceArray;

@property (weak, nonatomic) IBOutlet UIImageView *deviceListBg;
@property (weak, nonatomic) IBOutlet UIButton *setLanguageBtn;

@property (strong, nonatomic) UITableView* deviceList;
@property (weak, nonatomic) IBOutlet UIImageView *deviceListImage;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
