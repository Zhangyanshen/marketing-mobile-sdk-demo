//
//  TokenHelper.h
//  NBFrameworkDemo
//
//  Created by 张延深 on 2019/12/17.
//  Copyright © 2019 张延深. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TokenHelper : NSObject

+ (void)saveToken:(NSString *)token;
+ (NSString *)loadToken;

@end

NS_ASSUME_NONNULL_END
