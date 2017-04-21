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
typedef void(^ForceIsLoginBySdk)();//非 强更  取消和 确定后
@interface NdForceAndLogOut : NSObject
+(instancetype)shareInstance;
@property (nonatomic,copy) LoginOutBlock o_block;
@property (nonatomic,copy) ForceIsLoginBySdk o_loginSdk;
-(void)loginOut;
-(void)getForce;
@end
