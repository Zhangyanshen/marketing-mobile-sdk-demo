//
//  NBNetworkRequest.m
//  CRNDemo
//
//  Created by 张延深 on 2019/12/13.
//  Copyright © 2019 com.ctrip. All rights reserved.
//

#import "NBNetworkRequest.h"

#define dispatch_async_main(block) \
\
if ([NSThread currentThread].isMainThread) { \
    block \
} else { \
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ \
        block \
    }); \
}

@implementation NBNetworkRequest

+ (instancetype)sharedInstance {
    static NBNetworkRequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[NBNetworkRequest alloc] init];
    });
    return request;
}

- (void)POSTWithUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(successCallback)success fail:(failCallbak)fail {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handleResponseData:data error:error success:success fail:fail];
    }];
    [task resume];
}

- (void)GETWithUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(successCallback)success fail:(failCallbak)fail {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handleResponseData:data error:error success:success fail:fail];
    }];
    [task resume];
}

- (void)handleResponseData:(id)data error:(NSError *)error success:(successCallback)success fail:(failCallbak)fail {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            if (fail) {
                fail(error);
            }
        } else {
            if (data) {
                NSError *err;
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
                if (success) {
                    if (dataDic && [dataDic[@"success"] boolValue] && dataDic[@"param"]) {
                        success(dataDic[@"param"]);
                    } else {
                        success(@[]);
                    }
                }
            }
        }
    });
}

@end
