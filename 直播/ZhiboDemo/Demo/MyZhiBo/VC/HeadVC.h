//
//  HeadVC.h
//  Demo
//
//  Created by ugamehome on 2016/10/13.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UnityPaseBlock)(BOOL);
@interface HeadVC : UIViewController
//初始化 直播
- (instancetype)initWithPlayId:(NSString *)playid andPlayName:(NSString *)playName andServerid:(NSString *)serverid andSecretKey:(NSString *)secretKey andLevel:(NSString *)level;
//项目添加直播入口
@property (nonatomic,copy) UnityPaseBlock o_block;
- (void) addZhiboView;
@end
