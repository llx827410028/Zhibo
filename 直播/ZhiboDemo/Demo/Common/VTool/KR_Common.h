//
//  KR_Common.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/1/23.
//
//

#import <Foundation/Foundation.h>

@interface KR_Common : NSObject

+ (float)getWidthByWith5sWidth:(float )width;
+(float)getheightByWith5sHeight:(float )height;

+(void)setUsername:(NSString *)username;
+(NSString*)getUsername;


+(void)setUserpsw:(NSString *)userpsw;
+(NSString *)getUserpsw;

//保存 登录时间  如果超过5天为登录 不会自动登录 需要手动登录
+(void)setLoginTime:(NSString *)date;
+(NSString *)getLoginDate;
//login type  --> fb gc 为标示符号
+(void)setLoginType:(NSString *)loginType;
+(NSString *)getLoginType;
@end
