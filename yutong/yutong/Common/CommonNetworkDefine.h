//
//  CommonNetworkDefine.h
//  TestNetworkFrame
//
//  Created by iOS01iMac on 16/1/5.
//  Copyright © 2016年 ghm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROUTER_TCP_IP                           @"192.168.4.1"
#define ROUTER_TCP_Port                         180

////0为测试环境
////1为真实环境
//#define RUN_IN_TEST_OR_TURE                    0
//
////测试环境
//#if RUN_IN_TEST_OR_TURE == 0
//#define kBaseServerURL                 @"http://188.188.22.134:8888/chezhibao-api/apiService.hs"
////真实环境
//#else
//#define kBaseServerURL                 @"http://api.mychebao.com/chezhibao-api/apiService.hs"
//#endif /* CommonNetworkDefine_h */
//
//
////由业务模块id与相应模块的某个能力id组合成一个唯一的业务调用id
////业务调用id = 模块id（高16位）＋ 能力id（低16位）
//#define BusinesID(x, y) (((x)<<16) + (y))
//
////业务调用id中分离模块id
//#define ModuleID(x) ((x)>>16)
//
////业务调用id中分离能力id
//#define FuncID(x) ((x)&255)
//
////业务模块ID=================================================================================================
//typedef enum ManagerModuleID
//{
//    ELoginManager,              //登陆管理
//    EMarketmanager              //市场管理
//    
//}ManagerModuleID;
//
////业务功能ID=============================================================================================
//typedef enum NetworkManagerCapability
//{
//    ENetReqLogin = 1,           //登录
//    
//    ENetReqMarketList           //添加市场
//} NetworkManagerCapability;
//
////业务功能service=============================================================================================
////登录
//#define kLoginService                 @"channel.user.login"
////增加市场
//#define kMarketListService            @"channel.market.list"


