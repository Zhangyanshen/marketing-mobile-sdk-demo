//
//  NBDomainConfiguration.h
//  CRNDemo
//
//  Created by 张延深 on 2019/12/26.
//  Copyright © 2019 com.ctrip. All rights reserved.
//  域名配置

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBDomainConfiguration : NSObject

@property (nonatomic, copy, readonly) NSString *baseService;
@property (nonatomic, copy, readonly) NSString *h5Service;

+ (instancetype)domainConfigurationWithBaseService:(NSString *)baseService h5Service:(NSString *)h5Service;
- (instancetype)initWithBaseService:(NSString *)baseService h5Service:(NSString *)h5Service;

@end

NS_ASSUME_NONNULL_END
