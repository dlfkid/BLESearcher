//
//  MainViewController.h
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2017/7/31.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
#define SERVICE_ID @"service_id"
#define CHARACTERISTIC_ID @"characteristic"
#define DEVICE_ID @"device_id"

#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

typedef void(^passStatus)(NSString *message);

@interface MainViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>

{
    passStatus responStatus;
}

@property(nonatomic,strong) UILabel *status;
@property(nonatomic,strong) NSMutableArray *tableList;
@property(nonatomic,strong) NSMutableArray *servicesList;
@property(nonatomic,strong) NSMutableArray *charaList;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) CBCentralManager *centralManager;
@property(nonatomic,strong) CBPeripheral *currentPeripheral;
@property(nonatomic,strong) CBCharacteristic *currentCharacteristic;
@property(nonatomic,copy) NSData *setCharacteristicValue;

@end
