//
//  ZhiBoGiftView.h
//  Demo
//
//  Created by ugamehome on 2016/10/26.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiBoBaseView.h"
@class ZhiBoVC;

typedef void (^sendGiftBlock)(int,int);//第一个是数量,第二个是id

@interface ZhiBoGiftView : ZhiBoBaseView
- (void)getGift;
@property (nonatomic,strong)ZhiBoVC *o_zhiBoVC;
- (UIImage*)getGiftImageWithTag:(int)imageTag;
- (ZhiboModel_getGiftList*)getGiftListWithTag:(int)Tag;
@property (copy, nonatomic) sendGiftBlock o_sendGiftBlock;
- (void)initgoldandkc;
@end
//直播礼物 视图
@interface ZhiBoGiftItemView:ZhiBoBaseView
@property (weak, nonatomic) IBOutlet UIImageView *o_img_head;
@property (weak, nonatomic) IBOutlet UILabel *o_name;
@property (weak, nonatomic) IBOutlet UILabel *o_money;
@property (weak, nonatomic) IBOutlet UIImageView *o_img_select;
@property (weak, nonatomic) IBOutlet UIImageView *o_img_glod;
- (void)fillViewWithHeadImgUrl:(NSString *)headUrl andName:(NSString *)name andMoney:(long)money andPaytype:(int )payType andImgTag:(int)imgTag;
@end


@interface ZhiBoGiftIpadView : ZhiBoBaseView

@end
