//
//  NdForceAndLogOut.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/3/20.
//
//

#import <Foundation/Foundation.h>
//强制更新  已经 退出登录 功能
typedef void(^LoginOutBlock)();
@interface NdForceAndLogOut : NSObject
+(instancetype)shareInstance;
@property (nonatomic,copy) LoginOutBlock o_block;
-(void)loginOut;
-(void)getForce;
@end
