//
//  NdFaceBook.h
//  Unity-iPhone
//
//  Created by ugamehome on 2016/12/30.
//
//

#import <Foundation/Foundation.h>
typedef enum {
    NdFaceBookLoginType_Error,
    NdFaceBookLoginType_Susses,
    NdFaceBookLoginType_Cancel,
}NdFaceBookLoginType;

typedef void(^LoginResult)(NSString*sid,NSString*name,NSString*email,NdFaceBookLoginType);

@interface NdFaceBook : NSObject
+(instancetype)shareInstance;
//初始化 facebook sdk
+ (void)fbActivateApp;
+ (void)fbApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (BOOL)fbApplication:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

//登陆  登出
- (BOOL)isCurrentAccessToken;
- (void)login;
- (void)loginOut;
/** 判断是否登录过 */
- (BOOL)loginBycace;
@property (nonatomic,copy) LoginResult loginBlock;


/** acebook   other method */
- (void)openFbFansPageWithUrlstr:(NSString *)urlStr;
//fb 邀请
- (void)fbInviteWithlinkUrlstr:(NSString *)linkUrlstr andImageUrlstr:(NSString *)imageUrlstr;
//fb 关注
- (void)fbLikeWithUrlstr:(NSString *)urlStr;
- (void)fbShareWithImageStr:(NSString *)imageStr;


//数据分析统计
/** 启动应用 */
+(void)recordActivatedApp;

/** 应用登陆*/
+(void)recordLogin;

/** 应用记录等级*/
+(void)recordFBLeveWithLevel:(NSString *)leve andScore:(NSString*)score;

/** 购买*/
+(void)recordFBPayWithPrice:(NSString *)price andOrderId:(NSString *)orderId andContentType:(NSString *)category_a andCurrency:(NSString *)currency andQuantity:(NSString *)quantity anContent:(NSString *)content;

/** 创建角色 */
+(void)recordFBCreateRoleWithRolename:(NSString *)rolename andRoleId:(NSString *)roleid;

/** 加入心愿单*/
+(void)recordFBOrderWithOrderId:(NSString *)orderid andPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType;

/** 添加入购物车*/
+(void)recordFBAddToCartWithPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType andProductid:(NSString *)productid;

/** 解锁成就 */
+ (void)recordFBUnlockedAchievementWithAndAchievementId:(NSString *)AchievementId andDescription:(NSString*)description;
@end
