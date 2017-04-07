//
//  ZhiboRequests.m
//  Demo
//
//  Created by ugamehome on 2016/10/14.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiboRequests.h"
#import <objc/runtime.h>
#import "HHttpHelper.h"


@implementation ZhiboRequests
+(instancetype)shareInstance
{
    static ZhiboRequests * object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[ZhiboRequests alloc] init];
    });
    return object;
}

-(void)postZhiboData:(NSDictionary*)params andUrl:(NSString *)url andBackObjName:(NSString *)objName withSuccessBlock:(ZhiboRequstsSuccess) successBlock withFaildBlock:(ZhiboRequstsFaild)faildBlock{
    NSLog(@"zhiboData（%@）请求数据 =%@",objName,params);
    [HHttpHelper post:[NSString stringWithFormat:@"%@zhibo/%@",app_header_url,url] RequestParams:params FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"zhiboData(%@)= %@ \n zhiboError=%@\n ",objName,data,connectionError);
        if(connectionError == nil)
        {
            NSError *error=nil;
            NSLog(@"zhiboData（%@） =%@" ,objName, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"zhiboObject（%@）=%@" ,objName,object);
            if (error) {
                NSLog(@"zhiboError =%@",error);
            }
            successBlock(object);
        }
        else
        {
            faildBlock(connectionError);
        }
    }];
}
@end
