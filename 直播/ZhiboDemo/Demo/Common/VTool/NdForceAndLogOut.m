//
//  NdForceAndLogOut.m
//  Unity-iPhone
//
//  Created by ugamehome on 2017/3/20.
//
//

#import "NdForceAndLogOut.h"
#import "PaymentRequests.h"
#import <objc/message.h>
#define loginOut_tag 2000

#define update_tag 100
#define update_force_tag 101

@interface NdForceAndLogOut ()
@property(nonatomic,strong)   NSString* o_apkurl;

@end

@implementation NdForceAndLogOut
+(instancetype)shareInstance
{
    static NdForceAndLogOut * object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[NdForceAndLogOut alloc] init];
    });
    return object;
}


- (void)loginOut{
    NSDictionary *dic = [VTTool getPlistDicValueWithKey:@"Gamecenter"];
    if (!dic) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:dic[@"退出"]
                                                    message:dic[@"退出游戏?"]
                                                   delegate:self
                                          cancelButtonTitle:dic[@"取消"]
                                          otherButtonTitles:dic[@"确定"],nil];
    alert.tag = loginOut_tag;
    [alert show];
}


#pragma mark -- 强制更新
- (void)getForce{
    NSString *buildVersion = [VTTool appMinorVersion];
    NSLog(@"buildVersion---》%@",[buildVersion substringWithRange:NSMakeRange(buildVersion.length-3,3)]);
    int versioncode = [[buildVersion substringWithRange:NSMakeRange(buildVersion.length-3,3)] intValue];
    //product   0 为测试  1为正式
    NSString *requesttring = [NSString stringWithFormat:@"packagename=%@&channelid=%@&platform=iphone&versioncode=%d&product=%@",[VTTool getBundleID],app_channelid,versioncode,@"1"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@plugin/getUpdate.php?%@",app_header_url,requesttring];
    __weak NdForceAndLogOut *weakSelf = self;
    [[PaymentRequests shareInstance]getData:nil andisHud:NO andUrl:requestUrl andBackObjName:@"获取强更数据" withSuccessBlock:^(NSDictionary *backDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [weakSelf showAlertWithDic:backDic];
        });
    } withFaildBlock:^(NSError *error) {
        
    }];
}

- (void)showAlertWithDic:(NSDictionary *)dic{
    self.o_apkurl = dic[@"apkurl"];
    NSDictionary *gameDic = [VTTool getPlistDicValueWithKey:@"Gamecenter"];
    if (!dic) {
        return;
    }
    if ([dic[@"result"] intValue] == 0) {
        //为1  必须抢更
        if ([dic[@"isforce"] intValue]) {
            UIAlertView *alert = [[UIAlertView alloc]init];
            objc_setAssociatedObject(alert, "force", dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            alert.title = gameDic[@"更新"];
            alert.tag = update_force_tag;
            alert.delegate = self;
            alert.message = dic[@"updateword"];
            [alert addButtonWithTitle:gameDic[@"确定"]];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:gameDic[@"更新"]
                                                            message:dic[@"updateword"]
                                                           delegate:self
                                                  cancelButtonTitle:gameDic[@"取消"]
                                                  otherButtonTitles:gameDic[@"确定"],nil];
            objc_setAssociatedObject(alert, "force", dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            alert.tag = update_tag;
            [alert show];
        }
    }else{
        if (_o_loginSdk) {
            _o_loginSdk();
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == update_tag) {
        if (_o_loginSdk) {
            _o_loginSdk();
        }
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.o_apkurl]];
        }
    }else if(alertView.tag == loginOut_tag){
        if (buttonIndex == 1) {
            if (_o_block) {
                _o_block();
            }
        }
    }else if(alertView.tag == update_force_tag){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.o_apkurl]];
        [self  showAlertWithDic:objc_getAssociatedObject(alertView, "force")];
    }
}

@end
