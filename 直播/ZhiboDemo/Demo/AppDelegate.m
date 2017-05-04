//
//  AppDelegate.m
//  Demo
//
//  Created by ugamehome on 16/10/13.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "AppDelegate.h"
#import "HeadVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    HeadVC *VC = [[HeadVC alloc]initWithPlayId:@"21005" andPlayName:@"ThieuDan" andServerid:@"700091" andSecretKey:zhibo_SecretKey andLevel:@"17"];
    
    HeadVC *VC = [[HeadVC alloc]initWithPlayId:@"32901" andPlayName:@"" andServerid:@"900213" andSecretKey:zhibo_SecretKey andLevel:@"17"];
    
//    HeadVC *VC = [[HeadVC alloc]initWithPlayId:@"30216" andPlayName:@"항나" andServerid:@"700106" andSecretKey:@"kO*reA101Black#Soldier" andLevel:@"100"];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    NSLog(@"HeadVC--> %@",VC);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
