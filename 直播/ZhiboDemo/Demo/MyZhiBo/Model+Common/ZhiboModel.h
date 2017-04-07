//
//  ZhiboModel.h
//  Demo
//
//  Created by ugamehome on 2016/10/14.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhiboModel : NSObject
-(void)getModelFormJson:(NSDictionary *)dic;
@end

@interface ZhiboModel_GetPage_zhibos: ZhiboModel
@property (strong, nonatomic) NSString *anchorNickname;
@property (nonatomic)  int index;
@property (nonatomic,strong)  NSString* anchorUid;
@property (nonatomic)  int seenum;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *title;
@end

/**
 *  获取界面1
 */
@interface ZhiboModel_GetPage : ZhiboModel
/**< o_zhibos 直播列表 */
@property (strong, nonatomic) NSArray<ZhiboModel_GetPage_zhibos*> *o_zhibos;
@property (nonatomic)  int index;
@property (strong, nonatomic) NSString *title;
/**< type为展示类型，有两种(1)inapp为app页面(2)webview为浏览器展示 */
@property (strong, nonatomic) NSString  *type;//type为展示类型，有两种(1)inapp为app页面(2)webview为浏
@property (strong, nonatomic) NSString  *url;
@end

/**
 *  获取房间信息
 */
@interface ZhiboModel_Getroominfo : ZhiboModel
/**< result=0,进入这个房间  result=1,msg=”验签失败” 不在线：result=4,msg=” 主播不在线，请稍后再试”*/
@property (nonatomic)  int result;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *title;
@property (nonatomic,strong)  NSString* anchorUid;
@property (strong, nonatomic) NSString *anchorNickname;

@property (strong, nonatomic) NSString *liveurl;
@property (strong, nonatomic) NSString *upnum;
/**< 关注人数 */
@property (strong, nonatomic) NSString *accentionnumber;
/**< 观看人数 */
@property (strong, nonatomic) NSString *seenumber;
/**< 是否有关注 */
@property (nonatomic)  int isaccention;

@end

/**
 *  获取弹木
 */
@interface ZhiboModel_danmaku : ZhiboModel
@property (nonatomic)  int playerid;
@property (nonatomic)  int id;
@property (strong, nonatomic) NSString *playername;
@property (nonatomic) int viplevel;
@property (strong, nonatomic) NSString *danmakutext;
@property (strong, nonatomic) NSString *sendtime;
@property (nonatomic)  int index;
@end

@interface ZhiboModel_gift : ZhiboModel
@property (nonatomic)  int playerid;
@property (nonatomic)  int id;
@property (strong, nonatomic) NSString *playername;
@property (nonatomic) int viplevel;
@property (nonatomic) int giftid;
@property (nonatomic) int giftnum;
@property (strong, nonatomic) NSString *sendtime;
@property (nonatomic)  int index;
@end

@interface ZhiboModel_getDanmaku: ZhiboModel
/**< result=0为获取弹幕成功,此时可以显示弹幕
 result!=0的情况，不显示弹幕
”*/
@property (nonatomic)  int result;
@property (strong, nonatomic) NSString *msg;
@property (nonatomic,strong)  NSString* anchorUid;
@property (strong, nonatomic) NSArray<ZhiboModel_danmaku *>* o_danmaku;
@property (strong, nonatomic) NSArray<ZhiboModel_gift *> *o_gift;
@end

/**
 *  主播排名
 */
@interface ZhiboModel_getArchorRank_data : ZhiboModel
@property (nonatomic) int rank;
@property (nonatomic) int archorUid;
@property (strong, nonatomic) NSString *archorNickname;
@property (strong, nonatomic) NSString *upnum;
@end

@interface ZhiboModel_getArchorRank : ZhiboModel
/**< result=0，显示排行
 result!=0,toast msg内容
 ”*/
@property (nonatomic)  int result;
@property (strong, nonatomic) NSString *msg;
@property (nonatomic,strong)  NSString* anchorUid;
@property (strong, nonatomic) NSArray<ZhiboModel_getArchorRank_data *>* o_data;
@end

/**
 *  获取房间列表
 */
@interface ZhiboModel_getrooms_data:ZhiboModel
@property (nonatomic) int  index;
@property (strong, nonatomic) NSString *title;
@property (nonatomic,strong)  NSString* anchorUid;
@property (strong, nonatomic) NSString *anchorNickname;
@property (strong, nonatomic) NSString *thumbnail;
@property (nonatomic,strong)  NSString *seenum;
@end

@interface ZhiboModel_getrooms : ZhiboModel
/**< o_zhibos 直播列表 */
@property (strong, nonatomic) NSArray <ZhiboModel_getrooms_data*>*o_rooms;
@property (nonatomic)  int index;
@property (strong, nonatomic) NSString *title;
@end


@interface ZhiboModel_getroom : ZhiboModel
@property (nonatomic)  int result;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSArray<ZhiboModel_getrooms *>* o_data;
@property (strong, nonatomic) NSString *title;
@end

/**<获取礼品列表*/
@interface ZhiboModel_getGiftList : ZhiboModel
@property (nonatomic) int  id;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) int paytype;//:paytype:付费类型：1=金币，2=钻石
@property (nonatomic) long price;
@property (nonatomic) int effect;
@property (nonatomic,strong)  NSString *icon;
@property (strong, nonatomic) NSString *iconItem;
@property (nonatomic,strong)  NSString *nameItem;
@property (nonatomic) long timeItem;
@end

@interface ZhiboModel_getUserInfo : ZhiboModel
@property (nonatomic)  int result;
@property (strong, nonatomic) NSString *msg;
@property (nonatomic)long goldnum;
@property (nonatomic) long diamondnum;
@end

