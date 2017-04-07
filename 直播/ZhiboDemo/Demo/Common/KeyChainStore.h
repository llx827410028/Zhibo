//
//  KeyChainStore.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/2/9.
//
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end
