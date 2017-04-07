//
//  GiftAnimView.h
//  Demo
//
//  Created by ugamehome on 2016/11/18.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TimerFireBlock)(NSTimer *);

@interface GiftAnimView : UIView

- (void)sendAnimGiftWithSendName:(NSString *)sendName andInfoDic:(NSDictionary*)weakDic andTimerFireBlock:(TimerFireBlock)timerFireBlock;
@end
