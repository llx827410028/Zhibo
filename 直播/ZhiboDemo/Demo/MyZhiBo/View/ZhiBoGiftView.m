//
//  ZhiBoGiftView.m
//  Demo
//
//  Created by ugamehome on 2016/10/26.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoGiftView.h"
#import "ZhiBoVC.h"
#import "UIView+ZUtils.h"

@interface ZhiBoGiftView ()
@property (weak, nonatomic) IBOutlet UILabel *o_goldNum;
@property (weak, nonatomic) IBOutlet UILabel *o_diamondNum;
@property (retain, nonatomic) IBOutlet UIView *o_fdfd;

@property (weak, nonatomic) IBOutlet UILabel *o_giftNum;
@property (weak, nonatomic) IBOutlet UILabel *o_sendNum;
@property (weak, nonatomic) IBOutlet UIButton *o_btn_send;
@property (weak, nonatomic) IBOutlet UIScrollView *o_scro_gift;
@property (nonatomic,strong)NSMutableArray *o_data;
@property (weak, nonatomic) IBOutlet UILabel *o_showSelectText;
@property (weak, nonatomic) IBOutlet UIImageView *o_img_select;
@property (nonatomic)long secletIndex;
@property (nonatomic,strong)NSMutableDictionary *o_dic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *o_layout_image_height;
@property (strong,nonatomic)UILabel *o_label;
@property (nonatomic)BOOL isfirst;
@end

//界面大小  300 * 375   bili  0.66   liwu  75  104
@implementation ZhiBoGiftView


-(void)awakeFromNib{
    [super awakeFromNib];
    _o_data = [[NSMutableArray alloc]init];
    _o_sendNum.text = [ZhiboCommon getStringBykey:@"赠送数量:"];
    [_o_btn_send setTitle:[ZhiboCommon getStringBykey:@"发送"] forState:UIControlStateNormal];
    
    
    if (llx_screenHeight<375) {
        float  selfheight = llx_screenHeight * 0.66;
        //图片 大小
        CGFloat giftwidth = selfheight/3;
        CGFloat giftHeight = giftwidth/0.72;
        _o_layout_image_height.constant = llx_screenHeight - 95 - giftHeight;
    }
    [self initgoldandkc];
}

- (void)initgoldandkc{
    _o_diamondNum.text = [[ZhiboCommon getDiamondnum] intValue]?[ZhiboCommon ComputemoneyWithMoney:[[ZhiboCommon getDiamondnum] intValue]]:@"0";
     _o_goldNum.text = [[ZhiboCommon getGoldnum] intValue]?[ZhiboCommon ComputemoneyWithMoney:[[ZhiboCommon getGoldnum] intValue]]:@"0";
}

- (void)setupScroll{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        int x = 0;
        int y = 0;
        CGFloat giftwidth = 0;
        CGFloat giftHeight = 0;
        if (IS_IPAD) {
            y = 18;
            giftwidth = 75;
            giftHeight = 104;
        }else{
            float  selfheight = llx_screenHeight * 0.66;
            //图片 大小
            giftwidth = selfheight/3;
            giftHeight = giftwidth/0.72;
        }
        int viewHeight = 0;
        _secletIndex = _o_data.count  + 100;
        [self setupSelectViewWithIsaddnum:NO];
        _o_dic = [[NSMutableDictionary alloc]init];
        for(int i = 0 ;i< [_o_data count];i++ ){
            ZhiboModel_getGiftList *gift = [_o_data objectAtIndex:i];
            ZhiBoGiftItemView *view = [VTTool loadViewFromNib:@"ZhiBoGiftView" owner:nil atIndex:1];
            [_o_dic setObject:gift forKey:FORMAT(@"%d",gift.id)];
            if (i == [_o_data count]-1) {
                view.o_img_select.hidden = NO;
            }
            view.size = CGSizeMake(giftwidth, giftHeight);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                 [view fillViewWithHeadImgUrl:gift.icon andName:gift.name andMoney:gift.price andPaytype:gift.paytype andImgTag:gift.id];
            });
           
            view.tag = gift.id;
            
            UITapGestureRecognizer* singleRecognizer;
            singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
            singleRecognizer.numberOfTapsRequired = 1; // 单击
            [view addGestureRecognizer:singleRecognizer];
            
            
            view.x = x;
            view.y = y;
            if (IS_IPAD) {
                x += view.width+15;
            }else{
                 x += view.width*2;
                if(x >= self.heightOrWidthScale){
                    x = 0;
                    viewHeight = view.height;
                    y +=  view.height;
                }else{
                    x -= view.width;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [_o_scro_gift addSubview:view];
            });
            
        }
        
        long scollviewWidth = 0;
        int scollviewHeight = 0;
        
        if (IS_IPAD) {
            scollviewWidth = [_o_data count]*giftwidth;
            scollviewHeight = viewHeight;
        }else{
            scollviewWidth = self.heightOrWidthScale;
            scollviewHeight = y+viewHeight;
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [_o_scro_gift setContentSize:CGSizeMake(scollviewWidth, scollviewHeight)];
        });
    });
}

