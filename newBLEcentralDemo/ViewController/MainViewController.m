//
//  MainViewController.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2017/7/31.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "MainViewController.h"

// ViewController
#import "PeripherialViewController.h"

// helper
#import <CoreBluetooth/CoreBluetooth.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "BLECentralManager.h"
#import "UIDevice+DeviceInfo.h"

@interface MainViewController ()<BLECentralManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *peripheralList;
@property (nonatomic, strong) BLECentralManager *manager;

@end

static NSString * const peripheralListIdentifier = @"peripheralCell";

@implementation MainViewController

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:peripheralListIdentifier];
    __weak typeof(self) weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
    __strong typeof(self) strongSelf = weakSelf;
      [strongSelf.manager scanPeripherals];
      NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:8] interval:0 target:strongSelf selector:@selector(pullToRefreshTimeOut) userInfo:nil repeats:NO];
      [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }];
  }
  return _tableView;
}

- (BLECentralManager *)manager {
  if (!_manager) {
    _manager = [BLECentralManager sharedManager];
    _manager.delegate = self;
  }
  return _manager;
}

- (NSArray *)peripheralList {
  if (!_peripheralList) {
    _peripheralList = self.manager.peripherals;
  }
  return _peripheralList;
}

#pragma mark - UIbuild

- (void)loadView {
  UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
  view.backgroundColor = [UIColor whiteColor];
  self.view = view;
}


- (void)setupContents {
  [self.view addSubview:self.tableView];
}

#pragma mark - LifeCycle

- (void)dealloc {
  NSLog(@"Main view controller was dealloced");
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupContents];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(@([UIDevice navigationBarAndStatusBarHeight]));
    make.left.right.equalTo(@0);
    make.bottom.equalTo(@(-[UIDevice bottomIndicatior]));
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  self.navigationItem.title = localizedString(@"MainViewController.title");
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)pullToRefreshTimeOut {
  [self.tableView.pullToRefreshView stopAnimating];
}

#pragma mark - BLECentralManagerDelegate

- (void)managerDidUpadatePeripherals {
  [self.tableView reloadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.peripheralList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CBPeripheral *peripheral = self.peripheralList[indexPath.row];
  __weak typeof(self) weakSelf = self;
  [self.manager connectWithPeripheral:peripheral completionHandler:^(BOOL success, NSError * _Nullable error) {
    __strong typeof(self) strongSelf = weakSelf;
    if (success) {
      [SVProgressHUD showSuccessWithStatus:nil];
      PeripherialViewController *viewController = [[PeripherialViewController alloc] initWithPerpherial:peripheral];
      [strongSelf.navigationController pushViewController:viewController animated:YES];
    } else {
      [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }
  }];
  [SVProgressHUD show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:peripheralListIdentifier forIndexPath:indexPath];
  CBPeripheral *peripheral = self.peripheralList[indexPath.row];
  cell.textLabel.text = peripheral.identifier.UUIDString;
  return cell;
}

@end
