//
//  AppleIAP.m
//  IAPTest
//
//  Created by huang on 16/6/1.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "AppleIAP.h"
#import <StoreKit/StoreKit.h>

@implementation AppleProduct
-(instancetype)copyWithZone:(NSZone *)zone
{
    
    AppleProduct *product  = [[[self class] allocWithZone:zone] init];
    product.productIdentifier = _productIdentifier;
    product.receipt = _receipt;
    product.price = _price;
    product.quantity = _quantity;
    product.orderID = _orderID;
    product.message = _message;
    return product;
    
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.quantity = 1;
    }
    return self;
}

-(NSString*)description
{
    NSString *sting = [NSString stringWithFormat:@"productIdentifier= %@ | receipt =%@ | price=%lf | quantity = %li | orderID = %@",_productIdentifier,_receipt,_price,(long)_quantity,_orderID];
    return sting;
}


@end


@interface AppleIAP() <SKProductsRequestDelegate,SKPaymentTransactionObserver>
@end

@implementation AppleIAP

+(instancetype)shareInstancet
{
    static AppleIAP *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[AppleIAP alloc] init];
    });
    return object;
}

-(id)init
{
    self=[super init];
    if (self) {
        if ([SKPaymentQueue canMakePayments]) {
            _product =  [[AppleProduct alloc] init];
            // 执行下面提到的第5步：
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        } else {
            [self faildEvent:800 withMsg:@"失败，用户禁止应用内付费购买."];
        }
    }
    return self;
}

-(void)faildEvent:(int)code withMsg:(NSString*)msg
{
     self.product.message = @"无法获取产品信息，购买失败。";
    if (self.delegate) {
        [self.delegate failedPurchaseCallBack:code msg:self.product];
    }
    if (self.failedblock) {
        self.failedblock(code,self.product);
    }
    NSLog(@"%@", msg);
}

-(void)successEvent:(int)code withProductIdentifier:(NSString*)pid withReceipt:(NSString*)receipt
{
    self.product.productIdentifier = pid;
    self.product.receipt = receipt;
    if(self.delegate)
    {
        [self.delegate purchaseCallBack:code msg:self.product];
    }
    if (self.purcaseblock) {
        self.purcaseblock(code,self.product);
    }
}

- (void)getProductInfo:(NSString *)productID  {
    NSSet * set = [NSSet setWithArray:@[productID]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

#pragma mark - 
#pragma mark SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        [self faildEvent:801 withMsg:@"无法获取产品信息，购买失败。" ];
        return;
    }
    
    NSArray *producta = response.products;
    if([producta count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[producta count]);
    
    for (SKProduct *pro in producta) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
    }
    
    SKProduct  *product =myProduct[0];
    _product.price =[product.price doubleValue];
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver

//7、 当用户购买的操作有结果时，就会触发下面的回调函数，相应进行处理即可。
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                NSLog(@"transaction.error.code-->%ld",transaction.error.code);
                [self failedTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateDeferred:      //商品添加进列表
                NSLog(@"商品添加进");
                break;
            default:
                break;
        }
    }
}
//交易完成
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSString * receipt = [transaction.transactionReceipt base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        [self successEvent:0 withProductIdentifier:productIdentifier withReceipt:receipt];
           }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        [self faildEvent:1 withMsg:@"购买失败"];
        
    } else {
        [self faildEvent:4 withMsg:@"用户取消交易"];
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//已经购买过该商品
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self faildEvent:2 withMsg:@"重复订单"];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


@end
