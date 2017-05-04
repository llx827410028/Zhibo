//
//  NdGusetLoginView.m
//  Unity-iPhone
//
//  Created by ugamehome on 2017/2/9.
//
//

#import "NdGusetLoginView.h"
#import "UIView+ZUtils.h"
#import "KR_Common.h"
#import "PaymentRequests.h"

@interface NdGusetLoginView ()
@property (retain, nonatomic) IBOutlet UITextField *o_unameTf;
@property (retain, nonatomic) IBOutlet UIButton *o_btn_login;
@property (retain, nonatomic) IBOutlet UITextField *o_pswTf;
@end

@implementation NdGusetLoginView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    UIView *line1= [[UIView alloc]initWithFrame:CGRectMake(0, _o_unameTf.height-1, _o_unameTf.width, 0.5)];
    line1.backgroundColor = [UIColor whiteColor];
    [_o_unameTf addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _o_pswTf.height-1, _o_pswTf.width, 0.5)];
    line2.backgroundColor = [UIColor whiteColor];
     [_o_pswTf addSubview:line2];
    
    _o_btn_login.layer.cornerRadius = 5;
    _o_btn_login.layer.masksToBounds = YES;
    _o_btn_login.borderWidth = 1;
    _o_btn_login.borderColor = [VTTool  colorWithHexString:@"ff7300"];
}

#pragma mark -- 键盘通知 方法
// 监听键盘的frame即将改变的时候调用
- (void)keyboardWillChange:(NSNotification *)note{
    // 获得键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    if (CGRectGetMaxY(self.frame) > frame.origin.y) {
        self.y -= CGRectGetMaxY(self.frame) - frame.origin.y;
    }else if(frame.origin.y == llx_screenHeight){
        self.y  = (frame.origin.y -self.height)/2;
    }
    // 执行动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        // 如果有需要,重新排版
        [self layoutIfNeeded];
    }];
}

//赋值
- (void)resetValue{
    _o_unameTf.text = [KR_Common getUsername];
    _o_pswTf.text = [KR_Common getUserpsw];
}

- (void)gusetLogin{
    if (_o_unameTf.text.length<=0) {
        [VTTool mpProgressWithView:[VTTool appWindow] andString:[VTTool getPlistValueWithKey:@"用户名不能为空" andPlistName:@"Gamecenter"]];
        return;
    }
    if (_o_pswTf.text.length<=0) {
        [VTTool mpProgressWithView:[VTTool appWindow] andString:[VTTool getPlistValueWithKey:@"密码不能为空" andPlistName:@"Gamecenter"]];
        return;
    }
    [self requestLogin];
}


- (void)requestLogin{
    NSString *timestamp = [VTTool getTimeSp];
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    dic[@"username"] = _o_unameTf.text;
    dic[@"password"] = _o_pswTf.text;
    dic[@"gameid"] = Login_guset_gameid;
    dic[@"timestamp"] = timestamp;
    dic[@"appkey"] = [VTTool md5:[NSString stringWithFormat:@"%@%@%@",_o_unameTf.text,timestamp,Login_guset_secretkey]];//appkey = md5(name+timestamp+secretkey)
    __weak NdGusetLoginView *weakSelf = self;
    [[PaymentRequests shareInstance]postData:dic andisHud:YES andUrl:app_loginGuest_url andBackObjName:@"登陆游客模式登陆id" withSuccessBlock:^(NSDictionary *backid) {
        if ([backid[@"result"] intValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [weakSelf isHide:YES];
            });
            if (_o_block) {
                _o_block(backid[@"uid"]);
            }
        }
    } withFaildBlock:^(NSError *error) {
    }];
}


- (void)getGusetLoginAccount{
    if ([KR_Common getUserpsw].length>0 && [KR_Common getUsername]>0) {
         [self resetValue];
         [self isHide:NO];
    }else{
        NSString *timestamp = [VTTool getTimeSp];
        NSMutableDictionary * dic =[NSMutableDictionary dictionary];
        dic[@"gameid"] = Login_guset_gameid;
        dic[@"mcode"] = [VTTool getUUID];
        dic[@"timestamp"] = timestamp;
        dic[@"appkey"] = [VTTool md5:[NSString stringWithFormat:@"%@%@%@",Login_guset_gameid,timestamp,Login_guset_secretkey]];//appkey = md5(gameid+timestamp+secretkey)
        __weak NdGusetLoginView *weakSelf = self;
        [[PaymentRequests shareInstance]postData:dic andisHud:YES andUrl:app_getLoginGuest_url andBackObjName:@"获取游客模式登陆id" withSuccessBlock:^(NSDictionary *backid) {
            if ([backid[@"result"] intValue] == 0) {
                [KR_Common setUsername:backid[@"uname"]];
                [KR_Common setUserpsw:backid[@"psw"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf isHide:NO];
                    [self resetValue];
                });
            }
        } withFaildBlock:^(NSError *error) {
        }];
    }
}


- (IBAction)guesetLogin:(id)sender {
    [self requestLogin];
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
