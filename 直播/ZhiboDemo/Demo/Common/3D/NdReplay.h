//
//  NdReplay.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/3/15.
//
//

#import <Foundation/Foundation.h>

@interface NdReplay : NSObject
+(instancetype)shareInstance;
-(BOOL )isSupporios;
-(void)replayKitActionWithIsreplay:(BOOL )isreplay;
@end
