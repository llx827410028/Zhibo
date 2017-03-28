//
//  CacheSystem.m
//  IAPTest
//
//  Created by huang on 16/6/2.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "CacheSystem.h"

 NSString *const CacheSystemListPath = @"CacheSystemList";


@implementation CacheSystem
+(void)addCacheString:(NSString*)object forKey:(NSString*)key
{
    NSDictionary * dic =  [[NSUserDefaults standardUserDefaults] objectForKey:CacheSystemListPath];
    if (dic==nil) {
        dic = [NSDictionary dictionaryWithObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:CacheSystemListPath];
    }
    else
    {
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [newDic setObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] setValue:newDic forKey:CacheSystemListPath];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+(void)addCacheObject:(CacheObject*)object forKey:(NSString*)key
{
    NSDictionary * dic =  [[NSUserDefaults standardUserDefaults] objectForKey:CacheSystemListPath];
    if (dic==nil) {
        dic = [NSDictionary dictionaryWithObject:[NSKeyedArchiver archivedDataWithRootObject:object]forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:CacheSystemListPath];
    }
    else
    {
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [newDic setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:CacheSystemListPath];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}

+(void)removeCacheForKey:(NSString *)key
{
     NSDictionary * dic =  [[NSUserDefaults standardUserDefaults] objectForKey:CacheSystemListPath];
    if (dic==nil) {
        
    }
    else
    {
        NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [newDic removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] setValue:newDic forKey:CacheSystemListPath];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}

+(void)removeAllCache
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CacheSystemListPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDictionary*)getAllCache
{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:CacheSystemListPath];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    for (NSString * key  in dic.allKeys ) {
        id object = dic[key];
        if ([object isKindOfClass:[NSData class]]) {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:object];
        }
        newDic[key] = object;
    }
    
    return newDic;
}

+(NSString *)getCacheForKey:(NSString *)key
{
    id object =  [[CacheSystem getAllCache] objectForKey:key];
    if ([object isKindOfClass:[NSData class]]) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:object];
    }
    return object;
}

@end




@implementation CacheObject


-(NSString*)description
{
    NSString *string = [NSString stringWithFormat:@"paytoken = %@ | orderID=%@ ",self.paytoken,self.orderID];
    return string;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.paytoken forKey:@"paytoken"];
    [aCoder encodeObject:self.orderID forKey:@"orderID"];
}
-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.paytoken=[aDecoder decodeObjectForKey:@"paytoken"];
    self.orderID=[aDecoder decodeObjectForKey:@"orderID"];
    return self;
}
-(NSDictionary*)toDictionary
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:self.paytoken,@"paytoken",self.orderID,@"orderid", nil];
    return dic;
}
@end


