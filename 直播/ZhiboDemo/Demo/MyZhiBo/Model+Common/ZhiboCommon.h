//
//  ZhiboCommon.h
//  Demo
//
//  Created by ugamehome on 2017/1/16.
//  Copyright © 2017年 ugamehome. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
//这是一个能够传递image对象的Block image是解析完成的image对象 用于回调
typedef void(^ImageDownLoadBlock)(UIImage *image);

@interface ZhiboCommon : NSObject
+(void)setPlayId:(NSString *)playId;
+(NSString*)getPlayId;


+(void)setPlayName:(NSString *)playName;
+(NSString *)getPlayName;

+(void)setServerId:(NSString *)serverId;
+(NSString *)getServerId;


+(void)setAnchoruid:(NSString *)anchoruid;
+(NSString *)getAnchoruid;

+(void)setLevel:(NSString *)level;
+(NSString *)getLevel;


+(void)setSecret_key:(NSString *)secret_key;
+(NSString *)getSecret_key;


+(void)setDiamondnum:(NSString *)Diamondnum;
+(NSString *)getDiamondnum;

+(void)setGoldnum:(NSString *)Goldnum;
+(NSString *)getGoldnum;


+(void)setShowZhibo:(NSString *)Type;
+(NSString *)getZhibo;

+(void)mpProgressWithView:(UIView *)view andString:(NSString *)str;
/**
 * 解析字符串 （符合字符串规则，返回字符串，否则返回 nil）
 */
+(NSString*) parseStringWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key;
/**
 * 解析数字类型 （符合数字类型规则，返回数字类型，否则返回 0.0）
 */
+(int) parseNumberWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key;

+(long) parseLongberWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key;
/**
 *  获取 plist 配表得文字
 */
+(NSString *)getStringBykey:(NSString *)key;

+(NSString*)ComputemoneyWithMoney:(long )money;

+(BOOL)requestStatusbyReult:(int)reult;


+(void)downLoadImageWithURLString:(NSString *)urlString andBlock:(ImageDownLoadBlock)block;

+ (UIViewController *)getCurrentVC;
@end
