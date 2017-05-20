//
//  NdFaceBook.m
//  Unity-iPhone
//
//  Created by ugamehome on 2016/12/30.
//
//

#import "NdFaceBook.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "NdAppsflyer.h"

typedef enum {
    ShareType_Content,
    ShareType_Image,
}ShareType;

@interface NdFaceBook ()<FBSDKSharingDelegate,FBSDKAppInviteDialogDelegate>
@property (nonatomic,strong)FBSDKLoginManager *o_fblogin;
@property (strong, nonatomic) NSString* o_fbUserid;
@property (nonatomic)ShareType shareType;
@end

@implementation NdFaceBook
+(instancetype)shareInstance
{
    static NdFaceBook * object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[NdFaceBook alloc] init];
    });
    return object;
}

#pragma mark - initfacebookSdk
+(void)fbActivateApp{
    [FBSDKAppEvents activateApp];
}

+(void)fbApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    BOOL isYes =  [[FBSDKApplicationDelegate sharedInstance] application:application
                                           didFinishLaunchingWithOptions:launchOptions];
    NSLog(@"isYes-->%d",isYes);
}

+ (BOOL)fbApplication:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


+ (BOOL)fbApplication:(UIApplication *)application
              openURL:(NSURL *)url
              options:(NSDictionary<UIApplicationOpenURLOptionsKey,id>  *)options{
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

#pragma mark - facebook   login
- (BOOL)isCurrentAccessToken{
    if ([FBSDKAccessToken currentAccessToken] ) {
        return YES;
    }
    return NO;
}
//判断是否登录过
- (BOOL)loginBycace{
    if ([self isCurrentAccessToken]) {
        FBSDKAccessToken *result = [FBSDKAccessToken currentAccessToken];
        [self getFbDataWith:result.userID];
        return YES;
    }
    return NO;
}

- (void)loginOut{
    [_o_fblogin logOut];
}

- (void)login{
    if ([self loginBycace]) {
        return;
    }
    if (!_o_fblogin) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        _o_fblogin = login;
    }
    __weak typeof(self) ws = self;
    [_o_fblogin
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:nil
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"fb--->Process error");
             if (_loginBlock) {
                 _loginBlock(nil,nil,nil,NdFaceBookLoginType_Error);
             }
         } else if (result.isCancelled) {
             NSLog(@"fb--->Cancelled");
             if (_loginBlock) {
                 _loginBlock(nil,nil,nil,NdFaceBookLoginType_Cancel);
             }
         } else {
             NSLog(@"fb--->Logged in");
             [ws getFbDataWith:result.token.userID];
         }
     }];
}

- (void)getFbDataWith:(NSString *)userid{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:userid
                                  parameters:@{@"fields": @"id,name,email"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result,NSError *error) {
        // Handle the result
        if (_loginBlock) {
            _o_fbUserid = result[@"id"];
            _loginBlock(result[@"id"],result[@"name"],result[@"email"],NdFaceBookLoginType_Susses);
            [NdFaceBook recordLoginByFbWithGameId:result[@"id"]?:@"" andEmail:result[@"email"]?:@""andTEL:result[@"name"]?:@""];
            [NdAppsflyer recordLoginByFBWithId:result[@"id"]?:@""  andWithFBName:result[@"name"]?:@""];
        }
        NSLog(@"%@,%@,%@",result[@"id"],result[@"name"],result[@"email"]);
    }];
}

#pragma mark - facebook   other method
//fb 关注
- (void)fbLikeWithUrlstr:(NSString *)urlStr{
    [self gotofbWebWithStr:urlStr];
}

- (void)openFbFansPageWithUrlstr:(NSString *)urlStr{
    [self gotofbWebWithStr:urlStr];
}

- (void)openFbGroupWithUrlstr:(NSString *)urlStr{
    [self gotofbWebWithStr:urlStr];
}

- (void)gotofbWebWithStr:(NSString *)urlStr{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlStr]];
}

#pragma mark - facebook  邀请
- (void)fbInviteWithlinkUrlstr:(NSString *)linkUrlstr andImageUrlstr:(NSString *)imageUrlstr{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:linkUrlstr];
    content.appInvitePreviewImageURL = [NSURL URLWithString:imageUrlstr];
    [FBSDKAppInviteDialog showFromViewController:[ZhiboCommon getCurrentVC]
                                     withContent:content
                                        delegate:self];
}


#pragma mark --> FBSDKAppInviteDialogDelegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    NSLog(@"fbshare--->error %@",error);
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"fbshare--->results %@",results);
}

#pragma mark - fbshare
- (void)fbShareWithTitle:(NSString *)title andLink:(NSString *)link andDesc:(NSString *)desc{
    FBSDKShareLinkContent  *content = [[FBSDKShareLinkContent alloc]init];
    content.contentDescription = desc;
    content.contentTitle = title;
    content.contentURL = [NSURL URLWithString:link];
    _shareType = ShareType_Content;
    [FBSDKShareDialog showFromViewController:[ZhiboCommon getCurrentVC] withContent:content delegate:self];
}

- (void)fbShareWithImageStr:(NSString *)imageStr{
    UIImage *appleImage = [[UIImage alloc] initWithContentsOfFile:imageStr];
    FBSDKSharePhotoContent *photo = [[FBSDKSharePhotoContent alloc]init];
    FBSDKSharePhoto *sharePhoto = [[FBSDKSharePhoto alloc]init];
    sharePhoto.image = appleImage;
    
    NSArray *photos = @[ sharePhoto];
    photo.photos = photos;
    _shareType = ShareType_Image;
    [FBSDKShareDialog showFromViewController:[ZhiboCommon getCurrentVC] withContent:photo delegate:self];
}


