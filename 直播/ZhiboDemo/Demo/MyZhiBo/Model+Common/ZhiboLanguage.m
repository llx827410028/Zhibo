//
//  ZhiboLanguage.m
//  Demo
//
//  Created by ugamehome on 2017/1/11.
//  Copyright © 2017年 ugamehome. All rights reserved.
//

#import "ZhiboLanguage.h"
@interface ZhiboLanguage()
@property (nonatomic,strong)NSDictionary *o_dic;
@end

@implementation ZhiboLanguage
+(instancetype)shareInstance
{
    static ZhiboLanguage * object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[ZhiboLanguage alloc] init];
    });
    return object;
}

-(NSString *)getStringBykey:(NSString *)key{
    if (_o_dic) {
    }else{
        [self  loadPlistData];
    }
    
    NSLog(@"Language.plist-->%@",_o_dic[key]);
    return _o_dic[key];
}

- (void)loadPlistData{
    NSString *filePath = [self dataFilePath];
    //检查数据文件在不在
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        _o_dic = dic;
    }
}

-(NSString *)dataFilePath{    
    return [[NSBundle mainBundle] pathForResource:@"Language" ofType:@"plist"];
}

@end
