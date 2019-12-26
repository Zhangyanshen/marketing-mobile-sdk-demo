//
//  NBAccountListViewController.m
//  CRNDemo
//
//  Created by 张延深 on 2019/12/13.
//  Copyright © 2019 com.ctrip. All rights reserved.
//

#import "NBAccountListViewController.h"
#import "NBNetworkRequest.h"
#import "TokenHelper.h"

@interface NBAccountListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *accountArray;

@end

@implementation NBAccountListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号切换";
    [self.view addSubview:self.tableView];
    // 添加约束
    [self addConstraints];
    [self loadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NBAccountModel *account = self.accountArray[indexPath.row];
    cell.textLabel.text = account.name;
    cell.detailTextLabel.text = account.token;
    cell.accessoryType = [account.token isEqualToString:[TokenHelper loadToken]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NBAccountModel *model = self.accountArray[indexPath.row];
//    [TokenHelper saveToken:model.token];
    if (self.callback) {
        self.callback(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Setters/Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)accountArray {
    if (!_accountArray) {
        _accountArray = [NSMutableArray array];
    }
    return _accountArray;
}

#pragma mark - Private methods

- (void)addConstraints {
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraints:@[topConstraint, bottomConstraint, leadingConstraint, trailingConstraint]];
}

- (void)loadData {
    [[NBNetworkRequest sharedInstance] GETWithUrl:@"https://yg-marketing-api.newtamp.cn/api/v1/user/list" parameters:@{} success:^(id  _Nullable data) {
        NSLog(@"success:%@", data);
        [self formatData:data];
    } fail:^(NSError * _Nullable err) {
        NSLog(@"err:%@", err);
    }];
}

- (void)formatData:(NSArray *)data {
    if (!data) {
        return;
    }
    for (NSDictionary *dic in data) {
        NBAccountModel *model = [NBAccountModel new];
        model.userId = [dic[@"userId"] intValue];
        model.name = dic[@"name"];
        model.token = dic[@"token"];
        [self.accountArray addObject:model];
    }
    [self.tableView reloadData];
}

@end