//获取已经加载好的图片
- (UIImage*)getGiftImageWithTag:(int)imageTag{
    ZhiBoGiftItemView *view = [_o_scro_gift viewWithTag:imageTag];
    return view.o_img_head.image;
}
//获取礼物其他信息
- (ZhiboModel_getGiftList*)getGiftListWithTag:(int)Tag{
    return [_o_dic objectForKey:FORMAT(@"%d",Tag)];
}

- (void)ShowOrHide{
    self.isHide = !self.isHide;
    if (self.isHide) {
        [UIView animateWithDuration:0.3 animations:^{
            if (IS_IPAD) {
                self.y = llx_screenHeight;
                self.height = self.heightOrWidthScale;
            }else{
                self.width = self.heightOrWidthScale;
                self.x = llx_screenWidth;
            }
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            if (IS_IPAD) {
                self.y = llx_screenHeight - self.heightOrWidthScale;
                self.height = self.heightOrWidthScale;
            }else{
                self.width = self.heightOrWidthScale;
                self.x = llx_screenWidth - self.heightOrWidthScale;
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (IBAction)addNum:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag - 200) {
        case 1:
        {

        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {
            int num = [_o_giftNum.text intValue];
            if (num == 20) {
                [ZhiboCommon mpProgressWithView:_o_zhiBoVC.view andString:[ZhiboCommon getStringBykey:@"数量不能超过20"]];
            }else{
                num += 1;
                _o_giftNum.text = [NSString stringWithFormat:@"%d",num];
                [self setupSelectViewWithIsaddnum:YES];
            }
            
        }
            break;
        case 4:{
            if (_secletIndex >= 100) {
                [self sendGift];
            }
        }
            break;
        case 5:{
            int num = [_o_giftNum.text intValue];
            if (num == 1) {
                [ZhiboCommon mpProgressWithView:_o_zhiBoVC.view andString:[ZhiboCommon getStringBykey:@"数量不能少于1"]];
            }else{
                num -= 1;
                _o_giftNum.text = [NSString stringWithFormat:@"%d",num];
                [self setupSelectViewWithIsaddnum:YES];
            }
        }
            break;
        default:
            break;
    }
}



- (void)setupSelectViewWithIsaddnum:(BOOL)isAddbum{
    if (_secletIndex <= 100) {
        return;
    }
    ZhiboModel_getGiftList *gift = [_o_data objectAtIndex:_secletIndex-101];
    if (!isAddbum) {
        _o_giftNum.text = @"1";
        [ZhiboCommon downLoadImageWithURLString:gift.iconItem andBlock:^(UIImage *image) {
            _o_img_select.image = image;
        }];
//         [_o_img_select sd_setImageWithURL:[NSURL URLWithString:gift.iconItem]];
    }
    //礼物购买数量重置
    NSString *buystr = [ZhiboCommon getStringBykey:@"购买"];
    NSString *sendstr = [ZhiboCommon getStringBykey:@"可送"];
    NSString *day = nil;
    
    NSString *time = nil;
    if (gift.timeItem <= 86400) {
         day =  [ZhiboCommon getStringBykey:@"小时"];
        long timedouble = gift.timeItem/3600*[_o_giftNum.text intValue];
        time = FORMAT(@"%ld", timedouble);
    }else{
        day =  [ZhiboCommon getStringBykey:@"天"];
        long timedouble = gift.timeItem/3600/24*[_o_giftNum.text intValue];
        time =  FORMAT(@"%ld", timedouble);
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@(%@%@)",buystr,gift.name,sendstr,gift.nameItem,time,day];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, buystr.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(buystr.length, gift.name.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(gift.name.length+buystr.length, sendstr.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(gift.name.length+sendstr.length+buystr.length, str.length-gift.name.length-sendstr.length-buystr.length)];
    
    if (!_isfirst) {
        _o_showSelectText.attributedText = AttributedStr;
        _isfirst = YES;
    }else{
        if (_o_label) {
            [_o_label removeFromSuperview];
        }
        _o_showSelectText.hidden = YES;
        UILabel *lable = [[UILabel alloc]init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:12.0];
        lable.numberOfLines = 0;
        lable.frame = _o_showSelectText.frame;
        
        _o_label = lable;
        [_o_fdfd addSubview:lable];
        lable.attributedText = AttributedStr;
    }

//    _o_showSelectText.attributedText = AttributedStr;
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
    if (_secletIndex != recognizer.view.tag) {
        if (_secletIndex >= 100) {
            ZhiBoGiftItemView *oldSecletview = [_o_scro_gift viewWithTag:_secletIndex];
            oldSecletview.o_img_select.hidden = YES;
        }
        
        ZhiBoGiftItemView *newSecletview = [_o_scro_gift viewWithTag:recognizer.view.tag];
        newSecletview.o_img_select.hidden = NO;
        
        _secletIndex = recognizer.view.tag;
        [self setupSelectViewWithIsaddnum:NO];
    }
}




- (void)sendGift{
    ZhiboModel_getGiftList *gift = [_o_data objectAtIndex:_secletIndex-101];
    if (gift.paytype == 1) {
        NSLog(@"%d",[[ZhiboCommon getGoldnum]intValue]);
        if (gift.price > [[ZhiboCommon getGoldnum]intValue]) {
            [ZhiboCommon mpProgressWithView:_o_zhiBoVC.view andString:[ZhiboCommon getStringBykey:@"金币数量不足"]];
            return;
        }
    }else{
        NSLog(@"%d",[[ZhiboCommon getDiamondnum]intValue]);
        if (gift.price > [[ZhiboCommon getDiamondnum]intValue] ) {
            [ZhiboCommon mpProgressWithView:_o_zhiBoVC.view andString:[ZhiboCommon getStringBykey:@"砖石数量不足"]];
            return;
        }
    }
    
    
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"serverid":[ZhiboCommon getServerId],
                           @"playerid":[ZhiboCommon getPlayId],
                           @"playername":[ZhiboCommon getPlayName],
                           @"viplevel":[ZhiboCommon getLevel],
                           @"anchorUid":[ZhiboCommon getAnchoruid],
                           @"giftid":@(gift.id),
                           @"giftnum":_o_giftNum.text,
                           @"timestamp":timestamp,
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@%@%@",[ZhiboCommon getPlayId],[ZhiboCommon getAnchoruid],timestamp,[ZhiboCommon getSecret_key]]],
                           };

    @WeakObj(_o_zhiBoVC);
    @WeakObj(self)
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_o_zhiBoVC.view animated:YES];
    @WeakObj(hud)
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/sendgift.php" andBackObjName:@"sendgift" withSuccessBlock:^(id backId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudWeak hide:YES];
        });
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [selfWeak initgoldandkc];
            if (_o_sendGiftBlock) {
                _o_sendGiftBlock([_o_giftNum.text intValue],gift.id);
            }
            [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:[ZhiboCommon getStringBykey:@"礼物发送成功"]];
        });
    } withFaildBlock:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [hudWeak hide:YES];
            [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:[ZhiboCommon getStringBykey:@"礼物发送失败"]];
        });
    }];
}

