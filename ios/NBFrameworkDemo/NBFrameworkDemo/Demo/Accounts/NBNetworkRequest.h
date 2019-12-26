//
//  NBNetworkRequest.h
//  CRNDemo
//
//  Created by 张延深 on 2019/12/13.
//  Copyright © 2019 com.ctrip. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successCallback)(id _Nullable data);
typedef void(^failCallbak)(NSError * _Nullable err);

NS_ASSUME_NONNULL_BEGIN

@interface NBNetworkRequest : NSObject

+ (instancetype)sharedInstance;

- (void)POSTWithUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(successCallback)success fail:(failCallbak)fail;
- (void)GETWithUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(successCallback)success fail:(failCallbak)fail;

@end

NS_ASSUME_NONNULL_END
