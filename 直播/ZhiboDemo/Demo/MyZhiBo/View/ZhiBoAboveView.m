//
//  ZhiBoAboveView.m
//  Demo
//
//  Created by ugamehome on 2016/10/22.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoAboveView.h"
#import "ZhiBoVC.h"
@interface ZhiBoAboveView ()
@property (weak, nonatomic) IBOutlet UILabel *o_name;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_zan;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_attention;

@end

@implementation ZhiBoAboveView

-(void)setTitle:(NSString *)title{
    _title = title;
    _o_name.text = _title;
}


/**
 *   点赞
 */
- (void)getZanData{
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"playerid":[ZhiboCommon getPlayId],
                           @"serverid":[ZhiboCommon getServerId],
                           @"timestamp":timestamp,
                           @"anchorUid":[ZhiboCommon getAnchoruid],
                           @"playername":[ZhiboCommon getPlayName],
                           @"viplevel":[ZhiboCommon getLevel],//等级
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@%@",[ZhiboCommon getPlayId],[ZhiboCommon getAnchoruid],timestamp,[ZhiboCommon getSecret_key]]],
                           };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_o_zhiBoVC.view animated:YES];
    
    @WeakObj(hud);
    @WeakObj(_o_btn_zan);
    @WeakObj(_o_zhiBoVC);
    
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/up.php" andBackObjName:@"/up" withSuccessBlock:^(id backId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
            if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
            }else{
                if (backId[@"msg"]) {
                    [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:backId[@"msg"]];
                }
                return;
            }
            if ([backId[@"result"]intValue] == 0 || [backId[@"result"]intValue] == 5) {
                [_o_btn_zanWeak setSelected:!_o_btn_zanWeak.selected];
                [ZhiboCommon setDiamondnum:backId[@"diamondnum"]];
                [ZhiboCommon setGoldnum:backId[@"goldnum"]];
            }
        });
    } withFaildBlock:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
            [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString: [ZhiboCommon getStringBykey:@"点赞失败"]];
        });
    }];
}


/**
 *   关注
 */
- (void)getAttentionData{
    NSString *timestamp = [VTTool getTimeSp];
    NSString *action = @"1";
    if (_o_btn_attention.selected) {
        action = @"2";
    }
    NSDictionary *dic =  @{
                           @"playerid":[ZhiboCommon getPlayId],
                           @"serverid":[ZhiboCommon getServerId],
                           @"timestamp":timestamp,
                           @"anchorUid":[ZhiboCommon getAnchoruid],
                           @"action":action,
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@%@",[ZhiboCommon getPlayId],[ZhiboCommon getAnchoruid],timestamp,[ZhiboCommon getSecret_key]]],
                           };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_o_zhiBoVC.view animated:YES];
   
    
    @WeakObj(hud);
    @WeakObj(_o_btn_attention);
    @WeakObj(_o_zhiBoVC);

    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/attentionArchor.php" andBackObjName:@"attentionArchor" withSuccessBlock:^(id backId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
            if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
            }else{
                if (backId[@"msg"]) {
                    [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:backId[@"msg"]];
                }
                return;
            }
            
            NSString *msg = [ZhiboCommon getStringBykey:@"关注成功"];
            if (_o_btn_attentionWeak.selected) {
                msg = [ZhiboCommon getStringBykey:@"取消关注"];
            }
            _o_btn_attentionWeak.selected =!_o_btn_attentionWeak.selected;
            [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:msg];
        });
    } withFaildBlock:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
            [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:[ZhiboCommon getStringBykey:@"关注失败"]];
        });
    }];
}

- (IBAction)click:(id)sender {
    UIButton *bnt = (UIButton *)sender;
    if ((bnt.tag - BTN_TAG) == 2) {
        [self getZanData];
    }else if((bnt.tag - BTN_TAG) == 3){
         [self getAttentionData];
    }else{
        if (_o_clickAboveBtnBlock) {
            _o_clickAboveBtnBlock((int)(bnt .tag - BTN_TAG));
        }
    }
}

@end
