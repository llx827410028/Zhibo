//
//  AnimOperation.m
//  presentAnimation
//
//  Created by 许博 on 16/7/15.
//  Copyright © 2016年 许博. All rights reserved.
//

#import "AnimOperation.h"
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface AnimOperation ()
@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);
@end


@implementation AnimOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)animOperationWithUserID:(NSString *)userID model:(GiftModel *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock; {
    AnimOperation *op = [[AnimOperation alloc] init];
    op.presentView = [VTTool loadViewFromNib:@"PresentView" owner:nil atIndex:0];
    op.giftAnimView = [[GiftAnimView alloc]init];
    op.model = model;
    op.finishedBlock = finishedBlock;
    return op;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

- (void)start {
    // 添加到队列时调用
//    if (如果半天没消息或者取消了操作) { 
//        return
//    }
//    self.executing = YES;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        执行动画；
//        } completion:^(BOOL finished) {
//            self.finished = YES;
//            self.executing = NO;
//        }];
//    }];
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        
        _presentView.model = _model;
        if (_model.o_dic) {
            __weak UIView *weakAnimView = _giftAnimView;
            [_giftAnimView sendAnimGiftWithSendName:_model.name andInfoDic:_model.o_dic andTimerFireBlock:^(NSTimer *timer) {
                [timer invalidate];
                timer = nil;
                UIImageView *imageView = (UIImageView*)[weakAnimView viewWithTag:3001];
                [imageView stopAnimating];
                [weakAnimView removeFromSuperview];
            } ];
        }

        NSString *strname = [NSString stringWithFormat:@"%@%@%@%@",_model.name,[ZhiboCommon getStringBykey:@"赠送"],_model.giftName,[ZhiboCommon getStringBykey:@"获得"]];
        CGFloat maxWidth =  [VTTool estimateTextWidthByContent:strname textFont:[UIFont systemFontOfSize:14]];
        _presentView.frame = CGRectMake(_presentView.frame.origin.x, _presentView.frame.origin.y, maxWidth+270, _presentView.frame.size.height);
        _presentView.originFrame = _presentView.frame;
        
        [self.listView addSubview:_presentView];
        if (_model.o_dic) {
            [self.listView addSubview:_giftAnimView];
        }
        
        [self.presentView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];

    }];
    
}

- (CGFloat )calculateTextHeightWithName:(NSString *)name andGiftName:(NSString *)giftName{
    CGFloat nameWidth = [self estimateTextWidthByContent:name textFont:[UIFont systemFontOfSize:12]];
    CGFloat giftNameWidth = [self estimateTextWidthByContent:giftName textFont:[UIFont systemFontOfSize:12]];
    CGFloat maxWidth = 0;
    if (giftNameWidth > nameWidth) {
        maxWidth = giftNameWidth;
    }else{
        maxWidth = maxWidth;
    }
    return maxWidth;
}

- (CGFloat )estimateTextWidthByContent:(NSString *)content textFont:(UIFont *)font
{
    
    if ( nil == content || 0 == content.length )
        return 0.0f;
    
    CGSize theSize = CGSizeZero;
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        theSize = rect.size;
    }else{
        theSize = [content sizeWithFont:font];
    }
    
    return ceil(theSize.width);
}


#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
