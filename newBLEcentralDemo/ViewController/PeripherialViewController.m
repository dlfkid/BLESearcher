//
//  PeripherialViewController.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/17.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import "PeripherialViewController.h"

// helpers
#import <CoreBluetooth/CoreBluetooth.h>
#import <Masonry/Masonry.h>
#import "UIDevice+DeviceInfo.h"

@interface PeripherialViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CBPeripheral *perpherial;
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString * const serviceCellReuseIdentifier = @"PeripheralViewController.tableView.reuseIdentifier";

@implementation PeripherialViewController

#pragma mark - InitialSetup

- (instancetype)initWithPerpherial:(CBPeripheral *)perpherial {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _perpherial = perpherial;
  }
  return self;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:serviceCellReuseIdentifier];
  }
  return _tableView;
}


- (void)setupContent {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.tableView];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = self.perpherial.name;
  [self setupContent];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(@([UIDevice navigationBarAndStatusBarHeight]));
    make.left.right.equalTo(@0);
    make.bottom.equalTo(@([UIDevice bottomIndicatior]));
  }];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.perpherial.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:serviceCellReuseIdentifier];
  CBService *service = self.perpherial.services[indexPath.row];
  cell.textLabel.text = service.UUID.UUIDString;
  return cell;
}

@end
