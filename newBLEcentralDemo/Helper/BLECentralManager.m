//
//  BLECentralManager.m
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/18.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import "BLECentralManager.h"

// views
#import <SVProgressHUD/SVProgressHUD.h>

// helpers
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLECentralManager() <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, copy) CompletionHandler connectionCompletion;
@property (nonatomic, weak) CBPeripheral *connectingPerpheral;

@end

static NSString * const bleManageQueueName = @"com.seal.newBLEcentralDemo.bleManager.queue";

@implementation BLECentralManager

+ (BLECentralManager *)sharedManager {
  static BLECentralManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[BLECentralManager alloc] init];
    // 使用专门队列来管理BLE回调
    dispatch_queue_t blueToothManagerQueue = dispatch_queue_create([bleManageQueueName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    manager.centralManager = [[CBCentralManager alloc] initWithDelegate:manager queue:blueToothManagerQueue];
  });
  return manager;
}

- (NSMutableArray *)peripherals {
  if (!_peripherals) {
    _peripherals = [NSMutableArray array];
  }
  return _peripherals;
}

- (void)currentState {
  CBManagerState state = self.centralManager.state;
  switch (state) {
    case CBManagerStateUnknown:
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:localizedString(@"BLEManager.state.unkown")];
      });
      NSLog(@"CBManager state: Unknown");
      break;
    case CBManagerStatePoweredOn:
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:localizedString(@"BLEManager.state.on")];
      });
      NSLog(@"CBManager state: On");
      break;
    case CBManagerStateResetting:
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:localizedString(@"BLEManager.state.resetting")];
      });
      NSLog(@"CBManager state: Resetting");
      break;
    case CBManagerStatePoweredOff:
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:localizedString(@"BLEManager.state.off")];
      });
      NSLog(@"CBManager state: Off");
      break;
    case CBManagerStateUnsupported:
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:localizedString(@"BLEManager.state.unsupported")];
      });
      NSLog(@"CBManager state: Unsupported");
      break;
    case CBManagerStateUnauthorized:
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:localizedString(@"BLEManager.state.unauthorized")];
      });
      NSLog(@"CBManager state: Unauthorized");
      break;
  }
}

- (void)scanPeripherals {
  [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)stopScan {
    [self.centralManager stopScan];
}

- (void)connectWithPeripheral:(CBPeripheral *)peripheral completionHandler:(CompletionHandler)completion {
  self.connectionCompletion = completion;
  self.connectingPerpheral = peripheral;
  [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)disconnectWithPeripheral:(CBPeripheral *)peripheral {
  [self.centralManager cancelPeripheralConnection:peripheral];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
  if (![self.peripherals containsObject:peripheral]) {
    [self.peripherals addObject:peripheral];
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([self.delegate respondsToSelector:@selector(managerDidUpadatePeripheral:)]) {
        [self.delegate managerDidUpadatePeripheral:peripheral];
      }
    });
  }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([self.delegate respondsToSelector:@selector(managerDidLostConnectionToPeripheral:error:)]) {
      [self.delegate managerDidLostConnectionToPeripheral:peripheral error:error];
    }
  });
}

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
  [self currentState];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  if (peripheral == self.connectingPerpheral) {
    self.connectingPerpheral = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
      self.connectionCompletion(YES, nil);
    });
  }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  if (peripheral == self.connectingPerpheral) {
    self.connectingPerpheral = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
      self.connectionCompletion(NO, error);
    });
  }
}

@end
