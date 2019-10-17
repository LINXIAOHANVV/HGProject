//
//  AppDelegate.m
//  HGStudent
//
//  Created by DoronXC on 2017/1/11.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
//#import <CloudPushSDK/CloudPushSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    BaseTabBarController *tabbar = [[BaseTabBarController alloc] init];
    self.window.rootViewController = tabbar;
   
    /*
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
    // 监听推送通道打开动作
//    [self listenerOnChannelOpened];
    // 监听推送消息到达
    [self registerMessageReceive];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    */
    return YES;
}
//
//- (void)initCloudPush {
//    // SDK初始化
//    [CloudPushSDK asyncInit:@"*****" appSecret:@"*****" callback:^(CloudPushCallbackResult *res) {
//        if (res.success) {
//            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
//        } else {
//            NSLog(@"Push SDK init failed, error: %@", res.error);
//        }
//    }];
//}
///**
// *    注册苹果推送，获取deviceToken用于推送
// *
// *    @param     application
// */
//- (void)registerAPNS:(UIApplication *)application {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        // iOS 8 Notifications
//        [application registerUserNotificationSettings:
//         [UIUserNotificationSettings settingsForTypes:
//          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
//                                           categories:nil]];
//        [application registerForRemoteNotifications];
//    }
//    else {
//        // iOS < 8 Notifications
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//    }
//}
///*
// *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
// */
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
//        if (res.success) {
//            NSLog(@"Register deviceToken success.");
//        } else {
//            NSLog(@"Register deviceToken failed, error: %@", res.error);
//        }
//    }];
//}
///*
// *  苹果推送注册失败回调
// */
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
//}
///**
// *    注册推送消息到来监听
// */
//- (void)registerMessageReceive {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onMessageReceived:)
//                                                 name:@"CCPDidReceiveMessageNotification"
//                                               object:nil];
//}
///**
// *    处理到来推送消息
// *
// *    @param     notification
// */
//- (void)onMessageReceived:(NSNotification *)notification {
//    CCPSysMessage *message = [notification object];
//    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
//    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
//    NSLog(@"Receive message title: %@, content: %@.", title, body);
//}
//
///*
// *  App处于启动状态时，通知打开回调
// */
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
//    NSLog(@"Receive one notification.");
//    // 取得APNS通知内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    // 内容
//    NSString *content = [aps valueForKey:@"alert"];
//    // badge数量
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
//    // 播放声音
//    NSString *sound = [aps valueForKey:@"sound"];
//    // 取得Extras字段内容
//    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
//    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
//    // iOS badge 清0
//    application.applicationIconBadgeNumber = 0;
//    // 通知打开回执上报
//    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
//    [CloudPushSDK sendNotificationAck:userInfo];
//}

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
