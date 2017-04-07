//
//  ZhiBoBottomToolView.m
//  Demo
//
//  Created by ugamehome on 2016/10/21.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#define VIEW_Height  50
#import "ZhiBoVC.h"
#import "ZhiBoBottomToolView.h"
@interface ZhiBoBottomToolView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *o_btn_dm;
@property (weak, nonatomic) IBOutlet UITextField *o_tf;
@property (strong,nonatomic)NSString *o_danmu;
@end

@implementation ZhiBoBottomToolView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView{
    _o_tf.delegate = self;
    _o_tf.returnKeyType = UIReturnKeySend;
    _o_tf.layer.cornerRadius = 5;
    _o_tf.layer.masksToBounds = YES;
    _o_tf.placeholder = [NSString stringWithFormat:@"%@......",[ZhiboCommon getStringBykey:@"请在此输入弹幕"]];
    
    UIButton *pmbnt = [self viewWithTag:BottomType_RankView+BTN_TAG];
    UIButton *fjbnt = [self viewWithTag:BottomType_ListView+BTN_TAG];
    pmbnt.titleLabel.adjustsFontSizeToFitWidth = YES;
    fjbnt.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [fjbnt setTitle:[ZhiboCommon getStringBykey:@"房间列表"] forState:UIControlStateNormal];
    [pmbnt setTitle:[ZhiboCommon getStringBykey:@"主播排名"] forState:UIControlStateNormal];
}

- (void)hideKeyBoard{
    [_o_tf resignFirstResponder];
}


- (void)showTfbeginBnt{
    //这个bnt 主要是用来触发  uitextfield  因为 在5s屏幕上 不好触发
    UIButton *bnt = [self viewWithTag:BottomType_TfBegin+BTN_TAG];
    bnt.hidden = NO;
}

- (IBAction)clickZhiboRank:(id)sender {
    UIButton *bnt = (UIButton *)sender;
    
    if ((bnt.tag-BTN_TAG) == BottomType_TfBegin) {
        UIButton *bnt = [self viewWithTag:BottomType_TfBegin+BTN_TAG];
        bnt.hidden = YES;
        [_o_tf becomeFirstResponder];
        return;
    }
    
    if ((bnt.tag-BTN_TAG) == BottomType_DmStatus) {
        _o_btn_dm.selected = !_o_btn_dm.selected;
    }
    if (_showBottomBntBlock) {
        _showBottomBntBlock((int)(bnt.tag-BTN_TAG),_o_btn_dm.selected);
    }
}


- ( BOOL )textFieldShouldReturn:( UITextField *)textField {
     [_o_tf resignFirstResponder];
    _o_danmu = _o_tf.text;
    [self sendDanmu];
     return YES;
}


/**
 *   点赞
 */
- (void)sendDanmu{
    if (_o_danmu.length <= 0) {
        [ZhiboCommon mpProgressWithView:_o_zhiBoVC.view andString:[ZhiboCommon getStringBykey:@"请输入弹幕"]];
        return;
    }
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"playerid":[ZhiboCommon getPlayId],
                           @"serverid":[ZhiboCommon getServerId],
                           @"timestamp":timestamp,
                           @"anchorUid":[ZhiboCommon getAnchoruid],
                           @"playername":[ZhiboCommon getPlayName],
                           @"viplevel":[ZhiboCommon getLevel],//等级
                           @"danmaku":_o_danmu?:@"",
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@%@",[ZhiboCommon getPlayId],[ZhiboCommon getAnchoruid],timestamp,[ZhiboCommon getSecret_key]]],
                           };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_o_zhiBoVC.view animated:YES];
    @WeakObj(hud);
    @WeakObj(_o_zhiBoVC);
    
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/sendDanmaku.php" andBackObjName:@"sendDanmaku" withSuccessBlock:^(id backId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
            if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
            }else{
                if (backId[@"msg"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:backId[@"msg"]];
                    });
                }
                return;
            }
            
            
            [ZhiboCommon setDiamondnum:backId[@"diamondnum"]];
            [ZhiboCommon setGoldnum:backId[@"goldnum"]];
            
            [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:[ZhiboCommon getStringBykey:@"弹幕发送成功"]];
            if (_o_noticeDanmuBlock) {
                _o_noticeDanmuBlock(_o_danmu);
                _o_danmu = @"";
            }
        });
    } withFaildBlock:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
             [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:[ZhiboCommon getStringBykey:@"弹幕发送失败"]];
        });
    }];
}


@end
