//
//  MainViewController.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2017/7/31.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "MainViewController.h"

// helper
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <Masonry/Masonry.h>
#import "UIDevice+DeviceInfo.h"

@interface MainViewController ()<CBCentralManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray *peripheralList;

@end

static NSString * const peripheralListIdentifier = @"peripheralCell";

@implementation MainViewController

- (CBCentralManager *)centralManager {
  if (!_centralManager) {
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
  }
  return _centralManager;
}

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
      [strongSelf buildBLEmanager];
      NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:10] interval:0 target:strongSelf selector:@selector(pullToRefreshTimeOut) userInfo:nil repeats:NO];
      [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }];
  }
  return _tableView;
}

- (NSMutableArray *)peripheralList {
  if (!_peripheralList) {
    _peripheralList = [NSMutableArray array];
  }
  return _peripheralList;
}

#pragma mark - UIbuild

- (void)loadView {
  UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
  view.backgroundColor = [UIColor lightGrayColor];
  self.view = view;
}


- (void)setupContents {
  [self.view addSubview:self.tableView];
}

- (void)buildBLEmanager {
  NSLog(@"searching for device");
  [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.centralManager;
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


- (void)UIConstruct {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat topView = 20 + 44;
    
    
    UILabel *labelState = [[UILabel alloc]initWithFrame:CGRectMake(0, topView + 10, screenWidth, 44)];
    labelState.textAlignment = NSTextAlignmentCenter;
    labelState.text = @"Central Manager State";
    
    UILabel *labelContent = [[UILabel alloc]initWithFrame:CGRectMake(labelState.frame.origin.x, labelState.frame.origin.y + 10 + labelState.frame.size.height, screenWidth, 44)];
    labelContent.textAlignment = NSTextAlignmentCenter;
    labelContent.text = @"Standing by...";
    
    self.status = labelContent;
    
    [self.view addSubview:labelState];
    [self.view addSubview:labelContent];
    
    UITableView *BLEDeviceListView = [[UITableView alloc]initWithFrame:CGRectMake(0, labelContent.frame.origin.y + labelContent.frame.size.height + 10, screenWidth, 450) style:UITableViewStyleGrouped];
    self.tableView = BLEDeviceListView;
    BLEDeviceListView.delegate = self;
    BLEDeviceListView.dataSource = self;
    [BLEDeviceListView registerClass:[UITableViewCell class] forCellReuseIdentifier:DEVICE_ID];
    BLEDeviceListView.layer.borderWidth = 1;
    [self.view addSubview:BLEDeviceListView];
    
    UIButton *beginSearch = [UIButton buttonWithType:UIButtonTypeSystem];
    [beginSearch setTitle:@"SearchDevice" forState:UIControlStateNormal];
    [beginSearch setFrame:CGRectMake(0, screenHeight - 40, screenWidth, 40)];
    [beginSearch addTarget:self action:@selector(buildBLEmanager) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginSearch];
    
}

#pragma mark - BLE delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSMutableString *stateString = [NSMutableString stringWithFormat:@"Manager State:"];
    NSString *stateResult;
    switch (central.state) {
        case CBManagerStateUnknown:
          NSLog(@"Manager state unknown");
          stateResult = [stateString stringByAppendingString:@"unknown"];
          break;
            
        case CBManagerStateUnsupported:
          NSLog(@"manager state unsupport");
          stateResult = [stateString stringByAppendingString:@"unspport"];
          break;
            
        case CBManagerStateResetting:
          NSLog(@"manager state restting");
          stateResult = [stateString stringByAppendingString:@"resetting"];
          break;
            
        case CBManagerStateUnauthorized:
          NSLog(@"manager state unauthorized");
          stateResult = [stateString stringByAppendingString:@"unauthrized"];
          break;
            
        case CBManagerStatePoweredOff:
          NSLog(@"manager state power off");
          stateResult = [stateString stringByAppendingString:@"poweroff"];
          break;
            
        case CBManagerStatePoweredOn:
          NSLog(@"manager state power on");
          stateResult = [stateString stringByAppendingString:@"poweron"];
          [central scanForPeripheralsWithServices:nil options:nil];
          break;
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
  if (![self.peripheralList containsObject:peripheral]) {
    [self.peripheralList addObject:peripheral];
  }
  [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager stopScan];
    [peripheral discoverServices:nil];
    NSLog(@"connected to peripheral %@",peripheral.name);
    NSString *status = [NSString stringWithFormat:@"Connecting:%@",peripheral.name];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Connection brocken!");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Disconnected,reason:%@",error.localizedDescription);
    //[self.centralManager connectPeripheral:peripheral options:nil];
}

//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
//    [self.servicesList removeAllObjects];
//    [self.servicesList addObjectsFromArray:peripheral.services];
//  [NSString stringWithFormat:@"%@ : service found",peripheral.name];
//    NSLog(@"%@ :service found",peripheral.name);
//    [self.tableView reloadData];
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
//    [self.charaList removeAllObjects];
//    [self.charaList addObjectsFromArray:service.characteristics];
//    for(CBCharacteristic *chara in service.characteristics) {
//        NSLog(@"Characteristic UUID %@",chara.UUID);
//    }
//    if(error) {
//        NSLog(@"Characteristic found with : %@",error.localizedDescription);
//    }
//    [self.tableView reloadData];
//}

//- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    if (error) {
//        NSLog(@"订阅失败");
//        NSLog(@"%@",error.localizedDescription);
//        UIAlertController *setNotify = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",_currentCharacteristic.UUID] message:[NSString stringWithFormat:@"%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [setNotify addAction:yes];
//        [self presentViewController:setNotify animated:true completion:nil];
//    }else {
//        if (characteristic.isNotifying) {
//            NSLog(@"订阅成功");
//        } else {
//            NSLog(@"没有订阅");
//        }
//    }
//}

//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    NSData *data = characteristic.value;
//    NSString *textValue = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
//    UIAlertController *readValue = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",_currentCharacteristic.UUID] message:[NSString stringWithFormat:@"%@",textValue] preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [readValue addAction:yes];
//    [self presentViewController:readValue animated:true completion:nil];
//}

//- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    if (error) {
//      NSString *errorMessage = [error localizedDescription];
//    }
//}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.peripheralList.count;
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//
//    CBCharacteristic *chara = self.charaList[indexPath.row];
//    self.currentCharacteristic = chara;
//
//    UIAlertController *textAlert = [UIAlertController alertControllerWithTitle:@"PostData" message:@"In put characteristic value" preferredStyle:UIAlertControllerStyleAlert];
//
//    [textAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"set value for characteristic";
//        self.setCharacteristicValue = [textField.text dataUsingEncoding:NSUTF8StringEncoding];
//    }];
//    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.currentPeripheral writeValue:self.setCharacteristicValue forCharacteristic:self.currentCharacteristic type:CBCharacteristicWriteWithResponse];
//    }];
//
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
//
//    [textAlert addAction:confirm];
//    [textAlert addAction:cancel];
//
//    [self presentViewController:textAlert animated:true completion:nil];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:peripheralListIdentifier forIndexPath:indexPath];
  CBPeripheral *peripheral = self.peripheralList[indexPath.row];
  cell.textLabel.text = peripheral.identifier.UUIDString;
  return cell;
}

#pragma mark - Actions

- (void)pullToRefreshTimeOut {
  [self.tableView.pullToRefreshView stopAnimating];
}

@end
