//
//  MacroFuntions.h
//  ZXCheMo
//
//  Created by qws on 2016/11/9.
//  Copyright © 2016年 qws. All rights reserved.
//

#ifndef MacroFuntions_h
#define MacroFuntions_h

//Log
#define PO(x) NSLog(@"%s = %@", #x, x);
//debug环境下输出log  1：输出 0:不输出
#define kAppDebug 1
#if kAppDebug
#define kLog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define kLog(...)
#endif

//系统版本
#define IS_IOS8         @available(iOS 8.0, *)
#define IS_IOS9         @available(iOS 9.0, *)
#define IS_IOS10        @available(iOS 10.0, *)
#define IS_IOS11        @available(iOS 11.0, *)

//设备型号
#define IS_IPHONE5      (kSCREEN_HEIGHT == 568)
#define IS_IPHONEX      (kSCREEN_WIDTH == 375.f && kSCREEN_HEIGHT == 812.f)

//屏幕宽高
#define kWindow         [UIApplication sharedApplication].delegate.window
#define kSCREEN_HEIGHT  (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])?([[UIScreen mainScreen] bounds].size.width):([[UIScreen mainScreen] bounds].size.height))
#define kSCREEN_WIDTH   (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])?([[UIScreen mainScreen] bounds].size.height):([[UIScreen mainScreen] bounds].size.width))

//导航和状态栏高度
#define NAVI_HEIGHT     self.navigationController.navigationBar.frame.size.height
#define STATUS_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define TABBAR_HEIGHT   self.tabBarController.tabBar.frame.size.height

//Short spell
#define kUserDefault        [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//Function
#define _CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#define _L(key) NSLocalizedString(key, key)

#define _weaken(obj)     __weak   __typeof(obj) weak##obj   = obj;
#define _strongify(obj)  __strong __typeof(obj) strong##obj = obj;
#define _blocken(obj)    __block  __typeof(obj) block##obj  = obj;

//Alert弹框
#define SHOW_ALERT(_msg_)  [[[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];

#endif /* MacroFuntions_h */
