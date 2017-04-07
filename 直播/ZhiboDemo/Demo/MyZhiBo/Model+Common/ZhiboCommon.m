//
//  ZhiboCommon.m
//  Demo
//
//  Created by ugamehome on 2017/1/16.
//  Copyright © 2017年 ugamehome. All rights reserved.
//

#import "ZhiboCommon.h"
#import "ZhiboLanguage.h"

@implementation ZhiboCommon
+(void)setPlayId:(NSString *)playId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:playId forKey:@"playid"];
}
+(NSString*)getPlayId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"playid"] ?:@"";
}


+(void)setPlayName:(NSString *)playName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:playName forKey:@"playName"];
}
+(NSString *)getPlayName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"playName"] ?:@"";
}

+(void)setServerId:(NSString *)serverId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:serverId forKey:@"serverId"];
}
+(NSString *)getServerId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"serverId"] ?:@"";
}


+(void)setAnchoruid:(NSString *)anchoruid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:anchoruid forKey:@"anchoruid"];
}
+(NSString *)getAnchoruid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"anchoruid"] ?:@"";
}


+(void)setSecret_key:(NSString *)secret_key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:secret_key forKey:@"secret_key"];
}
+(NSString *)getSecret_key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"secret_key"] ?:@"";
}

+(void)setLevel:(NSString *)level{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:level forKey:@"level"];
}

+(NSString *)getLevel{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"level"] ?:@"";
}


+(void)setDiamondnum:(NSString *)Diamondnum{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Diamondnum forKey:@"diamondnum"];
}
+(NSString *)getDiamondnum{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults objectForKey:@"diamondnum"]);
    
    return   [defaults objectForKey:@"diamondnum"] ?:@"";
}

+(void)setGoldnum:(NSString *)Goldnum{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Goldnum forKey:@"goldnum"];
}
+(NSString *)getGoldnum{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"goldnum"] ?:@"";
}

+(void)setShowZhibo:(NSString *)Type{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Type forKey:@"showZhibo"];
}
+(NSString *)getZhibo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return   [defaults objectForKey:@"showZhibo"] ?:@"";
}

/**
 * 解析字符串 （符合字符串规则，返回字符串，否则返回 nil）
 */
+(NSString*) parseStringWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key{
    NSString *strValue = [jsonDic objectForKey:key];
    if ([ZhiboCommon validateStringNode:strValue]) {
        return strValue;
    }
    return nil;
}


+ (BOOL)validateStringNode:(NSString *)jsonValue
{
    if (![jsonValue isKindOfClass:[NSNull class]] && [jsonValue isKindOfClass:[NSString class]] && jsonValue.length>0) {
        return YES;
    }
    return NO;
}

/**
 * 解析数字类型 （符合数字类型规则，返回数字类型，否则返回 0.0）
 */
+(int) parseNumberWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key{
    NSNumber *strValue = [jsonDic objectForKey:key];
    if ([self validateNode:strValue]) {
        return strValue.intValue;
    }
    return 0;
}


+(long) parseLongberWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key{
    NSNumber *strValue = [jsonDic objectForKey:key];
    if ([self validateNode:strValue]) {
        return strValue.longValue;
    }
    return 0;
}

