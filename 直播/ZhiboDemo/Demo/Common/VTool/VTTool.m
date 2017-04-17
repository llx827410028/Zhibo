//
//  VTTool.m
//  Unity-iPhone
//
//  Created by ugamehome on 16/9/23.
//
//

#import "VTTool.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "KeyChainStore.h"
#import <CommonCrypto/CommonDigest.h>

@implementation VTTool
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    NSLog(@"手机的IP是：%@", address);
    
    return address;
}

+ (NSString *)getTimeSp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hhHH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    
    NSDate *dateNow2 = [formatter dateFromString:nowtimeStr];
    
     //    时间转时间戳的方法:
     //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];//这两个效果一样
     NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow2 timeIntervalSince1970]];//这两个效果一样
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}


+ (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


+ (id)loadViewFromNib:(NSString *)nibName owner:(id)owner atIndex:(NSUInteger)index
{
    NSArray *xibs = [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil];
    id xibView = nil;
    @try {
        xibView = xibs[index];
    }
    @catch (NSException *exception) {
        xibView = nil;
        NSLog(@"Fun:%s ---- \n%@",__FUNCTION__,exception);
    }
    return xibView;
}

/**
 * 获取 Documents路径
 */
+(NSString*) getDocumentsPath
{
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* pathfile = [path objectAtIndex:0];
    
    //#if __has_feature(obj_arc)
    //    NSMutableString* pathfile = [[NSMutableString alloc] initWithString:str];
    //#else
    //    NSMutableString* pathfile = [[[NSMutableString alloc] initWithString:str] autorelease];
    //#endif
    
    return pathfile;
}

+(void)mpProgressWithView:(UIView *)view andString:(NSString *)str{
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud1.mode = MBProgressHUDModeText;
    hud1.detailsLabelText = str;
    hud1.margin = 10.f;
    hud1.removeFromSuperViewOnHide = YES;
    [hud1 hide:YES afterDelay:2.0];
}


+(NSString*) getBundleID{
     return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/**
 * 获取App显示名称
 */
+ (NSString *)appDisplayName
{
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppName = [dicInfo objectForKey:@"CFBundleDisplayName"];
    return strAppName;
}

/**
 * 获取App主版本号
 */
+ (NSString *)appMajorVersion
{
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppBuild = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    return strAppBuild;
}

/**
 * 获取App次版本号
 */
+ (NSString *)appMinorVersion
{
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppVersion = [dicInfo objectForKey:@"CFBundleVersion"];
    return strAppVersion;
}

/**
 *	获取当前Application的keyWindow
 */
+ (UIWindow *)appWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return window;
}


+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[KeyChainStore load:KEY_USERNAME_PASSWORD];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}


+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (CGFloat )estimateTextWidthByContent:(NSString *)content textFont:(UIFont *)font
{
    
    if ( nil == content || 0 == content.length )
        return 0.0f;
    
    CGSize theSize = CGSizeZero;
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        theSize = rect.size;
    }else{
        theSize = [content sizeWithFont:font];
    }
    
    return ceil(theSize.width);
}

+(NSDictionary *)getPlistDicValueWithKey:(NSString*)key{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:key ofType:@"plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        if (dic) {
            return dic;
        }
    }
    return nil;
}

+(NSString *)getPlistValueWithKey:(NSString*)key andPlistName:(NSString*)name{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        if (dic) {
            return dic[key];
        }
    }
    return @"";
}

@end
