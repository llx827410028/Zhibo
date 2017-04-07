//
//  AppleIAP.h
//  IAPTest
//
//  Created by huang on 16/6/1.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppleProduct;
@protocol AppleIAPDelegate <NSObject>

#pragma mark - IAP Callback
//IAP充值，实现AppleIAPDelegate协议，并实现purchaseCallBack方法
- (void)purchaseCallBack:(int)code  msg:(AppleProduct*)msg;

//IAP失败回调
/*! IAP失败回调
 
 code               描述
 1             无效订单
 2             重复订单
 3             非此用户订单
 4              用户取消交易
 800             设备不支持内购
 801             从苹果服务器刷新商品列表失败
 802             所选商品还不支持购买
 
 */
- (void)failedPurchaseCallBack:(int)code msg:(AppleProduct*)msg;

@end


typedef void(^PurchaseCallBack)(int code,AppleProduct* msg);
typedef void(^FailedPurchaseCallBack)(int code,AppleProduct* msg);


@interface AppleIAP : NSObject
@property(nonatomic,weak)id<AppleIAPDelegate> delegate;
@property(nonatomic,copy)PurchaseCallBack purcaseblock;
@property(nonatomic,copy)FailedPurchaseCallBack failedblock;
@property(nonatomic,strong)AppleProduct *product;
+(instancetype)shareInstancet;
- (void)getProductInfo:(NSString *)productID ;
@end


@interface AppleProduct : NSObject<NSCopying>
@property(nonatomic,copy)NSString * productIdentifier;
@property(nonatomic,copy)NSString * receipt;
@property(nonatomic) NSInteger  quantity;
@property(nonatomic) double  price;
@property(nonatomic,copy)NSString * orderID;
@property(nonatomic,copy)NSString *message;
@end

