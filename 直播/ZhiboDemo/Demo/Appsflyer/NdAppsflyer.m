//
//  NdAppsflyer.m
//  Unity-iPhone
//
//  Created by ugamehome on 2017/4/13.
//
//

#import "NdAppsflyer.h"
#import "AppsFlyerTracker.h"
@implementation NdAppsflyer
+(void)initAppsFlayer{
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = app_appFlyer_DevKey;
    [AppsFlyerTracker sharedTracker].appleAppID = app_appFlyer_Appid;
}

+(void)AppsFlayerApplicationDidBecomeActive{
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

+(void)recordLogin{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventLogin withValues:nil];
}

+(void)recordLeveWithLevel:(NSString *)leve andScore:(NSString*)score{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventLevelAchieved withValues:@{AFEventParamLevel: leve,AFEventParamScore : score }];
}

+(void)recordRemoteWithDeviceToken:(NSData *)deviceToken{
    [[AppsFlyerTracker sharedTracker] registerUninstall:deviceToken];
}

+(void)recordPayWithPrice:(NSString *)price andOrderId:(NSString *)orderId andContentType:(NSString *)category_a andCurrency:(NSString *)currency andQuantity:(NSString *)quantity anContent:(NSString *)content{
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventPurchase withValues: @{
                                                                        AFEventParamContentId:orderId,
                                                                        AFEventParamContentType:category_a,
                                                                               AFEventParamRevenue: price,
                                                                        AFEventParamCurrency:currency,
                                                                        AFEventParamQuantity:quantity,
                                                                        AFEventParamContentList:content}];
}

+(void)recordRemoteNotification:(NSDictionary *)userInfo{
    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
}

+(void)recordCreateRoleWithRolename:(NSString *)rolename andRoleId:(NSString *)roleid{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventCustomerSegment withValues:@{AFEventParamCustomerUserId: roleid,AFEventParam1:rolename }];
}

+(void)recordAddToCartWithPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType andProductid:(NSString *)productid{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventAddToCart withValues:@{AFEventParamPrice:price,AFEventParamCurrency:currency,AFEventParamContentType:contentType,AFEventParamContentId:productid,}];
}


+(void)recordOrderWithOrderid:(NSString *)orderid andPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventOrderId withValues:@{AFEventParamPrice:price,AFEventParamCurrency:currency,AFEventParamContentType:contentType,AFEventParamContentId:orderid}];
}

@end
