//
//  PeripherialViewController.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/17.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import "PeripherialViewController.h"

// Controllers
#import "CharacterSettingViewController.h"

// helpers
#import <CoreBluetooth/CoreBluetooth.h>
#import <Masonry/Masonry.h>
#import "BLECentralManager.h"
#import "ControllerAnimationManager.h"
#import "UIDevice+DeviceInfo.h"

@interface PeripherialViewController()<UITableViewDelegate, UITableViewDataSource, CBPeripheralDelegate>

@property (nonatomic, strong) CBPeripheral *perpherial;
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString * const characteristicCellReuseIdentifier = @"PeripheralViewController.tableView.cell.reuseIdentifier";
static NSString * const serviceHeaderReuseIdentifier = @"PeripheralViewController.tableView.header.reuseIdentifier";

@implementation PeripherialViewController

#pragma mark - InitialSetup

- (instancetype)initWithPerpherial:(CBPeripheral *)perpherial {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _perpherial = perpherial;
    _perpherial.delegate = self;
  }
  return self;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:characteristicCellReuseIdentifier];
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:serviceHeaderReuseIdentifier];
  }
  return _tableView;
}


- (void)setupContent {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.tableView];
}

#pragma mark - LifeCycle

- (void)dealloc {
  [[BLECentralManager sharedManager] disconnectWithPeripheral:self.perpherial];
}

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

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.perpherial discoverServices:nil];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.perpherial.services.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  CBService *service = self.perpherial.services[section];
  return service.characteristics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:characteristicCellReuseIdentifier];
  CBService *service = self.perpherial.services[indexPath.section];
  CBCharacteristic *characteristic = service.characteristics[indexPath.row];
  cell.textLabel.text = characteristic.UUID.UUIDString;
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UITableViewHeaderFooterView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:serviceHeaderReuseIdentifier];
  CBService *service = self.perpherial.services[section];
  if (service) {
    [self.perpherial discoverCharacteristics:nil forService:service];
  }
  header.textLabel.text = service.UUID.UUIDString;
  return header;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBService *service = self.perpherial.services[indexPath.section];
    CBCharacteristic *characterisitc = service.characteristics[indexPath.row];
    CharacterSettingViewController *controller = [[CharacterSettingViewController alloc] initWithCharacteristic:characterisitc];
    [ControllerAnimationManager popUp:controller InViewConrtroller:self];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.navigationItem.title = peripheral.name;
  });
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}


@end
