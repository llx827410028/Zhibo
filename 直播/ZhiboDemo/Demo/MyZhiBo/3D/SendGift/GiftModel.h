//
//  GiftModel.h
//  presentAnimation
//
//  Created by 许博 on 16/7/15.
//  Copyright © 2016年 许博. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GiftModel : NSObject
@property (nonatomic,strong) NSString *recviceImgStr; // 头像
@property (nonatomic,strong) UIImage *giftImage; // 礼物
@property (nonatomic,copy) NSString *name; // 送礼物者
@property (nonatomic,copy) NSString *giftName; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,strong)NSDictionary *o_dic;//动态礼物信息
@end
