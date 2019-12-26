//
//  NBAccountModel.h
//  CRNDemo
//
//  Created by 张延深 on 2019/12/13.
//  Copyright © 2019 com.ctrip. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBAccountModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
