//
//  CharacterSettingViewController.h
//  newBLEcentralDemo
//
//  Created by LeonDeng on 2019/1/19.
//  Copyright © 2019 Ivan_deng. All rights reserved.
//

@class CBCharacteristic;

#import <UIKit/UIKit.h>
#import "SubViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CharacterSettingViewController : SubViewController

- (instancetype)initWithCharacteristic:(CBCharacteristic *)characteristic;

@end

NS_ASSUME_NONNULL_END
