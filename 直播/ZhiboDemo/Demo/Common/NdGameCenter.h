//
//  NdGameCenter.h
//  Unity-iPhone
//
//  Created by ugamehome on 2016/12/30.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
typedef void(^LoginGCSuccess)(NSString *userId,NSString *token);
typedef void(^LoginGCHideOrShowLoginView)(BOOL);//yes-->hide  no-->show
@interface NdGameCenter : NSObject
+(instancetype)shareInstance;
@property (nonatomic)BOOL isGetRankScoreToLeaderboard;//排行榜 是否与成就挂钩
- (BOOL) isGameCenterAvailable;//验证是否支持gamecenter
- (NSString*)getLocalPlayerId;//登陆成功 获取id

@property (nonatomic,copy) LoginGCSuccess o_block;
@property (nonatomic,copy) LoginGCHideOrShowLoginView o_hideLoginViewBlock;

- (void)initsdk;
- (void)showGameCenterWithType:(GKGameCenterViewControllerState)type;
- (void)showLeaderboardVC:(NSString *)leaderboardid;
- (void)showRankVC;
/**
 *  设置得分
 *
 *  @param identifier 排行榜标识
 *  @param value      得分
 */
-(void)addScoreWithIdentifier:(NSString *)identifier value:(int64_t)value;
//添加指定类别的成就
-(void)addAchievementWithIdentifier:(NSString *)identifier;
@end
