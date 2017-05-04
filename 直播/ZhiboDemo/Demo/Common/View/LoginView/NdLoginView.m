//
//  NdLoginView.m
//  Unity-iPhone
//
//  Created by ugamehome on 2017/2/7.
//
//

#import "NdLoginView.h"
#import "UIView+ZUtils.h"
#import "KR_Common.h"
#import "NdGusetLoginView.h"
#import "NdGameCenter.h"
#import "NdFaceBook.h"
#import "NdAppsflyer.h"
#import "NdFaceBook.h"
#import "PaymentRequests.h"
typedef enum {
    NdLoginType_GC,
    NdLoginType_FB,
    NdLoginType_GU,
}NdLoginType;
@interface NdLoginView()
@property (nonatomic,strong)UIView *o_bgView;
@property (nonatomic)BOOL isShowLoginView;
@property (nonatomic)BOOL o_isClickOnGCbnt;//是否点击了 game center 登录按钮
@property (nonatomic,strong)NdGusetLoginView *o_gusetLv;
@property (nonatomic)BOOL isAddToWindow;
@end

#define btn_tag 200
@implementation NdLoginView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        _isAddToWindow = NO;
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    CGFloat width = [KR_Common getWidthByWith5sWidth:240];
    CGFloat height  = [KR_Common getheightByWith5sHeight:54];
    CGFloat x = (llx_screenWidth-2*width)/3;
    CGFloat y = llx_screenHeight - height - 10;//最底下的按钮

    UIButton *gcBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [gcBnt setBackgroundImage:[UIImage imageNamed:@"Login-Button_Game-Center"] forState:UIControlStateNormal];
    gcBnt.tag = btn_tag;
    gcBnt.frame = CGRectMake(x, y, width, height);
    [gcBnt
     addTarget:self
     action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    x = width+2*x;
    UIButton *guBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [guBnt setBackgroundImage:[UIImage imageNamed:@"Login-Button_Guest-Login"] forState:UIControlStateNormal];
    guBnt.tag = btn_tag+2;
    guBnt.frame = CGRectMake(x, y, width, height);
    [guBnt
     addTarget:self
     action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    y = y-height - 15;
    UIButton *fbBnt=[UIButton buttonWithType:UIButtonTypeCustom];
    fbBnt.backgroundColor=[UIColor blueColor];
    fbBnt.frame = CGRectMake(x, y, width, height);
    fbBnt.tag = btn_tag+1;
    [fbBnt setTitle: @"FaceBook" forState: UIControlStateNormal];
    // Handle clicks on the button
    [fbBnt
     addTarget:self
     action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    

//    [self addSubview:fbBnt];
    [self addSubview:guBnt];
    [self addSubview:gcBnt];
}

- (void)loginAction:(UIButton *)sender{
    switch (sender.tag - btn_tag) {
        case NdLoginType_FB:
            [self loginForFB];
            break;
        case NdLoginType_GC:
            [self loginForGameCenter];
            break;
        case NdLoginType_GU:
            [self loginForGuest];
            break;
        default:
            break;
    }
}

#pragma mark - setupUI

- (void)setUpBgView{
    if (!_o_bgView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, llx_screenWidth,  llx_screenHeight)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        UIImageView  *bgView = [[UIImageView alloc]initWithFrame:CGRectMake((view.width-300)/2, 0, 300, 145)];
        [bgView setImage:[UIImage imageNamed:@"icon_login"]];
        [view addSubview: bgView];
        _o_bgView = view;
        [[VTTool appWindow] addSubview:_o_bgView];
    }else{
        [[VTTool appWindow]bringSubviewToFront:_o_bgView];
    }
}


- (BOOL)isLogin{
    //当服务器连接不上 重新连接的时候
    if ([KR_Common getLoginType]) {
        if ([[KR_Common getLoginType] isEqualToString:app_loginType_fb]) {
            if ([[NdGameCenter shareInstance]getLocalPlayerId]) {
                if (_o_loginSuccessblock) {
                    _o_loginSuccessblock([[NdGameCenter shareInstance]getLocalPlayerId] ,@"");
                     [NdAppsflyer recordLoginByGcWithId:[[NdGameCenter shareInstance]getLocalPlayerId]];
                      [NdFaceBook recordLoginByGcWithGameId:[[NdGameCenter shareInstance]getLocalPlayerId]];
                }
                return YES;
            }
        }else{
            if ([[NdFaceBook shareInstance]loginBycace]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)loginByUserdefault{
    // 之前有登录过
    if ([KR_Common getLoginType].length>0) {
        NSInteger loginTime = [[KR_Common getLoginDate]integerValue];
        NSInteger nowTime = [[VTTool getTimeSp]integerValue];
        
        if (nowTime - loginTime > 432000) {
            [KR_Common setLoginTime:@""];
            [KR_Common setLoginType:@""];
            [self showLoginView];
        }else{
            //自动登录
            if ([[KR_Common getLoginType] isEqualToString:app_loginType_fb]) {
                [self loginForFB];
            }else{
                [self loginForGameCenter];
            }
        }
    }else{
        [self showLoginView];
    }
}



#pragma mark --> 游客方式登录
- (void)loginForGuest{
    [self setUpBgView];
    //提前 创建视图
    if (!_o_gusetLv) {
        NdGusetLoginView *glv = [VTTool loadViewFromNib:@"NdGusetLoginView" owner:nil atIndex:0];
        glv.o_bgView = _o_bgView;
        glv.frame = [VTTool appWindow].frame;
        _o_gusetLv = glv;
        _o_gusetLv.o_block = ^(NSString *uid){
            if (_o_loginSuccessblock) {
                _o_loginSuccessblock(uid,@"");
            }
        };
        [[VTTool appWindow]addSubview:_o_gusetLv];
    }
    [_o_gusetLv getGusetLoginAccount];
}


#pragma mark --> gameCenter 登录
- (void)loginForGameCenter{
    if(_o_isClickOnGCbnt){
        [VTTool mpProgressWithView: [VTTool appWindow] andString:[VTTool getPlistValueWithKey:@"想要再次登录Game Center" andPlistName:@"Gamecenter"]];
        return;
    }
    _o_isClickOnGCbnt = YES;
    [MBProgressHUD showHUDAddedTo:[VTTool appWindow] animated:YES];
    if ([[NdGameCenter shareInstance]isGameCenterAvailable]) {
        [[NdGameCenter shareInstance]initsdk];
    }
    __weak NdLoginView *weakSelf = self;
    [NdGameCenter shareInstance].o_block = ^(NSString *userId,NSString *token){
        if ([KR_Common getLoginType].length<=0) {
            [KR_Common setLoginTime:[VTTool getTimeSp]];
            [KR_Common setLoginType:app_loginType_gc];
        }
        [NdAppsflyer recordLoginByGcWithId:userId];
        [NdFaceBook recordLoginByGcWithGameId:userId];
        if (_o_loginSuccessblock) {
            _o_loginSuccessblock(userId,token);
        }
    };
    
    [NdGameCenter shareInstance].o_hideLoginViewBlock = ^(BOOL isHide){
        if (isHide) {
        }else{
            [weakSelf showLoginView];
        }
    };
}


#pragma mark --> fb登录
- (void)loginForFB{
    if (![NdFaceBook shareInstance].loginBlock) {
        __weak NdLoginView *weakself = self;
        [NdFaceBook shareInstance].loginBlock = ^(NSString *userid,NSString *name,NSString *email,NdFaceBookLoginType type){
            if (type == NdFaceBookLoginType_Susses) {
                if ([KR_Common getLoginType].length<=0) {
                    [KR_Common setLoginTime:[VTTool getTimeSp]];
                    [KR_Common setLoginType:app_loginType_fb];
                }
                [NdAppsflyer recordLoginByFBWithId:userid andWithFBName:name];
                [NdFaceBook recordLoginByFbWithGameId:userid andEmail:name andTEL:email];
                [weakself getfbIdByMyServeWithSid:userid anName:name andEmail:email];
            }
        };
    }
    
    [[NdFaceBook shareInstance]login];
}


- (void)getfbIdByMyServeWithSid:(NSString *)sid anName:(NSString *)name andEmail:(NSString *)email{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *timestamp = [VTTool getTimeSp];
    params[@"fbid"] = sid?:@"";
    params[@"fbname"] = name?:@"";
    params[@"fbemail"] = email?:@"";
    params[@"gameid"] = timestamp;
    params[@"timestamp"] = timestamp;
    params[@"appkey"] = [VTTool md5:[NSString stringWithFormat:@"%@%@%@",sid,timestamp,Login_guset_secretkey]];//appkey = md5(name+timestamp+secretkey)
    [[PaymentRequests shareInstance]postData:params andisHud:YES andUrl:[NSString stringWithFormat:@"%@ugame/login/login_fb",app_header_url] andBackObjName:@"向服务器请求fb数据" withSuccessBlock:^(NSDictionary *backId) {
        if (backId[@"uid"]) {
            if (_o_loginSuccessblock) {
                _o_loginSuccessblock(backId[@"uid"],backId[@"uid"]);
            }
        }
    } withFaildBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 界面 显示 与隐藏
- (void)hideLoginView{
    if (!_isShowLoginView) {
        return;
    }
    _isShowLoginView = NO;
    [self isHide:YES];
}

- (void)showLoginView{
    _isShowLoginView = YES;
    [self setUpBgView];
    if (!_isAddToWindow) {
         [[VTTool appWindow]addSubview:self];
    }else{
        [self isHide:NO];
    }
}

- (void)isHide:(BOOL)isHide{
    if (isHide) {
        [[VTTool appWindow]sendSubviewToBack:_o_bgView];
        [[VTTool appWindow]sendSubviewToBack:self];
    }else{
        [[VTTool appWindow]bringSubviewToFront:_o_bgView];
        [[VTTool appWindow]bringSubviewToFront:self];
    }
}
@end
