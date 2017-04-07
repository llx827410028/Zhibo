//
//  ZhiBoAboveView.h
//  Demo
//
//  Created by ugamehome on 2016/10/22.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoBaseView.h"
@class ZhiBoVC;
typedef enum {
    BoAboveType_Back = 1,
    BoAboveType_Attention,
    BoAboveType_Zan,
    BoAboveType_Set,
}BoAboveType;

//直播顶部 视图
typedef void(^ClickAboveBtnView)(BoAboveType);
@interface ZhiBoAboveView : ZhiBoBaseView
@property (nonatomic,copy) ClickAboveBtnView o_clickAboveBtnBlock;
@property (strong, nonatomic) NSString *title;
@property (nonatomic,strong)ZhiBoVC *o_zhiBoVC;
@end
