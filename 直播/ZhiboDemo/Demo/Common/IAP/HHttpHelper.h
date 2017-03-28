//
//  NetworkRequest.h
//  netowrk
//
//  Created by huang on 16/2/26.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HHttpHelper : NSObject

+ (BOOL)NetWorkIsOK;//检查网络是否可用
+ (void)post:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;//post请求封装

@end
