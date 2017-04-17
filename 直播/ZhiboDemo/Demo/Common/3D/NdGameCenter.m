//
//  NdGameCenter.m
//  Unity-iPhone
//
//  Created by ugamehome on 2016/12/30.
//
//

#import "NdGameCenter.h"
#import "UnityAppController.h"

@interface NdGameCenter()<GKGameCenterControllerDelegate>
{
    // 记录上次的账号，用于确认是否有登出操作
    NSString* _lastPlayerId;
    // 判断是否登陆过一次了
    BOOL _hasLoginOnce;
}
@end

@implementation NdGameCenter


+(instancetype)shareInstance
{
    static NdGameCenter * object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[NdGameCenter alloc] init];
    });
    return object;
}

//检测
- (BOOL) isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}
///////////////////////////////////////
//初始化
-(void)initsdk
{
    NSLog(@"初始化 init");
    //一般要在这里增加回调监听
    NSLog(@"想要再次验证Game Center，请切到后台再切回来，或者重启游戏");
    [self registerForAuthenticationNotification];
    [self setAuthenticateLocalPlayer];
}

//注销
- (void)logout
{
    NSLog(@"注销 logout");
    // 苹果没有主动登出一说
}

//登陆
- (void)login
{
    NSLog(@"登陆 login");
    [self getSignature];
}

//帐号管理
- (void)userCenter
{
    NSLog(@"帐号管理 userCenter");
}

-(BOOL) isAuthenticated
{
    return [[GKLocalPlayer localPlayer] isAuthenticated];
}


-(NSString*) getLocalPlayerId
{
    if ([self isAuthenticated])
    {
        return [GKLocalPlayer localPlayer].playerID;
    }
    
    return nil;
}


// 这玩意只有第一次执行的时候会触发回调
-(void) setAuthenticateLocalPlayer
{
    NSLog(@"setAuthenticateLocalPlayer");
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error)
                                         {
                                             [self authenticateCallback:viewcontroller Error:error];
                                         })];
}

// 这玩意每次切换到桌面再切回来还会被调用一次，有点像支付
-(void) authenticateCallback:(UIViewController*)viewcontroller Error:(NSError*)error
{
    NSLog(@"authenticateCallback");
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        [MBProgressHUD hideHUDForView:[VTTool appWindow] animated:YES];
    });
    if (viewcontroller != nil)
    {
        if (_o_hideLoginViewBlock) {
            _o_hideLoginViewBlock(YES);
        }
        NSLog(@"打开Game Center验证界面.");
        [[ZhiboCommon getCurrentVC] presentViewController:viewcontroller animated:YES completion:^{
            
        }];
    }
    else
    {
        // 登出再登陆的，说明已经初始化过了
        if (self->_hasLoginOnce)
        {
            return;
        }
        // 切到后台，登出，再切回来，依旧是空viewcontroller，空error，非常神奇
        if ([self isAuthenticated])
        {
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                else{
                    
                }
            }];
            if (_o_block) {
                _o_block([GKLocalPlayer localPlayer].playerID,@"");
            }
            self->_hasLoginOnce = true;
        }
        else
        {
            if (_o_hideLoginViewBlock) {
                _o_hideLoginViewBlock(NO);
            }
            if (error)
            {
                 NSLog(@"error-->%@",[NSString stringWithFormat:@"code=%ld description=%@", (long)error.code, error.description]);
            }
            else
            {
                NSLog(@"error-->%@",@"Game Center登出了或者未知错误");
            }
        }
    }
}


-(void) getSignature
{
    // 如果还没有登录，特殊处理
    if (![self isAuthenticated])
    {
        NSLog(@"玩家还没有登录GameCenter，切到后台再切回来登陆，或者去Game Center登陆");
        return;
    }
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer generateIdentityVerificationSignatureWithCompletionHandler:^(NSURL *publicKeyUrl, NSData *signature, NSData *salt, uint64_t timestamp, NSError *error)
     {
         
         if(error != nil)
         {
             NSLog(@"error-->%@",[NSString stringWithFormat:@"code=%ld description=%@", (long)error.code, error.description]);
             return;
         }
         
         
         NSString* url = [publicKeyUrl absoluteString];
         NSString* sig = [NSString stringWithFormat:@"%@", [signature base64EncodedStringWithOptions: 0]];
         NSString* slt = [NSString stringWithFormat:@"%@", [salt base64EncodedStringWithOptions: 0]];
         NSString* stamp = [NSString stringWithFormat:@"%llu", timestamp];
         NSString* playerId = [GKLocalPlayer localPlayer].playerID;
         NSString* bundleId = [NSBundle mainBundle].bundleIdentifier;
         
         NSString* data = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@", playerId, sig, slt, stamp, url, bundleId];
         NSLog(@"%@", data);
     }];
}

-(void) registerForAuthenticationNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
}

