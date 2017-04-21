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

@interface NdFaceBook ()<FBSDKLoginButtonDelegate,FBSDKSharingDelegate,FBSDKAppInviteDialogDelegate>
@property (nonatomic,strong)FBSDKLoginManager *o_fblogin;
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
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
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
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      
                                      initWithGraphPath:result.userID
                                      
                                      parameters:@{@"fields": @"id,name,email"}
                                      
                                      HTTPMethod:@"GET"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result,NSError *error) {
            
            // Handle the result
            if (_loginBlock) {
                _loginBlock(result[@"id"],result[@"name"],result[@"email"],NdFaceBookLoginType_Susses);
            }
            NSLog(@"%@,%@,%@",result[@"id"],result[@"name"],result[@"email"]);
            
        }];
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
             
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                           
                                           initWithGraphPath:result.token.userID
                                           
                                           parameters:@{@"fields": @"id,name,email"}
                                           
                                           HTTPMethod:@"GET"];
             
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result,NSError *error) {
                 
                 // Handle the result
                 if (_loginBlock) {
                     _loginBlock(result[@"id"],result[@"name"],result[@"email"],NdFaceBookLoginType_Susses);
                 }
                 NSLog(@"%@,%@,%@",result[@"id"],result[@"name"],result[@"email"]);
                 
             }];
             
             
         }
     }];
}


#pragma mark --> FBSDKLoginButtonDelegate
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    NSLog(@"FB-->%@",result.token);
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  
                                  initWithGraphPath:result.token.userID
                                  
                                  parameters:@{@"fields": @"id,name,email"}
                                  
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result,NSError *error) {
        
        // Handle the result
        if (_loginBlock) {
            _loginBlock(result[@"id"],result[@"name"],result[@"email"],NdFaceBookLoginType_Susses);
        }
        NSLog(@"%@,%@,%@",result[@"id"],result[@"name"],result[@"email"]);
        
    }];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"FB-->%@",loginButton);
}

#pragma mark - facebook   other method

//fb 关注
- (void)fbLikeWithUrlstr:(NSString *)urlStr{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlStr]];
}

- (void)openFbFansPageWithUrlstr:(NSString *)urlStr{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlStr]];
}

#pragma mark - facebook  邀请
- (void)fbInviteWithlinkUrlstr:(NSString *)linkUrlstr andImageUrlstr:(NSString *)imageUrlstr{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:linkUrlstr];
    //optionally set previewImageURL
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

- (void)fbShareWithImageStr:(NSString *)imageStr{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.imageURL = [NSURL URLWithString:imageStr];
    [FBSDKShareDialog showFromViewController:[ZhiboCommon getCurrentVC] withContent:content delegate:self];
}


#pragma mark --> fbshareDelegate
-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
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
+(void)recordLogin{
  
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
+(void)recordFBCreateRoleWithRolename:(NSString *)rolename andRoleId:(NSString *)roleid{
  
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
