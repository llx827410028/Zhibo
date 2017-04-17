//
//  NdRemotePush.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/3/16.
//
//

#import <Foundation/Foundation.h>

@interface NdRemotePush : NSObject
+(instancetype)shareInstance;
- (void)showPushInfo;
//注册推送---》didFinishLaunchingWithOptions
- (void)registerRemoteNoticationWithapplication:(UIApplication*)application;
//获取推送信息 --->didFinishLaunchingWithOptions
- (void)getRemoteNoticationByLaunchingWithptions:(NSDictionary*)launchOptions;
//获取推送信息 --->fetchCompletionHandler
- (void)getReceiveRemoteNotification:(NSDictionary *)userInfo andApplication:(UIApplication *)application;
//获取注册推送 devicetoken
-(void)getRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
//上传推送信息
- (void)getServerPushInfoWithSid:(NSString *)sid andGameid:(NSString *)gameid andUid:(NSString *)uid;
@end
