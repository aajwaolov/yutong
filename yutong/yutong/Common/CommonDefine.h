//
//  CommonDefine.h
//  yutong
//
//  Created by iOS01iMac on 16/1/25.
//  Copyright © 2016年 ghm. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#import "CommonStr_en.h"

#define ImageWithName(name) [UIImage imageNamed:name]

//rgb获取颜色
#define kColorRGB(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f\
                                            green:(double)g/255.0f\
                                             blue:(double)b/255.0f alpha:a]
//十六进制颜色值
#define kColorHex(hexStr) [UIColor colorWithRed:((float)((hexStr & 0xFF0000) >> 16))/255.0\
                                          green:((float)((hexStr & 0xFF00) >> 8))/255.0\
                                           blue:((float)(hexStr & 0xFF))/255.0\
                                          alpha:1.0]
//十六进制颜色值加透明度
#define kColorHexAlpha(rgbValue,alphaValue) \
    [UIColor colorWithRed:((float)((hexStr & 0xFF0000) >> 16))/255.0\
                    green:((float)((hexStr & 0xFF00) >> 8))/255.0\
                     blue:((float)(hexStr & 0xFF))/255.0\
                    alpha:alphaValue]\

#define kLayerBorderColor kColorHex(0xd7010d)

//获取屏幕 宽度、高度
#define kMainScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kMainScreenHeight ([UIScreen mainScreen].bounds.size.height)

static const NSInteger kToolBarHieght = 50;

static const NSInteger kNavigationBarHieght = 64;

#endif /* CommonDefine_h */
