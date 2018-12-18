//
//  PeripherialViewController.h
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/17.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;

@interface PeripherialViewController : UIViewController

- (instancetype)initWithPerpherial:(CBPeripheral *)perpherial;

@end

NS_ASSUME_NONNULL_END
