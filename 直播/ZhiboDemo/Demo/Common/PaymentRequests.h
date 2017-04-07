//
//  PaymentRequests.h
//  IAPTest
//
//  Created by huang on 16/6/3.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppleIAP.h"
typedef void(^RequstsSuccess)(NSDictionary*);
typedef void(^RequstsFaild)(NSError*);

@interface PaymentRequests : NSObject

+(instancetype)shareInstance;

//检测发货
-(void)checkShipments;
-(void)buyEvent:(NSDictionary *)params withHUD:(BOOL)hud withSuccessBlock:(PurchaseCallBack)successblock withFaildBlock:(FailedPurchaseCallBack)faildBlock;
-(void)postData:(NSDictionary*)params andisHud:(BOOL)isHud andUrl:(NSString *)url andBackObjName:(NSString *)objName withSuccessBlock:(RequstsSuccess) successBlock withFaildBlock:(RequstsFaild)faildBlock;
-(void)getData:(NSString*)params andisHud:(BOOL)isHud andUrl:(NSString *)url andBackObjName:(NSString *)objName withSuccessBlock:(RequstsSuccess) successBlock withFaildBlock:(RequstsFaild)faildBlock;
@end
