//
//  ZhiBoSetProgress.h
//  Demo
//
//  Created by ugamehome on 2016/10/25.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoBaseView.h"
typedef enum {
    SetProgressWalkType_Top,
    SetProgressWalkType_Bottom,
    SetProgressWalkType_All,
}SetProgressWalkType;


typedef void(^walkType)(SetProgressWalkType);//第一个是弹幕的方向
//调节弹幕
typedef void(^adjustDm) (int,int);//第二个弹幕调节类型（弹幕亮度1，弹幕字体2）第三个是调节数
//直播设置 视图
@interface ZhiBoSetProgress : ZhiBoBaseView
@property (nonatomic,copy) walkType o_block;
@property (nonatomic,copy) adjustDm o_adjustBlock;
@end
