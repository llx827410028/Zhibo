//
//  ZhiBoBaseView.h
//  Demo
//
//  Created by ugamehome on 2016/10/22.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZhiBoBaseView : UIView
+ (instancetype)liveEndView;
- (void)ShowOrHide;
@property (nonatomic)BOOL isHide;
@property (nonatomic,assign)CGFloat heightOrWidthScale;
/** 以375 *667 屏幕尺寸为标准  获取相应地 高比例，宽的比例*/
- (void)setHeightScale;
- (void)setWidthScale;
@property (nonatomic)BOOL isViewShow;//是否在主界面显示
@end
