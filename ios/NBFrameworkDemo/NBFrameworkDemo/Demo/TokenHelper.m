//
//  TokenHelper.m
//  NBFrameworkDemo
//
//  Created by 张延深 on 2019/12/17.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "TokenHelper.h"

@implementation TokenHelper

+ (void)saveToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"NBWBSToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)loadToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"NBWBSToken"];
}

@end
