//
//  GiftAnimView.m
//  Demo
//
//  Created by ugamehome on 2016/11/18.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "GiftAnimView.h"
#import "UIView+ZUtils.h"

#define GiftName @"name"
#define GiftWidth @"width"
#define GiftHeight @"Height"
#define GiftNum @"num"
#define GiftTextName @"textName"
#define GiftId @"giftId"
#define GiftShowType @"showType"

@interface GiftAnimView()
@property (nonatomic,copy) TimerFireBlock timerFireBlock;
@end

@implementation GiftAnimView

- (void)sendAnimGiftWithSendName:(NSString *)sendName andInfoDic:(NSDictionary*)weakDic  andTimerFireBlock:(TimerFireBlock)timerFireBlock{
    _timerFireBlock = timerFireBlock;
    //对象初始化
   UIImageView*  flameAnimation = [[UIImageView alloc] init];
    flameAnimation.tag = 3001;
    UILabel *giftLable = [[UILabel alloc]init];
    giftLable.font = [UIFont systemFontOfSize:15];
    giftLable.textColor = [UIColor whiteColor];
    giftLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:flameAnimation];
    [self addSubview:giftLable];
    //计算显示的大小
    NSString *giftName = weakDic[GiftTextName];
    NSString *sendgiftstr = [ZhiboCommon getStringBykey:@"赠送"];
    
    NSString *strname = [NSString stringWithFormat:@"%@%@%@",sendName,sendgiftstr,giftName];
   NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:strname];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, sendName.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(sendName.length+sendgiftstr.length, giftName.length)];
    CGFloat textWidth = [VTTool estimateTextWidthByContent:strname textFont:[UIFont systemFontOfSize:15]];
    //frame 初始化
    flameAnimation.width = [weakDic[GiftWidth]intValue];
    flameAnimation.height = [weakDic[GiftHeight]intValue];
    giftLable.y = flameAnimation.height;
    giftLable.height = 20;
    
    CGPoint point;
    CGFloat giftAnimViewWidth;
    if (textWidth>[weakDic[GiftWidth]intValue]) {
        flameAnimation.x = (textWidth - [weakDic[GiftWidth]intValue])/2;
        giftAnimViewWidth = textWidth;
    }else{
        giftAnimViewWidth = flameAnimation.width;
    }
    point = CGPointMake((llx_screenWidth-giftAnimViewWidth)/2, (llx_screenHeight-flameAnimation.height)/2);//中心点
    self.frame = CGRectMake(point.x, point.y, giftAnimViewWidth, CGRectGetMaxY(giftLable.frame));
    giftLable.width = giftAnimViewWidth;
    
    NSMutableArray *giftImages = [[NSMutableArray alloc]init];
    //图片初始化
    int num = [weakDic[GiftNum] intValue];
    for (int i = 1; i <= num; i++) {
        NSString *imageStr = nil;
        if (i >= 10) {
            imageStr = [NSString stringWithFormat: @"anim_%@_000%d",weakDic[GiftName],i];
        }else{
            imageStr = [NSString stringWithFormat: @"anim_%@_0000%d",weakDic[GiftName],i];
        }
        UIImage *image = [UIImage imageNamed: imageStr];
        [giftImages addObject:image];
    }
    
    flameAnimation.animationImages = giftImages;
    flameAnimation.animationRepeatCount = 0;
    // start animating
    [flameAnimation startAnimating];
    
    //路径
    if ([weakDic[GiftShowType] intValue] < 3) {
        CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.duration = 5;
        pathAnimation.repeatCount = 1;
        CGMutablePathRef curvedPath = CGPathCreateMutable();
        if([weakDic[GiftShowType] intValue] == 1){
            CGPathMoveToPoint(curvedPath, NULL, llx_screenWidth+point.x, point.y);
            CGPathAddQuadCurveToPoint(curvedPath, NULL, llx_screenWidth+point.x, point.y, -giftAnimViewWidth, point.y);
        }else{
            CGPathMoveToPoint(curvedPath, NULL, llx_screenWidth+point.x, llx_screenHeight);
            CGPathAddQuadCurveToPoint(curvedPath, NULL, llx_screenWidth+point.x, llx_screenHeight, -giftAnimViewWidth, 0);
        }
        pathAnimation.path = curvedPath;
        CGPathRelease(curvedPath);
        //    在指定路径后，指定动画的对象，（在此用UIImageView举例：）
        [self.layer addAnimation:pathAnimation
                          forKey:@"moveTheSquare"];
    }
    
    giftLable.attributedText = attributedStr;
    NSTimer * _giftTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f  target:self selector:@selector(timerFire:)userInfo:nil repeats:YES];
}

-(void)timerFire:(NSTimer*)timer {
    if (self.timerFireBlock) {
        self.timerFireBlock(timer);
    }
}
@end
