//
//  NBConfigure.h
//  CRNDemo
//
//  Created by 张延深 on 2019/12/11.
//  Copyright © 2019 com.ctrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBDomainConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// SDK初始配置
@interface NBConfigure : NSObject

/// 域名配置项
@property (nonatomic, strong, readonly, class) NBDomainConfiguration *domainConfig;

/// 初始化SDK
+ (void)configSDKWithDomainConfiguration:(NBDomainConfiguration * __nullable)domainConfig;

@end

NS_ASSUME_NONNULL_END
