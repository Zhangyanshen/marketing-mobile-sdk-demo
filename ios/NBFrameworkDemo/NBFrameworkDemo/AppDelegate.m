//
//  AppDelegate.m
//  NBFrameworkDemo
//
//  Created by 张延深 on 2019/12/12.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "AppDelegate.h"
#import <NBFramework/NBFramework.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self confitUShareSettings];
    [self configUSharePlatforms];
    [NBConfigure initSDK];
    return YES;
}

- (void)confitUShareSettings {
    // 友盟分享初始化
    [UMConfigure initWithAppkey:@"5df097ef3fc1954db7000b3a" channel:@"App Store"];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd36e2a5336d63858" appSecret:@"6129d9745f2536df8f3a6de9956a28ac" redirectURL:@"http://mobile.umeng.com/social"];
}

// 回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
