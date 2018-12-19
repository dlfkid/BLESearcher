//
//  PeripheralTableViewCell.h
//  newBLEcentralDemo
//
//  Created by Ivan_deng on 2018/12/19.
//  Copyright © 2018 Ivan_deng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;

@interface PeripheralTableViewCell : UITableViewCell

@property (nonatomic, strong) CBPeripheral *peripheral;

+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
