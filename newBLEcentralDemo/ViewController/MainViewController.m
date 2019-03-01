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

// View
#import "PeripheralTableViewCell.h"

// helper
#import <CoreBluetooth/CoreBluetooth.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "BLECentralManager.h"
#import "UIDevice+DeviceInfo.h"

@interface MainViewController ()<BLECentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource>

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
    _tableView.rowHeight = [PeripheralTableViewCell rowHeight];
    [_tableView registerClass:[PeripheralTableViewCell class] forCellReuseIdentifier:peripheralListIdentifier];
    __weak typeof(self) weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
    __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.manager scanPeripherals];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [strongSelf.tableView.pullToRefreshView stopAnimating];
        });
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
  self.navigationItem.title = localizedString(@"MainViewController.title");
  UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
  view.backgroundColor = [UIColor whiteColor];
  self.view = view;
}


- (void)setupContents {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([UIDevice navigationBarAndStatusBarHeight]));
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-[UIDevice bottomIndicatior]));
    }];
}

#pragma mark - LifeCycle

- (void)dealloc {
  NSLog(@"Main view controller was dealloced");
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupContents];
  [self.tableView triggerPullToRefresh];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - BLECentralManagerDelegate

- (void)managerDidUpadatePeripheral:(CBPeripheral *)peripheral {
  peripheral.delegate = self;
  [self.tableView reloadData];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
  NSUInteger index = [self.manager.peripherals indexOfObject:peripheral];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
  });
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
  PeripheralTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:peripheralListIdentifier forIndexPath:indexPath];
  CBPeripheral *peripheral = self.peripheralList[indexPath.row];
  cell.peripheral = peripheral;
  return cell;
}

@end
