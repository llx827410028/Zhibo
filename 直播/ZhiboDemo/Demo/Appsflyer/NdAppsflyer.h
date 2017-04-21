//
//  NdAppsflyer.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/4/13.
//
//

#import <Foundation/Foundation.h>
@interface NdAppsflyer : NSObject
+(void)initAppsFlayer;
+(void)AppsFlayerApplicationDidBecomeActive;
+(void)recordLogin;
/**记录等级*/
+(void)recordLeveWithLevel:(NSString *)leve andScore:(NSString*)score;
/**卸载记录*/
+(void)recordRemoteWithDeviceToken:(NSData *)deviceToken;
/**购买记录*/
+(void)recordPayWithPrice:(NSString *)price andOrderId:(NSString *)orderId andContentType:(NSString *)category_a andCurrency:(NSString *)currency andQuantity:(NSString *)quantity anContent:(NSString *)content;
/**推送记录*/
+(void)recordRemoteNotification:(NSDictionary *)userInfo;
/**创建角色记录*/
+(void)recordCreateRoleWithRolename:(NSString *)rolename andRoleId:(NSString *)roleid;
/**加入购物车*/
+(void)recordAddToCartWithPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType andProductid:(NSString *)productid;
/**订单记录*/
+(void)recordOrderWithOrderid:(NSString *)orderid andPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType;
@end
