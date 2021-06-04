//
//  CurveViewController.h
//  yutong
//
//  Created by iOS01iMac on 2/4/16.
//  Copyright © 2016 ghm. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DemoBaseViewController.h"
#import <Charts/Charts.h>
#import "SocketManager.h"

@interface CurveViewController : DemoBaseViewController<ChartViewDelegate>
{
    NSInteger _requestType;

    SocketManager* _asyncSocket;
    
    NSInteger _num1;
//    NSInteger _num2;
//    NSInteger _num3;
//    NSInteger _num4;
//    NSInteger _num5;
//    NSInteger _num6;
//    NSInteger _num7;
//    NSInteger _num8;
    
    NSInteger goon;
    
//    NSInteger _recTime;
    
    NSInteger _latestCount;
    
    NSInteger _requestStatus;
    
}

@property (nonatomic, strong) LineChartView *chartView;

@property (strong, nonatomic) NSMutableArray* wd_1;
@property (strong, nonatomic) NSMutableArray* wd_2;
@property (strong, nonatomic) NSMutableArray* wdAll;
@property (strong, nonatomic) NSMutableArray* wdAll1;
@property (strong, nonatomic) NSMutableArray* wdAll2;
//@property (strong, nonatomic) NSMutableArray* wd_3;
//@property (strong, nonatomic) NSMutableArray* wd_4;
//@property (strong, nonatomic) NSMutableArray* wd_5;
//@property (strong, nonatomic) NSMutableArray* wd_6;
//@property (strong, nonatomic) NSMutableArray* wd_7;
//@property (strong, nonatomic) NSMutableArray* wd_8;


@property (strong, nonatomic) NSMutableArray* dy_1;
@property (strong, nonatomic) NSMutableArray* dy_2;
@property (strong, nonatomic) NSMutableArray* dy_All;

@property (strong, nonatomic) NSString* recStr;


@end
