//
//  ZhiboRequests.h
//  Demo
//
//  Created by ugamehome on 2016/10/14.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ZhiboRequstsSuccess)(id);
typedef void(^ZhiboRequstsFaild)(NSError*);
@interface ZhiboRequests : NSObject
+(instancetype)shareInstance;
-(void)postZhiboData:(NSDictionary*)params andUrl:(NSString *)url andBackObjName:(NSString *)objName withSuccessBlock:(ZhiboRequstsSuccess) successBlock withFaildBlock:(ZhiboRequstsFaild)faildBlock;
@end
