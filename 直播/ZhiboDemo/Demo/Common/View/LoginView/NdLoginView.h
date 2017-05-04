//
//  NdLoginView.h
//  Unity-iPhone
//
//  Created by ugamehome on 2017/2/7.
//
//

#import <UIKit/UIKit.h>
typedef void(^LoginSuccessBlock)(NSString *uid,NSString *token);
@interface NdLoginView : UIView
@property (nonatomic,copy) LoginSuccessBlock o_loginSuccessblock;
- (void)loginByUserdefault;
- (BOOL)isLogin;//当服务器连接不上 重新连接的时候
- (void)hideLoginView;
@end