/**
 *   获取礼品列表
 */
- (void)getGift{
    NSString *timestamp = [VTTool getTimeSp];
    NSDictionary *dic =  @{
                           @"timestamp":timestamp,
                           @"sign":[VTTool md5:[NSString stringWithFormat:@"%@%@",timestamp,[ZhiboCommon getSecret_key]]],
                           };
    @WeakObj(_o_data);
    @WeakObj(self);
    @WeakObj(_o_zhiBoVC);
    [[ZhiboRequests shareInstance]postZhiboData:dic andUrl:@"/getGiftList.php" andBackObjName:@"getGiftList" withSuccessBlock:^(id backId) {
        if([ZhiboCommon requestStatusbyReult:[backId[@"result"]intValue]]){
        }else{
            if (backId[@"msg"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZhiboCommon mpProgressWithView:_o_zhiBoVCWeak.view andString:backId[@"msg"]];
                });
            }
            return;
        }
        [_o_dataWeak removeAllObjects];
        for (NSDictionary *dic in backId[@"data"]) {
            ZhiboModel_getGiftList *gift = [[ZhiboModel_getGiftList alloc]init];
            [gift getModelFormJson:dic];
            [_o_dataWeak addObject:gift];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [selfWeak setupScroll];
        });
    } withFaildBlock:^(NSError * error) {

    }];
}

@end




@interface ZhiBoGiftItemView()
@end

@implementation ZhiBoGiftItemView

- (void)fillViewWithHeadImgUrl:(NSString *)headUrl andName:(NSString *)name andMoney:(long)money andPaytype:(int )payType andImgTag:(int)imgTag{
    [ZhiboCommon downLoadImageWithURLString:headUrl andBlock:^(UIImage *image) {
        _o_img_head.image = image;
    }];
//    [_o_img_head sd_setImageWithURL:[NSURL URLWithString:headUrl]];
    _o_img_head.tag = imgTag;
    _o_name.text = name;
    _o_money.text = [ZhiboCommon ComputemoneyWithMoney:money];
    
    if(payType == 1){
        [_o_img_glod setImage:[UIImage imageNamed:@"icon_gold"]];
    }else{
         [_o_img_glod setImage:[UIImage imageNamed:@"icon_unit"]];
    }
}


@end