#pragma mark-
+ (BOOL)validateNode:(id)jsonValue
{
    if (jsonValue && ![jsonValue isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

+(void)mpProgressWithView:(UIView *)view andString:(NSString *)str{
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud1.mode = MBProgressHUDModeText;
    hud1.detailsLabelText = str;
    hud1.margin = 10.f;
    hud1.removeFromSuperViewOnHide = YES;
    [hud1 hide:YES afterDelay:2.0];
}

+(NSString *)getStringBykey:(NSString *)key{
    return  [[ZhiboLanguage shareInstance]getStringBykey:key];
}

+ (NSString*)ComputemoneyWithMoney:(long )money{
    NSString *moneyStr = [NSString stringWithFormat:@"%ld",money];
    if (moneyStr.length <= 5) {
        moneyStr = [NSString stringWithFormat:@"%ld",money];
    }else{
        if (moneyStr.length <= 8 ) {
            moneyStr = [NSString stringWithFormat:@"%ld%@",money/10000,[ZhiboCommon getStringBykey:@"万"]];
        }else{
            if (money%100000000) {
                moneyStr = [NSString stringWithFormat:@"%ld%@%ld%@",money/100000000,[ZhiboCommon getStringBykey:@"亿"],money%100000000,[ZhiboCommon getStringBykey:@"万"]];
            }else{
                moneyStr = [NSString stringWithFormat:@"%ld%@",money/100000000,[ZhiboCommon getStringBykey:@"亿"]];
            }
        }
    }
    return moneyStr;
}

+(BOOL)requestStatusbyReult:(int)reult{
    if (reult == 0) {
        return YES;
    }
    return NO;
}

-(NSString *)toCapitalLetters:(NSString *)money
{
    //首先转化成标准格式        “200.23”
    NSMutableString *tempStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[money doubleValue]]];
    //位
    NSArray *carryArr1=@[@"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *carryArr2=@[@"分",@"角"];
    //数字
    NSArray *numArr=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSArray *temarr = [tempStr componentsSeparatedByString:@"."];
    //小数点前的数值字符串
    NSString *firstStr=[NSString stringWithFormat:@"%@",temarr[0]];
    //小数点后的数值字符串
    NSString *secondStr=[NSString stringWithFormat:@"%@",temarr[1]];
    
    //是否拼接了“零”，做标记
    bool zero=NO;
    //拼接数据的可变字符串
    NSMutableString *endStr=[[NSMutableString alloc] init];
    
    /**
     *  首先遍历firstStr，从最高位往个位遍历    高位----->个位
     */
    
    for(int i=(int)firstStr.length;i>0;i--)
    {
        //取最高位数
        NSInteger MyData=[[firstStr substringWithRange:NSMakeRange(firstStr.length-i, 1)] integerValue];
        
        if ([numArr[MyData] isEqualToString:@"零"]) {
            
            if ([carryArr1[i-1] isEqualToString:@"万"]||[carryArr1[i-1] isEqualToString:@"亿"]||[carryArr1[i-1] isEqualToString:@"元"]||[carryArr1[i-1] isEqualToString:@"兆"]) {
                //去除有“零万”
                if (zero) {
                    endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:(endStr.length-1)]];
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }else{
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }
                
                //去除有“亿万”、"兆万"的情况
                if ([carryArr1[i-1] isEqualToString:@"万"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"亿"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                }
                //去除“兆亿”
                if ([carryArr1[i-1] isEqualToString:@"亿"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                }
                
                
            }else{
                if (!zero) {
                    [endStr appendString:numArr[MyData]];
                    zero=YES;
                }
                
            }
            
        }else{
            //拼接数字
            [endStr appendString:numArr[MyData]];
            //拼接位
            [endStr appendString:carryArr1[i-1]];
            //不为“零”
            zero=NO;
        }
    }
    
    /**
     *  再遍历secondStr    角位----->分位
     */
    
    if ([secondStr isEqualToString:@"00"]) {
        [endStr appendString:@"整"];
    }else{
        for(int i=(int)secondStr.length;i>0;i--)
        {
            //取最高位数
            NSInteger MyData=[[secondStr substringWithRange:NSMakeRange(secondStr.length-i, 1)] integerValue];
            
            [endStr appendString:numArr[MyData]];
            [endStr appendString:carryArr2[i-1]];
        }
    }
    
    return endStr;
}

+(void)downLoadImageWithURLString:(NSString *)urlString andBlock:(ImageDownLoadBlock)block{
    if (urlString.length <= 0) {
        return;
    }
    NSString *hesderString = [urlString substringToIndex:4];
    if ([hesderString isEqualToString:@"http"]) {
        NSURLSession *session =[NSURLSession sharedSession];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage *image  =[UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            dispatch_async(dispatch_get_main_queue(), ^{
                //使用Block将值传递出去
                block(image);
            });
        }];
        [task resume];
    }else{
        //抛出异常
        @throw [NSException exceptionWithName:@"ImageDownLoad Error" reason:@"Your urlString mayBe an Illegal string" userInfo:nil];
    }
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
