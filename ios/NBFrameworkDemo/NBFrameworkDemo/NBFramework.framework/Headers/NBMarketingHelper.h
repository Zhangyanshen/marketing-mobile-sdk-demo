//
//  MarketingHelper.h
//  CRNDemo
//
//  Created by 张延深 on 2019/12/9.
//  Copyright © 2019 com.ctrip. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 分享的platform
typedef enum : NSUInteger {
    NBShareTypeWechatSession = 1, // 微信好友
    NBShareTypeWechatTimeLine     // 朋友圈
} NBShareType;

/// module对应的枚举
typedef enum : NSUInteger {
    NBMarketingHeadline = 0,   // 财经早报
    NBMarketingNews,           // 财经资讯
    NBMarketingCard,           // 智能名片
    NBMarketingLeads,          // 营销线索
    NBMarketingActivity,       // 访客记录
    NBMarketingAnalysis        // 营销分析
} NBMarketingModule;

NS_ASSUME_NONNULL_BEGIN

@class NBMarketingHelper;

@protocol NBMarketingHelperDelegate <NSObject>

/// 分享WebPage
/// @param helper NBMarketingHelper实例
/// @param data 分享的数据
/// @param callback 回调方法
- (void)marketingHelper:(NBMarketingHelper *)helper
           shareWebPage:(NSDictionary *)data
               complete:(void(^ _Nullable)(NSArray *response))callback;

/// 分享图片
/// @param helper NBMarketingHelper实例
/// @param data 分享的数据
/// @param callback 回调方法
- (void)marketingHelper:(NBMarketingHelper *)helper
             shareImage:(NSDictionary *)data
               complete:(void(^ _Nullable)(NSArray *response))callback;

/// 分享小程序
/// @param helper NBMarketingHelper实例
/// @param data 分享的数据
/// @param callback 回调方法
- (void)marketingHelper:(NBMarketingHelper *)helper
              shareMini:(NSDictionary *)data
               complete:(void(^ _Nullable)(NSArray *response))callback;

@end

@interface NBMarketingHelper : NSObject

/// 代理
@property (nonatomic, strong) id<NBMarketingHelperDelegate> delegate;

/// 单例
+ (instancetype)sharedInstance;

/// 打开module
/// @param moduleType module对应的枚举
/// @param token 登录令牌
/// @param viewController 打开module的viewController
+ (void)openModule:(NBMarketingModule)moduleType
             token:(NSString *)token
fromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