// 这玩意会比authenticationHandler早回调
-(void) authenticationChanged
{
    NSLog(@"authenticationChanged");
    
    // 登出了或者切换了账号
    if (self->_lastPlayerId != nil)
    {
        [self logout];
    }
    self->_lastPlayerId = [self getLocalPlayerId];
}




#pragma mark - 排行榜 实现

/**
*  设置得分
*
*  @param identifier 排行榜标识
*  @param value      得分
*/
-(void)addScoreWithIdentifier:(NSString *)identifier value:(int64_t)value{
    if (![GKLocalPlayer localPlayer].isAuthenticated) {
        NSLog(@"未获得用户授权.");
        return;
    }
    //创建积分对象
    GKScore *score=[[GKScore alloc]initWithLeaderboardIdentifier:identifier];
    //设置得分
    score.value=value;
    //提交积分到Game Center服务器端,注意保存是异步的,并且支持离线提交
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if(error){
            NSLog(@"保存积分过程中发生错误,错误信息:%@",error.localizedDescription);
            NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:score];
             [self storeScoreForLater:saveSocreData];
            return ;
        }
        NSLog(@"添加积分成功.");
    }];
 }

//提交未成功  保存数据
- (void)storeScoreForLater:(NSData *)scoreData{
    NSMutableArray *savedScoresArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [savedScoresArray addObject:scoreData];
    [[NSUserDefaults standardUserDefaults] setObject:savedScoresArray forKey:@"savedScores"];
}

//重新提交分数
- (void)submitAllSavedScores{
    NSMutableArray *savedScoreArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedScores"];
    
    for(NSData *scoreData in savedScoreArray){
        GKScore *scoreReporter = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
        
        [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
            if(error){
                NSLog(@"保存积分过程中发生错误,错误信息:%@",error.localizedDescription);
                NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:saveSocreData];
                [self storeScoreForLater:saveSocreData];
                return ;
            }
            NSLog(@"添加积分成功.");
        }];
    }
}

#pragma mark - 显示gamecenter 界面
//创建GKLocalboardViewController来显示排行榜.
- (void)showGameCenterWithType:(GKGameCenterViewControllerState)type{
    if (![GKLocalPlayer localPlayer].isAuthenticated) {
        NSLog(@"未获得用户授权.");
        return;
  }
    GKGameCenterViewController *gameView = [[GKGameCenterViewController alloc] init];
    if(gameView != nil){
        UnityAppController * appDelegate = (UnityAppController*)[UIApplication sharedApplication].delegate;
        [appDelegate isUnityPause:true];
        gameView.gameCenterDelegate = self;
        gameView.viewState = type;
        [[ZhiboCommon getCurrentVC] presentViewController:gameView animated:YES completion:^{
        }];
    }
}

- (void)showLeaderboardVC:(NSString *)leaderboardid{
    [self showGameCenterWithType:GKGameCenterViewControllerStateLeaderboards];
}
- (void)showRankVC{
    [self showGameCenterWithType:GKGameCenterViewControllerStateAchievements];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [[ZhiboCommon getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    UnityAppController * appDelegate = (UnityAppController*)[UIApplication sharedApplication].delegate;
    [appDelegate isUnityPause:false];
}

#pragma mark -  添加指定类别的成就
-(void)addAchievementWithIdentifier:(NSString *)identifier{
    if (![GKLocalPlayer localPlayer].isAuthenticated) {
        NSLog(@"未获得用户授权.");
        return;
    }
    //创建成就
    GKAchievement *achievement=[[GKAchievement alloc]initWithIdentifier:identifier];
    achievement.percentComplete=100;//设置此成就完成度，100代表获得此成就
    NSLog(@"%@",achievement);
    //保存成就到Game Center服务器,注意保存是异步的,并且支持离线提交
    [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
        if(error){
            NSLog(@"保存成就过程中发生错误,错误信息:%@",error.localizedDescription);
            return ;
        }
        if (_isGetRankScoreToLeaderboard) {
            [self getarchievemetData];
        }
        NSLog(@"添加成就成功.");
    }];
 }

- (void)getarchievemetData{
    //获取所有成就
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray<GKAchievementDescription *> * _Nullable descriptions, NSError * _Nullable error) {
        if (!error) {
            //获取已经完成的成就
            [GKAchievement  loadAchievementsWithCompletionHandler:^(NSArray<GKAchievement *> * _Nullable achievements, NSError * _Nullable error) {
                if (!error) {
                    NSInteger score = 0;
                    for (GKAchievement *obj in achievements) {
                        if (obj.completed) {
                            for (GKAchievementDescription *description in descriptions) {
                                if ([description.identifier isEqualToString:obj.identifier]) {
                                    score+= description.maximumPoints;
                                }
                            }
                        }
                    }
                    //获取排行榜id 并加入 数据
                    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray<GKLeaderboard *> * _Nullable leaderboards, NSError * _Nullable error) {
                        for (GKLeaderboard *obj in leaderboards) {
                            [self addScoreWithIdentifier:obj.identifier value:score];
                        }
                    }];
                }
            }];

        }
    }];
}

@end
