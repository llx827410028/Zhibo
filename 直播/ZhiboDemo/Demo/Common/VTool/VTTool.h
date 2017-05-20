//
//  VTTool.h
//  Unity-iPhone
//
//  Created by ugamehome on 16/9/23.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VTTool : NSObject
+ (NSString *)deviceIPAdress;
+ (NSString *)getTimeSp;
+ (NSString *) md5:(NSString *)str;
/**
 * @method loadViewFromNib:
 * @abstract 从与类名对应的XIB文件中加载指定索引的View对象，允许指定View的owner
 * @param nibName XIB文件名
 * @param owner View的owner
 * @param index View在XIB中的顺序索引
 */
+ (id)loadViewFromNib:(NSString *)nibName owner:(id)owner atIndex:(NSUInteger)index;

+(NSString*) getDocumentsPath;

+(void)mpProgressWithView:(UIView *)view andString:(NSString *)str;

/**
 *  获取BundleID
 */
+(NSString*) getBundleID;
/**
 * 获取App显示名称
 */
+ (NSString *)appDisplayName;

/**
 * 获取App主版本号(2.1.0)
 */
+ (NSString *)appMajorVersion;

/**
 * 获取App次版本号 (2015020201)
 */
+ (NSString *)appMinorVersion;

/**
 *	获取当前Application的keyWindow
 */
+ (UIWindow *)appWindow;
/**  */
+(NSString *)getUUID;

+ (UIColor *) colorWithHexString: (NSString *)color;
+ (CGFloat )estimateTextWidthByContent:(NSString *)content textFont:(UIFont *)font;

+(NSDictionary *)getPlistDicValueWithKey:(NSString*)key;

+(NSString *)getPlistValueWithKey:(NSString*)key andPlistName:(NSString*)name;
+(NSString *)isEntiyWithKey:(NSString*)key;
//判断是否为ipv6环境
+ (BOOL)isIpv6;

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
@end
