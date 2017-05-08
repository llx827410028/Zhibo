//
//  NdReplay.m
//  Unity-iPhone
//
//  Created by ugamehome on 2017/3/15.
//
//

#import "NdReplay.h"
#import <ReplayKit/ReplayKit.h>
#import "UnityAppController.h"

@interface NdReplay ()<RPPreviewViewControllerDelegate>

@end

@implementation NdReplay

+(instancetype)shareInstance
{
    static NdReplay * object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[NdReplay alloc] init];
    });
    return object;
}

//启动或者停止录制回放
-(void)replayKitActionWithIsreplay:(BOOL )isreplay{
    //判断是否已经开始录制回放
    if(!isreplay){
        //停止录制回放，并显示回放的预览，在预览中用户可以选择保存视频到相册中、放弃、或者分享出去
        [[RPScreenRecorder sharedRecorder]stopRecordingWithHandler:^(RPPreviewViewController*_Nullable previewViewController,NSError *_Nullable error){
            if(error){
                NSLog(@"%@", error);
                //处理发生的错误，如磁盘空间不足而停止等
            }
            if(previewViewController){
                //设置预览页面到代理
                UnityAppController * appDelegate = (UnityAppController*)[UIApplication sharedApplication].delegate;
                [appDelegate isUnityPause:true];
                previewViewController.previewControllerDelegate = self;
                [[ZhiboCommon getCurrentVC] presentViewController:previewViewController animated:YES completion:nil];
            }
        }];
        return;
    }
    //如果还没有开始录制，判断系统是否支持
    if([RPScreenRecorder sharedRecorder].available){
        NSLog(@"OK");
        //如果支持，就使用下面的方法可以启动录制回放
        [[RPScreenRecorder sharedRecorder]startRecordingWithMicrophoneEnabled:YES handler:^(NSError*_Nullable error){
            NSLog(@"%@",error);
            //处理发生的错误，如设用户权限原因无法开始录制等
        }];
    }else{
        NSLog(@"录制回放功能不可用");
    }
}
//回放预览界面的代理方法
-(void)previewControllerDidFinish:(RPPreviewViewController*)previewController{
    //用户操作完成后，返回之前的界面
    [previewController dismissViewControllerAnimated:YES completion:nil];
    UnityAppController * appDelegate = (UnityAppController*)[UIApplication sharedApplication].delegate;
    [appDelegate isUnityPause:false];
}

-(BOOL )isSupporios{
    //如果还没有开始录制，判断系统是否支持
    if([RPScreenRecorder sharedRecorder].available){
        return YES;
    }else{
        return NO;
    }
}

@end
