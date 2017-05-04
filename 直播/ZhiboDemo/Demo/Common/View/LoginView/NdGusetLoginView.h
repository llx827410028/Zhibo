//
//  NdGusetLoginView.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/2/9.
//
//

#import <UIKit/UIKit.h>

typedef void(^LoginRusultBlock)(NSString *);//1.uid
@interface NdGusetLoginView : UIView
@property (nonatomic,copy) LoginRusultBlock o_block;
//获取游客账号
- (void)getGusetLoginAccount;
@property (strong, nonatomic) UIView *o_bgView;
- (void)isHide:(BOOL)isHide;
@end
