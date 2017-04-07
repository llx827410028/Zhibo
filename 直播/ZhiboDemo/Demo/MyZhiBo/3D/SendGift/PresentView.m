//
//  PresentView.m
//  presentAnimation
//
//  Created by 许博 on 16/7/14.
//  Copyright © 2016年 许博. All rights reserved.
//

#import "PresentView.h"
#import "ZhiboCommon.h"

@interface PresentView ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) void(^completeBlock)(BOOL finished,NSInteger finishCount); // 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在3秒内，还能继续累加

@property (weak, nonatomic) IBOutlet UILabel *o_giftName;
@property (weak, nonatomic) IBOutlet UIImageView *o_img_gift;
@property (weak, nonatomic) IBOutlet ShakeLabel *o_sendNum;
@property (weak, nonatomic) IBOutlet UIImageView *o_img_recive;
@property (retain, nonatomic) IBOutlet UILabel *o_huode;

@end

@implementation PresentView

-(void)awakeFromNib{
    [super awakeFromNib];
//    _o_huode.text = [ZhiboCommon getStringBykey:@"获得"];
}

// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(completeBlock)completed{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self shakeNumberLabel];
    }];
    self.completeBlock = completed;
}

- (void)shakeNumberLabel{
    _animCount ++;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
    [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:2];
    
    
    self.o_sendNum.text =  [NSString stringWithFormat:@"X%ld",(long)_animCount];
     [self.o_sendNum startAnimWithDuration:0.3];
}

- (void)hidePresendView
{
    [UIView animateWithDuration:0.30 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.completeBlock) {
            self.completeBlock(finished,_animCount);
        }
        [self reset];
        _finished = finished;
        [self removeFromSuperview];
    }];
}

// 重置
- (void)reset {
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.o_sendNum.text = @"";
}

- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        [self setUI];
    }
    return self;
}


#pragma mark 布局 UI
- (void)layoutSubviews {
    [super layoutSubviews];
    _bgImageView.frame = self.bounds;
    _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
    _bgImageView.layer.masksToBounds = YES;
}

#pragma mark 初始化 UI
- (void)setUI {
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.3;
    _animCount = 0;
    [self addSubview:_bgImageView];
}

- (void)setModel:(GiftModel *)model {
    _model = model;
    NSString *sendgiftstr = [ZhiboCommon getStringBykey:@"赠送"];
    NSString *strname = [NSString stringWithFormat:@"%@%@%@",model.name,sendgiftstr,model.giftName];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:strname];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, model.name.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(model.name.length+sendgiftstr.length, model.giftName.length)];
    
    _o_giftName.attributedText = attributedStr;
    _o_img_gift.image = model.giftImage;
    [ZhiboCommon downLoadImageWithURLString:model.recviceImgStr andBlock:^(UIImage *image) {
        _o_img_recive.image = image;
    }];
    _giftCount = model.giftCount;
}
@end
