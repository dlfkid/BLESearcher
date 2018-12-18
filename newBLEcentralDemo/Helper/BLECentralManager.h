//
//  BLECentralManager.h
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/18.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompletionHandler)(BOOL success, NSError * _Nullable error);

@class CBPeripheral;

@protocol BLECentralManagerDelegate <NSObject>

@optional
- (void)managerDidUpadatePeripherals;
- (void)managerDidLostConnectionToPeripheral:(CBPeripheral *)perpherial error:(NSError * _Nullable)error;

@end

@interface BLECentralManager : NSObject

@property (nonatomic, weak) NSObject<BLECentralManagerDelegate> *delegate;

@property (nonatomic, strong) NSMutableArray <CBPeripheral *> *peripherals;

+ (BLECentralManager *)sharedManager;

- (void)currentState;

- (void)scanPeripherals;

- (void)connectWithPeripheral:(CBPeripheral *)peripheral completionHandler:(CompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
