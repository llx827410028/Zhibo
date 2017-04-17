//
//  PaymentRequests.m
//  IAPTest
//
//  Created by huang on 16/6/3.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "PaymentRequests.h"
#import "HHttpHelper.h"
#import "CacheSystem.h"

 NSString *const orderid = @"orderid";
 NSString *const paytoken = @"paytoken";

@interface PaymentRequests()

@end

@implementation PaymentRequests

+(instancetype)shareInstance
{
    static PaymentRequests * object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[PaymentRequests alloc] init];
    });
    return object;
}

-(BOOL)checkNetwork
{
    BOOL isConnect = YES;
    
    return isConnect;
    
}

-(void)checkShipments
{
    
    NSDictionary * cacheDic =  [CacheSystem getAllCache];
    if (cacheDic == nil || cacheDic.count == 0 || ![self checkNetwork]) {
        return;
    }
    else
    {
        for (NSString * key in cacheDic.allKeys) {
            //            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:key,orderid,[cacheDic objectForKey:key],paytoken,nil];
            NSDictionary *dic = nil;
            id object = [cacheDic objectForKey:key];
            if ([object conformsToProtocol:@protocol( CacheProtocol )]) {
                dic = [ object performSelector:@selector(toDictionary) withObject:nil ];
            }
            else
            {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:key,orderid,object,paytoken,nil];
            }
            
            [self shipmentsRequest:dic withHUD:NO withSuccessBlock:^(NSDictionary *dic) {
                [CacheSystem removeCacheForKey:key];
                
            } withFaildBlock:^(NSError *error) {
                
            }];
        }
    }
}

-(void)getData:(NSString *)params andisHud:(BOOL)isHud andUrl:(NSString *)url andBackObjName:(NSString *)objName withSuccessBlock:(RequstsSuccess)successBlock withFaildBlock:(RequstsFaild)faildBlock{
    NSLog(@"postData--->（%@）请求数据 -->%@",url,params);
    if (isHud) {
          [MBProgressHUD showHUDAddedTo:[VTTool appWindow] animated:YES];
    }
    [HHttpHelper get:url FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (isHud) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [MBProgressHUD hideHUDForView:[VTTool appWindow] animated:YES];
            });
        }
        NSLog(@"postData(%@)= %@ \n postError=%@\n ",objName,data,connectionError);
        if(connectionError == nil)
        {
            NSError *error=nil;
            NSLog(@"postData（%@） =%@" ,objName, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"postData（%@）=%@" ,objName,object);
            if (error) {
                NSLog(@"postData =%@",error);
            }
            successBlock(object);
        }
        else
        {
            faildBlock(connectionError);
        }
    }];
}


-(void)postData:(NSDictionary*)params andisHud:(BOOL)isHud andUrl:(NSString *)url andBackObjName:(NSString *)objName withSuccessBlock:(RequstsSuccess) successBlock withFaildBlock:(RequstsFaild)faildBlock{
    NSLog(@"postData--->（%@）请求数据 -->%@",url,params);
    if (isHud) {
        [MBProgressHUD showHUDAddedTo:[VTTool appWindow] animated:YES];
    }
    [HHttpHelper post:url RequestParams:params FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (isHud) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [MBProgressHUD hideHUDForView:[VTTool appWindow] animated:YES];
            });
        }
        NSLog(@"postData(%@)= %@ \n postError=%@\n ",objName,data,connectionError);
        if(connectionError == nil)
        {
            NSError *error=nil;
            NSLog(@"postData（%@） =%@" ,objName, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"postData（%@）=%@" ,objName,object);
            if (error) {
                NSLog(@"postData =%@",error);
            }
            successBlock(object);
        }
        else
        {
            faildBlock(connectionError);
        }
    }];
}

-(void)buyEvent:(NSDictionary *)params withHUD:(BOOL)hud withSuccessBlock:(PurchaseCallBack)successblock withFaildBlock:(FailedPurchaseCallBack)faildBlock
{
    if (hud) {
        [MBProgressHUD showHUDAddedTo:[VTTool appWindow] animated:YES];
    }
    [AppleIAP shareInstancet].failedblock=faildBlock;
    [self getTempOrder:params withSuccessBlock:^(NSDictionary * dic) {
        [AppleIAP shareInstancet].purcaseblock=^(int code,AppleProduct *product){
            //请法发货
            NSMutableDictionary *shipmentDic = [NSMutableDictionary dictionary];
            shipmentDic[orderid] = [NSString stringWithFormat:@"%@", dic[orderid] ];
            shipmentDic[paytoken] = product.receipt;
            
            AppleProduct *nproduct = [product copy];
            nproduct.orderID = dic[orderid];
            
            [self shipmentsRequest:shipmentDic withHUD:hud withSuccessBlock:^(NSDictionary *dic) {
                
                [CacheSystem removeCacheForKey:shipmentDic[orderid]];
                successblock(1,nproduct);
                NSLog(@"发货成功");
                if (hud) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 更新界面
                        [MBProgressHUD hideHUDForView:[VTTool appWindow] animated:YES];
                    });
                }
            } withFaildBlock:^(NSError *error) {
                NSLog(@"发货失败 error=%@",error);
                
                CacheObject *object = [CacheObject new];
                object.orderID =shipmentDic[orderid];
                object.paytoken =shipmentDic[paytoken];
                [CacheSystem addCacheObject:object forKey:object.orderID];
                if (hud) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 更新界面
                        [MBProgressHUD hideHUDForView:[VTTool appWindow] animated:YES];
                    });
                }
            }];
        };
        
        [AppleIAP shareInstancet].failedblock = ^(int code,AppleProduct* msg){
            if (hud) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [MBProgressHUD hideHUDForView:[VTTool appWindow] animated:YES];
                });
            }
        };
        
        [[AppleIAP shareInstancet ]getProductInfo:params[@"appStoreProductid"]];
        
    } withFaildBlock:^(NSError * error) {
        AppleProduct *nproduct = [[AppleIAP shareInstancet].product copy];
        nproduct.message = @"订单无效";
        faildBlock(1,nproduct);
        if (hud) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [MBProgressHUD hideHUDForView:[VTTool appWindow] animated:YES];
            });
        }
    }];
}

//请求发货
-(void)shipmentsRequest:(NSDictionary*)params withHUD:(BOOL)hud withSuccessBlock:(RequstsSuccess) successBlock withFaildBlock:(RequstsFaild)faildBlock
{
    if (hud) {
        //
    }
    NSLog(@"requesturl -->%@ params -->%@",app_request_good_url,params);
    [HHttpHelper post:app_request_good_url RequestParams:params FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"data= %@ \n error=%@\n ",data,connectionError);
        if(connectionError == nil)
        {
            NSError *error=nil;
            NSLog(@"data =%@" , [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"object=%@",object);
            if (error) {
                //                NSLog(@"error =%@",error);
            }
            successBlock(object);
        }
        else
        {
            faildBlock(connectionError);
        }
    }];
    
}


//请求临时订单
-(void)getTempOrder:(NSDictionary*)params withSuccessBlock:(RequstsSuccess) successBlock withFaildBlock:(RequstsFaild)faildBlock
{
    NSLog(@"requesturl -->%@-->%@",app_getOrder_url,params);
    [HHttpHelper post:app_getOrder_url RequestParams:params FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"data= %@ \n error=%@\n ",data,connectionError);
        if(connectionError == nil)
        {
            NSError *error=nil;
            NSLog(@"data =%@" , [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             NSLog(@"object=%@",object);
            if (error) {
                NSLog(@"error =%@",error);
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
