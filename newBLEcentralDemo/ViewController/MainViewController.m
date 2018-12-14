//
//  MainViewController.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2017/7/31.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)getCentralManager {
    __block MainViewController *blockSelf = self;
    responStatus = ^(NSString * message){
        blockSelf.status.text = message;
    };
    _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    NSLog(@"Establishing central manager");
}

- (NSMutableArray *)tableList {
    if(!_tableList) {
        _tableList = [NSMutableArray array];
    }
    return _tableList;
}

- (NSMutableArray *)charaList {
    if(!_charaList) {
        _charaList = [NSMutableArray array];
    }
    return _charaList;
}

- (NSMutableArray *)servicesList {
    if(!_servicesList) {
        _servicesList = [NSMutableArray array];
    }
    return _servicesList;
}

#pragma mark - UIbuild
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCentralManager];
    [self UIConstruct];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"BLE_Demo_central";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)buildBLEmanager {
    NSLog(@"searching for device");
    [self.tableList removeAllObjects];
    [self.servicesList removeAllObjects];
    [self.charaList removeAllObjects];
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

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
            NSLog(@"manager state poweroff");
            stateResult = [stateString stringByAppendingString:@"poweroff"];
            break;
            
        case CBManagerStatePoweredOn:
            NSLog(@"manager state poweron");
            stateResult = [stateString stringByAppendingString:@"poweron"];
            break;
            
        default:
            break;
    }
    
    responStatus(stateResult);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    responStatus(@"A peripheral device was found");
    [self.tableList addObject:peripheral];
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager stopScan];
    self.currentPeripheral = peripheral;
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    NSLog(@"connected to peripheral %@",peripheral.name);
    NSString *status = [NSString stringWithFormat:@"Connecting:%@",peripheral.name];
    responStatus(status);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Connection brocken!");
    responStatus(@"Connection failure");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Disconnected,reason:%@",error.localizedDescription);
    responStatus(@"Connection lost!");
    //[self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    [self.servicesList removeAllObjects];
    [self.servicesList addObjectsFromArray:peripheral.services];
    responStatus([NSString stringWithFormat:@"%@ : service found",peripheral.name]);
    NSLog(@"%@ :service found",peripheral.name);
    [self.tableView reloadData];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    [self.charaList removeAllObjects];
    [self.charaList addObjectsFromArray:service.characteristics];
    for(CBCharacteristic *chara in service.characteristics) {
        NSLog(@"Characteristic UUID %@",chara.UUID);
    }
    if(error) {
        NSLog(@"Characteristic found with : %@",error.localizedDescription);
    }
    [self.tableView reloadData];
    responStatus(@"Characteristic found");
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅失败");
        NSLog(@"%@",error.localizedDescription);
        UIAlertController *setNotify = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",_currentCharacteristic.UUID] message:[NSString stringWithFormat:@"%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [setNotify addAction:yes];
        [self presentViewController:setNotify animated:true completion:nil];
    }else {
        if (characteristic.isNotifying) {
            NSLog(@"订阅成功");
        } else {
            NSLog(@"没有订阅");
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *data = characteristic.value;
    NSString *textValue = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    UIAlertController *readValue = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",_currentCharacteristic.UUID] message:[NSString stringWithFormat:@"%@",textValue] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [readValue addAction:yes];
    [self presentViewController:readValue animated:true completion:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if(error){
        NSString *errorMessage = [error localizedDescription];
        responStatus(errorMessage);
    }
    else
        responStatus(@"update value success");
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) {
        return _tableList.count;
    }else if(section == 1) {
        return _servicesList.count;
    }else {
        return _charaList.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return [NSString stringWithFormat:@"Device found : %lu",(unsigned long)self.tableList.count];
    }else if(section == 1) {
        return [NSString stringWithFormat:@"current device %@",_currentPeripheral.name];
    }else {
        return [NSString stringWithFormat:@"Characteristic %lu",_charaList.count];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    CBCharacteristic *chara = self.charaList[indexPath.row];
    self.currentCharacteristic = chara;
    
    UIAlertController *textAlert = [UIAlertController alertControllerWithTitle:@"PostData" message:@"In put characteristic value" preferredStyle:UIAlertControllerStyleAlert];

    [textAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"set value for characteristic";
        self.setCharacteristicValue = [textField.text dataUsingEncoding:NSUTF8StringEncoding];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.currentPeripheral writeValue:self.setCharacteristicValue forCharacteristic:self.currentCharacteristic type:CBCharacteristicWriteWithResponse];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [textAlert addAction:confirm];
    [textAlert addAction:cancel];
    
    [self presentViewController:textAlert animated:true completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DEVICE_ID forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(indexPath.section == 0){
    CBPeripheral *device = self.tableList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",device.name];
    return cell;
    }
    else if(indexPath.section == 1) {
        CBService *service = self.servicesList[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",service.UUID];
        return cell;
    }
    else {
        CBCharacteristic *chara = self.charaList[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",chara.UUID];
        [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        CBPeripheral *device = self.tableList[indexPath.row];
        NSLog(@"ready to connect %@",device.name);
        NSString *status = [NSString stringWithFormat:@"ready to connect %@",device.name];
        responStatus(status);
        [self.centralManager connectPeripheral:device options:nil];
    }else if(indexPath.section == 1){
        CBService *service = self.servicesList[indexPath.row];
        NSLog(@"Finding characteristic for service");
        [self.currentPeripheral discoverCharacteristics:nil forService:service];
        NSString *status = [NSString stringWithFormat:@"%@ characteristc",service.UUID];
        responStatus(status);
    }else {
        CBCharacteristic *chara = self.charaList[indexPath.row];
        NSLog(@"reading characteristic %@",chara.UUID);
        [_currentPeripheral readValueForCharacteristic:chara];
        [_currentPeripheral setNotifyValue:true forCharacteristic:chara];
        _currentCharacteristic = chara;
    }
}



@end
