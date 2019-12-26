//
//  NBAccountListViewController.h
//  CRNDemo
//
//  Created by 张延深 on 2019/12/13.
//  Copyright © 2019 com.ctrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NBAccountListViewController : UIViewController

@property (nonatomic, copy) void(^callback)(NBAccountModel * _Nullable accountModel);

@end

NS_ASSUME_NONNULL_END
