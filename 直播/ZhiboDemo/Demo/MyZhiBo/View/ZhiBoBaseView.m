//
//  ZhiBoBaseView.m
//  Demo
//
//  Created by ugamehome on 2016/10/22.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoBaseView.h"
#import "UIView+ZUtils.h"

@interface ZhiBoBaseView()

@end

@implementation ZhiBoBaseView
+ (instancetype)liveEndView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)ShowOrHide{
    self.isHide = !self.isHide;
    if (self.isHide) {
        [UIView animateWithDuration:0.3 animations:^{
            self.width = self.heightOrWidthScale;
            self.x = llx_screenWidth;
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.width = self.heightOrWidthScale;
            self.x = llx_screenWidth - self.heightOrWidthScale;
        } completion:^(BOOL finished) {
        }];
    }
}

//以屏幕375*667 为标准
- (void)setHeightScale{
    self.height = llx_screenHeight * self.height/375;
    self.y = llx_screenHeight;
    _heightOrWidthScale = self.height;
}

- (void)setWidthScale{
    self.width = llx_screenWidth * self.width/667;
    self.x = llx_screenWidth;
    _heightOrWidthScale = self.width;
}
@end
