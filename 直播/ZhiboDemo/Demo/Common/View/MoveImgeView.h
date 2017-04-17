//
//  MoveImgeView.h
//  Nav+Tab
//
//  Created by ugamehome on 2017/3/20.
//  Copyright © 2017年 ugamehome. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReplayIos)(BOOL);
@interface MoveImgeView : UIImageView
- (id)initWithFrame:(CGRect)frame withNomalImageStr:(NSString *)nImageStr andSelectImageStr:(NSString *)select;
@property (nonatomic,copy) ReplayIos o_block;
@property (assign, nonatomic) CGPoint beginpoint;
@end
