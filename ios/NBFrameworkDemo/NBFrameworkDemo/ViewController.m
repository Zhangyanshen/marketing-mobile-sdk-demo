//
//  ViewController.m
//  NBFrameworkDemo
//
//  Created by 张延深 on 2019/12/12.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ViewController.h"
#import <NBFramework/NBFramework.h>
#import <UMShare/UMShare.h>
#import "NBAccountListViewController.h"
#import "TokenHelper.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, NBMarketingHelperDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *loginLbl;
@property (weak, nonatomic) IBOutlet UILabel *tokenLbl;
@property (weak, nonatomic) IBOutlet UITextField *tokenField;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *token = [TokenHelper loadToken];
    self.loginLbl.text = token ? @"已登录" : @"未登录";
    self.tokenLbl.text = token ?: @"";
    self.tokenField.text = token;
    // 初始化MarketingHelper
    [NBMarketingHelper sharedInstance].delegate = self;
    self.dataArray = @[
        @{@"title": @"财经早报", @"type": @(NBMarketingHeadline)},
        @{@"title": @"财经资讯", @"type": @(NBMarketingNews)},
        @{@"title": @"智能名片", @"type": @(NBMarketingCard)},
        @{@"title": @"营销线索", @"type": @(NBMarketingLeads)},
        @{@"title": @"访客记录", @"type": @(NBMarketingActivity)},
        @{@"title": @"营销分析", @"type": @(NBMarketingAnalysis)}
    ];
//    [self setupUI];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *data = self.dataArray[indexPath.row];
    cell.textLabel.text = data[@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = self.dataArray[indexPath.row];
    [NBMarketingHelper openModule:[data[@"type"] integerValue] token:self.tokenField.text fromViewController:self];
}

#pragma mark - NBMarketingHelperDelegate

- (void)marketingHelper:(NBMarketingHelper *)helper shareMini:(NSDictionary *)data complete:(void (^)(NSArray * _Nonnull))callback {
    [self shareToMini:data callback:callback];
}

- (void)marketingHelper:(NBMarketingHelper *)helper shareImage:(NSDictionary *)data complete:(void (^)(NSArray * _Nonnull))callback {
    if ([data[@"platform"] intValue] == NBShareTypeWechatSession) {
        [self shareImg:data platform:UMSocialPlatformType_WechatSession callback:callback];
    } else {
        [self shareImg:data platform:UMSocialPlatformType_WechatTimeLine callback:callback];
    }
}

- (void)marketingHelper:(NBMarketingHelper *)helper shareWebPage:(NSDictionary *)data complete:(void (^)(NSArray * _Nonnull))callback {
    if ([data[@"platform"] intValue] == NBShareTypeWechatSession) { // 好友
        [self shareH5:data platform:UMSocialPlatformType_WechatSession callback:callback];
    } else {
        [self shareH5:data platform:UMSocialPlatformType_WechatTimeLine callback:callback];
    }
}

#pragma mark - Event response

- (void)switchAccount:(UIBarButtonItem *)item {
    NBAccountListViewController *accountListVC = [[NBAccountListViewController alloc] init];
    accountListVC.callback = ^(NBAccountModel * _Nullable accountModel) {
        if (accountModel) {
            self.tokenLbl.text = accountModel.token;
            self.loginLbl.text = @"已登录";
        }
    };
    [self.navigationController pushViewController:accountListVC animated:YES];
}

#pragma mark - Private methods

- (void)setupUI {
    self.tableView.tableFooterView = [UIView new];
    UIBarButtonItem *switchAccount = [[UIBarButtonItem alloc] initWithTitle:@"切换账号" style:UIBarButtonItemStylePlain target:self action:@selector(switchAccount:)];
    self.navigationItem.rightBarButtonItem = switchAccount;
}

- (void)shareH5:(NSDictionary *)shareData
       platform:(UMSocialPlatformType)platform
       callback:(void (^ _Nullable)(NSArray *response))callback
{
    if (!shareData) {
        return;
    }
    // 创建分享消息对象
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    // 创建网页内容对象
    UMShareWebpageObject *shareObj = [UMShareWebpageObject shareObjectWithTitle:shareData[@"title"] descr:shareData[@"text"] thumImage:shareData[@"icon"]];
    // 设置网页地址
    shareObj.webpageUrl = shareData[@"link"];
    // 分享消息对象设置分享内容对象
    messageObj.shareObject = shareObj;
    // 调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObj currentViewController:self completion:^(id result, NSError *error) {
        if (callback) {
            NSInteger code = 200;
            NSString *msg = @"分享成功";
            if (error) {
                code = error.code;
                msg = error.localizedDescription;
            }
            callback(@[@(code), msg]);
        }
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        } else {
            NSLog(@"response data is %@", result);
        }
    }];
}

- (void)shareImg:(NSDictionary *)shareData
        platform:(UMSocialPlatformType)platform
        callback:(void (^ _Nullable)(NSArray *response))callback {
    if (!shareData) {
        return;
    }
    // 创建分享消息对象
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    // 创建图片内容对象
    UMShareImageObject *shareObj = [[UMShareImageObject alloc] init];
    [shareObj setThumbImage:shareData[@"icon"]];
    [shareObj setShareImage:shareData[@"icon"]];
    // 分享消息对象设置分享内容对象
    messageObj.shareObject = shareObj;
    // 调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObj currentViewController:self completion:^(id result, NSError *error) {
        if (callback) {
            NSInteger code = 200;
            NSString *msg = @"分享成功";
            if (error) {
                code = error.code;
                msg = error.localizedDescription;
            }
            callback(@[@(code), msg]);
        }
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        } else {
            NSLog(@"response data is %@", result);
        }
    }];
}

- (void)shareToMini:(NSDictionary *)shareData
           callback:(void (^ _Nullable)(NSArray *response))callback
{
    if (!shareData) {
        return;
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareMiniProgramObject *shareObj = [UMShareMiniProgramObject shareObjectWithTitle:shareData[@"title"] descr:shareData[@"text"] thumImage:nil];
    shareObj.webpageUrl = @"http://mobile.umeng.com/social";
    shareObj.userName = @"gh_f501ac1af8bb";
    shareObj.path = shareData[@"page"];
    shareObj.hdImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareData[@"img"]]];
    shareObj.miniProgramType = UShareWXMiniProgramTypeRelease;
    messageObject.shareObject = shareObj;
    
    // 调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        if (callback) {
            NSInteger code = 200;
            NSString *msg = @"分享成功";
            if (error) {
                code = error.code;
                msg = error.localizedDescription;
            }
            callback(@[@(code), msg]);
        }
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        } else {
            if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = result;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
            } else {
                NSLog(@"response data is %@", result);
            }
        }
    }];
}

@end
