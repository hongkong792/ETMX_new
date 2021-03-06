//
//  AppDelegate.m
//  ETMX
//
//  Created by 杨香港 on 2016/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "AppDelegate.h"
#import "CheckNetWorkerTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSDate * date = [NSDate date];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"date"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"date"];
    }
    //网络监控
    NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:ADRESSIP];
    if ((obj == nil ||[obj isEqualToString:@""])) {
        [[NSUserDefaults standardUserDefaults] setObject:@"59.40.73.167:8085" forKey:ADRESSIP];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [CheckNetWorkerTool sharedManager];
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:@"appLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
            //  [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
            //  [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:@"appLanguage"];//繁體
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  //  [NSThread detachNewThreadSelector:@selector(stopTask) toTarget:self withObject:nil];
//    double delaySeconds = 10.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySeconds*NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^{
//        NSString * str = nil;
//        NSMutableArray * arr = [NSMutableArray array];
//        [arr setValue:str forKey:@"test"];
//    });
//    
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

/**
 *程序崩溃
 */
- (void)stopTask
{
    [NSTimer scheduledTimerWithTimeInterval:60*60*24*7 target:self selector:@selector(appCrash) userInfo:nil repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}

- (void)appCrash
{
    NSString * str = nil;
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:str];

}
@end
