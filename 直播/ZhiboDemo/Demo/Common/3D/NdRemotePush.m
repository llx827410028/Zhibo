//
//  NdRemotePush.m
//  Unity-iPhone
//
//  Created by ugamehome on 2017/3/16.
//
//

#import "NdRemotePush.h"
#import "PaymentRequests.h"
@interface NdRemotePush ()
@property (nonatomic,strong)NSString *o_deviceToken;
@property (nonatomic,strong)NSString *o_clickNotifyMsg;
@end

@implementation NdRemotePush
+(instancetype)shareInstance
{
    static NdRemotePush * object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[NdRemotePush alloc] init];
    });
    return object;
}

- (void)showPushInfo{
    if (self.o_clickNotifyMsg.length>0) {
        UIAlertView *alert = [[UIAlertView alloc]init];
        alert.title = [VTTool getPlistValueWithKey:@"提示" andPlistName:@"Gamecenter"];
        alert.message = self.o_clickNotifyMsg;
        [alert addButtonWithTitle:[VTTool getPlistValueWithKey:@"确定" andPlistName:@"Gamecenter"]];
        [alert show];
    }
    self.o_clickNotifyMsg = @"";
}

- (void)registerRemoteNoticationWithapplication:(UIApplication*)application{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) { //iOS8.0以后注册方法与之前有所不同，需要要分别对待
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge) categories: nil];
        [application registerUserNotificationSettings: settings];
        [application registerForRemoteNotifications];
    }else{ //iOS8.0以前版本的注册方法
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
}

- (void)getRemoteNoticationByLaunchingWithptions:(NSDictionary*)launchOptions{
    //初始化...
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification && remoteNotification[@"aps"]){
        NSDictionary * aps = remoteNotification[@"aps"];
        if(aps && aps[@"alert"]){
            _o_clickNotifyMsg = remoteNotification[@"alert"];
            NSLog(@"clickNotifyMsg_didFinishLaunchingWithOptions-->%@",_o_clickNotifyMsg);
        }
    }
}

- (void)getReceiveRemoteNotification:(NSDictionary *)userInfo andApplication:(UIApplication *)application{
    if (application.applicationState != UIApplicationStateInactive) {
        NSString *clickNotifyMsg = nil;
        if(userInfo && userInfo[@"aps"]){
            NSDictionary * aps = userInfo[@"aps"];
            if(aps && aps[@"alert"]){
                self.o_clickNotifyMsg = aps[@"alert"];
                NSLog(@"clickNotifyMsg_notStateInactive--->%@",clickNotifyMsg);
            }
        }
        [self showPushInfo];
        if (application.applicationState == UIApplicationStateBackground) {
            application.applicationIconBadgeNumber += 1;
        }
    }
}


- (void)getServerPushInfoWithSid:(NSString *)sid andGameid:(NSString *)gameid andUid:(NSString *)uid{
//    NSString *requesttring = [NSString stringWithFormat:@"gameid=%@&uid=%@&regid=%@&key=%@&sid=%@&device=2",gameid,uid,self.o_deviceToken,[VTTool md5:[NSString stringWithFormat:@"%@%@%@%@",gameid,uid,self.o_deviceToken,app_push_secretkey]],sid];
//    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",app_push_url,requesttring];
//    [[PaymentRequests shareInstance]getData:nil andisHud:NO andUrl:requestUrl andBackObjName:@"上传推送信息" withSuccessBlock:^(NSDictionary *backDic) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 更新界面
//        });
//    } withFaildBlock:^(NSError *error) {
//        
//    }];

}

-(void)getRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSString *deviceTokenString2 = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                     
                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
                                    
                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"方式2：%@", deviceTokenString2);
    self.o_deviceToken = deviceTokenString2;
    NSLog(@"%@",[[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]);
    NSLog(@"%@",deviceToken);
}
@end
