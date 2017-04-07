//
//  ZhiboLanguage.h
//  Demo
//
//  Created by ugamehome on 2017/1/11.
//  Copyright © 2017年 ugamehome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhiboLanguage : NSObject
+(instancetype)shareInstance;
-(NSString *)getStringBykey:(NSString *)key;
@end
