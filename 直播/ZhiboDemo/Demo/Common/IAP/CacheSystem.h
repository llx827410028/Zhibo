//
//  CacheSystem.h
//  IAPTest
//
//  Created by huang on 16/6/2.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CacheSystemListPath;
@class CacheObject;
@protocol CacheProtocol;
@interface CacheSystem : NSObject

+(void)addCacheString:(NSString*)object forKey:(NSString*)key;
+(void)addCacheObject:(id<CacheProtocol>)object forKey:(NSString *)key;
+(void)removeCacheForKey:(NSString*)key;
+(void)removeAllCache;
+(NSDictionary *)getAllCache;
+(NSString*)getCacheForKey:(NSString*)key;
@end



@protocol CacheProtocol <NSCoding>

-(NSDictionary*)toDictionary;

@end

@interface CacheObject : NSObject <CacheProtocol>
{
    
}
@property(nonatomic,copy)NSString *orderID;
@property(nonatomic,copy)NSString *paytoken;

@end
