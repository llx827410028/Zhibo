//
//  ZhiBoBottomToolView.h
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhiBoBaseView.h"
@class ZhiBoVC;
typedef enum {
    BottomType_RankView = 1,
    BottomType_ListView,
    BottomType_DmStatus,
    BottomType_Refresh,
    BottomType_TfBegin,
}BottomType;
//直播低部 视图
typedef void(^ShowBottomBntView)(BottomType,BOOL);
typedef void (^NoticeDanmuBlock)(NSString*);
@interface ZhiBoBottomToolView : ZhiBoBaseView
- (void)hideKeyBoard;
- (void)showTfbeginBnt;
@property (nonatomic,strong)ZhiBoVC *o_zhiBoVC;
@property (nonatomic,copy) ShowBottomBntView showBottomBntBlock;
@property (nonatomic,copy) NoticeDanmuBlock o_noticeDanmuBlock;
@end
