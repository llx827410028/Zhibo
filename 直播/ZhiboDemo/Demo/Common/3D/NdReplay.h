//
//  NdReplay.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/3/15.
//
//

#import <Foundation/Foundation.h>
#warning 本类 如果没有用到 请删除--------------NdReplay--------------
@interface NdReplay : NSObject
+(instancetype)shareInstance;
//判断设备是否支持录像~
-(BOOL )isSupporios;
//打开 关闭 replay
-(void)replayKitActionWithIsreplay:(BOOL )isreplay;
@end