#pragma mark --> fbshareDelegate
-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    //    if (_o_fbUserid.length<= 0) {
    //        [[NdFaceBook shareInstance]login];
    //    }
    
    if (_shareType == ShareType_Content) {
        [NdFaceBook recordFbShareWithFbId:_o_fbUserid?:@"" andFbType:@"content" andEventName:@"nd_ios_fbshare_content"];
    }else if(_shareType == ShareType_Image){
        [NdFaceBook recordFbShareWithFbId:_o_fbUserid?:@"" andFbType:@"photo" andEventName:@"nd_ios_fbshare_image"];
    }
    
    NSLog(@"fbshare--->results %@",results);
}


- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"fbshare--->error %@",error);
}


- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"fbshare-->sharerCancel");
}


#pragma mark - 数据分析
/** 启动应用 */
+(void)recordActivatedApp{
    [FBSDKAppEvents logEvent:FBSDKAppEventNameRated];
}

/** 应用登陆*/
+(void)recordLoginByGcWithGameId:(NSString *)gcid{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:gcid, @"Nd_Custom_LoginBy_GcId", nil];
    [FBSDKAppEvents logEvent: @"nd_ios_Gc_login"parameters: params];
}

//fack book 登陆
+(void)recordLoginByFbWithGameId:(NSString *)fbId andEmail:(NSString *)fbMail andTEL:(NSString *)fbTel{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:fbId, @"Nd_Custom_LoginBy_FbId", fbMail, @"Nd_Custom_LoginBy_FbMail",fbTel, @"Nd_Custom_LoginBy_FbTel",nil];
    [FBSDKAppEvents logEvent: @"nd_ios_Fb_login"parameters: params];
}

//游客模式登陆
+(void)recordLoginByGuWithGameId:(NSString *)guid{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:guid, @"Nd_Custom_LoginBy_GuId", nil];
    [FBSDKAppEvents logEvent: @"nd_ios_Gu_login"parameters: params];
}

//记录fb 分享~
+(void)recordFbShareWithFbId:(NSString *)fbId andFbType:(NSString *)type andEventName:(NSString *)name{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:fbId, @"Nd_ios_fbShare_Id", type, @"Nd_ios_fbShare_type",nil];
    [FBSDKAppEvents logEvent: name parameters: params];
}

/** 应用记录等级*/
+(void)recordFBLeveWithLevel:(NSString *)leve andScore:(NSString*)score{
    [FBSDKAppEvents logEvent:FBSDKAppEventNameAchievedLevel parameters:@{
                                                                         FBSDKAppEventParameterNameLevel:leve}];
}

/** 购买*/
+(void)recordFBPayWithPrice:(NSString *)price andOrderId:(NSString *)orderId andContentType:(NSString *)category_a andCurrency:(NSString *)currency andQuantity:(NSString *)quantity anContent:(NSString *)content{
    [FBSDKAppEvents logPurchase:[price doubleValue] currency:currency parameters:@{
                                                                                   FBSDKAppEventParameterNameCurrency : currency,
                                                                                   FBSDKAppEventParameterNameContentType : category_a,
                                                                                   FBSDKAppEventParameterNameContentID : orderId ,
                                                                                   
                                                                                   FBSDKAppEventParameterNameDescription:content,
                                                                                   FBSDKAppEventParameterNameNumItems:quantity}];
}
/** 创建角色 */
+ (void)logNd_ios_create_roleEvent:(NSString*)ndCustomRolePlayName
                ndCustomRolePlayid:(NSString*)ndCustomRolePlayid
                         valToSum :(double)valToSum {
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     ndCustomRolePlayName, @"NdCustomRolePlayName",
     ndCustomRolePlayid, @"NdCustomRolePlayid",
     nil];
    [FBSDKAppEvents logEvent: @"nd_ios_create_role"
                  valueToSum: valToSum
                  parameters: params];
}

/** 加入心愿单*/
+(void)recordFBOrderWithOrderId:(NSString *)orderid andPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType{
    [FBSDKAppEvents logEvent:FBSDKAppEventNameAddedToWishlist
                  valueToSum:[price doubleValue]
                  parameters:@{ FBSDKAppEventParameterNameContentType : contentType,
                                FBSDKAppEventParameterNameContentID : orderid,
                                FBSDKAppEventParameterNameCurrency : currency} ];
}


/** 添加入购物车*/
+(void)recordFBAddToCartWithPrice:(NSString *)price andCurrency:(NSString *)currency andContentType:(NSString *)contentType andProductid:(NSString *)productid{
    [FBSDKAppEvents logEvent:FBSDKAppEventNameAddedToCart
                  valueToSum:[price doubleValue]
                  parameters:@{ FBSDKAppEventParameterNameContentType : contentType,
                                FBSDKAppEventParameterNameCurrency : currency,FBSDKAppEventParameterNameContentID : productid,} ];
}



/** 解锁成就 */
+ (void)recordFBUnlockedAchievementWithAndAchievementId:(NSString *)AchievementId andDescription:(NSString*)description{
    [FBSDKAppEvents logEvent:FBSDKAppEventNameUnlockedAchievement parameters:@{FBSDKAppEventParameterNameContentID : AchievementId,
                                                                               FBSDKAppEventParameterNameDescription: description,
                                                                               }];
}

@end
