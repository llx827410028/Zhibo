//
//  KR_Common.m
//  Unity-iPhone
//
//  Created by ugamehome on 2017/1/23.
//
//

#import "KR_Common.h"
@interface KR_Common()
@property (nonatomic,strong)NSDictionary *o_dic;
@end

@implementation KR_Common

+ (float)getWidthByWith5sWidth:(float )width{
    return llx_screenWidth/568*width;
}


+(float)getheightByWith5sHeight:(float )height{
    return llx_screenHeight/320*height;
}


+(void)setUsername:(NSString *)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"username"];
}
+(NSString*)getUsername{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"username"] ?:@"";
}


+(void)setUserpsw:(NSString *)userpsw{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userpsw forKey:@"userpsw"];
}
+(NSString *)getUserpsw{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"userpsw"] ?:@"";
}


+(void)setLoginTime:(NSString *)date{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:date forKey:@"loginDate"];
}
+(NSString *)getLoginDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"loginDate"] ?:@"";
}


+(void)setLoginType:(NSString *)loginType{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:loginType forKey:@"loginType"];
}
+(NSString *)getLoginType{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"loginType"] ?:@"";
}
@end
