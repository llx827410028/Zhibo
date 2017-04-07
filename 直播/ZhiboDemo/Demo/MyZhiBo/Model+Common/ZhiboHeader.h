//
//  ZhiboHeader.h
//  Unity-iPhone
//
//  Created by ugamehome on 2016/10/28.
//
//

#import "ZhiboRequests.h"
#import "VTTool.h"
#import "ZhiboModel.h"
#import "MBProgressHUD.h"
#import "ZhiboCommon.h"
//
//
#define BTN_TAG 200
#define llx_screenHeight [[UIScreen mainScreen]bounds].size.height //屏幕高度
#define llx_screenWidth [[UIScreen mainScreen]bounds].size.width
//
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif
//

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define WeakSelf __weak typeof(self) weakSelf = self;


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//
////格式化 字符串
#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

