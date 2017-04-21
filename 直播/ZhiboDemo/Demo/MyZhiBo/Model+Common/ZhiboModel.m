//
//  ZhiboModel.m
//  Demo
//
//  Created by ugamehome on 2016/10/14.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "ZhiboModel.h"

@implementation ZhiboModel
-(void)getModelFormJson:(NSDictionary *)dic{
    
}
@end

@implementation ZhiboModel_GetPage
-(void)getModelFormJson:(NSDictionary *)dic{
    self.index = [ZhiboCommon parseNumberWithJsonDic:dic key:@"index"];
    self.title = [ZhiboCommon parseStringWithJsonDic:dic key:@"title"];
    self.type = [ZhiboCommon parseStringWithJsonDic:dic key:@"type"];
    self.url = [ZhiboCommon parseStringWithJsonDic:dic key:@"url"];
}
@end

@implementation ZhiboModel_GetPage_zhibos
-(void)getModelFormJson:(NSDictionary *)dic{
    self.index = [ZhiboCommon parseNumberWithJsonDic:dic key:@"index"];
    self.seenum = [ZhiboCommon parseNumberWithJsonDic:dic key:@"seenum"];
    self.title = [ZhiboCommon parseStringWithJsonDic:dic key:@"title"];
    self.anchorNickname = [ZhiboCommon parseStringWithJsonDic:dic key:@"anchorNickname"];
    self.anchorUid = [ZhiboCommon parseStringWithJsonDic:dic key:@"anchorUid"];
     self.thumbnail = [ZhiboCommon parseStringWithJsonDic:dic key:@"thumbnail"];
}
@end

@implementation ZhiboModel_Getroominfo
-(void)getModelFormJson:(NSDictionary *)dic{
    self.result = [ZhiboCommon parseNumberWithJsonDic:dic key:@"result"];
    self.msg = [ZhiboCommon parseStringWithJsonDic:dic key:@"msg"];
    self.title = [ZhiboCommon parseStringWithJsonDic:dic key:@"title"];
    self.cmSWat = [ZhiboCommon parseNumberWithJsonDic:dic key:@"CmSWat"];
    self.anchorNickname = [ZhiboCommon parseStringWithJsonDic:dic key:@"anchorNickname"];
    self.anchorUid =[ZhiboCommon parseStringWithJsonDic:dic key:@"anchorUid"];
    self.liveurl = [ZhiboCommon parseStringWithJsonDic:dic key:@"liveurl"];
    self.upnum = [ZhiboCommon parseStringWithJsonDic:dic key:@"upnum"];
    self.accentionnumber = [ZhiboCommon parseStringWithJsonDic:dic key:@"accentionnumber"];
    self.seenumber = [ZhiboCommon parseStringWithJsonDic:dic key:@"seenumber"];
    self.isaccention = [ZhiboCommon parseNumberWithJsonDic:dic key:@"isaccention"];
}
@end

@implementation ZhiboModel_danmaku
-(void)getModelFormJson:(NSDictionary *)dic{
    self.playerid = [ZhiboCommon parseNumberWithJsonDic:dic key:@"playerid"];
    self.playername = [ZhiboCommon parseStringWithJsonDic:dic key:@"playername"];
    self.viplevel = [ZhiboCommon parseNumberWithJsonDic:dic key:@"viplevel"];
    self.danmakutext = [ZhiboCommon parseStringWithJsonDic:dic key:@"danmakutext"];
    self.sendtime = [ZhiboCommon parseStringWithJsonDic:dic key:@"sendtime"];
    self.index = [ZhiboCommon parseNumberWithJsonDic:dic key:@"index"];
    self.id = [ZhiboCommon parseNumberWithJsonDic:dic key:@"id"];
}
@end

@implementation ZhiboModel_gift
-(void)getModelFormJson:(NSDictionary *)dic{
    self.playerid = [ZhiboCommon parseNumberWithJsonDic:dic key:@"playerid"];
    self.playername = [ZhiboCommon parseStringWithJsonDic:dic key:@"playername"];
    self.viplevel = [ZhiboCommon parseNumberWithJsonDic:dic key:@"viplevel"];
    self.giftid = [ZhiboCommon parseNumberWithJsonDic:dic key:@"giftid"];
    self.giftnum = [ZhiboCommon parseNumberWithJsonDic:dic key:@"giftnum"];
    self.sendtime = [ZhiboCommon parseStringWithJsonDic:dic key:@"sendtime"];
    self.index = [ZhiboCommon parseNumberWithJsonDic:dic key:@"index"];
    self.id = [ZhiboCommon parseNumberWithJsonDic:dic key:@"id"];
}
@end

