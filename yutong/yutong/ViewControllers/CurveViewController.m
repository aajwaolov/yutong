//
//  CurveViewController.m
//  yutong
//
//  Created by iOS01iMac on 2/4/16.
//  Copyright © 2016 ghm. All rights reserved.
//

#import "CurveViewController.h"
#import "CommonDefine.h"
#import "yutong-Swift.h"
#import "CommonNetworkDefine.h"
#import "Comm.h"

#pragma clang diagnostic ignored "-Wformat"
@interface CurveViewController ()

@property (strong, nonatomic) NSString *requestString;
@property (strong, nonatomic) NSString *suffix;
@property (strong, nonatomic) NSMutableArray *dyArray;

@end

@implementation CurveViewController

const static NSInteger countPerPage = 5;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDefaultLeftBarButtonItem];
    
    [self setLanguageImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName,
                                [UIFont systemFontOfSize:20],
                                NSFontAttributeName,
                                nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"foot"]forBarMetrics:UIBarMetricsDefault];
    
    UIImageView* bg = [[UIImageView alloc]init];
    bg.userInteractionEnabled = YES;
    bg.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    
    [self.view addSubview:bg];
    
    UIImageView* chartBg = [[UIImageView alloc]init];
    chartBg.userInteractionEnabled = YES;
    chartBg.frame = CGRectMake(20, 20, kMainScreenWidth - 20*2, kMainScreenHeight - 70 - 20 - 64);
    chartBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chartBg];
    
    _chartView = [[LineChartView alloc]init];
    _chartView.frame = CGRectMake(2, 2, chartBg.frame.size.width-4, chartBg.frame.size.height - 4);
    _chartView.backgroundColor = kColorHex(0x70ffff);
    [chartBg addSubview:_chartView];
    
    [self setChartView];
    
    CGFloat btnMargin = 20;
    CGFloat leftMargin = 20;
    CGFloat btnWidth = ((kMainScreenWidth - leftMargin*2) - btnMargin*2)/3;
    CGFloat btnY = 70 + (kMainScreenHeight - 70 - 70 - 64) + 20;
    CGFloat btnHeight = 30;
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(leftMargin, btnY, btnWidth, btnHeight);
    leftBtn.backgroundColor = [UIColor clearColor];
    [bg addSubview:leftBtn];
    leftBtn.tag = 1;
    if(/* DISABLES CODE */ (1))
    {
        [leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    }
    else
    {
        [leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    [leftBtn addTarget:self action:@selector(startRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.hidden = YES;
    rightBtn.frame = CGRectMake(leftMargin + btnWidth + btnMargin, btnY, btnWidth, btnHeight);
    rightBtn.backgroundColor = [UIColor clearColor];
    [bg addSubview:rightBtn];
    rightBtn.tag = 2;
    if(/* DISABLES CODE */ (1))
    {
        [rightBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    }
    else
    {
        [rightBtn setImage:[Comm imageName:@""] forState:UIControlStateNormal];
    }
    [rightBtn addTarget:self action:@selector(startRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* voltageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voltageBtn.frame = CGRectMake(leftMargin + (btnWidth + btnMargin)*2, btnY, btnWidth, btnHeight);
    voltageBtn.backgroundColor = [UIColor clearColor];
    [bg addSubview:voltageBtn];
    voltageBtn.tag = 3;
    if(/* DISABLES CODE */ (1))
    {
        [voltageBtn setImage:[UIImage imageNamed:@"voltage2"] forState:UIControlStateNormal];
    }
    else
    {
        [voltageBtn setImage:[Comm imageName:@""] forState:UIControlStateNormal];
    }
    [voltageBtn addTarget:self action:@selector(startRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    _wd_1 = [NSMutableArray arrayWithCapacity:1];
    _wd_2 = [NSMutableArray arrayWithCapacity:1];
    _wdAll = [NSMutableArray arrayWithCapacity:1];
    _wdAll1 = [NSMutableArray arrayWithCapacity:1];
    _wdAll2 = [NSMutableArray arrayWithCapacity:1];

    _dy_1 = [NSMutableArray array];
    _dy_2 = [NSMutableArray array];
    _dy_All = [NSMutableArray array];
    _requestType = 1;

}

- (void) setLanguageImage
{
    UIView* titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, 200, 30);
    
    UIImageView* titleImage = [[UIImageView alloc]init];
    titleImage.image = [Comm imageName:@"graph"];
    titleImage.frame = CGRectMake(70, 5, 60, 20);
    
    [titleView addSubview:titleImage];
    
    self.navigationItem.titleView = titleView;
    
//    _deviceListImage.image = [Comm imageName:@"device_list_text"];
//    
//    [_addBtn setImage:[Comm imageName:@"add_device_btn"] forState:UIControlStateNormal];
}

- (void) startRequest
{
    //    if(!_asyncSocket)
    //    {
    
    _asyncSocket = [SocketManager instanse];
    [_asyncSocket disconnect];
    _asyncSocket.delegate = self;
    NSError *err = nil;

    if(![_asyncSocket connectToHost:ROUTER_TCP_IP onPort:ROUTER_TCP_Port error:&err])
    {
        NSLog(@"Error: %@", err);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"网络连接失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    return;
}
- (void) startRequest:(UIButton*) btn
{
    _requestType = 1;
    
    _requestStatus = btn.tag;
    [_wd_1 removeAllObjects];
    [_wd_2 removeAllObjects];
    
    [_wdAll removeAllObjects];
    [_wdAll1 removeAllObjects];
    [_wdAll2 removeAllObjects];

    [_dy_1 removeAllObjects];
    [_dy_2 removeAllObjects];
    [_dy_All removeAllObjects];
    
    [self startRequest];
}

- (NSString*) requestData
{
    _num1 = 0;
    if(_requestStatus == 1)
    {
        self.requestString = @"JTZNBX2015#read_wd1_1#";
    }
    else if(_requestStatus == 2)
    {
        self.requestString = @"JTZNBX2015#read_wd2_1#";
    }
    else if(_requestStatus == 3)
    {
        self.requestString = @"JTZNBX2015#read_dy1_1#";
    }
    else
    {
        self.requestString = @"JTZNBX2015#read_dy2_1#";
    }
    
    return self.requestString;
}


- (NSString *)suffix
{
    return [self.requestString substringWithRange:NSMakeRange(self.requestString.length - 4, 1)];
}

- (NSMutableArray *)dyArray
{
    if ([self.suffix isEqualToString:@"1"]) {
        return _dy_1;
    }
    return _dy_2;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [self showProgress];
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    NSString* requestStr = [self requestData];
    NSLog(@"tempStr = %@", requestStr);
    NSData* data = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [_asyncSocket writeData:data withTimeout:-1 tag:1];
    [_asyncSocket readDataWithTimeout:30 tag:1];
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"aStr===%@",aStr);
    
    if(_requestType == 1) {
        NSArray* tempArray = [aStr componentsSeparatedByString:@"#"];
       
        if(_num1 == 0) {
            _recStr = @"";
            _recStr = [_recStr stringByAppendingString:aStr];
            
            _num1 = ((NSString*)[tempArray objectAtIndex:1]).integerValue;
            
            if(_num1 == [_recStr length])
            {
                for(int i = 2; i < [tempArray count] - 1; i++)
                {
                    NSInteger tempInt = ((NSString*)[tempArray objectAtIndex:i]).integerValue;
                    NSMutableArray *array = (_requestStatus == 3 || _requestStatus == 4) ? self.dyArray : _wd_1;
                    [array addObject:[NSNumber numberWithInteger:tempInt]];
                }
                
                _requestType = 2;
                _recStr = @"";
                
                _num1 = 0;
                
                if(_requestStatus == 1)
                {
                    self.requestString = @"JTZNBX2015#read_wd1";
                }
                else if(_requestStatus == 2)
                {
                    self.requestString = @"JTZNBX2015#read_wd2";
                }
                else if(_requestStatus == 3)
                {
                    self.requestString = @"JTZNBX2015#read_dy1";
                }
                else
                {
                    self.requestString = @"JTZNBX2015#read_dy2";
                }
                self.requestString = [NSString stringWithFormat:@"%@_%ld#", self.requestString,tag + 1];
                NSData* data = [self.requestString dataUsingEncoding:NSUTF8StringEncoding];
                
                [_asyncSocket writeData:data withTimeout:-1 tag:tag + 1];
                [_asyncSocket readDataWithTimeout:30 tag: tag + 1];
            }
            else
            {
                [sock readDataWithTimeout:-1 tag:tag];
            }
        }
        else
        {
             _recStr = [_recStr stringByAppendingString:aStr];
            
            if(_num1 == [_recStr length])
            {
                NSArray* tempArray1 = [_recStr componentsSeparatedByString:@"#"];
                for(int i = 2; i < [tempArray1 count] - 1; i++)
                {
                    NSInteger tempInt = ((NSString*)[tempArray1 objectAtIndex:i]).integerValue;
                    NSMutableArray *array = (_requestStatus == 3 || _requestStatus == 4) ? self.dyArray : _wd_1;
                    [array addObject:[NSNumber numberWithInteger:tempInt]];
                }
                _requestType = 2;
                _recStr = @"";
                
                _num1 = 0;
                
                [_wd_2 removeAllObjects];

                if(_requestStatus == 1)
                {
                    self.requestString = @"JTZNBX2015#read_wd1";
                }
                else if(_requestStatus == 2)
                {
                    self.requestString = @"JTZNBX2015#read_wd2";
                }
                else if(_requestStatus == 3)
                {
                    self.requestString = @"JTZNBX2015#read_dy1";
                }
                else
                {
                    self.requestString = @"JTZNBX2015#read_dy2";
                }
                
                self.requestString = [NSString stringWithFormat:@"%@_%ld#",self.requestString,tag + 1];
                
                NSData* data = [self.requestString dataUsingEncoding:NSUTF8StringEncoding];
                
                [_asyncSocket writeData:data withTimeout:-1 tag:tag + 1];
                [_asyncSocket readDataWithTimeout:30 tag: tag + 1];
            }
            else
            {
                [sock readDataWithTimeout:-1 tag:tag];
            }

        }
    }
    else
    {
        NSArray* tempArray = [aStr componentsSeparatedByString:@"#"];

        if(_num1 == 0) {
            _recStr = @"";
            _recStr = [_recStr stringByAppendingString:aStr];
            
             _num1 = ((NSString*)[tempArray objectAtIndex:1]).integerValue;
            
            if(_num1 == [_recStr length]) {
                if([tempArray count] - 2 == 1024) {
                    _recStr = @"";

                    if(_requestStatus == 1)
                    {
                        self.requestString = @"JTZNBX2015#read_wd1";
                    }
                    else if(_requestStatus == 2)
                    {
                        self.requestString = @"JTZNBX2015#read_wd2";
                    }
                    else if(_requestStatus == 3)
                    {
                        self.requestString = @"JTZNBX2015#read_dy1";
                    }
                    else
                    {
                        self.requestString = @"JTZNBX2015#read_dy2";
                    }
                    
                    self.requestString = [NSString stringWithFormat:@"%@_%ld#",self.requestString,tag + 1];
                    
                    NSData* data = [self.requestString dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSLog(@"tag == %ld", tag + 1);
                    [_asyncSocket writeData:data withTimeout:-1 tag:tag + 1];
                    [_asyncSocket readDataWithTimeout:30 tag: tag + 1];
                } else {
                    for(int i = 2; i < [tempArray count] - 1; i++)
                    {
                        NSInteger tempInt = ((NSString*)[tempArray objectAtIndex:i]).integerValue;
                        NSMutableArray *array = (_requestStatus == 3 || _requestStatus == 4) ? self.dyArray : _wd_1;
                        [array addObject:[NSNumber numberWithInteger:tempInt]];
                    }
                    if (_requestStatus == 3) {
                        tag = 0;
                        _requestType = 1;
                        _num1 = 0;
                        _requestStatus = 4;
                        self.requestString = @"JTZNBX2015#read_dy2";
                        self.requestString = [NSString stringWithFormat:@"%@_%ld#",self.requestString,tag + 1];

                        NSData* data = [self.requestString dataUsingEncoding:NSUTF8StringEncoding];

                        NSLog(@"tag == %ld", tag + 1);
                        [_asyncSocket writeData:data withTimeout:-1 tag:tag + 1];
                        [_asyncSocket readDataWithTimeout:30 tag: tag + 1];
                    } else {

                        [self hideProgress];
                        if (_requestStatus == 4) {

                            NSInteger count = (_dy_1.count < _dy_2.count)?_dy_1.count:_dy_2.count;
                            for (int i = 0; i < count; i++)
                            {

                                NSNumber* num1 = [_dy_1 objectAtIndex:i];
                                NSNumber* num2 = [_dy_2 objectAtIndex:i];
                                NSString* tempStr = [NSString stringWithFormat:@"%ld.%ld", num1.integerValue, num2.integerValue];

                                NSLog(@"tempStr  = %@", tempStr);

                                NSNumber* tempNum = [NSNumber numberWithFloat:tempStr.floatValue];
                                [_dy_All addObject:tempNum];
                            }


                            [self setChartViewV];
                            [self setDataCountV:_dy_All];

                            NSLog(@"_wdAll count = %ld", [_dy_All count]);
                            [_chartView.viewPortHandler setMaximumScaleX: _dy_All.count/countPerPage];
                            [_chartView zoom:_dy_All.count/(countPerPage * 6) scaleY:2 x:0 y:0];
                        } else {
                            //温度了

                            for (int i = 0; i < _wd_1.count; i++)
                            {
                                NSString* temp = [_wd_1 objectAtIndex:i];
                                NSNumber* tempNum = [NSNumber numberWithInteger:temp.integerValue];
                                [_wdAll addObject:tempNum];
                            }

                            [self setChartView];
                            [self setDataCount:_wdAll];

                            NSLog(@"_wdAll count = %ld", [_wdAll count]);
                            [_chartView.viewPortHandler setMaximumScaleX: _wdAll.count/countPerPage];
                            [_chartView zoom:_wdAll.count/(countPerPage*6) scaleY:2 x:0 y:0];
                        }
                    }
                }
            }
            else
            {
                [sock readDataWithTimeout:-1 tag:tag];
            }
            
            NSLog(@"_num1 = %ld", (long)_num1);
        } else {
            //以下不用管
            _recStr = [_recStr stringByAppendingString:aStr];
            
            NSArray* tempArray2 = [_recStr componentsSeparatedByString:@"#"];
            
            if(_num1 == [_recStr length])
            {
                for(int i = 2; i < [tempArray2 count] - 1; i++)
                {
                    NSInteger tempInt = ((NSString*)[tempArray2 objectAtIndex:i]).integerValue;
                    [_wd_2 addObject:[NSNumber numberWithInteger:tempInt]];
                }
                
                NSLog(@"_wd_2 count = %ld", [_wd_2 count]);
                
                if([_wd_2 count] == 1024)
                {
                    _requestType = 2;
                    _recStr = @"";
                    
                    _num1 = 0;

                    if(_requestStatus == 1)
                    {
                        self.requestString = @"JTZNBX2015#read_wd1";
                    }
                    else if(_requestStatus == 2)
                    {
                        self.requestString = @"JTZNBX2015#read_wd2";
                    }
                    else if(_requestStatus == 3)
                    {
                        self.requestString = @"JTZNBX2015#read_dy1";
                    }
                    else
                    {
                        self.requestString = @"JTZNBX2015#read_dy2";
                    }
                    
                    self.requestString = [NSString stringWithFormat:@"%@_%ld#",self.requestString,tag + 1];
                    
                    NSData* data = [self.requestString dataUsingEncoding:NSUTF8StringEncoding];
                    
                    [_asyncSocket writeData:data withTimeout:-1 tag:tag + 1];
                    [_asyncSocket readDataWithTimeout:30 tag: tag + 1];
                }
                else
                {
                    [_wdAll removeAllObjects];

                    if(_requestStatus < 3)
                    {
                        for (int i = 0; i < _wd_1.count; i++)
                        {
                            NSString* temp = [_wd_1 objectAtIndex:i];
                            NSNumber* tempNum = [NSNumber numberWithInteger:temp.integerValue];
                            [_wdAll addObject:tempNum];
                        }
                        [_wd_1 removeAllObjects];
                        
                        for (int i = 0; i < _wd_2.count; i++)
                        {
                            NSString* temp = [_wd_2 objectAtIndex:i];
                            NSNumber* tempNum = [NSNumber numberWithInteger:temp.integerValue];
                            [_wdAll addObject:tempNum];
                        }
                        [_wd_2 removeAllObjects];
                        
                        [self setDataCount:_wdAll];

                        NSLog(@"_wdAll count = %ld", [_wdAll count]);
    //                    [_chartView zoom:_wdAll.count/(countPerPage*6) scaleY:2 x:0 y:0];
                        [_chartView.viewPortHandler setMaximumScaleX: _wdAll.count/countPerPage];
                        [_chartView zoom:_wdAll.count/(countPerPage*6) scaleY:2 x:0 y:0];
                    }
                    else if(_requestStatus == 3)
                    {
                        _requestStatus = 4;
                        
                        [_wdAll1 removeAllObjects];
                        
                        for (int i = 0; i < _wd_1.count; i++)
                        {
                            NSString* temp = [_wd_1 objectAtIndex:i];
                            NSNumber* tempNum = [NSNumber numberWithInteger:temp.integerValue];
                            [_wdAll1 addObject:tempNum];
                        }
                        [_wd_1 removeAllObjects];
                        for (int i = 0; i < _wd_2.count; i++)
                        {
                            NSString* temp = [_wd_2 objectAtIndex:i];
                            NSNumber* tempNum = [NSNumber numberWithInteger:temp.integerValue];
                            [_wdAll1 addObject:tempNum];
                        }
                        [_wd_2 removeAllObjects];
                        
                        NSString* requestStr = [self requestData];
                        NSLog(@"tempStr = %@", requestStr);
                        _requestType = 1;
                        NSData* data = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
                        [_asyncSocket writeData:data withTimeout:-1 tag:1];
                        [_asyncSocket readDataWithTimeout:30 tag:1];
                    }
                    else
                    {
                        [_wdAll2 removeAllObjects];
                        
                        for (int i = 0; i < _wd_1.count; i++)
                        {
                            NSString* temp = [_wd_1 objectAtIndex:i];
                            NSNumber* tempNum = [NSNumber numberWithInteger:temp.integerValue];
                            [_wdAll2 addObject:tempNum];
                        }
                        [_wd_1 removeAllObjects];
                        
                        for (int i = 0; i < _wd_2.count; i++)
                        {
                            NSString* temp = [_wd_2 objectAtIndex:i];
                            NSNumber* tempNum = [NSNumber numberWithInteger:temp.integerValue];
                            [_wdAll2 addObject:tempNum];
                        }
                        [_wd_2 removeAllObjects];
                        
                        [_wdAll removeAllObjects];
                        
                        NSInteger count = (_wdAll1.count < _wdAll2.count)?_wdAll1.count:_wdAll2.count;
                        for (int i = 0; i < count; i++)
                        {
                           
                            NSNumber* num1 = [_wdAll1 objectAtIndex:i];
                            NSNumber* num2 = [_wdAll2 objectAtIndex:i];
                            NSString* tempStr = [NSString stringWithFormat:@"%ld.%ld", num1.integerValue, num2.integerValue];
                            
                             NSLog(@"tempStr  = %@", tempStr);
                            
                            NSNumber* tempNum = [NSNumber numberWithFloat:tempStr.floatValue];
                            [_wdAll addObject:tempNum];
                        }
                        
                        
                        [self setChartViewV];
                        [self setDataCountV:_wdAll];
                        
                        NSLog(@"_wdAll count = %ld", [_wdAll count]);
                        
                        
                        //                    [_chartView zoom:_wdAll.count/(countPerPage*6) scaleY:2 x:0 y:0];
                        [_chartView.viewPortHandler setMaximumScaleX: _wdAll.count/countPerPage];
                        [_chartView zoom:_wdAll.count/(countPerPage*6) scaleY:2 x:0 y:0];
                    }
   
                }
            }
            else
            {
                [sock readDataWithTimeout:-1 tag:tag];
            }
        }
    }
}

- (void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"thread(%@,onSocket:%p didWriteDataWithTag:%ld", @"gggg",sock,tag);
}


- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
    NSLog(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"connect error!";
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
//    hud.removeFromSuperViewOnHide = YES;
//    
//    [hud hide:YES afterDelay:2];
//    [_HUD hide:YES];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //断开连接了
    NSLog(@"onSocketDidDisconnect:%p", sock);
}

- (void)setDataCountV:(NSArray*) array
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++)
    {
        int loseFlag = 0;
        NSInteger hour, min, sec;
        
        NSString* tempStr;
//        if(loseFlag == 0)
//        {
            NSNumber* num = [array objectAtIndex:i];
            
            if(num.integerValue < 50)
            {
                hour = ((i+1)*10)/3600;
                min = ((i+1)*10-hour*3600)/60;
                sec = ((i+1)*10-3600*hour-min*60);
                
            }
            else
            {
                loseFlag = 1;
            }
            
            tempStr = [NSString stringWithFormat:@"-%ldhour%ldmin%ldsec", hour,min,sec];
            [xVals addObject:tempStr];
            
//        }
//        else
//        {
//            tempStr = @"-hour-min-sec";
//            [xVals addObject:tempStr];
//            
//        }
        
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++)
    {
        //        double mult = (range + 1);
        //        double val = (double) (arc4random_uniform(mult)) + 3;
        //        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
        NSNumber* num = (NSNumber*)[array objectAtIndex:i];
        CGFloat val = [num floatValue];
        
        if( val > 100)
        {
            val = 0;
        }
        
        if(val < - 100)
        {
            val = -100;
        }
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"（V） -24 hour voltage  graph"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.blackColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 0.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    //set1.fillAlpha = 65/255.0;
    //set1.fillColor = UIColor.blackColor;
    
    NSArray *gradientColors = @[
                                (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                ];
    gradientColors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set1.fillAlpha = 1.f;
    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set1.drawFilledEnabled = YES;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterNoStyle;
    formatter.maximumFractionDigits = 2;//小数位数
    formatter.multiplier = @1.f;
    [data setValueFormatter:formatter];//设置显示数据格式
    [data setValueTextColor:[UIColor brownColor]];
    
    [data setValueFormatter:formatter];
    
    _chartView.data = data;
}

- (void)setDataCount:(NSArray*) array
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++)
    {
        int loseFlag = 0;
        NSInteger hour, min, sec;
        
        NSString* tempStr;
//        if(loseFlag == 0)
//        {
            NSNumber* num = [array objectAtIndex:i];
            
            if(num.integerValue < 50)
            {
                hour = ((i+1)*10)/3600;
                min = ((i+1)*10-hour*3600)/60;
                sec = ((i+1)*10-3600*hour-min*60);
                
            }
            else
            {
                loseFlag = 1;
            }
            
            tempStr = [NSString stringWithFormat:@"-%ldhour%ldmin%ldsec", hour,min,sec];
            [xVals addObject:tempStr];
            
//        }
//        else
//        {
//            tempStr = @"-hour-min-sec";
//            [xVals addObject:tempStr];
//            
//        }
        
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++)
    {
        //        double mult = (range + 1);
        //        double val = (double) (arc4random_uniform(mult)) + 3;
        //        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
        NSNumber* num = (NSNumber*)[array objectAtIndex:i];
        double val = [num integerValue];
        
        if( val > 100)
        {
            val = 0;
        }
        
        if(val < - 100)
        {
            val = -100;
        }
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"（℃）-24hour  temperature graph"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.blackColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 0.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    //set1.fillAlpha = 65/255.0;
    //set1.fillColor = UIColor.blackColor;
    
    NSArray *gradientColors = @[
                                (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                ];
    gradientColors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set1.fillAlpha = 1.f;
    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set1.drawFilledEnabled = YES;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    _chartView.data = data;
}

- (void) setChartView
{
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
                     @{@"key": @"toggleCubic", @"label": @"Toggle Cubic"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleStartZero", @"label": @"Toggle StartZero"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     ];
    
    _chartView.delegate = self;
    
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    // x-axis limit line
    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
    llXAxis.lineWidth = 4.0;
    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
    llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
    
    //[_chartView.xAxis addLimitLine:llXAxis];
    
    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:130.0 label:@"Upper Limit"];
    ll1.lineWidth = 4.0;
    ll1.lineDashLengths = @[@5.f, @5.f];
    ll1.labelPosition = ChartLimitLabelPositionRightTop;
    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:-30.0 label:@"Lower Limit"];
    ll2.lineWidth = 4.0;
    ll2.lineDashLengths = @[@5.f, @5.f];
    ll2.labelPosition = ChartLimitLabelPositionRightBottom;
    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    [leftAxis addLimitLine:ll1];
    [leftAxis addLimitLine:ll2];
    
    leftAxis.customAxisMax = 100.0;
    leftAxis.customAxisMin = -100.0;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.rightAxis.enabled = NO;
    
    [_chartView.viewPortHandler setMaximumScaleY: 2.f];
    
    
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _chartView.marker = marker;
    
    _chartView.legend.form = ChartLegendFormLine;
    
    //    [self setDataCount:(12) range:100];
    
    //    _sliderX.value = 44.0;
    //    _sliderY.value = 100.0;
    //    [self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
}

- (void) setChartViewV
{
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
                     @{@"key": @"toggleCubic", @"label": @"Toggle Cubic"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleStartZero", @"label": @"Toggle StartZero"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     ];
    
    _chartView.delegate = self;
    
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    // x-axis limit line
    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
    llXAxis.lineWidth = 4.0;
    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
    llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
    
    //[_chartView.xAxis addLimitLine:llXAxis];
    
    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:130.0 label:@"Upper Limit"];
    ll1.lineWidth = 4.0;
    ll1.lineDashLengths = @[@5.f, @5.f];
    ll1.labelPosition = ChartLimitLabelPositionRightTop;
    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:-30.0 label:@"Lower Limit"];
    ll2.lineWidth = 4.0;
    ll2.lineDashLengths = @[@5.f, @5.f];
    ll2.labelPosition = ChartLimitLabelPositionRightBottom;
    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    [leftAxis addLimitLine:ll1];
    [leftAxis addLimitLine:ll2];
    
    leftAxis.customAxisMax = 100.0f;
    leftAxis.customAxisMin = 0.0;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.rightAxis.enabled = NO;
    
    [_chartView.viewPortHandler setMaximumScaleY: 2.f];
    
    
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _chartView.marker = marker;
    
    _chartView.legend.form = ChartLegendFormLine;
    
//    [self setDataCount:(12) range:100];
    
    //    _sliderX.value = 44.0;
    //    _sliderY.value = 100.0;
    //    [self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
}

- (void) setDefaultLeftBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, 30, 30);
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backBarItem;
    self.navigationItem.backBarButtonItem = nil;
}

- (void) setDefaulToolbarView
{
    UIImageView*  toolBarImage = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"foot"]];
    toolBarImage.frame = CGRectMake(0,
                                    kMainScreenHeight - kToolBarHieght,
                                    kMainScreenWidth,
                                    kToolBarHieght);
    
    UILabel* toolBarLabel = [[UILabel alloc]init];
    toolBarLabel.frame = CGRectMake(0, 0, kMainScreenWidth, kToolBarHieght);
    toolBarLabel.text = @"www.cn-yutong.com";
    toolBarLabel.textAlignment = NSTextAlignmentCenter;
    toolBarLabel.textColor = [UIColor whiteColor];
    
    [toolBarImage addSubview:toolBarLabel];
    
    [self setToolbarView:toolBarImage];
}

- (void) setToolbarView:(UIView*) view
{
    [self.view addSubview:view];
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = (range + 1);
        double val = (double) (arc4random_uniform(mult)) + 3;
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"（V） -24 hour voltage  graph"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.blackColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 0.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    //set1.fillAlpha = 65/255.0;
    //set1.fillColor = UIColor.blackColor;
    
    NSArray *gradientColors = @[
                                (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                ];

    gradientColors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set1.fillAlpha = 1.f;
    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set1.drawFilledEnabled = YES;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    _chartView.data = data;
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleValues"])
    {
        for (id<IChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawValuesEnabled = !set.isDrawValuesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleFilled"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleCircles"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = !set.isDrawCirclesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCubicEnabled = !set.isDrawCubicEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlight"])
    {
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleStartZero"])
    {
        _chartView.leftAxis.startAtZeroEnabled = !_chartView.leftAxis.isStartAtZeroEnabled;
        _chartView.rightAxis.startAtZeroEnabled = !_chartView.rightAxis.isStartAtZeroEnabled;
        
        [_chartView notifyDataSetChanged];
    }
    
    if ([key isEqualToString:@"animateX"])
    {
        [_chartView animateWithXAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateY"])
    {
        [_chartView animateWithYAxisDuration:3.0 easingOption:ChartEasingOptionEaseInCubic];
    }
    
    if ([key isEqualToString:@"animateXY"])
    {
        [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"saveToGallery"])
    {
        [_chartView saveToCameraRoll];
    }
    
    if ([key isEqualToString:@"togglePinchZoom"])
    {
        _chartView.pinchZoomEnabled = !_chartView.isPinchZoomEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleAutoScaleMinMax"])
    {
        _chartView.autoScaleMinMaxEnabled = !_chartView.isAutoScaleMinMaxEnabled;
        [_chartView notifyDataSetChanged];
    }
}

#pragma mark - Actions

- (IBAction)slidersValueChanged:(id)sender
{
    //_sliderTextX.text = [@((int)_sliderX.value + 1) stringValue];
    // _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    //[self setDataCount:(_sliderX.value + 1) range:_sliderY.value];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
