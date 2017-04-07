//
//  ZhiBoListView.h
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhiBoBaseView.h"


typedef void(^LoadRoomBlock)(NSString* imageUrl,NSString*title);
//直播排行榜 视图
@interface ZhiBoListView : ZhiBoBaseView
- (void)getZhiboListinfo;
@property (nonatomic,copy) LoadRoomBlock o_block;
@end