@implementation ZhiboModel_getDanmaku
-(void)getModelFormJson:(NSDictionary *)dic{
    self.result = [ZhiboCommon parseNumberWithJsonDic:dic key:@"result"];
    self.msg = [ZhiboCommon parseStringWithJsonDic:dic key:@"msg"];
    self.anchorUid =[ZhiboCommon parseStringWithJsonDic:dic key:@"anchorUid"];
}
@end

@implementation ZhiboModel_getArchorRank_data
-(void)getModelFormJson:(NSDictionary *)dic{
    self.rank = [ZhiboCommon parseNumberWithJsonDic:dic key:@"rank"];
    self.archorUid = [ZhiboCommon parseNumberWithJsonDic:dic key:@"archorUid"];
    self.archorNickname = [ZhiboCommon parseStringWithJsonDic:dic key:@"anchorNickname"];
    self.upnum = [ZhiboCommon parseStringWithJsonDic:dic key:@"upnum"];
}
@end

@implementation ZhiboModel_getArchorRank
-(void)getModelFormJson:(NSDictionary *)dic{
    self.result = [ZhiboCommon parseNumberWithJsonDic:dic key:@"result"];
    self.msg = [ZhiboCommon parseStringWithJsonDic:dic key:@"msg"];
    self.anchorUid =[ZhiboCommon parseStringWithJsonDic:dic key:@"anchorUid"];
}
@end

@implementation ZhiboModel_getrooms
-(void)getModelFormJson:(NSDictionary *)dic{
    self.index = [ZhiboCommon parseNumberWithJsonDic:dic key:@"index"];
    self.title = [ZhiboCommon parseStringWithJsonDic:dic key:@"title"];
}
@end

@implementation ZhiboModel_getrooms_data

-(void)getModelFormJson:(NSDictionary *)dic{
    self.index = [ZhiboCommon parseNumberWithJsonDic:dic key:@"index"];
    self.seenum = [ZhiboCommon parseStringWithJsonDic:dic key:@"seenum"];
    self.title = [ZhiboCommon parseStringWithJsonDic:dic key:@"title"];
    self.anchorNickname = [ZhiboCommon parseStringWithJsonDic:dic key:@"anchorNickname"];
    self.anchorUid = [ZhiboCommon parseStringWithJsonDic:dic key:@"anchorUid"];
    self.thumbnail = [ZhiboCommon parseStringWithJsonDic:dic key:@"thumbnail"];
}
@end

@implementation ZhiboModel_getroom
-(void)getModelFormJson:(NSDictionary *)dic{
    self.result = [ZhiboCommon parseNumberWithJsonDic:dic key:@"result"];
    self.msg = [ZhiboCommon parseStringWithJsonDic:dic key:@"msg"];
    self.title  = [ZhiboCommon parseStringWithJsonDic:dic key:@"title"];
}
@end

@implementation ZhiboModel_getGiftList
-(void)getModelFormJson:(NSDictionary *)dic{
    self.id = [ZhiboCommon parseNumberWithJsonDic:dic key:@"id"];
    self.name = [ZhiboCommon parseStringWithJsonDic:dic key:@"name"];
    self.paytype = [ZhiboCommon parseNumberWithJsonDic:dic key:@"paytype"];
    self.price = [ZhiboCommon parseLongberWithJsonDic:dic key:@"price"];
    self.effect = [ZhiboCommon parseNumberWithJsonDic:dic key:@"effect"];
    self.icon = [ZhiboCommon parseStringWithJsonDic:dic key:@"icon"];
    self.iconItem = [ZhiboCommon parseStringWithJsonDic:dic key:@"iconItem"];
    self.nameItem = [ZhiboCommon parseStringWithJsonDic:dic key:@"nameItem"];
    self.timeItem = [ZhiboCommon parseNumberWithJsonDic:dic key:@"timeItem"];
}
@end

@implementation ZhiboModel_getUserInfo
-(void)getModelFormJson:(NSDictionary *)dic{
    self.result = [ZhiboCommon parseNumberWithJsonDic:dic key:@"result"];
    self.diamondnum = [ZhiboCommon parseLongberWithJsonDic:dic key:@"diamondnum"];
    self.msg = [ZhiboCommon parseStringWithJsonDic:dic key:@"msg"];
    self.goldnum = [ZhiboCommon parseNumberWithJsonDic:dic key:@"goldnum"];
}
@end
