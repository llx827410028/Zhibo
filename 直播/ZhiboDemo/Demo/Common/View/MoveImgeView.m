//
//  MoveImgeView.m
//  Nav+Tab
//
//  Created by ugamehome on 2017/3/20.
//  Copyright © 2017年 ugamehome. All rights reserved.
//

#import "MoveImgeView.h"
@interface MoveImgeView()
@property (nonatomic)BOOL isSelect;
@property(nonatomic,strong) NSString *o_nStr;
@property (nonatomic,strong)NSString *o_sStr;
@end
@implementation MoveImgeView
- (id)initWithFrame:(CGRect)frame withNomalImageStr:(NSString *)nImageStr andSelectImageStr:(NSString *)selectImageStr{
   self = [super  initWithFrame:frame];
    if (self)
    {
        _o_nStr = nImageStr;
        _o_sStr = selectImageStr;
        [self setImage:[UIImage imageNamed:nImageStr]];
        _isSelect = NO;
        self.userInteractionEnabled = YES;
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.beginpoint = [touch locationInView:self];
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - self.beginpoint.x;
    float dy = point.y - self.beginpoint.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    float halfx = CGRectGetMidX(self.bounds);
    if(dx<0)
    {
        newcenter.x=MAX(halfx,newcenter.x);
    }
    else
    {
        newcenter.x=MIN(self.superview.bounds.size.width-halfx,newcenter.x);
    }
    float halfy=CGRectGetMidY(self.bounds);
    if(dy<0)
    {
        newcenter.y=MAX(newcenter.y,halfy);
    }
    else
    {
        newcenter.y=MIN(newcenter.y,self.superview.bounds.size.height-halfy);
    }
    self.center=newcenter;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(touch.tapCount == 1) {
        NSLog(@"点击1");
        _isSelect = !_isSelect;
        [self setImage:[UIImage imageNamed:_isSelect?_o_sStr:_o_nStr]];
        if (_o_block) {
            _o_block(_isSelect);
        }
    }
    if(touch.tapCount == 2) {
        NSLog(@"点击2");
    }
}
@end
