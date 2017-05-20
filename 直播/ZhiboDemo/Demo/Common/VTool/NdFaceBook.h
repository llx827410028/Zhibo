//
//  NdFaceBook.h
//  Unity-iPhone
//
//  Created by ugamehome on 2016/12/30.
//
//
/*
 <key>CFBundleURLTypes</key>
	<array>
 <dict>
 <key>CFBundleURLSchemes</key>
 <array>
 <string>fb274850969639729</string>
 </array>
 </dict>
	</array>
	<key>FacebookAppID</key>
	<string>274850969639729</string>
	<key>FacebookDisplayName</key>
	<string>The Killbox - المواجهة</string>
	<key>LSApplicationQueriesSchemes</key>
	<array>
 <string>fbapi</string>
 <string>fb-messenger-api</string>
 <string>fbauth2</string>
 <string>fbshareextension</string>
	</array>
 */

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
+ (BOOL)fbApplication:(UIApplication *)application
              openURL:(NSURL *)url
              options:(NSDictionary<UIApplicationOpenURLOptionsKey,id>  *)options;

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
//fb
- (void)openFbGroupWithUrlstr:(NSString *)urlStr;
//fb 关注
- (void)fbLikeWithUrlstr:(NSString *)urlStr;
- (void)fbShareWithImageStr:(NSString *)imageStr;
- (void)fbShareWithTitle:(NSString *)title andLink:(NSString *)link andDesc:(NSString *)desc;

//数据分析统计
/** 启动应用 */
+(void)recordActivatedApp;

/** 应用登陆*/
+(void)recordLoginByGcWithGameId:(NSString *)gcid;

//fack book 登陆
+(void)recordLoginByFbWithGameId:(NSString *)fbId andEmail:(NSString *)fbMail andTEL:(NSString *)fbTel;

//游客模式登陆
+(void)recordLoginByGuWithGameId:(NSString *)guid;

//记录fb 分享~
+(void)recordFbShareWithFbId:(NSString *)fbId andFbType:(NSString *)type andEventName:(NSString *)name;

/** 应用记录等级*/
+(void)recordFBLeveWithLevel:(NSString *)leve andScore:(NSString*)score;

/** 购买*/
+(void)recordFBPayWithPrice:(NSString *)price andOrderId:(NSString *)orderId andContentType:(NSString *)category_a andCurrency:(NSString *)currency andQuantity:(NSString *)quantity anContent:(NSString *)content;

/** 创建角色 */
+ (void)logNd_ios_create_roleEvent:(NSString*)ndCustomRolePlayName
                ndCustomRolePlayid:(NSString*)ndCustomRolePlayid
                         valToSum :(double)valToSum;

/** 加入心愿单*/
+(void)recordFBOrderWithOrderId:(NSString *)orderid andPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType;

/** 添加入购物车*/
+(void)recordFBAddToCartWithPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType andProductid:(NSString *)productid;

/** 解锁成就 */
+ (void)recordFBUnlockedAchievementWithAndAchievementId:(NSString *)AchievementId andDescription:(NSString*)description;
@end
